<template>
  <div class="dashboard">
    <header class="header">
      <h1>员工工作台</h1>
      <button class="logout-btn" @click="logout">退出登录</button>
    </header>
    <div class="menu-container">
      <div class="menu-item" @click="navigateTo('todayReservation')">
        <div class="menu-icon">📋</div>
        <div class="menu-label">今日预约</div>
      </div>
      <div class="menu-item" @click="navigateTo('attendance')">
        <div class="menu-icon">📍</div>
        <div class="menu-label">考勤打卡</div>
      </div>
      <div class="menu-item" @click="navigateTo('performance')">
        <div class="menu-icon">📊</div>
        <div class="menu-label">我的业绩</div>
      </div>
      <div class="menu-item" @click="navigateTo('marketing')">
        <div class="menu-icon">📣</div>
        <div class="menu-label">全员营销</div>
      </div>
      <div class="menu-item" @click="navigateTo('checkout')">
        <div class="menu-icon">💳</div>
        <div class="menu-label">开单（加钟）</div>
      </div>
      <div class="menu-item" @click="navigateTo('shiftApply')">
        <div class="menu-icon">🔄</div>
        <div class="menu-label">申请调班</div>
      </div>
      <div class="menu-item" @click="navigateTo('notifications')">
        <div class="menu-icon">🔔</div>
        <div class="menu-label">消息通知</div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'StaffDashboard',
  methods: {
    logout() {
      localStorage.removeItem('userInfo')
      this.$router.push('/login')
    },
    navigateTo(page) {
      switch (page) {
        case 'attendance':
          this.$router.push('/staff/attendance')
          break
        case 'todayReservation':
          this.$router.push('/staff/reservation/today')
          break
        case 'performance':
          this.$router.push('/staff/performance')
          break
        case 'marketing':
          this.$router.push('/staff/marketing')
          break
        case 'checkout':
          this.$router.push('/staff/checkout')
          break
        case 'shiftApply':
          this.$router.push('/staff/shift/apply')
          break
        case 'notifications':
          this.$router.push('/staff/notifications')
          break
        default:
          alert(`${page}功能开发中`)
      }
    }
  }
}
</script>

<style scoped>
.dashboard {
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

.logout-btn {
  padding: 8px 16px;
  background-color: #ff6b81;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.menu-container {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
  padding: 20px;
}

.menu-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 20px;
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  cursor: pointer;
  transition: transform 0.2s;
}

.menu-item:hover {
  transform: translateY(-5px);
}

.menu-icon {
  font-size: 32px;
  margin-bottom: 10px;
}

.menu-label {
  font-size: 14px;
  color: #333;
  text-align: center;
}
</style>
