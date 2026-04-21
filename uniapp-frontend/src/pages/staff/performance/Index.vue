<template>
  <div class="performance">
    <header class="header">
      <h1>我的业绩</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="stats-container">
      <div class="stat-card">
        <div class="stat-icon">💰</div>
        <div class="stat-info">
          <div class="stat-value">{{ totalSales || 0 }}</div>
          <div class="stat-label">总销售额</div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon">📈</div>
        <div class="stat-info">
          <div class="stat-value">{{ totalCommission || 0 }}</div>
          <div class="stat-label">总提成</div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon">📋</div>
        <div class="stat-info">
          <div class="stat-value">{{ totalOrders || 0 }}</div>
          <div class="stat-label">服务次数</div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon">⭐</div>
        <div class="stat-info">
          <div class="stat-value">{{ averageRating || 0 }}</div>
          <div class="stat-label">平均评分</div>
        </div>
      </div>
    </div>

    <div class="filter-bar">
      <select v-model="filterPeriod" @change="loadPerformance">
        <option value="week">本周</option>
        <option value="month">本月</option>
        <option value="quarter">本季度</option>
        <option value="year">本年</option>
      </select>
    </div>

    <div class="performance-list">
      <div v-for="item in performanceData" :key="item.id" class="performance-item">
        <div class="item-header">
          <span class="item-date">{{ formatDate(item.date) }}</span>
          <span class="item-amount">¥{{ item.amount }}</span>
        </div>
        <div class="item-detail">
          <span class="item-service">{{ item.serviceName }}</span>
          <span class="item-commission">提成: ¥{{ item.commission }}</span>
        </div>
        <div class="item-customer" v-if="item.customerName">
          客户: {{ item.customerName }}
        </div>
      </div>
      <div v-if="performanceData.length === 0" class="empty">
        <div class="empty-icon">📊</div>
        <p>暂无业绩数据</p>
      </div>
    </div>
  </div>
</template>

<script>
import { commissionAPI, orderAPI } from '../../../api/index'

export default {
  name: 'StaffPerformance',
  data() {
    return {
      filterPeriod: 'month',
      totalSales: 0,
      totalCommission: 0,
      totalOrders: 0,
      averageRating: 0,
      performanceData: []
    }
  },
  mounted() {
    this.loadPerformance()
  },
  methods: {
    async loadPerformance() {
      try {
        // 模拟数据，实际应该从后端API获取
        const mockData = {
          week: {
            totalSales: 1500,
            totalCommission: 300,
            totalOrders: 10,
            averageRating: 4.8,
            data: [
              { id: 1, date: '2024-04-15', amount: 200, serviceName: '面部护理', commission: 40, customerName: '张女士' },
              { id: 2, date: '2024-04-16', amount: 350, serviceName: '身体按摩', commission: 70, customerName: '李女士' },
              { id: 3, date: '2024-04-17', amount: 180, serviceName: '头部护理', commission: 36, customerName: '王女士' }
            ]
          },
          month: {
            totalSales: 6800,
            totalCommission: 1360,
            totalOrders: 35,
            averageRating: 4.7,
            data: [
              { id: 1, date: '2024-04-01', amount: 220, serviceName: '面部护理', commission: 44, customerName: '陈女士' },
              { id: 2, date: '2024-04-05', amount: 450, serviceName: '身体按摩', commission: 90, customerName: '林女士' },
              { id: 3, date: '2024-04-10', amount: 380, serviceName: '头部护理', commission: 76, customerName: '黄女士' },
              { id: 4, date: '2024-04-15', amount: 200, serviceName: '面部护理', commission: 40, customerName: '张女士' },
              { id: 5, date: '2024-04-20', amount: 550, serviceName: '身体护理套装', commission: 110, customerName: '吴女士' }
            ]
          },
          quarter: {
            totalSales: 22000,
            totalCommission: 4400,
            totalOrders: 120,
            averageRating: 4.6,
            data: [
              { id: 1, date: '2024-04-01', amount: 220, serviceName: '面部护理', commission: 44, customerName: '陈女士' },
              { id: 2, date: '2024-04-05', amount: 450, serviceName: '身体按摩', commission: 90, customerName: '林女士' },
              { id: 3, date: '2024-03-15', amount: 380, serviceName: '头部护理', commission: 76, customerName: '黄女士' },
              { id: 4, date: '2024-03-20', amount: 200, serviceName: '面部护理', commission: 40, customerName: '张女士' },
              { id: 5, date: '2024-02-10', amount: 550, serviceName: '身体护理套装', commission: 110, customerName: '吴女士' }
            ]
          },
          year: {
            totalSales: 88000,
            totalCommission: 17600,
            totalOrders: 480,
            averageRating: 4.5,
            data: [
              { id: 1, date: '2024-04-01', amount: 220, serviceName: '面部护理', commission: 44, customerName: '陈女士' },
              { id: 2, date: '2024-03-05', amount: 450, serviceName: '身体按摩', commission: 90, customerName: '林女士' },
              { id: 3, date: '2024-02-15', amount: 380, serviceName: '头部护理', commission: 76, customerName: '黄女士' },
              { id: 4, date: '2024-01-20', amount: 200, serviceName: '面部护理', commission: 40, customerName: '张女士' },
              { id: 5, date: '2023-12-10', amount: 550, serviceName: '身体护理套装', commission: 110, customerName: '吴女士' }
            ]
          }
        }
        
        const periodData = mockData[this.filterPeriod]
        this.totalSales = periodData.totalSales
        this.totalCommission = periodData.totalCommission
        this.totalOrders = periodData.totalOrders
        this.averageRating = periodData.averageRating
        this.performanceData = periodData.data
      } catch (error) {
        console.error('加载业绩数据失败:', error)
      }
    },
    formatDate(date) {
      if (!date) return ''
      const d = new Date(date)
      return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
    },
    goBack() {
      this.$router.push('/staff/dashboard')
    }
  }
}
</script>

<style scoped>
.performance {
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

.stats-container {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 15px;
  padding: 20px;
}

.stat-card {
  background-color: #fff;
  border-radius: 8px;
  padding: 20px;
  display: flex;
  align-items: center;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.stat-icon {
  font-size: 32px;
  margin-right: 15px;
}

.stat-info {
  flex: 1;
}

.stat-value {
  font-size: 20px;
  font-weight: bold;
  color: #333;
}

.stat-label {
  font-size: 14px;
  color: #666;
  margin-top: 5px;
}

.filter-bar {
  background-color: #fff;
  padding: 15px 20px;
  margin-bottom: 10px;
}

.filter-bar select {
  padding: 8px 16px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
  width: 100%;
}

.performance-list {
  padding: 20px;
}

.performance-item {
  background-color: #fff;
  border-radius: 8px;
  padding: 15px;
  margin-bottom: 15px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.item-header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 10px;
}

.item-date {
  font-size: 14px;
  color: #666;
}

.item-amount {
  font-size: 16px;
  font-weight: bold;
  color: #ff6b81;
}

.item-detail {
  display: flex;
  justify-content: space-between;
  margin-bottom: 8px;
}

.item-service {
  font-size: 14px;
  color: #333;
}

.item-commission {
  font-size: 14px;
  color: #4CAF50;
}

.item-customer {
  font-size: 12px;
  color: #999;
  margin-top: 5px;
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
