<template>
  <div class="shift-list">
    <header class="header">
      <h1>门店交班</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="toolbar">
      <div class="filter-group">
        <select v-model="filterStatus" @change="handleFilter">
          <option value="">全部状态</option>
          <option value="待确认">待确认</option>
          <option value="已确认">已确认</option>
        </select>
      </div>
      <button class="add-btn" @click="goToAdd">发起交班</button>
    </div>

    <div class="shift-container">
      <div v-for="shift in filteredShifts" :key="shift.id" class="shift-item">
        <div class="shift-header">
          <h3>交班单 #{{ shift.id }}</h3>
          <span :class="['status-badge', shift.status === '待确认' ? 'status-pending' : 'status-confirmed']">
            {{ shift.status }}
          </span>
        </div>
        <div class="shift-info">
          <div class="info-row">
            <span class="label">交班员工：</span>
            <span class="value">{{ shift.employee && shift.employee.user ? shift.employee.user.name : '' }}</span>
          </div>
          <div class="info-row">
            <span class="label">交班时间：</span>
            <span class="value">{{ formatDate(shift.shiftDate) }}</span>
          </div>
        </div>
        <div class="shift-amounts">
          <div class="amount-item">
            <span class="label">现金：</span>
            <span class="value">¥{{ shift.cashAmount }}</span>
          </div>
          <div class="amount-item">
            <span class="label">微信：</span>
            <span class="value">¥{{ shift.wechatAmount }}</span>
          </div>
          <div class="amount-item">
            <span class="label">支付宝：</span>
            <span class="value">¥{{ shift.alipayAmount }}</span>
          </div>
          <div class="amount-item">
            <span class="label">银行卡：</span>
            <span class="value">¥{{ shift.cardAmount }}</span>
          </div>
          <div class="amount-item">
            <span class="label">储值卡：</span>
            <span class="value">¥{{ shift.memberCardAmount }}</span>
          </div>
          <div class="amount-item">
            <span class="label">优惠券：</span>
            <span class="value">¥{{ shift.couponAmount }}</span>
          </div>
        </div>
        <div class="shift-total">
          <div class="total-row">
            <span class="label">实收总额：</span>
            <span class="value total">¥{{ shift.totalAmount }}</span>
          </div>
          <div class="total-row">
            <span class="label">系统应收：</span>
            <span class="value">¥{{ shift.systemAmount }}</span>
          </div>
          <div class="total-row" v-if="shift.difference != 0">
            <span class="label">差异：</span>
            <span class="value difference">¥{{ shift.difference }}</span>
          </div>
          <div class="total-row" v-if="shift.differenceReason">
            <span class="label">差异原因：</span>
            <span class="value">{{ shift.differenceReason }}</span>
          </div>
        </div>
        <div class="shift-actions">
          <button v-if="shift.status === '待确认'" class="confirm-btn" @click="confirmShift(shift)">
            确认交班
          </button>
          <button class="print-btn" @click="printShift(shift)">
            打印小票
          </button>
        </div>
      </div>
      <div v-if="filteredShifts.length === 0" class="empty">
        <div class="empty-icon">📋</div>
        <p>暂无交班记录</p>
      </div>
    </div>
  </div>
</template>

<script>
import { shiftAPI } from '../../../api/index'

export default {
  name: 'ShiftList',
  data() {
    return {
      shifts: [],
      filterStatus: '',
      loading: false
    }
  },
  computed: {
    filteredShifts() {
      if (!this.filterStatus) {
        return this.shifts
      }
      return this.shifts.filter(shift => shift.status === this.filterStatus)
    }
  },
  mounted() {
    this.loadShifts()
  },
  methods: {
    async loadShifts() {
      this.loading = true
      try {
        const response = await shiftAPI.getAll()
        if (Array.isArray(response)) {
          this.shifts = response
        }
      } catch (error) {
        console.error('加载交班列表失败:', error)
      } finally {
        this.loading = false
      }
    },
    formatDate(date) {
      if (!date) return ''
      const d = new Date(date)
      return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')} ${String(d.getHours()).padStart(2, '0')}:${String(d.getMinutes()).padStart(2, '0')}`
    },
    handleFilter() {
      // 筛选由computed属性处理
    },
    goBack() {
      this.$router.push('/admin/dashboard')
    },
    goToAdd() {
      this.$router.push('/admin/shift/add')
    },
    async confirmShift(shift) {
      if (!confirm('确定要确认这个交班吗？')) {
        return
      }

      try {
        await shiftAPI.updateStatus(shift.id, '已确认')
        this.loadShifts()
        alert('交班已确认')
      } catch (error) {
        alert('操作失败')
      }
    },
    printShift(shift) {
      alert('打印功能开发中')
    }
  }
}
</script>

<style scoped>
.shift-list {
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
}

.filter-group select {
  padding: 8px 16px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.shift-container {
  padding: 20px;
}

.shift-item {
  background-color: #fff;
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 15px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.shift-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
  padding-bottom: 15px;
  border-bottom: 1px solid #eee;
}

.shift-header h3 {
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

.status-confirmed {
  background-color: #E8F5E9;
  color: #4CAF50;
}

.shift-info {
  margin-bottom: 15px;
}

.info-row {
  display: flex;
  margin-bottom: 8px;
}

.info-row .label {
  width: 80px;
  font-size: 14px;
  color: #666;
}

.info-row .value {
  font-size: 14px;
  color: #333;
}

.shift-amounts {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 10px;
  padding: 15px;
  background-color: #f9f9f9;
  border-radius: 4px;
  margin-bottom: 15px;
}

.amount-item {
  display: flex;
  justify-content: space-between;
  font-size: 14px;
}

.amount-item .label {
  color: #666;
}

.amount-item .value {
  color: #333;
  font-weight: bold;
}

.shift-total {
  padding: 15px 0;
  border-top: 1px solid #eee;
}

.total-row {
  display: flex;
  justify-content: space-between;
  margin-bottom: 8px;
}

.total-row .label {
  font-size: 14px;
  color: #666;
}

.total-row .value {
  font-size: 14px;
  color: #333;
}

.total-row .value.total {
  font-size: 18px;
  font-weight: bold;
  color: #ff6b81;
}

.total-row .value.difference {
  color: #f44336;
}

.shift-actions {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  padding-top: 15px;
  border-top: 1px solid #eee;
}

.confirm-btn {
  padding: 8px 20px;
  background-color: #4CAF50;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.print-btn {
  padding: 8px 20px;
  background-color: #2196F3;
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