<template>
  <div class="dashboard">
    <header class="header">
      <h1>会员中心</h1>
      <button class="logout-btn" @click="logout">退出登录</button>
    </header>
    <div class="menu-container">
      <div class="menu-item" @click="navigateTo('profile')">
        <div class="menu-icon">👤</div>
        <div class="menu-label">个人资料</div>
      </div>
      <div class="menu-item" @click="navigateTo('reservation')">
        <div class="menu-icon">📋</div>
        <div class="menu-label">预约服务</div>
      </div>
      <div class="menu-item" @click="navigateTo('myReservations')">
        <div class="menu-icon">📅</div>
        <div class="menu-label">我的预约</div>
      </div>
      <div class="menu-item" @click="navigateTo('consumption')">
        <div class="menu-icon">💳</div>
        <div class="menu-label">消费记录</div>
      </div>
      <div class="menu-item" @click="navigateTo('mall')">
        <div class="menu-icon">🛍️</div>
        <div class="menu-label">在线商城</div>
      </div>
      <div class="menu-item" @click="navigateTo('points')">
        <div class="menu-icon">🎁</div>
        <div class="menu-label">积分商城</div>
      </div>
      <div class="menu-item" @click="navigateTo('activities')">
        <div class="menu-icon">🎉</div>
        <div class="menu-label">营销活动</div>
      </div>
      <div class="menu-item" @click="navigateTo('evaluation')">
        <div class="menu-icon">⭐</div>
        <div class="menu-label">评价系统</div>
      </div>
      <div class="menu-item" @click="navigateTo('notifications')">
        <div class="menu-icon">🔔</div>
        <div class="menu-label">消息通知</div>
      </div>
      <div class="menu-item" @click="navigateTo('promoter')">
        <div class="menu-icon">📣</div>
        <div class="menu-label">推广员功能</div>
      </div>
      <div class="menu-item" @click="navigateTo('verification')">
        <div class="menu-icon">✓</div>
        <div class="menu-label">我的核销码</div>
      </div>
      <div class="menu-item" @click="navigateTo('grouppurchase')">
        <div class="menu-icon">🏷️</div>
        <div class="menu-label">本地生活团购</div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'CustomerDashboard',
  methods: {
    logout() {
      localStorage.removeItem('userInfo')
      this.$router.push('/login')
    },
    navigateTo(page) {
      switch (page) {
        case 'profile':
          this.$router.push('/customer/profile')
          break
        case 'reservation':
          this.$router.push('/customer/reservation/create')
          break
        case 'myReservations':
          this.$router.push('/customer/reservation/list')
          break
        case 'consumption':
          this.$router.push('/customer/consumption')
          break
        case 'mall':
          this.$router.push('/customer/mall')
          break
        case 'points':
          this.$router.push('/customer/points')
          break
        case 'activities':
          this.$router.push('/customer/activities')
          break
        case 'evaluation':
          this.$router.push('/customer/evaluation')
          break
        case 'notifications':
          this.$router.push('/customer/notifications')
          break
        case 'promoter':
          this.$router.push('/customer/promoter')
          break
        case 'verification':
          this.$router.push('/customer/verification')
          break
        case 'grouppurchase':
          this.$router.push('/customer/grouppurchase')
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
