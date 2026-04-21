<template>
  <div class="dashboard-data">
    <header class="header">
      <h1>数据分析</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="data-container">
      <div class="stats-section">
        <div class="stat-card">
          <div class="stat-icon">💰</div>
          <div class="stat-info">
            <div class="stat-label">今日营收</div>
            <div class="stat-value">¥{{ dashboardData.todayRevenue || 0 }}</div>
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-icon">📈</div>
          <div class="stat-info">
            <div class="stat-label">本月营收</div>
            <div class="stat-value">¥{{ dashboardData.monthRevenue || 0 }}</div>
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-icon">📋</div>
          <div class="stat-info">
            <div class="stat-label">今日订单</div>
            <div class="stat-value">{{ dashboardData.todayOrders || 0 }}</div>
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-icon">📅</div>
          <div class="stat-info">
            <div class="stat-label">本月订单</div>
            <div class="stat-value">{{ dashboardData.monthOrders || 0 }}</div>
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-icon">🗓️</div>
          <div class="stat-info">
            <div class="stat-label">今日预约</div>
            <div class="stat-value">{{ dashboardData.todayReservations || 0 }}</div>
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-icon">👥</div>
          <div class="stat-info">
            <div class="stat-label">新增顾客</div>
            <div class="stat-value">{{ dashboardData.newCustomers || 0 }}</div>
          </div>
        </div>
      </div>

      <div class="section-title">
        <h2>员工业绩排行</h2>
      </div>
      <div class="performance-list">
        <div v-for="(performance, index) in employeePerformance" :key="performance.employeeId" class="performance-item">
          <div class="rank" :class="'rank-' + (index + 1)">{{ index + 1 }}</div>
          <div class="employee-info">
            <div class="employee-name">{{ performance.employeeName }}</div>
            <div class="order-count">{{ performance.orderCount }} 订单</div>
          </div>
          <div class="performance-amount">
            ¥{{ performance.totalAmount || 0 }}
          </div>
        </div>
        <div v-if="employeePerformance.length === 0" class="empty">
          <p>暂无数据</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { dashboardAPI } from '../../../api/index'

export default {
  name: 'DashboardData',
  data() {
    return {
      dashboardData: {},
      employeePerformance: [],
      loading: false
    }
  },
  mounted() {
    this.loadDashboardData()
    this.loadEmployeePerformance()
  },
  methods: {
    async loadDashboardData() {
      this.loading = true
      try {
        const response = await dashboardAPI.getData()
        if (response) {
          this.dashboardData = response
        }
      } catch (error) {
        console.error('加载数据失败:', error)
      } finally {
        this.loading = false
      }
    },
    async loadEmployeePerformance() {
      try {
        const response = await dashboardAPI.getEmployeePerformance()
        if (Array.isArray(response)) {
          this.employeePerformance = response
        }
      } catch (error) {
        console.error('加载员工绩效失败:', error)
      }
    },
    goBack() {
      this.$router.push('/admin/dashboard')
    }
  }
}
</script>

<style scoped>
.dashboard-data {
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

.data-container {
  padding: 20px;
}

.stats-section {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 15px;
  margin-bottom: 30px;
}

.stat-card {
  display: flex;
  align-items: center;
  padding: 20px;
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.stat-icon {
  font-size: 32px;
  margin-right: 15px;
}

.stat-info {
  flex: 1;
}

.stat-label {
  font-size: 14px;
  color: #666;
  margin-bottom: 5px;
}

.stat-value {
  font-size: 24px;
  font-weight: bold;
  color: #333;
}

.section-title {
  margin-bottom: 15px;
}

.section-title h2 {
  font-size: 16px;
  color: #333;
}

.performance-list {
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  padding: 15px;
}

.performance-item {
  display: flex;
  align-items: center;
  padding: 15px 0;
  border-bottom: 1px solid #eee;
}

.performance-item:last-child {
  border-bottom: none;
}

.rank {
  width: 30px;
  height: 30px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  font-weight: bold;
  color: #fff;
  background-color: #ccc;
  margin-right: 15px;
}

.rank-1 {
  background-color: #FFD700;
}

.rank-2 {
  background-color: #C0C0C0;
}

.rank-3 {
  background-color: #CD7F32;
}

.employee-info {
  flex: 1;
}

.employee-name {
  font-size: 14px;
  color: #333;
  font-weight: bold;
}

.order-count {
  font-size: 12px;
  color: #666;
  margin-top: 4px;
}

.performance-amount {
  font-size: 16px;
  font-weight: bold;
  color: #ff6b81;
}

.empty {
  text-align: center;
  padding: 30px;
  color: #999;
}

.empty p {
  margin: 0;
}
</style>