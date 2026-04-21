<template>
  <div class="customer-reservations">
    <header class="header">
      <h1>我的预约</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="reservation-container">
      <div class="filter-bar">
        <select v-model="filterStatus" @change="handleFilter">
          <option value="">全部状态</option>
          <option value="待确认">待确认</option>
          <option value="已确认">已确认</option>
          <option value="已到店">已到店</option>
          <option value="已完成">已完成</option>
          <option value="已取消">已取消</option>
          <option value="爽约">爽约</option>
        </select>
      </div>

      <div class="reservation-list">
        <div v-for="reservation in filteredReservations" :key="reservation.id" class="reservation-item">
          <div class="reservation-header">
            <h3>{{ reservation.service ? reservation.service.name : '' }}</h3>
            <span :class="['status-badge', getStatusClass(reservation.status)]">
              {{ reservation.status }}
            </span>
          </div>
          <div class="reservation-info">
            <div class="info-item">
              <span class="label">预约时间：</span>
              <span class="value">{{ formatDateTime(reservation.reservationDate) }}</span>
            </div>
            <div class="info-item">
              <span class="label">美容师：</span>
              <span class="value">{{ reservation.employee && reservation.employee.user ? reservation.employee.user.name : '' }}</span>
            </div>
            <div class="info-item">
              <span class="label">来源：</span>
              <span class="value">{{ reservation.source }}</span>
            </div>
          </div>
          <div class="reservation-actions">
            <button v-if="reservation.status === '待确认'" class="cancel-btn" @click="cancelReservation(reservation)">
              取消预约
            </button>
            <div v-if="reservation.status === '已确认'" class="qrcode-section">
              <div class="qrcode">
                <img src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAxMDAgMTAwIj48cmVjdCB3aWR0aD0iMTAwIiBoZWlnaHQ9IjEwMCIgZmlsbD0iI2Y1ZjVmNSIvPjxjaXJjbGUgY3g9IjUwIiBjeT0iNTAiIHI9IjQwIiBmaWxsPSIjZmZmIi8+PHBhdGggZD0iTTIwLDgwYTQwLDQwIDAsMSw4MCwwIDQwLDQwLDAsMS04MCwwWiIgZmlsbD0iI2ZmZiIvPjwvc3ZnPg==" alt="预约码">
              </div>
              <p class="qrcode-text">预约码：{{ reservation.id }}</p>
            </div>
          </div>
        </div>
        <div v-if="reservations.length === 0" class="empty">
          <div class="empty-icon">📅</div>
          <p>暂无预约记录</p>
          <button class="reserve-btn" @click="goToReserve">立即预约</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { reservationAPI } from '../../../api/index'

export default {
  name: 'CustomerReservations',
  data() {
    return {
      reservations: [],
      filterStatus: '',
      loading: false
    }
  },
  computed: {
    filteredReservations() {
      return this.reservations.filter(reservation => {
        return !this.filterStatus || reservation.status === this.filterStatus
      })
    }
  },
  mounted() {
    this.loadReservations()
  },
  methods: {
    async loadReservations() {
      this.loading = true
      try {
        const response = await reservationAPI.getAll()
        if (Array.isArray(response)) {
          this.reservations = response
        }
      } catch (error) {
        console.error('加载预约列表失败:', error)
      } finally {
        this.loading = false
      }
    },
    formatDateTime(date) {
      if (!date) return ''
      const d = new Date(date)
      return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')} ${String(d.getHours()).padStart(2, '0')}:${String(d.getMinutes()).padStart(2, '0')}`
    },
    getStatusClass(status) {
      switch (status) {
        case '待确认': return 'status-pending'
        case '已确认': return 'status-confirmed'
        case '已到店': return 'status-arrived'
        case '已完成': return 'status-completed'
        case '已取消': return 'status-cancelled'
        case '爽约': return 'status-noshow'
        default: return ''
      }
    },
    handleFilter() {
      // 筛选由computed属性处理
    },
    goBack() {
      this.$router.push('/customer/dashboard')
    },
    goToReserve() {
      this.$router.push('/customer/reservation/create')
    },
    async cancelReservation(reservation) {
      if (confirm('确定要取消这个预约吗？')) {
        try {
          await reservationAPI.updateStatus(reservation.id, '已取消')
          this.loadReservations()
          alert('预约已取消')
        } catch (error) {
          alert('操作失败')
        }
      }
    }
  }
}
</script>

<style scoped>
.customer-reservations {
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

.reservation-container {
  padding: 20px;
}

.filter-bar {
  background-color: #fff;
  padding: 15px;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  margin-bottom: 20px;
}

.filter-bar select {
  width: 100%;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.reservation-list {
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  padding: 20px;
}

.reservation-item {
  border-bottom: 1px solid #eee;
  padding: 15px 0;
}

.reservation-item:last-child {
  border-bottom: none;
}

.reservation-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.reservation-header h3 {
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
  background-color: #E3F2FD;
  color: #1976D2;
}

.status-arrived {
  background-color: #E8F5E9;
  color: #4CAF50;
}

.status-completed {
  background-color: #E8F5E9;
  color: #4CAF50;
}

.status-cancelled {
  background-color: #FFEBEE;
  color: #F44336;
}

.status-noshow {
  background-color: #FFEBEE;
  color: #F44336;
}

.reservation-info {
  margin-bottom: 15px;
}

.info-item {
  display: flex;
  margin-bottom: 8px;
}

.info-item .label {
  width: 80px;
  font-size: 14px;
  color: #666;
}

.info-item .value {
  flex: 1;
  font-size: 14px;
  color: #333;
}

.reservation-actions {
  display: flex;
  justify-content: flex-end;
  align-items: center;
}

.cancel-btn {
  padding: 8px 16px;
  background-color: #f44336;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.qrcode-section {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.qrcode {
  width: 100px;
  height: 100px;
  margin-bottom: 10px;
}

.qrcode img {
  width: 100%;
  height: 100%;
}

.qrcode-text {
  font-size: 12px;
  color: #666;
  margin: 0;
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
  margin: 0 0 20px 0;
}

.reserve-btn {
  padding: 12px 30px;
  background-color: #ff6b81;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}
</style>