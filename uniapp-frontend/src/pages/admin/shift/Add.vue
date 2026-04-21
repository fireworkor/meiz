<template>
  <div class="shift-add">
    <header class="header">
      <h1>发起交班</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="form-container">
      <div class="form-group">
        <label>交班员工</label>
        <select v-model="form.employeeId">
          <option value="">请选择员工</option>
          <option v-for="employee in employees" :key="employee.id" :value="employee.id">
            {{ employee.user ? employee.user.name : '' }}
          </option>
        </select>
      </div>

      <div class="form-section">
        <h3>收款明细</h3>
        <div class="form-group">
          <label>现金</label>
          <input type="number" v-model.number="form.cashAmount" placeholder="0.00" step="0.01">
        </div>
        <div class="form-group">
          <label>微信支付</label>
          <input type="number" v-model.number="form.wechatAmount" placeholder="0.00" step="0.01">
        </div>
        <div class="form-group">
          <label>支付宝</label>
          <input type="number" v-model.number="form.alipayAmount" placeholder="0.00" step="0.01">
        </div>
        <div class="form-group">
          <label>银行卡</label>
          <input type="number" v-model.number="form.cardAmount" placeholder="0.00" step="0.01">
        </div>
        <div class="form-group">
          <label>储值卡</label>
          <input type="number" v-model.number="form.memberCardAmount" placeholder="0.00" step="0.01">
        </div>
        <div class="form-group">
          <label>优惠券</label>
          <input type="number" v-model.number="form.couponAmount" placeholder="0.00" step="0.01">
        </div>
      </div>

      <div class="form-section">
        <h3>对账信息</h3>
        <div class="form-group">
          <label>系统应收金额</label>
          <input type="number" v-model.number="form.systemAmount" placeholder="0.00" step="0.01">
        </div>
        <div class="form-group">
          <label>差异金额</label>
          <input type="number" v-model.number="form.difference" placeholder="0.00" step="0.01">
        </div>
        <div class="form-group">
          <label>差异原因</label>
          <textarea v-model="form.differenceReason" placeholder="请输入差异原因（如有）"></textarea>
        </div>
      </div>

      <div class="total-section">
        <div class="total-row">
          <span>实收总额：</span>
          <span class="total-amount">¥{{ totalAmount.toFixed(2) }}</span>
        </div>
      </div>

      <div class="form-group">
        <label>备注</label>
        <textarea v-model="form.notes" placeholder="请输入备注"></textarea>
      </div>

      <button class="submit-btn" @click="handleSubmit" :disabled="loading">
        {{ loading ? '提交中...' : '发起交班' }}
      </button>
    </div>
  </div>
</template>

<script>
import { shiftAPI, employeeAPI } from '../../../api/index'

export default {
  name: 'ShiftAdd',
  data() {
    return {
      form: {
        employeeId: '',
        cashAmount: 0,
        wechatAmount: 0,
        alipayAmount: 0,
        cardAmount: 0,
        memberCardAmount: 0,
        couponAmount: 0,
        systemAmount: 0,
        difference: 0,
        differenceReason: '',
        notes: ''
      },
      employees: [],
      loading: false
    }
  },
  computed: {
    totalAmount() {
      return (this.form.cashAmount || 0) +
             (this.form.wechatAmount || 0) +
             (this.form.alipayAmount || 0) +
             (this.form.cardAmount || 0) +
             (this.form.memberCardAmount || 0) +
             (this.form.couponAmount || 0)
    }
  },
  mounted() {
    this.loadEmployees()
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
    async handleSubmit() {
      if (!this.form.employeeId) {
        alert('请选择交班员工')
        return
      }

      this.loading = true
      try {
        const requestData = {
          employeeId: parseInt(this.form.employeeId),
          shiftDate: new Date().toISOString(),
          cashAmount: this.form.cashAmount || 0,
          wechatAmount: this.form.wechatAmount || 0,
          alipayAmount: this.form.alipayAmount || 0,
          cardAmount: this.form.cardAmount || 0,
          memberCardAmount: this.form.memberCardAmount || 0,
          couponAmount: this.form.couponAmount || 0,
          totalAmount: this.totalAmount,
          systemAmount: this.form.systemAmount || 0,
          difference: this.form.difference || 0,
          differenceReason: this.form.differenceReason,
          status: '待确认',
          notes: this.form.notes
        }
        const response = await shiftAPI.create(requestData)
        if (response.id) {
          alert('交班发起成功')
          this.$router.push('/admin/shift/list')
        }
      } catch (error) {
        alert('发起失败')
      } finally {
        this.loading = false
      }
    },
    goBack() {
      this.$router.push('/admin/shift/list')
    }
  }
}
</script>

<style scoped>
.shift-add {
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

.form-section {
  margin-bottom: 20px;
  padding-bottom: 20px;
  border-bottom: 1px solid #eee;
}

.form-section h3 {
  font-size: 16px;
  color: #333;
  margin-bottom: 15px;
}

.form-group {
  margin-bottom: 15px;
}

.form-group label {
  display: block;
  margin-bottom: 8px;
  font-size: 14px;
  color: #666;
}

.form-group input,
.form-group select,
.form-group textarea {
  width: 100%;
  padding: 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
  box-sizing: border-box;
}

.form-group textarea {
  min-height: 80px;
  resize: vertical;
}

.total-section {
  padding: 15px;
  background-color: #f9f9f9;
  border-radius: 4px;
  margin-bottom: 20px;
}

.total-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 16px;
}

.total-amount {
  font-size: 24px;
  font-weight: bold;
  color: #ff6b81;
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