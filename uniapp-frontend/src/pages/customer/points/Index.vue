<template>
  <div class="points-mall">
    <header class="header">
      <h1>积分商城</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="points-info">
      <div class="points-card">
        <div class="points-header">
          <h2>我的积分</h2>
          <span class="points-balance">{{ userPoints }} 积分</span>
        </div>
        <div class="points-rules">
          <div class="rule-item">
            <span class="rule-icon">💰</span>
            <span class="rule-text">消费1元 = 1积分</span>
          </div>
          <div class="rule-item">
            <span class="rule-icon">🎁</span>
            <span class="rule-text">100积分 = 1元</span>
          </div>
          <div class="rule-item">
            <span class="rule-icon">📅</span>
            <span class="rule-text">积分有效期：1年</span>
          </div>
        </div>
      </div>
    </div>

    <div class="points-history">
      <h2 class="section-title">积分明细</h2>
      <div class="history-list">
        <div v-for="item in pointsHistory" :key="item.id" class="history-item">
          <div class="history-info">
            <h3 class="history-title">{{ item.title }}</h3>
            <p class="history-date">{{ item.date }}</p>
          </div>
          <div :class="['history-points', item.type === 'income' ? 'points-income' : 'points-expense']">
            {{ item.type === 'income' ? '+' : '-' }}{{ item.points }}
          </div>
        </div>
        <div v-if="pointsHistory.length === 0" class="empty">
          <div class="empty-icon">🎁</div>
          <p>暂无积分记录</p>
        </div>
      </div>
    </div>

    <div class="exchange-section">
      <h2 class="section-title">积分兑换</h2>
      <div class="exchange-list">
        <div v-for="item in exchangeItems" :key="item.id" class="exchange-item" @click="exchangeItem(item)">
          <div class="item-image">
            <img :src="item.image" :alt="item.name" />
          </div>
          <div class="item-info">
            <h3 class="item-name">{{ item.name }}</h3>
            <p class="item-description">{{ item.description }}</p>
            <div class="item-points">
              <span class="points-required">{{ item.points }} 积分</span>
              <button class="exchange-btn" :disabled="userPoints < item.points">
                {{ userPoints < item.points ? '积分不足' : '立即兑换' }}
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'CustomerPoints',
  data() {
    return {
      userPoints: 1280,
      pointsHistory: [
        {
          id: 1,
          title: '消费获得积分',
          points: 128,
          type: 'income',
          date: '2024-04-20 14:30'
        },
        {
          id: 2,
          title: '兑换商品',
          points: 500,
          type: 'expense',
          date: '2024-04-15 10:20'
        },
        {
          id: 3,
          title: '消费获得积分',
          points: 89,
          type: 'income',
          date: '2024-04-10 16:45'
        },
        {
          id: 4,
          title: '注册送积分',
          points: 200,
          type: 'income',
          date: '2024-04-01 09:00'
        }
      ],
      exchangeItems: [
        {
          id: 1,
          name: '优惠券 ¥50',
          description: '满200元可用',
          points: 5000,
          image: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=coupon%2050%20yuan&image_size=square'
        },
        {
          id: 2,
          name: '面部护理一次',
          description: '价值198元',
          points: 1980,
          image: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=facial%20treatment%20service&image_size=square'
        },
        {
          id: 3,
          name: '面膜一盒',
          description: '5片装',
          points: 800,
          image: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=face%20mask%20box&image_size=square'
        },
        {
          id: 4,
          name: '精美礼品',
          description: '品牌定制',
          points: 500,
          image: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=gift%20box%20精美礼品&image_size=square'
        }
      ]
    }
  },
  methods: {
    exchangeItem(item) {
      if (this.userPoints < item.points) {
        uni.showToast({ title: '积分不足', icon: 'none' })
        return
      }
      
      uni.showModal({
        title: '确认兑换',
        content: `确定要花费 ${item.points} 积分兑换 ${item.name} 吗？`,
        success: (res) => {
          if (res.confirm) {
            this.userPoints -= item.points
            this.pointsHistory.unshift({
              id: Date.now(),
              title: `兑换 ${item.name}`,
              points: item.points,
              type: 'expense',
              date: new Date().toLocaleString()
            })
            uni.showToast({ title: '兑换成功', icon: 'success' })
          }
        }
      })
    },
    goBack() {
      this.$router.push('/customer/dashboard')
    }
  }
}
</script>

<style scoped>
.points-mall {
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

.points-info {
  padding: 20px;
}

.points-card {
  background-color: #fff;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.points-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  padding-bottom: 15px;
  border-bottom: 1px solid #eee;
}

.points-header h2 {
  font-size: 16px;
  color: #333;
  margin: 0;
}

.points-balance {
  font-size: 24px;
  font-weight: bold;
  color: #ff6b81;
}

.points-rules {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.rule-item {
  display: flex;
  align-items: center;
}

.rule-icon {
  font-size: 16px;
  margin-right: 10px;
}

.rule-text {
  font-size: 14px;
  color: #666;
}

.section-title {
  font-size: 16px;
  color: #333;
  margin: 20px 0 15px 20px;
}

.history-list {
  padding: 0 20px;
}

.history-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background-color: #fff;
  border-radius: 8px;
  padding: 15px;
  margin-bottom: 10px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.history-info {
  flex: 1;
}

.history-title {
  font-size: 14px;
  color: #333;
  margin: 0 0 5px 0;
}

.history-date {
  font-size: 12px;
  color: #999;
  margin: 0;
}

.history-points {
  font-size: 16px;
  font-weight: bold;
}

.points-income {
  color: #4CAF50;
}

.points-expense {
  color: #F44336;
}

.exchange-list {
  padding: 0 20px 20px;
}

.exchange-item {
  display: flex;
  background-color: #fff;
  border-radius: 8px;
  padding: 15px;
  margin-bottom: 15px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  cursor: pointer;
  transition: transform 0.2s;
}

.exchange-item:hover {
  transform: translateY(-2px);
}

.item-image {
  width: 80px;
  height: 80px;
  margin-right: 15px;
  flex-shrink: 0;
}

.item-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 8px;
}

.item-info {
  flex: 1;
}

.item-name {
  font-size: 16px;
  color: #333;
  margin: 0 0 5px 0;
}

.item-description {
  font-size: 14px;
  color: #666;
  margin: 0 0 10px 0;
}

.item-points {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.points-required {
  font-size: 14px;
  color: #ff6b81;
  font-weight: bold;
}

.exchange-btn {
  padding: 6px 12px;
  background-color: #ff6b81;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 12px;
  cursor: pointer;
}

.exchange-btn:disabled {
  background-color: #ccc;
  cursor: not-allowed;
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
