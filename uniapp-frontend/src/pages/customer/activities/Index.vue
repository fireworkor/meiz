<template>
  <div class="activities">
    <header class="header">
      <h1>营销活动</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="banner-section">
      <div class="banner" @click="viewActivity(1)">
        <img src="https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=beauty%20salon%20promotion%20banner%20spring%20sale&image_size=landscape_16_9" alt="春季促销" />
        <div class="banner-content">
          <h3>春季护理特惠</h3>
          <p>所有护理项目8折优惠</p>
          <span class="banner-date">2024.04.01-2024.04.30</span>
        </div>
      </div>
    </div>

    <div class="activity-list">
      <div v-for="activity in activities" :key="activity.id" class="activity-card" @click="viewActivity(activity.id)">
        <div class="activity-image">
          <img :src="activity.image" :alt="activity.name" />
          <div class="activity-tag" v-if="activity.tag">{{ activity.tag }}</div>
        </div>
        <div class="activity-info">
          <h3 class="activity-name">{{ activity.name }}</h3>
          <p class="activity-description">{{ activity.description }}</p>
          <div class="activity-meta">
            <span class="activity-date">{{ activity.dateRange }}</span>
            <span :class="['activity-status', getStatusClass(activity.status)]">
              {{ activity.status }}
            </span>
          </div>
        </div>
      </div>
    </div>

    <div class="recommended-section">
      <h2 class="section-title">推荐活动</h2>
      <div class="recommended-list">
        <div v-for="recommended in recommendedActivities" :key="recommended.id" class="recommended-item" @click="viewActivity(recommended.id)">
          <div class="recommended-icon">{{ recommended.icon }}</div>
          <div class="recommended-content">
            <h3 class="recommended-name">{{ recommended.name }}</h3>
            <p class="recommended-desc">{{ recommended.description }}</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'CustomerActivities',
  data() {
    return {
      activities: [
        {
          id: 1,
          name: '春季护理特惠',
          description: '春季护理套餐8折优惠，包含面部护理和身体按摩',
          dateRange: '2024.04.01-2024.04.30',
          status: '进行中',
          tag: '热门',
          image: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=spring%20skincare%20promotion&image_size=square'
        },
        {
          id: 2,
          name: '新客专享',
          description: '新客户消费满200减50，首次体验额外送面膜',
          dateRange: '2024.04.01-2024.05.31',
          status: '进行中',
          tag: '新客',
          image: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=new%20customer%20promotion&image_size=square'
        },
        {
          id: 3,
          name: '会员日活动',
          description: '会员专享双倍积分，部分产品5折起',
          dateRange: '2024.05.01-2024.05.07',
          status: '未开始',
          image: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=member%20day%20promotion&image_size=square'
        },
        {
          id: 4,
          name: '五一劳动节',
          description: '劳动最光荣，全场护理项目7折优惠',
          dateRange: '2024.05.01-2024.05.03',
          status: '未开始',
          image: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=may%20day%20promotion&image_size=square'
        }
      ],
      recommendedActivities: [
        {
          id: 1,
          name: '分享有礼',
          description: '分享活动给好友，双方都可获得优惠券',
          icon: '📤'
        },
        {
          id: 2,
          name: '生日特权',
          description: '生日当月享受护理项目6折优惠',
          icon: '🎂'
        },
        {
          id: 3,
          name: '打卡领积分',
          description: '连续打卡7天，领取100积分',
          icon: '📅'
        }
      ]
    }
  },
  methods: {
    viewActivity(id) {
      uni.showToast({ title: `查看活动详情 ${id}`, icon: 'none' })
    },
    getStatusClass(status) {
      switch (status) {
        case '进行中': return 'status-active'
        case '已结束': return 'status-ended'
        case '未开始': return 'status-pending'
        default: return ''
      }
    },
    goBack() {
      this.$router.push('/customer/dashboard')
    }
  }
}
</script>

<style scoped>
.activities {
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

.banner-section {
  padding: 20px;
}

.banner {
  position: relative;
  border-radius: 8px;
  overflow: hidden;
  cursor: pointer;
}

.banner img {
  width: 100%;
  height: 200px;
  object-fit: cover;
}

.banner-content {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  background: linear-gradient(transparent, rgba(0, 0, 0, 0.7));
  color: #fff;
  padding: 20px;
}

.banner-content h3 {
  font-size: 18px;
  margin: 0 0 5px 0;
}

.banner-content p {
  font-size: 14px;
  margin: 0 0 10px 0;
}

.banner-date {
  font-size: 12px;
  opacity: 0.8;
}

.activity-list {
  padding: 0 20px;
}

.activity-card {
  background-color: #fff;
  border-radius: 8px;
  overflow: hidden;
  margin-bottom: 15px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  cursor: pointer;
  transition: transform 0.2s;
}

.activity-card:hover {
  transform: translateY(-2px);
}

.activity-image {
  position: relative;
  height: 150px;
}

.activity-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.activity-tag {
  position: absolute;
  top: 10px;
  left: 10px;
  background-color: #ff6b81;
  color: #fff;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
}

.activity-info {
  padding: 15px;
}

.activity-name {
  font-size: 16px;
  color: #333;
  margin: 0 0 8px 0;
}

.activity-description {
  font-size: 14px;
  color: #666;
  margin: 0 0 10px 0;
  line-height: 1.4;
}

.activity-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.activity-date {
  font-size: 12px;
  color: #999;
}

.activity-status {
  padding: 2px 8px;
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

.section-title {
  font-size: 16px;
  color: #333;
  margin: 20px 0 15px 20px;
}

.recommended-list {
  padding: 0 20px 20px;
}

.recommended-item {
  display: flex;
  align-items: center;
  background-color: #fff;
  border-radius: 8px;
  padding: 15px;
  margin-bottom: 10px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  cursor: pointer;
  transition: transform 0.2s;
}

.recommended-item:hover {
  transform: translateY(-2px);
}

.recommended-icon {
  font-size: 32px;
  margin-right: 15px;
  width: 50px;
  height: 50px;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #f0f0f0;
  border-radius: 50%;
  flex-shrink: 0;
}

.recommended-content {
  flex: 1;
}

.recommended-name {
  font-size: 16px;
  color: #333;
  margin: 0 0 5px 0;
}

.recommended-desc {
  font-size: 14px;
  color: #666;
  margin: 0;
}
</style>
