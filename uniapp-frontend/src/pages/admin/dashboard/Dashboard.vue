<template>
  <div class="dashboard">
    <header class="header">
      <h1>管理员工作台</h1>
      <button class="logout-btn" @click="logout">退出登录</button>
    </header>
    <div class="menu-container">
      <div class="menu-item" @click="navigateTo('employee')">
        <div class="menu-icon">👥</div>
        <div class="menu-label">员工管理</div>
      </div>
      <div class="menu-item" @click="navigateTo('schedule')">
        <div class="menu-icon">📅</div>
        <div class="menu-label">员工排班</div>
      </div>
      <div class="menu-item" @click="navigateTo('attendance')">
        <div class="menu-icon">📍</div>
        <div class="menu-label">考勤管理</div>
      </div>
      <div class="menu-item" @click="navigateTo('salary')">
        <div class="menu-icon">💵</div>
        <div class="menu-label">薪酬管理</div>
      </div>
      <div class="menu-item" @click="navigateTo('shift')">
        <div class="menu-icon">🔄</div>
        <div class="menu-label">门店交班</div>
      </div>
      <div class="menu-item" @click="navigateTo('customer')">
        <div class="menu-icon">👤</div>
        <div class="menu-label">顾客档案</div>
      </div>
      <div class="menu-item" @click="navigateTo('marketing')">
        <div class="menu-icon">📣</div>
        <div class="menu-label">全员营销</div>
      </div>
      <div class="menu-item" @click="navigateTo('reservation')">
        <div class="menu-icon">📋</div>
        <div class="menu-label">预约管理</div>
      </div>
      <div class="menu-item" @click="navigateTo('room')">
        <div class="menu-icon">🏠</div>
        <div class="menu-label">房间管理</div>
      </div>
      <div class="menu-item" @click="navigateTo('checkout')">
        <div class="menu-icon">💳</div>
        <div class="menu-label">开单收银</div>
      </div>
      <div class="menu-item" @click="navigateTo('inventory')">
        <div class="menu-icon">📦</div>
        <div class="menu-label">库存管理</div>
      </div>
      <div class="menu-item" @click="navigateTo('commission')">
        <div class="menu-icon">💰</div>
        <div class="menu-label">提成管理</div>
      </div>
      <div class="menu-item" @click="navigateTo('service')">
        <div class="menu-icon">✂️</div>
        <div class="menu-label">服务记录</div>
      </div>
      <div class="menu-item" @click="navigateTo('analysis')">
        <div class="menu-icon">📊</div>
        <div class="menu-label">数据分析</div>
      </div>
      <div class="menu-item" @click="navigateTo('member')">
        <div class="menu-icon">💎</div>
        <div class="menu-label">会员体系</div>
      </div>
      <div class="menu-item" @click="navigateTo('coupon')">
        <div class="menu-icon">🎫</div>
        <div class="menu-label">卡券管理</div>
      </div>
      <div class="menu-item" @click="navigateTo('verification')">
        <div class="menu-icon">✓</div>
        <div class="menu-label">核销管理</div>
      </div>
      <div class="menu-item" @click="navigateTo('grouppurchase')">
        <div class="menu-icon">🏷️</div>
        <div class="menu-label">本地生活团购</div>
      </div>
      <div class="menu-item" @click="navigateTo('marketing')">
        <div class="menu-icon">📢</div>
        <div class="menu-label">营销活动</div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'AdminDashboard',
  methods: {
    logout() {
      localStorage.removeItem('userInfo')
      this.$router.push('/login')
    },
    navigateTo(page) {
      switch (page) {
        case 'employee':
          this.$router.push('/admin/employee/list')
          break
        case 'customer':
          this.$router.push('/admin/customer/list')
          break
        case 'checkout':
          this.$router.push('/admin/checkout')
          break
        case 'reservation':
          this.$router.push('/admin/reservation/list')
          break
        case 'schedule':
          this.$router.push('/admin/schedule/list')
          break
        case 'shift':
          this.$router.push('/admin/shift/list')
          break
        case 'inventory':
          this.$router.push('/admin/inventory/list')
          break
        case 'commission':
          this.$router.push('/admin/commission/list')
          break
        case 'service':
          this.$router.push('/admin/service/records')
          break
        case 'room':
          this.$router.push('/admin/room/list')
          break
        case 'analysis':
          this.$router.push('/admin/dashboard/data')
          break
        case 'member':
          this.$router.push('/admin/member/list')
          break
        case 'coupon':
          this.$router.push('/admin/coupon/list')
          break
        case 'marketing':
          this.$router.push('/admin/marketing/list')
          break
        case 'attendance':
          this.$router.push('/admin/attendance')
          break
        case 'salary':
          this.$router.push('/admin/salary')
          break
        case 'verification':
          this.$router.push('/admin/verification')
          break
        case 'grouppurchase':
          this.$router.push('/admin/grouppurchase')
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