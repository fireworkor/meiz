<template>
  <div class="promoter">
    <header class="header">
      <h1>推广员功能</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="promoter-info">
      <div class="promoter-card">
        <div class="promoter-header">
          <h2>我的推广码</h2>
          <div class="promoter-code">{{ promoterCode }}</div>
        </div>
        <div class="qrcode-section">
          <div class="qrcode">
            <img src="https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=QR%20code%20for%20promotion&image_size=square" alt="推广二维码" />
          </div>
          <div class="qrcode-tips">
            <p>扫描二维码，成为我的下线</p>
            <button class="share-btn" @click="shareQRCode">分享二维码</button>
          </div>
        </div>
      </div>
    </div>

    <div class="commission-section">
      <h2 class="section-title">推广收益</h2>
      <div class="commission-stats">
        <div class="stat-item">
          <div class="stat-value">{{ totalCommission }}</div>
          <div class="stat-label">累计收益</div>
        </div>
        <div class="stat-item">
          <div class="stat-value">{{ todayCommission }}</div>
          <div class="stat-label">今日收益</div>
        </div>
        <div class="stat-item">
          <div class="stat-value">{{ teamCount }}</div>
          <div class="stat-label">团队人数</div>
        </div>
        <div class="stat-item">
          <div class="stat-value">{{ todayNew }}</div>
          <div class="stat-label">今日新增</div>
        </div>
      </div>
    </div>

    <div class="commission-history">
      <h2 class="section-title">收益明细</h2>
      <div class="history-list">
        <div v-for="item in commissionHistory" :key="item.id" class="history-item">
          <div class="history-info">
            <h3 class="history-title">{{ item.title }}</h3>
            <p class="history-date">{{ item.date }}</p>
          </div>
          <div class="history-amount">+¥{{ item.amount }}</div>
        </div>
        <div v-if="commissionHistory.length === 0" class="empty">
          <div class="empty-icon">💰</div>
          <p>暂无收益记录</p>
        </div>
      </div>
    </div>

    <div class="team-section">
      <h2 class="section-title">我的团队</h2>
      <div class="team-list">
        <div v-for="member in teamMembers" :key="member.id" class="team-item">
          <div class="member-info">
            <h3 class="member-name">{{ member.name }}</h3>
            <p class="member-joined">{{ member.joinedDate }}</p>
          </div>
          <div class="member-level" :class="`level-${member.level}`">
            {{ member.level }}级
          </div>
        </div>
        <div v-if="teamMembers.length === 0" class="empty">
          <div class="empty-icon">👥</div>
          <p>暂无团队成员</p>
        </div>
      </div>
    </div>

    <div class="rules-section">
      <h2 class="section-title">推广规则</h2>
      <div class="rules-content">
        <div class="rule-item">
          <span class="rule-number">1</span>
          <div class="rule-text">
            <h3>直接推广</h3>
            <p>推荐新用户注册，可获得该用户消费金额的5%作为佣金</p>
          </div>
        </div>
        <div class="rule-item">
          <span class="rule-number">2</span>
          <div class="rule-text">
            <h3>间接推广</h3>
            <p>推荐的用户再推荐新用户，可获得新用户消费金额的2%作为佣金</p>
          </div>
        </div>
        <div class="rule-item">
          <span class="rule-number">3</span>
          <div class="rule-text">
            <h3>团队奖励</h3>
            <p>团队人数达到10人，可获得团队总消费金额的1%作为额外奖励</p>
          </div>
        </div>
        <div class="rule-item">
          <span class="rule-number">4</span>
          <div class="rule-text">
            <h3>提现规则</h3>
            <p>佣金满100元可提现，提现到微信钱包</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'CustomerPromoter',
  data() {
    return {
      promoterCode: 'BD888888',
      totalCommission: '2,888.00',
      todayCommission: '128.00',
      teamCount: 25,
      todayNew: 3,
      commissionHistory: [
        {
          id: 1,
          title: '直接推广 - 张女士消费',
          amount: 58.50,
          date: '2024-04-22 14:30'
        },
        {
          id: 2,
          title: '间接推广 - 李女士消费',
          amount: 12.80,
          date: '2024-04-22 10:20'
        },
        {
          id: 3,
          title: '团队奖励',
          amount: 100.00,
          date: '2024-04-21 23:59'
        },
        {
          id: 4,
          title: '直接推广 - 王女士消费',
          amount: 35.60,
          date: '2024-04-21 16:45'
        }
      ],
      teamMembers: [
        {
          id: 1,
          name: '张女士',
          joinedDate: '2024-04-20',
          level: 1
        },
        {
          id: 2,
          name: '李女士',
          joinedDate: '2024-04-18',
          level: 2
        },
        {
          id: 3,
          name: '王女士',
          joinedDate: '2024-04-15',
          level: 1
        },
        {
          id: 4,
          name: '陈女士',
          joinedDate: '2024-04-10',
          level: 2
        }
      ]
    }
  },
  methods: {
    shareQRCode() {
      uni.showToast({ title: '二维码已分享到剪贴板', icon: 'success' })
    },
    goBack() {
      this.$router.push('/customer/dashboard')
    }
  }
}
</script>

<style scoped>
.promoter {
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

.promoter-info {
  padding: 20px;
}

.promoter-card {
  background-color: #fff;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.promoter-header {
  text-align: center;
  margin-bottom: 20px;
  padding-bottom: 15px;
  border-bottom: 1px solid #eee;
}

.promoter-header h2 {
  font-size: 16px;
  color: #333;
  margin: 0 0 10px 0;
}

.promoter-code {
  font-size: 24px;
  font-weight: bold;
  color: #ff6b81;
  letter-spacing: 2px;
}

.qrcode-section {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.qrcode {
  margin-bottom: 20px;
}

.qrcode img {
  width: 150px;
  height: 150px;
  border: 2px solid #f0f0f0;
  border-radius: 8px;
}

.qrcode-tips {
  text-align: center;
}

.qrcode-tips p {
  font-size: 14px;
  color: #666;
  margin: 0 0 10px 0;
}

.share-btn {
  padding: 10px 20px;
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

.commission-stats {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 15px;
  padding: 0 20px;
  margin-bottom: 20px;
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

.history-list,
.team-list {
  padding: 0 20px;
}

.history-item,
.team-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background-color: #fff;
  border-radius: 8px;
  padding: 15px;
  margin-bottom: 10px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.history-info,
.member-info {
  flex: 1;
}

.history-title,
.member-name {
  font-size: 14px;
  color: #333;
  margin: 0 0 5px 0;
}

.history-date,
.member-joined {
  font-size: 12px;
  color: #999;
  margin: 0;
}

.history-amount {
  font-size: 16px;
  font-weight: bold;
  color: #4CAF50;
}

.member-level {
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: bold;
}

.level-1 {
  background-color: #E3F2FD;
  color: #1976D2;
}

.level-2 {
  background-color: #E8F5E9;
  color: #4CAF50;
}

.rules-section {
  padding: 0 20px 20px;
}

.rules-content {
  background-color: #fff;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.rule-item {
  display: flex;
  margin-bottom: 20px;
  padding-bottom: 20px;
  border-bottom: 1px solid #f0f0f0;
}

.rule-item:last-child {
  margin-bottom: 0;
  padding-bottom: 0;
  border-bottom: none;
}

.rule-number {
  width: 30px;
  height: 30px;
  background-color: #ff6b81;
  color: #fff;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
  margin-right: 15px;
  flex-shrink: 0;
}

.rule-text h3 {
  font-size: 14px;
  color: #333;
  margin: 0 0 5px 0;
}

.rule-text p {
  font-size: 14px;
  color: #666;
  margin: 0;
  line-height: 1.4;
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
