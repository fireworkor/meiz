<template>
  <div class="commission-list">
    <header class="header">
      <h1>提成管理</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="toolbar">
      <div class="filter-group">
        <select v-model="filterStatus" @change="handleFilter">
          <option value="">全部状态</option>
          <option value="待结算">待结算</option>
          <option value="已结算">已结算</option>
        </select>
      </div>
      <div class="filter-group">
        <select v-model="filterEmployee" @change="handleFilter">
          <option value="">全部员工</option>
          <option v-for="employee in employees" :key="employee.id" :value="employee.id">
            {{ employee.user ? employee.user.name : '' }}
          </option>
        </select>
      </div>
      <button class="add-btn" @click="goToAdd">添加提成</button>
    </div>

    <div class="commission-container">
      <div v-for="commission in filteredCommissions" :key="commission.id" class="commission-item">
        <div class="commission-header">
          <h3>提成 #{{ commission.id }}</h3>
          <span :class="['status-badge', commission.status === '已结算' ? 'status-settled' : 'status-pending']">
            {{ commission.status }}
          </span>
        </div>
        <div class="commission-info">
          <div class="info-row">
            <span class="label">员工：</span>
            <span class="value">{{ commission.employee && commission.employee.user ? commission.employee.user.name : '' }}</span>
          </div>
          <div class="info-row">
            <span class="label">订单号：</span>
            <span class="value">#{{ commission.order ? commission.order.id : '' }}</span>
          </div>
          <div class="info-row">
            <span class="label">提成类型：</span>
            <span class="value">{{ commission.commissionType }}</span>
          </div>
          <div class="info-row">
            <span class="label">提成日期：</span>
            <span class="value">{{ formatDate(commission.commissionDate) }}</span>
          </div>
        </div>
        <div class="commission-amount">
          <span class="label">提成金额：</span>
          <span class="amount">¥{{ commission.amount }}</span>
        </div>
        <div class="commission-actions">
          <button v-if="commission.status === '待结算'" class="settle-btn" @click="settleCommission(commission)">
            结算
          </button>
        </div>
      </div>
      <div v-if="filteredCommissions.length === 0" class="empty">
        <div class="empty-icon">💰</div>
        <p>暂无提成记录</p>
      </div>
    </div>
  </div>
</template>

<script>
import { commissionAPI, employeeAPI } from '../../../api/index'

export default {
  name: 'CommissionList',
  data() {
    return {
      commissions: [],
      employees: [],
      filterStatus: '',
      filterEmployee: '',
      loading: false
    }
  },
  computed: {
    filteredCommissions() {
      return this.commissions.filter(commission => {
        if (this.filterStatus && commission.status !== this.filterStatus) return false
        if (this.filterEmployee && commission.employee && commission.employee.id !== parseInt(this.filterEmployee)) return false
        return true
      })
    }
  },
  mounted() {
    this.loadEmployees()
    this.loadCommissions()
  },
  methods: {
    async loadEmployees() {
      try {
        const response = await employeeAPI.getAll()
        if (Array.isArray(response)) {
          this.employees = response
        }
      } catch (error) {
        console.error('加载员工列表失败:', error)
      }
    },
    async loadCommissions() {
      this.loading = true
      try {
        const response = await commissionAPI.getAll()
        if (Array.isArray(response)) {
          this.commissions = response
        }
      } catch (error) {
        console.error('加载提成列表失败:', error)
      } finally {
        this.loading = false
      }
    },
    formatDate(date) {
      if (!date) return ''
      const d = new Date(date)
      return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
    },
    handleFilter() {
      // 筛选由computed属性处理
    },
    goBack() {
      this.$router.push('/admin/dashboard')
    },
    goToAdd() {
      this.$router.push('/admin/commission/add')
    },
    async settleCommission(commission) {
      if (typeof uni !== 'undefined') {
        uni.showModal({
          title: '确认结算',
          content: '确定要结算这个提成吗？',
          success: async (res) => {
            if (res.confirm) {
              try {
                await commissionAPI.updateStatus(commission.id, '已结算')
                this.loadCommissions()
                if (typeof uni !== 'undefined') {
                  uni.showToast({ title: '结算成功', icon: 'success' })
                }
              } catch (error) {
                console.error('结算失败:', error)
                if (typeof uni !== 'undefined') {
                  uni.showToast({ title: '结算失败，请重试', icon: 'none' })
                }
              }
            }
          }
        })
      } else {
        if (!confirm('确定要结算这个提成吗？')) {
          return
        }

        try {
          await commissionAPI.updateStatus(commission.id, '已结算')
          this.loadCommissions()
          alert('结算成功')
        } catch (error) {
          alert('结算失败')
        }
      }
    }
  }
}
</script>

<style scoped>
.commission-list {
  min-height: 100vh;
  background-color: #f5f5f5;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  background-color: #fff;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.header h1 {
  font-size: 18px;
  color: #333;
}

.back-btn,
.add-btn {
  padding: 8px 16px;
  background-color: #ff6b81;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px 20px;
  background-color: #fff;
  margin-bottom: 10px;
  gap: 10px;
}

.filter-group select {
  padding: 8px 16px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.commission-container {
  padding: 20px;
}

.commission-item {
  background-color: #fff;
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 15px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.commission-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
  padding-bottom: 15px;
  border-bottom: 1px solid #eee;
}

.commission-header h3 {
  font-size: 16px;
  color: #333;
  margin: 0;
}

.status-badge {
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
}

.status-pending {
  background-color: #FFF3E0;
  color: #FF9800;
}

.status-settled {
  background-color: #E8F5E9;
  color: #4CAF50;
}

.commission-info {
  margin-bottom: 15px;
}

.info-row {
  display: flex;
  justify-content: space-between;
  margin-bottom: 8px;
}

.info-row .label {
  font-size: 14px;
  color: #666;
}

.info-row .value {
  font-size: 14px;
  color: #333;
}

.commission-amount {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px 0;
  border-top: 1px solid #eee;
}

.commission-amount .label {
  font-size: 14px;
  color: #666;
}

.commission-amount .amount {
  font-size: 24px;
  font-weight: bold;
  color: #ff6b81;
}

.commission-actions {
  display: flex;
  justify-content: flex-end;
  padding-top: 15px;
  border-top: 1px solid #eee;
}

.settle-btn {
  padding: 8px 20px;
  background-color: #4CAF50;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.empty {
  text-align: center;
  padding: 60px 20px;
  background-color: #fff;
  border-radius: 8px;
  color: #999;
}

.empty-icon {
  font-size: 48px;
  margin-bottom: 20px;
}

.empty p {
  font-size: 16px;
  margin: 0;
}
</style>