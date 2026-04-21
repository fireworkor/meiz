<template>
  <div class="notifications">
    <header class="header">
      <h1>消息通知</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="notification-tabs">
      <div class="tab" :class="{ active: activeTab === 'all' }" @click="activeTab = 'all'">
        全部
      </div>
      <div class="tab" :class="{ active: activeTab === 'unread' }" @click="activeTab = 'unread'">
        未读
      </div>
      <div class="tab" :class="{ active: activeTab === 'system' }" @click="activeTab = 'system'">
        系统
      </div>
    </div>

    <div class="notification-list">
      <div v-for="notification in filteredNotifications" :key="notification.id" class="notification-item" @click="markAsRead(notification)">
        <div class="notification-icon" :class="getIconClass(notification.type)">
          {{ getIcon(notification.type) }}
        </div>
        <div class="notification-content">
          <div class="notification-header">
            <h3 class="notification-title">{{ notification.title }}</h3>
            <span class="notification-time">{{ formatTime(notification.time) }}</span>
          </div>
          <p class="notification-message">{{ notification.message }}</p>
          <div class="notification-badge" v-if="!notification.read">未读</div>
        </div>
      </div>
      <div v-if="filteredNotifications.length === 0" class="empty">
        <div class="empty-icon">🔔</div>
        <p>暂无消息</p>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'StaffNotifications',
  data() {
    return {
      activeTab: 'all',
      notifications: [
        {
          id: 1,
          title: '调班申请已批准',
          message: '您的调班申请已被批准，新班次为晚班 (14:00-22:00)',
          time: '2024-04-22 10:30',
          type: 'shift',
          read: false
        },
        {
          id: 2,
          title: '新的预约',
          message: '您有一个新的预约，顾客：张女士，时间：2024-04-23 14:00',
          time: '2024-04-22 09:15',
          type: 'reservation',
          read: false
        },
        {
          id: 3,
          title: '业绩通知',
          message: '您本月的销售业绩已更新，总销售额：¥6800，总提成：¥1360',
          time: '2024-04-01 00:00',
          type: 'performance',
          read: true
        },
        {
          id: 4,
          title: '系统通知',
          message: '系统将于2024-04-25 23:00进行维护，预计持续2小时',
          time: '2024-04-20 16:30',
          type: 'system',
          read: true
        },
        {
          id: 5,
          title: '营销活动开始',
          message: '春季护理特惠活动已开始，所有护理项目8折优惠',
          time: '2024-04-01 00:00',
          type: 'marketing',
          read: true
        }
      ]
    }
  },
  computed: {
    filteredNotifications() {
      let result = [...this.notifications]
      
      if (this.activeTab === 'unread') {
        result = result.filter(n => !n.read)
      } else if (this.activeTab === 'system') {
        result = result.filter(n => n.type === 'system')
      }
      
      return result.sort((a, b) => new Date(b.time) - new Date(a.time))
    }
  },
  methods: {
    markAsRead(notification) {
      if (!notification.read) {
        notification.read = true
        uni.showToast({ title: '已标记为已读', icon: 'success' })
      }
    },
    getIcon(type) {
      switch (type) {
        case 'shift': return '🔄'
        case 'reservation': return '📋'
        case 'performance': return '📊'
        case 'system': return '⚙️'
        case 'marketing': return '📣'
        default: return '🔔'
      }
    },
    getIconClass(type) {
      switch (type) {
        case 'shift': return 'icon-shift'
        case 'reservation': return 'icon-reservation'
        case 'performance': return 'icon-performance'
        case 'system': return 'icon-system'
        case 'marketing': return 'icon-marketing'
        default: return ''
      }
    },
    formatTime(time) {
      if (!time) return ''
      const date = new Date(time)
      const now = new Date()
      const diff = now - date
      
      if (diff < 60000) return '刚刚'
      if (diff < 3600000) return `${Math.floor(diff / 60000)}分钟前`
      if (diff < 86400000) return `${Math.floor(diff / 3600000)}小时前`
      if (diff < 604800000) return `${Math.floor(diff / 86400000)}天前`
      
      return time.split(' ')[0]
    },
    goBack() {
      this.$router.push('/staff/dashboard')
    }
  }
}
</script>

<style scoped>
.notifications {
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

.notification-tabs {
  display: flex;
  background-color: #fff;
  margin-bottom: 10px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.tab {
  flex: 1;
  padding: 15px;
  text-align: center;
  font-size: 14px;
  color: #666;
  cursor: pointer;
  border-bottom: 2px solid transparent;
  transition: all 0.2s;
}

.tab.active {
  color: #ff6b81;
  border-bottom-color: #ff6b81;
  font-weight: bold;
}

.notification-list {
  padding: 20px;
}

.notification-item {
  display: flex;
  background-color: #fff;
  border-radius: 8px;
  padding: 15px;
  margin-bottom: 15px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  cursor: pointer;
  transition: transform 0.2s;
}

.notification-item:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.notification-icon {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 20px;
  margin-right: 15px;
  flex-shrink: 0;
}

.icon-shift {
  background-color: #E3F2FD;
}

.icon-reservation {
  background-color: #E8F5E9;
}

.icon-performance {
  background-color: #FFF3E0;
}

.icon-system {
  background-color: #F3E5F5;
}

.icon-marketing {
  background-color: #FFF8E1;
}

.notification-content {
  flex: 1;
  position: relative;
}

.notification-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 8px;
}

.notification-title {
  font-size: 16px;
  color: #333;
  margin: 0;
  font-weight: bold;
}

.notification-time {
  font-size: 12px;
  color: #999;
}

.notification-message {
  font-size: 14px;
  color: #666;
  margin: 0 0 8px 0;
  line-height: 1.4;
}

.notification-badge {
  position: absolute;
  top: 0;
  right: 0;
  padding: 2px 8px;
  background-color: #ff6b81;
  color: #fff;
  font-size: 12px;
  border-radius: 4px;
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
