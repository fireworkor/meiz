<template>
  <div class="commission-add">
    <header class="header">
      <h1>添加提成</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="form-container">
      <div class="form-group">
        <label>员工</label>
        <select v-model="form.employeeId">
          <option value="">请选择员工</option>
          <option v-for="employee in employees" :key="employee.id" :value="employee.id">
            {{ employee.user ? employee.user.name : '' }}
          </option>
        </select>
      </div>

      <div class="form-group">
        <label>订单</label>
        <select v-model="form.orderId">
          <option value="">请选择订单</option>
          <option v-for="order in orders" :key="order.id" :value="order.id">
            订单 #{{ order.id }} - ¥{{ order.totalAmount }}
          </option>
        </select>
      </div>

      <div class="form-group">
        <label>提成类型</label>
        <select v-model="form.commissionType">
          <option value="">请选择提成类型</option>
          <option value="服务提成">服务提成</option>
          <option value="销售产品提成">销售产品提成</option>
          <option value="办卡提成">办卡提成</option>
          <option value="耗卡提成">耗卡提成</option>
          <option value="全员营销佣金">全员营销佣金</option>
        </select>
      </div>

      <div class="form-group">
        <label>提成金额</label>
        <input type="number" v-model.number="form.amount" placeholder="0.00" step="0.01">
      </div>

      <div class="form-group">
        <label>提成日期</label>
        <input type="date" v-model="form.commissionDate">
      </div>

      <button class="submit-btn" @click="handleSubmit" :disabled="loading">
        {{ loading ? '提交中...' : '提交' }}
      </button>
    </div>
  </div>
</template>

<script>
import { commissionAPI, employeeAPI, orderAPI } from '../../../api/index'

export default {
  name: 'CommissionAdd',
  data() {
    return {
      form: {
        employeeId: '',
        orderId: '',
        commissionType: '',
        amount: 0,
        commissionDate: '',
        status: '待结算'
      },
      employees: [],
      orders: [],
      loading: false
    }
  },
  mounted() {
    this.loadEmployees()
    this.loadOrders()
    this.form.commissionDate = this.formatDate(new Date())
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
    async loadOrders() {
      try {
        const response = await orderAPI.getAll()
        if (Array.isArray(response)) {
          this.orders = response
        }
      } catch (error) {
        console.error('加载订单列表失败:', error)
      }
    },
    formatDate(date) {
      const d = new Date(date)
      return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
    },
    async handleSubmit() {
      if (!this.form.employeeId || !this.form.orderId || !this.form.commissionType || !this.form.amount) {
        if (typeof uni !== 'undefined') {
          uni.showToast({ title: '请填写必填项', icon: 'none' })
        } else {
          alert('请填写必填项')
        }
        return
      }

      this.loading = true
      try {
        const requestData = {
          employeeId: parseInt(this.form.employeeId),
          orderId: parseInt(this.form.orderId),
          commissionType: this.form.commissionType,
          amount: this.form.amount,
          commissionDate: this.form.commissionDate,
          status: this.form.status
        }
        const response = await commissionAPI.create(requestData)
        if (response.id) {
          if (typeof uni !== 'undefined') {
            uni.showToast({ title: '添加成功', icon: 'success' })
            // 延迟跳转，让用户看到成功提示
            setTimeout(() => {
              this.$router.push('/admin/commission/list')
            }, 1500)
          } else {
            alert('添加成功')
            this.$router.push('/admin/commission/list')
          }
        }
      } catch (error) {
        console.error('添加提成失败:', error)
        if (typeof uni !== 'undefined') {
          uni.showToast({ title: '添加失败，请重试', icon: 'none' })
        } else {
          alert('添加失败')
        }
      } finally {
        this.loading = false
      }
    },
    goBack() {
      this.$router.push('/admin/commission/list')
    }
  }
}
</script>

<style scoped>
.commission-add {
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

.back-btn {
  padding: 8px 16px;
  background-color: #ff6b81;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.form-container {
  background-color: #fff;
  padding: 20px;
  margin: 20px;
  border-radius: 8px;
}

.form-group {
  margin-bottom: 20px;
}

.form-group label {
  display: block;
  margin-bottom: 8px;
  font-size: 14px;
  color: #666;
}

.form-group input,
.form-group select {
  width: 100%;
  padding: 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
  box-sizing: border-box;
}

.submit-btn {
  width: 100%;
  padding: 14px;
  background-color: #ff6b81;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 16px;
  cursor: pointer;
}

.submit-btn:disabled {
  background-color: #ccc;
  cursor: not-allowed;
}
</style>