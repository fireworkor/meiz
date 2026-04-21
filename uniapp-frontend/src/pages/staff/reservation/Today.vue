<template>
  <div class="today-reservation">
    <header class="header">
      <h1>今日预约</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="reservation-container">
      <div class="date-info">
        <h2>{{ currentDate }}</h2>
        <p>{{ currentDay }}</p>
      </div>

      <div class="reservation-list">
        <div v-for="reservation in todayReservations" :key="reservation.id" class="reservation-item">
          <div class="reservation-time">
            <span class="time">{{ formatTime(reservation.reservationDate) }}</span>
            <span :class="['status-badge', getStatusClass(reservation.status)]">
              {{ reservation.status }}
            </span>
          </div>
          <div class="reservation-info">
            <div class="customer-info">
              <h3>{{ reservation.customer && reservation.customer.user ? reservation.customer.user.name : '' }}</h3>
              <p>{{ reservation.customer && reservation.customer.user ? reservation.customer.user.phone : '' }}</p>
            </div>
            <div class="service-info">
              <p class="service-name">{{ reservation.service ? reservation.service.name : '' }}</p>
              <p class="room">{{ reservation.room ? reservation.room.name : '' }}</p>
            </div>
          </div>
          <div class="reservation-actions">
            <button v-if="reservation.status === '待确认'" class="confirm-btn" @click="confirmReservation(reservation)">
              确认
            </button>
            <button v-if="reservation.status === '已确认'" class="arrive-btn" @click="arriveReservation(reservation)">
              到店
            </button>
            <button v-if="reservation.status === '已到店'" class="complete-btn" @click="completeReservation(reservation)">
              完成
            </button>
          </div>
        </div>
        <div v-if="todayReservations.length === 0" class="empty">
          <div class="empty-icon">📅</div>
          <p>今日暂无预约</p>
        </div>
      </div>

      <div class="stats-section">
        <div class="stat-item">
          <span class="stat-value">{{ totalReservations }}</span>
          <span class="stat-label">总预约数</span>
        </div>
        <div class="stat-item">
          <span class="stat-value">{{ confirmedReservations }}</span>
          <span class="stat-label">已确认</span>
        </div>
        <div class="stat-item">
          <span class="stat-value">{{ completedReservations }}</span>
          <span class="stat-label">已完成</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { reservationAPI, employeeAPI } from '../../../api/index'

export default {
  name: 'TodayReservation',
  data() {
    return {
      todayReservations: [],
      currentDate: '',
      currentDay: '',
      loading: false,
      currentEmployee: null
    }
  },
  computed: {
    totalReservations() {
      return this.todayReservations.length
    },
    confirmedReservations() {
      return this.todayReservations.filter(r => r.status === '已确认' || r.status === '已到店' || r.status === '已完成').length
    },
    completedReservations() {
      return this.todayReservations.filter(r => r.status === '已完成').length
    }
  },
  mounted() {
    this.updateDate()
    this.loadCurrentEmployee()
  },
  methods: {
    updateDate() {
      const now = new Date()
      this.currentDate = `${now.getFullYear()}年${now.getMonth() + 1}月${now.getDate()}日`
      this.currentDay = ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'][now.getDay()]
    },
    async loadCurrentEmployee() {
      const userStr = localStorage.getItem('userInfo')
      if (userStr) {
        const userInfo = JSON.parse(userStr)
        try {
          const response = await employeeAPI.getAll()
          if (Array.isArray(response)) {
            const employees = response.filter(e => e.user && e.user.username === userInfo.username)
            if (employees.length > 0) {
              this.currentEmployee = employees[0]
              this.loadTodayReservations()
            }
          }
        } catch (error) {
          console.error('加载员工信息失败:', error)
        }
      }
    },
    async loadTodayReservations() {
      if (!this.currentEmployee) return

      try {
        const response = await reservationAPI.getAll()
        if (Array.isArray(response)) {
          const today = new Date()
          today.setHours(0, 0, 0, 0)
          const tomorrow = new Date(today)
          tomorrow.setDate(tomorrow.getDate() + 1)

          this.todayReservations = response.filter(reservation => {
            if (!reservation.employee || reservation.employee.id !== this.currentEmployee.id) {
              return false
            }
            const reservationDate = new Date(reservation.reservationDate)
            return reservationDate >= today && reservationDate < tomorrow
          })
        }
      } catch (error) {
        console.error('加载预约失败:', error)
      }
    },
    formatTime(date) {
      if (!date) return '--:--'
      const d = new Date(date)
      return `${String(d.getHours()).padStart(2, '0')}:${String(d.getMinutes()).padStart(2, '0')}`
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
    goBack() {
      this.$router.push('/staff/dashboard')
    },
    async confirmReservation(reservation) {
      try {
        await reservationAPI.updateStatus(reservation.id, '已确认')
        this.loadTodayReservations()
        alert('预约已确认')
      } catch (error) {
        alert('操作失败')
      }
    },
    async arriveReservation(reservation) {
      try {
        await reservationAPI.updateStatus(reservation.id, '已到店')
        this.loadTodayReservations()
        alert('顾客已到店')
      } catch (error) {
        alert('操作失败')
      }
    },
    async completeReservation(reservation) {
      try {
        await reservationAPI.updateStatus(reservation.id, '已完成')
        this.loadTodayReservations()
        alert('服务已完成')
      } catch (error) {
        alert('操作失败')
      }
    }
  }
}
</script>

<style scoped>
.today-reservation {
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

.date-info {
  background-color: #fff;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  margin-bottom: 20px;
  text-align: center;
}

.date-info h2 {
  font-size: 24px;
  color: #333;
  margin-bottom: 5px;
}

.date-info p {
  font-size: 14px;
  color: #666;
  margin: 0;
}

.reservation-list {
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  padding: 20px;
  margin-bottom: 20px;
}

.reservation-item {
  border-bottom: 1px solid #eee;
  padding: 15px 0;
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
}

.reservation-item:last-child {
  border-bottom: none;
}

.reservation-time {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-right: 20px;
}

.time {
  font-size: 20px;
  font-weight: bold;
  color: #333;
  margin-bottom: 5px;
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
  flex: 1;
}

.customer-info h3 {
  font-size: 16px;
  color: #333;
  margin-bottom: 5px;
}

.customer-info p {
  font-size: 14px;
  color: #666;
  margin: 0 0 10px 0;
}

.service-info .service-name {
  font-size: 14px;
  color: #333;
  margin: 0 0 5px 0;
}

.service-info .room {
  font-size: 12px;
  color: #999;
  margin: 0;
}

.reservation-actions {
  display: flex;
  flex-direction: column;
  gap: 5px;
}

.confirm-btn,
.arrive-btn,
.complete-btn {
  padding: 8px 16px;
  border: none;
  border-radius: 4px;
  font-size: 12px;
  cursor: pointer;
}

.confirm-btn {
  background-color: #2196F3;
  color: #fff;
}

.arrive-btn {
  background-color: #FF9800;
  color: #fff;
}

.complete-btn {
  background-color: #4CAF50;
  color: #fff;
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