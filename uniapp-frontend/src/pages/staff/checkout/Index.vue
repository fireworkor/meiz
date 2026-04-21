<template>
  <div class="checkout">
    <header class="header">
      <h1>开单（加钟）</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="checkout-form">
      <div class="form-section">
        <h2 class="section-title">顾客信息</h2>
        <div class="form-group">
          <label>顾客姓名</label>
          <input type="text" v-model="form.customerName" placeholder="请输入顾客姓名" />
        </div>
        <div class="form-group">
          <label>联系电话</label>
          <input type="tel" v-model="form.customerPhone" placeholder="请输入联系电话" />
        </div>
        <div class="form-group">
          <label>会员卡号</label>
          <input type="text" v-model="form.membershipCardNumber" placeholder="请输入会员卡号" />
        </div>
      </div>

      <div class="form-section">
        <h2 class="section-title">服务项目</h2>
        <div class="service-list">
          <div v-for="service in services" :key="service.id" class="service-item" @click="selectService(service)">
            <div class="service-info">
              <h3>{{ service.name }}</h3>
              <p class="service-price">¥{{ service.price }}</p>
            </div>
            <div class="service-check" v-if="selectedServices.includes(service.id)">
              <span class="check-icon">✓</span>
            </div>
          </div>
        </div>
      </div>

      <div class="form-section">
        <h2 class="section-title">已选服务</h2>
        <div class="selected-services">
          <div v-for="id in selectedServices" :key="id" class="selected-service-item">
            <span>{{ getServiceName(id) }}</span>
            <div class="service-actions">
              <input type="number" v-model="serviceQuantities[id]" min="1" max="10" />
              <button class="remove-btn" @click="removeService(id)">删除</button>
            </div>
          </div>
          <div v-if="selectedServices.length === 0" class="empty-services">
            <p>请选择服务项目</p>
          </div>
        </div>
      </div>

      <div class="form-section">
        <h2 class="section-title">支付信息</h2>
        <div class="payment-info">
          <div class="payment-row">
            <span class="label">服务总额</span>
            <span class="value">¥{{ calculateTotal() }}</span>
          </div>
          <div class="payment-row">
            <span class="label">优惠金额</span>
            <span class="value">¥{{ discountAmount }}</span>
          </div>
          <div class="payment-row total">
            <span class="label">应付金额</span>
            <span class="value">¥{{ calculateTotal() - discountAmount }}</span>
          </div>
        </div>
        <div class="payment-methods">
          <div class="payment-method" v-for="method in paymentMethods" :key="method.value" @click="selectPaymentMethod(method.value)">
            <span class="method-name">{{ method.name }}</span>
            <span class="method-check" v-if="form.paymentMethod === method.value">✓</span>
          </div>
        </div>
      </div>

      <div class="form-actions">
        <button class="submit-btn" @click="handleSubmit">确认开单</button>
      </div>
    </div>
  </div>
</template>

<script>
import { productAPI, orderAPI } from '../../../api/index'

export default {
  name: 'StaffCheckout',
  data() {
    return {
      form: {
        customerName: '',
        customerPhone: '',
        membershipCardNumber: '',
        paymentMethod: 'cash'
      },
      services: [
        { id: 1, name: '面部护理', price: 198 },
        { id: 2, name: '身体按摩', price: 298 },
        { id: 3, name: '头部护理', price: 168 },
        { id: 4, name: '背部护理', price: 258 },
        { id: 5, name: '手部护理', price: 98 },
        { id: 6, name: '足部护理', price: 128 }
      ],
      selectedServices: [],
      serviceQuantities: {},
      discountAmount: 0,
      paymentMethods: [
        { name: '现金', value: 'cash' },
        { name: '微信支付', value: 'wechat' },
        { name: '支付宝', value: 'alipay' },
        { name: '会员卡', value: 'membership' }
      ]
    }
  },
  methods: {
    selectService(service) {
      if (!this.selectedServices.includes(service.id)) {
        this.selectedServices.push(service.id)
        this.serviceQuantities[service.id] = 1
      }
    },
    removeService(id) {
      const index = this.selectedServices.indexOf(id)
      if (index > -1) {
        this.selectedServices.splice(index, 1)
        delete this.serviceQuantities[id]
      }
    },
    getServiceName(id) {
      const service = this.services.find(s => s.id === id)
      return service ? service.name : ''
    },
    calculateTotal() {
      return this.selectedServices.reduce((total, id) => {
        const service = this.services.find(s => s.id === id)
        const quantity = this.serviceQuantities[id] || 1
        return total + (service ? service.price * quantity : 0)
      }, 0)
    },
    selectPaymentMethod(method) {
      this.form.paymentMethod = method
    },
    async handleSubmit() {
      if (!this.form.customerName) {
        uni.showToast({ title: '请输入顾客姓名', icon: 'none' })
        return
      }
      if (!this.form.customerPhone) {
        uni.showToast({ title: '请输入联系电话', icon: 'none' })
        return
      }
      if (this.selectedServices.length === 0) {
        uni.showToast({ title: '请选择服务项目', icon: 'none' })
        return
      }

      try {
        const orderData = {
          customerName: this.form.customerName,
          customerPhone: this.form.customerPhone,
          membershipCardNumber: this.form.membershipCardNumber,
          paymentMethod: this.form.paymentMethod,
          totalAmount: this.calculateTotal(),
          discountAmount: this.discountAmount,
          actualAmount: this.calculateTotal() - this.discountAmount,
          items: this.selectedServices.map(id => {
            const service = this.services.find(s => s.id === id)
            return {
              serviceId: id,
              serviceName: service.name,
              price: service.price,
              quantity: this.serviceQuantities[id] || 1
            }
          })
        }
        
        // 模拟提交
        console.log('提交订单:', orderData)
        uni.showToast({ title: '开单成功', icon: 'success' })
        setTimeout(() => {
          this.goBack()
        }, 1500)
      } catch (error) {
        console.error('开单失败:', error)
        uni.showToast({ title: '开单失败', icon: 'none' })
      }
    },
    goBack() {
      this.$router.push('/staff/dashboard')
    }
  }
}
</script>

<style scoped>
.checkout {
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

.checkout-form {
  padding: 20px;
}

.form-section {
  background-color: #fff;
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 20px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.section-title {
  font-size: 16px;
  color: #333;
  margin-bottom: 15px;
  padding-bottom: 10px;
  border-bottom: 1px solid #eee;
}

.form-group {
  margin-bottom: 15px;
}

.form-group label {
  display: block;
  font-size: 14px;
  color: #666;
  margin-bottom: 8px;
}

.form-group input {
  width: 100%;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
  box-sizing: border-box;
}

.service-list {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 10px;
}

.service-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px;
  border: 1px solid #ddd;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s;
}

.service-item:hover {
  border-color: #ff6b81;
  background-color: #f9f9f9;
}

.service-info h3 {
  font-size: 14px;
  color: #333;
  margin: 0 0 5px 0;
}

.service-price {
  font-size: 16px;
  font-weight: bold;
  color: #ff6b81;
  margin: 0;
}

.service-check {
  width: 20px;
  height: 20px;
  border-radius: 50%;
  background-color: #ff6b81;
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
}

.selected-services {
  border-top: 1px solid #eee;
  padding-top: 15px;
}

.selected-service-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 0;
  border-bottom: 1px solid #f0f0f0;
}

.service-actions {
  display: flex;
  align-items: center;
  gap: 10px;
}

.service-actions input {
  width: 60px;
  padding: 5px;
  border: 1px solid #ddd;
  border-radius: 4px;
  text-align: center;
}

.remove-btn {
  padding: 5px 10px;
  background-color: #F44336;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 12px;
  cursor: pointer;
}

.empty-services {
  text-align: center;
  padding: 30px;
  color: #999;
}

.payment-info {
  margin-bottom: 20px;
}

.payment-row {
  display: flex;
  justify-content: space-between;
  margin-bottom: 10px;
}

.payment-row .label {
  font-size: 14px;
  color: #666;
}

.payment-row .value {
  font-size: 14px;
  color: #333;
}

.payment-row.total {
  font-weight: bold;
  padding-top: 10px;
  border-top: 1px solid #eee;
}

.payment-row.total .value {
  color: #ff6b81;
  font-size: 16px;
}

.payment-methods {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 10px;
}

.payment-method {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px;
  border: 1px solid #ddd;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s;
}

.payment-method:hover {
  border-color: #ff6b81;
}

.payment-method.selected {
  border-color: #ff6b81;
  background-color: #FFF3F5;
}

.method-check {
  color: #ff6b81;
  font-weight: bold;
}

.form-actions {
  margin-top: 20px;
}

.submit-btn {
  width: 100%;
  padding: 15px;
  background-color: #ff6b81;
  color: #fff;
  border: none;
  border-radius: 8px;
  font-size: 16px;
  cursor: pointer;
}
</style>
