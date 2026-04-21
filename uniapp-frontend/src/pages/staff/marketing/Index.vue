<template>
  <div class="marketing">
    <header class="header">
      <h1>全员营销</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="marketing-activities">
      <h2 class="section-title">当前活动</h2>
      <div class="activity-list">
        <div v-for="activity in activities" :key="activity.id" class="activity-card">
          <div class="activity-header">
            <h3>{{ activity.name }}</h3>
            <span :class="['status-badge', getStatusClass(activity.status)]">
              {{ activity.status }}
            </span>
          </div>
          <div class="activity-info">
            <div class="info-row">
              <span class="label">活动类型：</span>
              <span class="value">{{ activity.type }}</span>
            </div>
            <div class="info-row">
              <span class="label">活动时间：</span>
              <span class="value">{{ formatDate(activity.startDate) }} 至 {{ formatDate(activity.endDate) }}</span>
            </div>
            <div class="info-row" v-if="activity.discountRate">
              <span class="label">折扣力度：</span>
              <span class="value">{{ (activity.discountRate * 10).toFixed(1) }}折</span>
            </div>
            <div class="info-row" v-if="activity.description">
              <span class="label">活动说明：</span>
              <span class="value">{{ activity.description }}</span>
            </div>
          </div>
          <div class="activity-actions">
            <button class="share-btn" @click="shareActivity(activity)">分享活动</button>
            <button class="details-btn" @click="viewActivityDetails(activity.id)">查看详情</button>
          </div>
        </div>
        <div v-if="activities.length === 0" class="empty">
          <div class="empty-icon">📢</div>
          <p>暂无营销活动</p>
        </div>
      </div>
    </div>

    <div class="marketing-tools">
      <h2 class="section-title">营销工具</h2>
      <div class="tool-grid">
        <div class="tool-item" @click="createCoupon">
          <div class="tool-icon">🎫</div>
          <div class="tool-label">发放优惠券</div>
        </div>
        <div class="tool-item" @click="shareStore">
          <div class="tool-icon">🏠</div>
          <div class="tool-label">分享店铺</div>
        </div>
        <div class="tool-item" @click="inviteCustomer">
          <div class="tool-icon">👥</div>
          <div class="tool-label">邀请顾客</div>
        </div>
        <div class="tool-item" @click="viewQRCode">
          <div class="tool-icon">📱</div>
          <div class="tool-label">我的二维码</div>
        </div>
      </div>
    </div>

    <div class="performance-section">
      <h2 class="section-title">我的营销业绩</h2>
      <div class="performance-stats">
        <div class="stat-item">
          <div class="stat-value">{{ totalReferrals }}</div>
          <div class="stat-label">推荐人数</div>
        </div>
        <div class="stat-item">
          <div class="stat-value">{{ totalSales }}</div>
          <div class="stat-label">销售金额</div>
        </div>
        <div class="stat-item">
          <div class="stat-value">{{ totalRewards }}</div>
          <div class="stat-label">奖励金额</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { marketingActivityAPI } from '../../../api/index'

export default {
  name: 'StaffMarketing',
  data() {
    return {
      activities: [],
      totalReferrals: 12,
      totalSales: 5800,
      totalRewards: 870
    }
  },
  mounted() {
    this.loadActivities()
  },
  methods: {
    async loadActivities() {
      try {
        // 模拟数据，实际应该从后端API获取
        this.activities = [
          {
            id: 1,
            name: '春季护理特惠',
            type: '折扣活动',
            status: '进行中',
            startDate: '2024-04-01',
            endDate: '2024-04-30',
            discountRate: 0.8,
            description: '春季护理套餐8折优惠，包含面部护理和身体按摩'
          },
          {
            id: 2,
            name: '新客专享',
            type: '满减活动',
            status: '进行中',
            startDate: '2024-04-01',
            endDate: '2024-05-31',
            minAmount: 200,
            discountAmount: 50,
            description: '新客户消费满200减50'
          },
          {
            id: 3,
            name: '会员日活动',
            type: '会员专享',
            status: '未开始',
            startDate: '2024-05-01',
            endDate: '2024-05-07',
            description: '会员专享双倍积分'
          }
        ]
      } catch (error) {
        console.error('加载营销活动失败:', error)
      }
    },
    formatDate(date) {
      if (!date) return ''
      const d = new Date(date)
      return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
    },
    getStatusClass(status) {
      switch (status) {
        case '进行中': return 'status-active'
        case '已结束': return 'status-ended'
        case '未开始': return 'status-pending'
        default: return ''
      }
    },
    shareActivity(activity) {
      uni.showToast({ title: '分享链接已复制到剪贴板', icon: 'success' })
    },
    viewActivityDetails(id) {
      uni.showToast({ title: '查看活动详情', icon: 'none' })
    },
    createCoupon() {
      uni.showToast({ title: '优惠券发放功能开发中', icon: 'none' })
    },
    shareStore() {
      uni.showToast({ title: '店铺链接已复制到剪贴板', icon: 'success' })
    },
    inviteCustomer() {
      uni.showToast({ title: '邀请链接已复制到剪贴板', icon: 'success' })
    },
    viewQRCode() {
      uni.showToast({ title: '二维码功能开发中', icon: 'none' })
    },
    goBack() {
      this.$router.push('/staff/dashboard')
    }
  }
}
</script>

<style scoped>
.marketing {
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

.section-title {
  font-size: 16px;
  color: #333;
  margin: 20px 0 15px 20px;
}

.activity-list {
  padding: 0 20px;
}

.activity-card {
  background-color: #fff;
  border-radius: 8px;
  padding: 15px;
  margin-bottom: 15px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.activity-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
  padding-bottom: 10px;
  border-bottom: 1px solid #eee;
}

.activity-header h3 {
  font-size: 16px;
  color: #333;
  margin: 0;
}

.status-badge {
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
}

.status-active {
  background-color: #E3F2FD;
  color: #1976D2;
}

.status-ended {
  background-color: #FFEBEE;
  color: #F44336;
}

.status-pending {
  background-color: #FFF3E0;
  color: #FF9800;
}

.activity-info {
  margin-bottom: 15px;
}

.info-row {
  display: flex;
  margin-bottom: 8px;
}

.info-row .label {
  font-size: 14px;
  color: #666;
  width: 80px;
}

.info-row .value {
  font-size: 14px;
  color: #333;
  flex: 1;
}

.activity-actions {
  display: flex;
  gap: 10px;
}

.share-btn,
.details-btn {
  flex: 1;
  padding: 8px;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.share-btn {
  background-color: #4CAF50;
  color: #fff;
}

.details-btn {
  background-color: #2196F3;
  color: #fff;
}

.tool-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 15px;
  padding: 0 20px;
}

.tool-item {
  background-color: #fff;
  border-radius: 8px;
  padding: 20px;
  display: flex;
  flex-direction: column;
  align-items: center;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  cursor: pointer;
  transition: transform 0.2s;
}

.tool-item:hover {
  transform: translateY(-5px);
}

.tool-icon {
  font-size: 32px;
  margin-bottom: 10px;
}

.tool-label {
  font-size: 14px;
  color: #333;
  text-align: center;
}

.performance-stats {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 15px;
  padding: 0 20px 20px;
}

.stat-item {
  background-color: #fff;
  border-radius: 8px;
  padding: 20px;
  text-align: center;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.stat-value {
  font-size: 20px;
  font-weight: bold;
  color: #333;
}

.stat-label {
  font-size: 12px;
  color: #666;
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
