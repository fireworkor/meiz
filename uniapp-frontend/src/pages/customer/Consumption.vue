<template>
  <div class="customer-consumption">
    <header class="header">
      <h1>消费记录</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="consumption-container">
      <div class="filter-bar">
        <input type="date" v-model="startDate" @change="handleFilter">
        <span>至</span>
        <input type="date" v-model="endDate" @change="handleFilter">
      </div>

      <div class="consumption-list">
        <div v-for="order in filteredOrders" :key="order.id" class="consumption-item">
          <div class="order-header">
            <h3>订单 #{{ order.id }}</h3>
            <span class="order-date">{{ formatDate(order.createTime) }}</span>
          </div>
          <div class="order-items">
            <div v-for="(item, index) in order.orderItems" :key="index" class="order-item">
              <span class="item-name">{{ item.name }}</span>
              <span class="item-quantity">{{ item.quantity }}份</span>
              <span class="item-price">¥{{ (item.price * item.quantity).toFixed(2) }}</span>
            </div>
          </div>
          <div class="order-footer">
            <div class="payment-method">
              <span>支付方式：</span>
              <span>{{ getPaymentMethodText(order.paymentMethod) }}</span>
            </div>
            <div class="order-total">
              <span>合计：</span>
              <span class="total-price">¥{{ order.totalAmount.toFixed(2) }}</span>
            </div>
          </div>
        </div>
        <div v-if="orders.length === 0" class="empty">
          <div class="empty-icon">📊</div>
          <p>暂无消费记录</p>
        </div>
      </div>

      <div class="stats-section">
        <div class="stat-item">
          <span class="stat-value">{{ totalOrders }}</span>
          <span class="stat-label">总订单数</span>
        </div>
        <div class="stat-item">
          <span class="stat-value">¥{{ totalSpending.toFixed(2) }}</span>
          <span class="stat-label">总消费</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { orderAPI } from '../../api/index'

export default {
  name: 'CustomerConsumption',
  data() {
    return {
      orders: [],
      startDate: '',
      endDate: '',
      loading: false
    }
  },
  computed: {
    filteredOrders() {
      return this.orders.filter(order => {
        if (!order.createTime) return true
        const orderDate = new Date(order.createTime)
        if (this.startDate) {
          const start = new Date(this.startDate)
          if (orderDate < start) return false
        }
        if (this.endDate) {
          const end = new Date(this.endDate)
          end.setHours(23, 59, 59, 999)
          if (orderDate > end) return false
        }
        return true
      })
    },
    totalOrders() {
      return this.orders.length
    },
    totalSpending() {
      return this.orders.reduce((sum, order) => sum + (order.totalAmount || 0), 0)
    }
  },
  mounted() {
    this.loadOrders()
  },
  methods: {
    async loadOrders() {
      this.loading = true
      try {
        const response = await orderAPI.getAll()
        if (Array.isArray(response)) {
          this.orders = response
        }
      } catch (error) {
        console.error('加载订单列表失败:', error)
      } finally {
        this.loading = false
      }
    },
    formatDate(date) {
      if (!date) return ''
      const d = new Date(date)
      return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
    },
    getPaymentMethodText(method) {
      const methods = {
        cash: '现金',
        wechat: '微信支付',
        alipay: '支付宝',
        bank: '银行卡',
        member_card: '储值余额'
      }
      return methods[method] || method
    },
    handleFilter() {
      // 筛选由computed属性处理
    },
    goBack() {
      this.$router.push('/customer/dashboard')
    }
  }
}
</script>

<style scoped>
.customer-consumption {
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

.consumption-container {
  padding: 20px;
}

.filter-bar {
  display: flex;
  align-items: center;
  background-color: #fff;
  padding: 15px;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  margin-bottom: 20px;
  gap: 10px;
}

.filter-bar input {
  flex: 1;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.filter-bar span {
  color: #666;
  font-size: 14px;
}

.consumption-list {
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  padding: 20px;
  margin-bottom: 20px;
}

.consumption-item {
  border-bottom: 1px solid #eee;
  padding: 15px 0;
}

.consumption-item:last-child {
  border-bottom: none;
}

.order-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.order-header h3 {
  font-size: 16px;
  color: #333;
  margin: 0;
}

.order-date {
  font-size: 12px;
  color: #999;
}

.order-items {
  margin-bottom: 10px;
}

.order-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 5px 0;
  font-size: 14px;
}

.item-name {
  flex: 1;
  color: #333;
}

.item-quantity {
  color: #666;
  margin: 0 10px;
}

.item-price {
  color: #333;
  font-weight: bold;
}

.order-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 10px;
  border-top: 1px solid #f0f0f0;
}

.payment-method {
  font-size: 14px;
  color: #666;
}

.order-total {
  font-size: 14px;
  font-weight: bold;
  color: #333;
}

.total-price {
  color: #ff6b81;
  font-size: 16px;
}

.empty {
  text-align: center;
  padding: 60px 20px;
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

.stats-section {
  display: flex;
  justify-content: space-around;
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  padding: 20px;
}

.stat-item {
  text-align: center;
}

.stat-value {
  display: block;
  font-size: 24px;
  font-weight: bold;
  color: #ff6b81;
  margin-bottom: 5px;
}

.stat-label {
  font-size: 14px;
  color: #666;
}
</style>