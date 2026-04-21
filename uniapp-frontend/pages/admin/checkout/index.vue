<template>
  <div class="checkout">
    <header class="header">
      <h1>开单收银</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>
    
    <div class="checkout-steps">
      <!-- 步骤1：选择顾客 -->
      <div class="step" v-if="currentStep === 1">
        <h2>选择顾客</h2>
        <div class="search-bar">
          <input type="text" v-model="searchCustomer" placeholder="搜索顾客姓名或手机号">
          <button class="search-btn" @click="searchCustomers">搜索</button>
        </div>
        <div class="customer-list">
          <div v-for="customer in customers" :key="customer.id" class="customer-item" @click="selectCustomer(customer)">
            <div class="customer-info">
              <h3>{{ customer.user.name }}</h3>
              <p>{{ customer.user.phone }}</p>
              <p v-if="customer.tags">{{ customer.tags }}</p>
            </div>
          </div>
        </div>
        <button class="next-btn" @click="nextStep">下一步</button>
      </div>
      
      <!-- 步骤2：选择服务/产品 -->
      <div class="step" v-if="currentStep === 2">
        <h2>选择服务/产品</h2>
        <div class="tab-bar">
          <button :class="{ active: activeTab === 'service' }" @click="activeTab = 'service'">服务</button>
          <button :class="{ active: activeTab === 'product' }" @click="activeTab = 'product'">产品</button>
        </div>
        
        <div class="item-list" v-if="activeTab === 'service'">
          <div v-for="service in services" :key="service.id" class="item-item" @click="addItem(service, 'service')">
            <div class="item-info">
              <h3>{{ service.name }}</h3>
              <p>{{ service.description }}</p>
              <p class="price">¥{{ service.price }}</p>
            </div>
          </div>
        </div>
        
        <div class="item-list" v-if="activeTab === 'product'">
          <div v-for="product in products" :key="product.id" class="item-item" @click="addItem(product, 'product')">
            <div class="item-info">
              <h3>{{ product.name }}</h3>
              <p>{{ product.description }}</p>
              <p class="price">¥{{ product.price }}</p>
            </div>
          </div>
        </div>
        
        <div class="order-items" v-if="orderItems.length > 0">
          <h3>已选项目</h3>
          <div v-for="(item, index) in orderItems" :key="index" class="order-item">
            <div class="item-name">{{ item.name }}</div>
            <div class="item-quantity">
              <button @click="decreaseQuantity(index)">-</button>
              <span>{{ item.quantity }}</span>
              <button @click="increaseQuantity(index)">+</button>
            </div>
            <div class="item-price">¥{{ item.price * item.quantity }}</div>
            <button class="delete-btn" @click="removeItem(index)">删除</button>
          </div>
          <div class="total">
            <span>合计：</span>
            <span class="total-price">¥{{ totalAmount }}</span>
          </div>
        </div>
        
        <div class="step-buttons">
          <button class="prev-btn" @click="prevStep">上一步</button>
          <button class="next-btn" @click="nextStep">下一步</button>
        </div>
      </div>
      
      <!-- 步骤3：选择员工 -->
      <div class="step" v-if="currentStep === 3">
        <h2>选择员工</h2>
        <div class="employee-list">
          <div v-for="employee in employees" :key="employee.id" class="employee-item" @click="selectEmployee(employee)">
            <div class="employee-info">
              <h3>{{ employee.user.name }}</h3>
              <p>{{ employee.position }}</p>
              <p>{{ employee.employeeId }}</p>
            </div>
          </div>
        </div>
        <div class="step-buttons">
          <button class="prev-btn" @click="prevStep">上一步</button>
          <button class="next-btn" @click="nextStep">下一步</button>
        </div>
      </div>
      
      <!-- 步骤4：选择支付方式 -->
      <div class="step" v-if="currentStep === 4">
        <h2>选择支付方式</h2>
        <div class="payment-methods">
          <div v-for="method in paymentMethods" :key="method.value" class="payment-method" @click="selectPaymentMethod(method.value)">
            <div class="method-info">
              <h3>{{ method.label }}</h3>
            </div>
            <div class="method-radio" :class="{ active: selectedPaymentMethod === method.value }"></div>
          </div>
        </div>
        
        <div class="order-summary">
          <h3>订单 summary</h3>
          <div class="summary-item">
            <span>顾客：</span>
            <span>{{ selectedCustomer ? selectedCustomer.user.name : '' }}</span>
          </div>
          <div class="summary-item">
            <span>员工：</span>
            <span>{{ selectedEmployee ? selectedEmployee.user.name : '' }}</span>
          </div>
          <div class="summary-item">
            <span>项目数量：</span>
            <span>{{ orderItems.length }}</span>
          </div>
          <div class="summary-item total">
            <span>合计：</span>
            <span>¥{{ totalAmount }}</span>
          </div>
        </div>
        
        <div class="step-buttons">
          <button class="prev-btn" @click="prevStep">上一步</button>
          <button class="submit-btn" @click="submitOrder">提交订单</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      currentStep: 1,
      searchCustomer: '',
      customers: [
        {
          id: 1,
          user: {
            name: '顾客1',
            phone: '13800138002'
          },
          tags: 'VIP,老顾客'
        },
        {
          id: 2,
          user: {
            name: '顾客2',
            phone: '13800138003'
          },
          tags: '新顾客'
        }
      ],
      services: [
        {
          id: 1,
          name: '面部护理',
          description: '深层清洁，补水保湿',
          price: 200
        },
        {
          id: 2,
          name: '身体护理',
          description: '全身按摩，放松身心',
          price: 300
        },
        {
          id: 3,
          name: '美甲',
          description: '专业美甲服务',
          price: 100
        }
      ],
      products: [
        {
          id: 1,
          name: '爽肤水',
          description: '深层补水',
          price: 150
        },
        {
          id: 2,
          name: '面霜',
          description: '滋润保湿',
          price: 200
        },
        {
          id: 3,
          name: '精华液',
          description: '抗衰紧致',
          price: 300
        }
      ],
      employees: [
        {
          id: 1,
          user: {
            name: '员工1',
            phone: '13800138001'
          },
          position: '美容师',
          employeeId: 'EMP001'
        },
        {
          id: 2,
          user: {
            name: '员工2',
            phone: '13800138004'
          },
          position: '美容师',
          employeeId: 'EMP002'
        }
      ],
      paymentMethods: [
        { label: '现金', value: 'cash' },
        { label: '微信', value: 'wechat' },
        { label: '支付宝', value: 'alipay' },
        { label: '银行卡', value: 'bank' },
        { label: '储值余额', value: 'member_card' }
      ],
      activeTab: 'service',
      selectedCustomer: null,
      selectedEmployee: null,
      selectedPaymentMethod: 'cash',
      orderItems: [],
      totalAmount: 0
    }
  },
  methods: {
    goBack() {
      uni.navigateBack();
    },
    nextStep() {
      if (this.currentStep < 4) {
        this.currentStep++;
      }
    },
    prevStep() {
      if (this.currentStep > 1) {
        this.currentStep--;
      }
    },
    searchCustomers() {
      // 这里调用搜索顾客API
      uni.showToast({ title: '搜索功能开发中', icon: 'none' });
    },
    selectCustomer(customer) {
      this.selectedCustomer = customer;
    },
    selectEmployee(employee) {
      this.selectedEmployee = employee;
    },
    selectPaymentMethod(method) {
      this.selectedPaymentMethod = method;
    },
    addItem(item, type) {
      // 检查是否已存在
      const existingItem = this.orderItems.find(i => i.id === item.id && i.type === type);
      if (existingItem) {
        existingItem.quantity++;
      } else {
        this.orderItems.push({
          id: item.id,
          name: item.name,
          price: item.price,
          quantity: 1,
          type: type
        });
      }
      this.calculateTotal();
    },
    removeItem(index) {
      this.orderItems.splice(index, 1);
      this.calculateTotal();
    },
    increaseQuantity(index) {
      this.orderItems[index].quantity++;
      this.calculateTotal();
    },
    decreaseQuantity(index) {
      if (this.orderItems[index].quantity > 1) {
        this.orderItems[index].quantity--;
        this.calculateTotal();
      }
    },
    calculateTotal() {
      this.totalAmount = this.orderItems.reduce((total, item) => {
        return total + (item.price * item.quantity);
      }, 0);
    },
    submitOrder() {
      // 表单验证
      if (!this.selectedCustomer || !this.selectedEmployee || this.orderItems.length === 0) {
        uni.showToast({ title: '请填写所有必填信息', icon: 'none' });
        return;
      }
      
      // 这里调用提交订单API
      console.log('提交订单:', {
        customer: this.selectedCustomer,
        employee: this.selectedEmployee,
        paymentMethod: this.selectedPaymentMethod,
        orderItems: this.orderItems,
        totalAmount: this.totalAmount
      });
      uni.showToast({ title: '订单提交成功', icon: 'success' });
      setTimeout(() => {
        uni.navigateBack();
      }, 1000);
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

.checkout-steps {
  padding: 20px;
}

.step {
  background-color: #fff;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.step h2 {
  font-size: 16px;
  color: #333;
  margin-bottom: 20px;
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
  cursor: pointer;
}

.customer-list,
.employee-list {
  max-height: 300px;
  overflow-y: auto;
  margin-bottom: 20px;
}

.customer-item,
.employee-item {
  padding: 15px;
  border-bottom: 1px solid #eee;
  cursor: pointer;
}

.customer-item:hover,
.employee-item:hover {
  background-color: #f5f5f5;
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
  max-height: 300px;
  overflow-y: auto;
  margin-bottom: 20px;
}

.item-item {
  padding: 15px;
  border-bottom: 1px solid #eee;
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
  margin: 0 0 5px 0;
}

.item-info .price {
  font-size: 14px;
  font-weight: bold;
  color: #ff6b81;
}

.order-items {
  margin-top: 20px;
  padding: 15px;
  background-color: #f9f9f9;
  border-radius: 4px;
}

.order-items h3 {
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

.item-quantity {
  display: flex;
  align-items: center;
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

.delete-btn {
  width: 24px;
  height: 24px;
  border: none;
  background-color: #f44336;
  color: #fff;
  border-radius: 4px;
  font-size: 12px;
  cursor: pointer;
}

.total {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 0;
  margin-top: 10px;
  font-weight: bold;
}

.total-price {
  color: #ff6b81;
  font-size: 16px;
}

.payment-methods {
  margin-bottom: 20px;
}

.payment-method {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px;
  border-bottom: 1px solid #eee;
  cursor: pointer;
}

.payment-method:hover {
  background-color: #f5f5f5;
}

.method-info h3 {
  font-size: 14px;
  color: #333;
  margin: 0;
}

.method-radio {
  width: 20px;
  height: 20px;
  border: 1px solid #ddd;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.method-radio.active {
  background-color: #ff6b81;
  border-color: #ff6b81;
}

.method-radio.active::after {
  content: '';
  width: 10px;
  height: 10px;
  background-color: #fff;
  border-radius: 50%;
}

.order-summary {
  margin-bottom: 20px;
  padding: 15px;
  background-color: #f9f9f9;
  border-radius: 4px;
}

.order-summary h3 {
  font-size: 14px;
  color: #333;
  margin-bottom: 15px;
}

.summary-item {
  display: flex;
  justify-content: space-between;
  margin-bottom: 10px;
  font-size: 14px;
}

.summary-item.total {
  font-weight: bold;
  margin-top: 10px;
  padding-top: 10px;
  border-top: 1px solid #eee;
}

.step-buttons {
  display: flex;
  justify-content: space-between;
  margin-top: 20px;
}

.next-btn,
.prev-btn,
.submit-btn {
  padding: 10px 30px;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.next-btn,
.submit-btn {
  background-color: #ff6b81;
  color: #fff;
}

.prev-btn {
  background-color: #9E9E9E;
  color: #fff;
}

.submit-btn {
  width: 100%;
}
</style>