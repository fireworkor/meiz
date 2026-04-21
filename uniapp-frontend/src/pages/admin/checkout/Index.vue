<template>
  <div class="checkout">
    <header class="header">
      <h1>开单收银</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="checkout-container">
      <div class="step-indicator">
        <div :class="['step', { active: step >= 1, completed: step > 1 }]">
          <span class="step-num">1</span>
          <span class="step-text">选择顾客</span>
        </div>
        <div class="step-line"></div>
        <div :class="['step', { active: step >= 2, completed: step > 2 }]">
          <span class="step-num">2</span>
          <span class="step-text">选择项目</span>
        </div>
        <div class="step-line"></div>
        <div :class="['step', { active: step >= 3, completed: step > 3 }]">
          <span class="step-num">3</span>
          <span class="step-text">选择员工</span>
        </div>
        <div class="step-line"></div>
        <div :class="['step', { active: step >= 4 }]">
          <span class="step-num">4</span>
          <span class="step-text">支付方式</span>
        </div>
      </div>

      <div class="step-content">
        <div v-if="step === 1" class="step1">
          <div class="search-bar">
            <input type="text" v-model="searchKeyword" placeholder="搜索顾客姓名或手机号">
            <button class="search-btn" @click="searchCustomers">搜索</button>
          </div>
          <div class="customer-list">
            <div v-for="customer in customers" :key="customer.id" :class="['customer-item', { selected: selectedCustomer && selectedCustomer.id === customer.id }]" @click="selectCustomer(customer)">
              <div class="customer-info">
                <h3>{{ customer.user ? customer.user.name : '' }}</h3>
                <p>{{ customer.user ? customer.user.phone : '' }}</p>
                <p v-if="customer.tags">{{ customer.tags }}</p>
              </div>
            </div>
          </div>
        </div>

        <div v-if="step === 2" class="step2">
          <div class="tab-bar">
            <button :class="{ active: activeTab === 'service' }" @click="activeTab = 'service'">服务项目</button>
            <button :class="{ active: activeTab === 'product' }" @click="activeTab = 'product'">商品</button>
          </div>

          <div class="item-list" v-if="activeTab === 'service'">
            <div v-for="service in services" :key="service.id" class="item-item" @click="addService(service)">
              <div class="item-info">
                <h3>{{ service.name }}</h3>
                <p>{{ service.description || service.duration + '分钟' }}</p>
                <p class="price">¥{{ service.price }}</p>
              </div>
              <span class="add-icon">+</span>
            </div>
          </div>

          <div class="item-list" v-if="activeTab === 'product'">
            <div v-for="product in products" :key="product.id" class="item-item" @click="addProduct(product)">
              <div class="item-info">
                <h3>{{ product.name }}</h3>
                <p>{{ product.description }}</p>
                <p class="price">¥{{ product.price }}</p>
              </div>
              <span class="add-icon">+</span>
            </div>
          </div>

          <div class="selected-items" v-if="orderItems.length > 0">
            <h3>已选项目</h3>
            <div v-for="(item, index) in orderItems" :key="index" class="order-item">
              <div class="item-name">{{ item.name }}</div>
              <div class="item-quantity">
                <button @click="decreaseQuantity(index)">-</button>
                <span>{{ item.quantity }}</span>
                <button @click="increaseQuantity(index)">+</button>
              </div>
              <div class="item-price">¥{{ (item.price * item.quantity).toFixed(2) }}</div>
              <button class="delete-btn" @click="removeItem(index)">×</button>
            </div>
            <div class="total">
              <span>合计：</span>
              <span class="total-price">¥{{ totalAmount.toFixed(2) }}</span>
            </div>
          </div>
        </div>

        <div v-if="step === 3" class="step3">
          <div class="employee-list">
            <div v-for="employee in employees" :key="employee.id" :class="['employee-item', { selected: selectedEmployee && selectedEmployee.id === employee.id }]" @click="selectEmployee(employee)">
              <div class="employee-info">
                <h3>{{ employee.user ? employee.user.name : '' }}</h3>
                <p>{{ employee.position }}</p>
                <p>{{ employee.employeeId }}</p>
              </div>
            </div>
          </div>
        </div>

        <div v-if="step === 4" class="step4">
          <div class="order-summary">
            <h3>订单 summary</h3>
            <div class="summary-item">
              <span>顾客：</span>
              <span>{{ selectedCustomer && selectedCustomer.user ? selectedCustomer.user.name : '' }}</span>
            </div>
            <div class="summary-item">
              <span>服务员工：</span>
              <span>{{ selectedEmployee && selectedEmployee.user ? selectedEmployee.user.name : '' }}</span>
            </div>
            <div class="summary-item">
              <span>项目数量：</span>
              <span>{{ orderItems.length }}</span>
            </div>
            <div class="summary-item total">
              <span>合计金额：</span>
              <span class="total-price">¥{{ totalAmount.toFixed(2) }}</span>
            </div>
          </div>

          <div class="payment-methods">
            <h3>选择支付方式</h3>
            <div v-for="method in paymentMethods" :key="method.value" :class="['payment-method', { selected: selectedPaymentMethod === method.value }]" @click="selectedPaymentMethod = method.value">
              <span>{{ method.label }}</span>
              <span :class="['radio', { active: selectedPaymentMethod === method.value }]"></span>
            </div>
          </div>
        </div>
      </div>

      <div class="step-buttons">
        <button class="prev-btn" @click="prevStep" v-if="step > 1">上一步</button>
        <button class="next-btn" @click="nextStep" v-if="step < 4" :disabled="!canNext">下一步</button>
        <button class="submit-btn" @click="submitOrder" v-if="step === 4" :disabled="loading">
          {{ loading ? '提交中...' : '确认支付' }}
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import { customerAPI, employeeAPI, orderAPI } from '../../../api/index'

export default {
  name: 'Checkout',
  data() {
    return {
      step: 1,
      searchKeyword: '',
      customers: [],
      services: [
        { id: 1, name: '面部护理', description: '深层清洁补水', price: 200, duration: 60 },
        { id: 2, name: '身体护理', description: '全身按摩放松', price: 300, duration: 90 },
        { id: 3, name: '美甲', description: '专业美甲服务', price: 100, duration: 30 }
      ],
      products: [
        { id: 1, name: '爽肤水', description: '补水保湿', price: 150 },
        { id: 2, name: '面霜', description: '滋润保湿', price: 200 },
        { id: 3, name: '精华液', description: '抗衰紧致', price: 300 }
      ],
      employees: [],
      activeTab: 'service',
      selectedCustomer: null,
      selectedEmployee: null,
      selectedPaymentMethod: 'cash',
      orderItems: [],
      paymentMethods: [
        { label: '现金', value: 'cash' },
        { label: '微信支付', value: 'wechat' },
        { label: '支付宝', value: 'alipay' },
        { label: '银行卡', value: 'bank' },
        { label: '储值余额', value: 'member_card' }
      ],
      loading: false
    }
  },
  computed: {
    totalAmount() {
      return this.orderItems.reduce((sum, item) => sum + item.price * item.quantity, 0)
    },
    canNext() {
      switch (this.step) {
        case 1: return !!this.selectedCustomer
        case 2: return this.orderItems.length > 0
        case 3: return !!this.selectedEmployee
        default: return true
      }
    }
  },
  mounted() {
    this.loadCustomers()
    this.loadEmployees()
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
    searchCustomers() {
      // 搜索由computed属性处理
    },
    selectCustomer(customer) {
      this.selectedCustomer = customer
    },
    addService(service) {
      const existing = this.orderItems.find(item => item.id === service.id && item.type === 'service')
      if (existing) {
        existing.quantity++
      } else {
        this.orderItems.push({
          id: service.id,
          name: service.name,
          price: service.price,
          quantity: 1,
          type: 'service'
        })
      }
    },
    addProduct(product) {
      const existing = this.orderItems.find(item => item.id === product.id && item.type === 'product')
      if (existing) {
        existing.quantity++
      } else {
        this.orderItems.push({
          id: product.id,
          name: product.name,
          price: product.price,
          quantity: 1,
          type: 'product'
        })
      }
    },
    increaseQuantity(index) {
      this.orderItems[index].quantity++
    },
    decreaseQuantity(index) {
      if (this.orderItems[index].quantity > 1) {
        this.orderItems[index].quantity--
      }
    },
    removeItem(index) {
      this.orderItems.splice(index, 1)
    },
    selectEmployee(employee) {
      this.selectedEmployee = employee
    },
    prevStep() {
      if (this.step > 1) this.step--
    },
    nextStep() {
      if (this.canNext && this.step < 4) this.step++
    },
    goBack() {
      this.$router.push('/admin/dashboard')
    },
    async submitOrder() {
      this.loading = true
      try {
        const orderData = {
          customer: this.selectedCustomer,
          employee: this.selectedEmployee,
          paymentMethod: this.selectedPaymentMethod,
          orderItems: this.orderItems,
          totalAmount: this.totalAmount
        }
        const response = await orderAPI.create(orderData)
        if (response.id) {
          alert('订单提交成功')
          this.$router.push('/admin/dashboard')
        }
      } catch (error) {
        alert('订单提交失败')
      } finally {
        this.loading = false
      }
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

.checkout-container {
  padding: 20px;
}

.step-indicator {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-bottom: 30px;
}

.step {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.step-num {
  width: 30px;
  height: 30px;
  border-radius: 50%;
  background-color: #ddd;
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  margin-bottom: 5px;
}

.step.active .step-num {
  background-color: #ff6b81;
}

.step.completed .step-num {
  background-color: #4CAF50;
}

.step-text {
  font-size: 12px;
  color: #666;
}

.step.active .step-text {
  color: #ff6b81;
}

.step-line {
  width: 50px;
  height: 2px;
  background-color: #ddd;
  margin: 0 10px;
  margin-bottom: 20px;
}

.step-content {
  background-color: #fff;
  border-radius: 8px;
  padding: 20px;
  min-height: 400px;
}

.search-bar {
  display: flex;
  margin-bottom: 20px;
}

.search-bar input {
  flex: 1;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px 0 0 4px;
  font-size: 14px;
}

.search-btn {
  padding: 10px 20px;
  background-color: #ff6b81;
  color: #fff;
  border: none;
  border-radius: 0 4px 4px 0;
  font-size: 14px;
}

.customer-list,
.employee-list {
  max-height: 300px;
  overflow-y: auto;
}

.customer-item,
.employee-item {
  padding: 15px;
  border: 1px solid #eee;
  border-radius: 4px;
  margin-bottom: 10px;
  cursor: pointer;
}

.customer-item:hover,
.employee-item:hover {
  background-color: #f5f5f5;
}

.customer-item.selected,
.employee-item.selected {
  border-color: #ff6b81;
  background-color: #FFF5F5;
}

.customer-info h3,
.employee-info h3 {
  font-size: 14px;
  color: #333;
  margin-bottom: 5px;
}

.customer-info p,
.employee-info p {
  font-size: 12px;
  color: #666;
  margin: 0;
}

.tab-bar {
  display: flex;
  margin-bottom: 20px;
  border-bottom: 1px solid #ddd;
}

.tab-bar button {
  flex: 1;
  padding: 10px;
  background: none;
  border: none;
  font-size: 14px;
  color: #666;
  cursor: pointer;
}

.tab-bar button.active {
  color: #ff6b81;
  border-bottom: 2px solid #ff6b81;
}

.item-list {
  max-height: 200px;
  overflow-y: auto;
  margin-bottom: 20px;
}

.item-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px;
  border: 1px solid #eee;
  border-radius: 4px;
  margin-bottom: 10px;
  cursor: pointer;
}

.item-item:hover {
  background-color: #f5f5f5;
}

.item-info h3 {
  font-size: 14px;
  color: #333;
  margin-bottom: 5px;
}

.item-info p {
  font-size: 12px;
  color: #666;
  margin: 0;
}

.item-info .price {
  font-size: 14px;
  font-weight: bold;
  color: #ff6b81;
}

.add-icon {
  width: 30px;
  height: 30px;
  border-radius: 50%;
  background-color: #ff6b81;
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 18px;
}

.selected-items {
  border-top: 1px solid #eee;
  padding-top: 20px;
}

.selected-items h3 {
  font-size: 14px;
  color: #333;
  margin-bottom: 15px;
}

.order-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 0;
  border-bottom: 1px solid #eee;
}

.item-name {
  flex: 1;
  font-size: 14px;
}

.item-quantity {
  display: flex;
  align-items: center;
  margin: 0 15px;
}

.item-quantity button {
  width: 24px;
  height: 24px;
  border: 1px solid #ddd;
  background-color: #fff;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.item-quantity span {
  margin: 0 10px;
  font-size: 14px;
}

.item-price {
  font-size: 14px;
  font-weight: bold;
  color: #ff6b81;
  margin-right: 10px;
}

.delete-btn {
  width: 24px;
  height: 24px;
  border: none;
  background-color: #f44336;
  color: #fff;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.total {
  display: flex;
  justify-content: space-between;
  padding: 15px 0;
  font-weight: bold;
}

.total-price {
  font-size: 18px;
  color: #ff6b81;
}

.payment-methods {
  margin-top: 20px;
}

.payment-methods h3 {
  font-size: 14px;
  color: #333;
  margin-bottom: 15px;
}

.payment-method {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px;
  border: 1px solid #eee;
  border-radius: 4px;
  margin-bottom: 10px;
  cursor: pointer;
}

.payment-method:hover {
  background-color: #f5f5f5;
}

.payment-method.selected {
  border-color: #ff6b81;
  background-color: #FFF5F5;
}

.radio {
  width: 20px;
  height: 20px;
  border: 1px solid #ddd;
  border-radius: 50%;
}

.radio.active {
  background-color: #ff6b81;
  border-color: #ff6b81;
}

.step-buttons {
  display: flex;
  justify-content: center;
  gap: 20px;
  margin-top: 20px;
}

.prev-btn,
.next-btn,
.submit-btn {
  padding: 12px 40px;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.prev-btn {
  background-color: #9E9E9E;
  color: #fff;
}

.next-btn,
.submit-btn {
  background-color: #ff6b81;
  color: #fff;
}

.next-btn:disabled,
.submit-btn:disabled {
  background-color: #ccc;
  cursor: not-allowed;
}
</style>