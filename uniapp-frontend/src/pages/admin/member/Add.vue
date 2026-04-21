<template>
  <div class="member-add">
    <header class="header">
      <h1>办理会员卡</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="form-container">
      <div class="form-group">
        <label>顾客</label>
        <select v-model="form.customerId">
          <option value="">请选择顾客</option>
          <option v-for="customer in customers" :key="customer.id" :value="customer.id">
            {{ customer.user ? customer.user.name : '' }} - {{ customer.user ? customer.user.phone : '' }}
          </option>
        </select>
      </div>

      <div class="form-group">
        <label>卡类型</label>
        <select v-model="form.cardType" @change="handleCardTypeChange">
          <option value="">请选择卡类型</option>
          <option value="储值卡">储值卡</option>
          <option value="折扣卡">折扣卡</option>
          <option value="疗程卡">疗程卡</option>
        </select>
      </div>

      <div class="form-group">
        <label>开卡金额</label>
        <input type="number" v-model.number="form.totalAmount" placeholder="0.00" step="0.01">
      </div>

      <div class="form-group">
        <label>折扣率</label>
        <input type="number" v-model.number="form.discountRate" placeholder="0.0-1.0" step="0.1" min="0" max="1">
        <span class="hint">例如：0.9 表示9折</span>
      </div>

      <div class="card-preview" v-if="form.cardType">
        <h3>会员卡预览</h3>
        <div class="preview-content">
          <div class="preview-type">{{ form.cardType }}</div>
          <div class="preview-amount">¥{{ form.totalAmount || 0 }}</div>
          <div class="preview-discount">{{ form.discountRate ? (form.discountRate * 10).toFixed(1) + '折' : '-' }}</div>
        </div>
      </div>

      <button class="submit-btn" @click="handleSubmit" :disabled="loading">
        {{ loading ? '提交中...' : '确认办理' }}
      </button>
    </div>
  </div>
</template>

<script>
import { membershipCardAPI, customerAPI } from '../../../api/index'

export default {
  name: 'MemberAdd',
  data() {
    return {
      form: {
        customerId: '',
        cardType: '',
        totalAmount: 0,
        discountRate: 1,
        balance: 0,
        points: 0,
        status: '正常'
      },
      customers: [],
      loading: false
    }
  },
  mounted() {
    this.loadCustomers()
  },
  methods: {
    async loadCustomers() {
      try {
        const response = await customerAPI.getAll()
        if (Array.isArray(response)) {
          this.customers = response
        }
      } catch (error) {
        console.error('加载顾客列表失败:', error)
      }
    },
    handleCardTypeChange() {
      if (this.form.cardType === '储值卡') {
        this.form.discountRate = 1
      } else if (this.form.cardType === '折扣卡') {
        this.form.discountRate = 0.9
      } else if (this.form.cardType === '疗程卡') {
        this.form.discountRate = 1
      }
    },
    async handleSubmit() {
      if (!this.form.customerId || !this.form.cardType) {
        alert('请填写必填项')
        return
      }

      this.loading = true
      try {
        const cardNumber = 'MC' + Date.now()
        const requestData = {
          customerId: parseInt(this.form.customerId),
          cardNumber: cardNumber,
          cardType: this.form.cardType,
          totalAmount: this.form.totalAmount || 0,
          balance: this.form.totalAmount || 0,
          discountRate: this.form.discountRate || 1,
          points: Math.floor((this.form.totalAmount || 0) / 10),
          issueDate: new Date().toISOString(),
          status: this.form.status
        }
        const response = await membershipCardAPI.create(requestData)
        if (response.id) {
          alert('办理成功')
          this.$router.push('/admin/member/list')
        }
      } catch (error) {
        alert('办理失败')
      } finally {
        this.loading = false
      }
    },
    goBack() {
      this.$router.push('/admin/member/list')
    }
  }
}
</script>

<style scoped>
.member-add {
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

.form-group .hint {
  display: block;
  margin-top: 5px;
  font-size: 12px;
  color: #999;
}

.card-preview {
  background: linear-gradient(135deg, #ff6b81 0%, #ff4757 100%);
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 20px;
  color: #fff;
}

.card-preview h3 {
  font-size: 14px;
  margin-bottom: 15px;
  opacity: 0.8;
}

.preview-type {
  font-size: 18px;
  margin-bottom: 10px;
}

.preview-amount {
  font-size: 32px;
  font-weight: bold;
  margin-bottom: 10px;
}

.preview-discount {
  font-size: 14px;
  opacity: 0.9;
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