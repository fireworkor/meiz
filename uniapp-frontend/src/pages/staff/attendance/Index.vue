<template>
  <div class="attendance">
    <header class="header">
      <h1>考勤打卡</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="attendance-container">
      <div class="employee-info">
        <div class="avatar">
          <img src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAxMDAgMTAwIj48cmVjdCB3aWR0aD0iMTAwIiBoZWlnaHQ9IjEwMCIgZmlsbD0iI2Y1ZjVmNSIvPjxjaXJjbGUgY3g9IjUwIiBjeT0iMzUiIHI9IjE4IiBmaWxsPSIjZmZmIi8+PHBhdGggZD0iTTIwLDg1YTMwLDMwIDAsMSw1LDYwLDMwLDMwLDAsMSw1LTYsMCwwLDAsMS01LDBaIiBmaWxsPSIjZmZmIi8+PC9zdmc+" alt="头像">
        </div>
        <div class="info">
          <h2>{{ userInfo.username }}</h2>
          <p>{{ employeeInfo.position || '员工' }}</p>
          <p>{{ employeeInfo.employeeId || '' }}</p>
        </div>
      </div>

      <div class="location-info">
        <div class="location-item">
          <span class="label">当前位置：</span>
          <span class="value" :class="{ 'text-danger': !locationValid }">
            {{ locationText }}
          </span>
        </div>
        <div class="location-item">
          <span class="label">打卡范围：</span>
          <span class="value">门店半径100米内</span>
        </div>
      </div>

      <div class="attendance-status">
        <div class="status-item">
          <span class="label">今日状态：</span>
          <span class="value" :class="statusClass">{{ todayStatus }}</span>
        </div>
        <div class="status-item" v-if="todayAttendance">
          <span class="label">上班打卡：</span>
          <span class="value">{{ formatTime(todayAttendance.checkInTime) }}</span>
        </div>
        <div class="status-item" v-if="todayAttendance && todayAttendance.checkOutTime">
          <span class="label">下班打卡：</span>
          <span class="value">{{ formatTime(todayAttendance.checkOutTime) }}</span>
        </div>
      </div>

      <div class="current-time">
        <div class="time">{{ currentTime }}</div>
        <div class="date">{{ currentDate }}</div>
      </div>

      <div class="action-buttons">
        <button v-if="!todayAttendance" class="check-in-btn" @click="handleCheckIn" :disabled="loading || !locationValid">
          {{ loading ? '处理中...' : '上班打卡' }}
        </button>
        <button v-else-if="!todayAttendance.checkOutTime" class="check-out-btn" @click="handleCheckOut" :disabled="loading || !locationValid">
          {{ loading ? '处理中...' : '下班打卡' }}
        </button>
        <button v-else class="completed-btn" disabled>
          今日已完成打卡
        </button>
      </div>

      <div class="attendance-history">
        <h3>打卡记录</h3>
        <div class="history-list">
          <div v-for="record in attendanceHistory" :key="record.id" class="history-item">
            <div class="history-date">{{ formatDate(record.checkInTime) }}</div>
            <div class="history-time">
              <span>上班：{{ formatTime(record.checkInTime) }}</span>
              <span v-if="record.checkOutTime">下班：{{ formatTime(record.checkOutTime) }}</span>
            </div>
            <div class="history-status" :class="getStatusClass(record.status)">{{ record.status }}</div>
          </div>
          <div v-if="attendanceHistory.length === 0" class="empty">暂无打卡记录</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { attendanceAPI, employeeAPI } from '../../../api/index'
import { toast, modal, navigate } from '../../../utils/common'

export default {
  name: 'StaffAttendance',
  data() {
    return {
      userInfo: {},
      employeeInfo: {},
      locationText: '正在获取位置...',
      locationValid: false,
      todayAttendance: null,
      todayStatus: '未打卡',
      currentTime: '',
      currentDate: '',
      attendanceHistory: [],
      loading: false,
      timer: null
    }
  },
  computed: {
    statusClass() {
      switch (this.todayStatus) {
        case '正常': return 'text-success'
        case '迟到': return 'text-warning'
        case '旷工': return 'text-danger'
        default: return ''
      }
    }
  },
  mounted() {
    const userStr = localStorage.getItem('userInfo')
    if (userStr) {
      this.userInfo = JSON.parse(userStr)
    }
    this.getLocation()
    this.loadTodayAttendance()
    this.loadAttendanceHistory()
    this.updateTime()
    this.timer = setInterval(this.updateTime, 1000)
  },
  beforeDestroy() {
    if (this.timer) {
      clearInterval(this.timer)
    }
  },
  methods: {
    updateTime() {
      const now = new Date()
      this.currentTime = `${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}:${String(now.getSeconds()).padStart(2, '0')}`
      this.currentDate = `${now.getFullYear()}年${now.getMonth() + 1}月${now.getDate()}日 ${['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'][now.getDay()]}`
    },
    getLocation() {
      if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(
          (position) => {
            this.locationText = `纬度: ${position.coords.latitude.toFixed(6)}, 经度: ${position.coords.longitude.toFixed(6)}`
            this.locationValid = true
          },
          (error) => {
            this.locationText = '获取位置失败，请检查定位权限'
            this.locationValid = false
          }
        )
      } else {
        this.locationText = '浏览器不支持定位功能'
        this.locationValid = false
      }
    },
    async loadTodayAttendance() {
      try {
        const response = await employeeAPI.getAll()
        if (Array.isArray(response)) {
          const employees = response.filter(e => e.user && e.user.username === this.userInfo.username)
          if (employees.length > 0) {
            this.employeeInfo = employees[0]
            const todayResp = await attendanceAPI.getToday(employees[0].id)
            if (todayResp) {
              this.todayAttendance = todayResp
              this.todayStatus = todayResp.status || '正常'
            }
          } else {
            console.error('未找到当前员工信息')
            toast.show({ title: '未找到员工信息' })
          }
        }
      } catch (error) {
        console.error('加载今日考勤失败:', error)
        toast.show({ title: '加载考勤失败' })
      }
    },
    async loadAttendanceHistory() {
      try {
        if (!this.employeeInfo || !this.employeeInfo.id) return
        const response = await attendanceAPI.getByEmployee(this.employeeInfo.id)
        if (Array.isArray(response)) {
          this.attendanceHistory = response.slice(0, 7)
        }
      } catch (error) {
        console.error('加载考勤记录失败:', error)
        toast.show({ title: '加载考勤记录失败' })
      }
    },
    formatTime(time) {
      if (!time) return '--:--'
      const d = new Date(time)
      return `${String(d.getHours()).padStart(2, '0')}:${String(d.getMinutes()).padStart(2, '0')}`
    },
    formatDate(time) {
      if (!time) return ''
      const d = new Date(time)
      return `${d.getMonth() + 1}月${d.getDate()}日`
    },
    getStatusClass(status) {
      switch (status) {
        case '正常': return 'status-normal'
        case '迟到': return 'status-late'
        case '旷工': return 'status-absent'
        default: return ''
      }
    },
    goBack() {
      this.$router.push('/staff/dashboard')
    },
    async handleCheckIn() {
      if (!this.locationValid) {
        if (typeof uni !== 'undefined') {
          toast.show({ title: '请在门店范围内打卡' })
        }
        return
      }

      if (!this.employeeInfo || !this.employeeInfo.id) {
        toast.show({ title: '员工信息不存在' })
        return
      }

      this.loading = true
      try {
        const response = await attendanceAPI.checkIn({
          employeeId: this.employeeInfo.id,
          location: this.locationText,
          photo: ''
        })
        if (response && response.id) {
          this.todayAttendance = response
          this.todayStatus = response.status || '正常'
          this.loadAttendanceHistory()
          toast.show({ title: '上班打卡成功' })
        } else {
          toast.show({ title: '打卡失败' })
        }
      } catch (error) {
        console.error('打卡失败:', error)
        if (typeof uni !== 'undefined') {
          toast.show({ title: '打卡失败，请重试' })
        }
      } finally {
        this.loading = false
      }
    },
    async handleCheckOut() {
      if (!this.locationValid) {
        if (typeof uni !== 'undefined') {
          toast.show({ title: '请在门店范围内打卡' })
        }
        return
      }

      if (!this.todayAttendance || !this.todayAttendance.id) {
        toast.show({ title: '请先上班打卡' })
        return
      }

      this.loading = true
      try {
        const response = await attendanceAPI.checkOut({
          attendanceId: this.todayAttendance.id,
          location: this.locationText,
          photo: ''
        })
        if (response && response.id) {
          this.todayAttendance = response
          this.loadAttendanceHistory()
          toast.show({ title: '下班打卡成功' })
        } else {
          toast.show({ title: '打卡失败' })
        }
      } catch (error) {
        console.error('打卡失败:', error)
        if (typeof uni !== 'undefined') {
          toast.show({ title: '打卡失败，请重试' })
        }
      } finally {
        this.loading = false
      }
    }
  }
}
</script>

<style scoped>
.attendance {
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

.attendance-container {
  padding: 20px;
}

.employee-info {
  display: flex;
  align-items: center;
  padding: 20px;
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  margin-bottom: 15px;
}

.avatar img {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  margin-right: 20px;
}

.info h2 {
  font-size: 18px;
  color: #333;
  margin-bottom: 5px;
}

.info p {
  font-size: 14px;
  color: #666;
  margin: 0;
}

.location-info,
.attendance-status {
  padding: 15px;
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  margin-bottom: 15px;
}

.location-item,
.status-item {
  display: flex;
  justify-content: space-between;
  margin-bottom: 10px;
}

.location-item .label,
.status-item .label {
  font-size: 14px;
  color: #666;
}

.location-item .value,
.status-item .value {
  font-size: 14px;
  color: #333;
}

.text-success { color: #4CAF50; }
.text-warning { color: #FF9800; }
.text-danger { color: #F44336; }

.current-time {
  text-align: center;
  padding: 30px;
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  margin-bottom: 15px;
}

.current-time .time {
  font-size: 48px;
  font-weight: bold;
  color: #333;
}

.current-time .date {
  font-size: 16px;
  color: #666;
  margin-top: 10px;
}

.action-buttons {
  display: flex;
  justify-content: center;
  margin-bottom: 15px;
}

.check-in-btn,
.check-out-btn,
.completed-btn {
  padding: 15px 60px;
  border: none;
  border-radius: 4px;
  font-size: 16px;
  font-weight: bold;
  cursor: pointer;
}

.check-in-btn {
  background-color: #4CAF50;
  color: #fff;
}

.check-out-btn {
  background-color: #2196F3;
  color: #fff;
}

.completed-btn {
  background-color: #9E9E9E;
  color: #fff;
  cursor: not-allowed;
}

.check-in-btn:disabled,
.check-out-btn:disabled {
  background-color: #ccc;
  cursor: not-allowed;
}

.attendance-history {
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  padding: 20px;
}

.attendance-history h3 {
  font-size: 16px;
  color: #333;
  margin-bottom: 15px;
}

.history-list {
  max-height: 300px;
  overflow-y: auto;
}

.history-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 0;
  border-bottom: 1px solid #eee;
}

.history-date {
  font-size: 14px;
  color: #333;
  width: 70px;
}

.history-time {
  flex: 1;
  font-size: 14px;
  color: #666;
  text-align: center;
}

.history-time span {
  margin-right: 15px;
}

.history-status {
  font-size: 12px;
  font-weight: bold;
  padding: 4px 8px;
  border-radius: 4px;
}

.status-normal {
  background-color: #E8F5E9;
  color: #4CAF50;
}

.status-late {
  background-color: #FFF3E0;
  color: #FF9800;
}

.status-absent {
  background-color: #FFEBEE;
  color: #F44336;
}

.empty {
  text-align: center;
  padding: 20px;
  color: #999;
}
</style>