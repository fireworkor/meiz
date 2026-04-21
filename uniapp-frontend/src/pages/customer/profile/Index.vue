<template>
  <div class="profile">
    <header class="header">
      <h1>个人资料</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="profile-card">
      <div class="avatar-section">
        <div class="avatar">
          <img :src="userInfo.avatar || 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=user%20avatar%20portrait&image_size=square'" alt="头像" />
        </div>
        <div class="user-info">
          <h2>{{ userInfo.name }}</h2>
          <p class="phone">{{ userInfo.phone }}</p>
          <div class="member-badge" v-if="userInfo.membershipLevel">
            {{ userInfo.membershipLevel }}会员
          </div>
        </div>
      </div>

      <div class="stats-section">
        <div class="stat-item">
          <div class="stat-value">{{ userInfo.points }}</div>
          <div class="stat-label">积分</div>
        </div>
        <div class="stat-item">
          <div class="stat-value">{{ userInfo.balance }}</div>
          <div class="stat-label">余额</div>
        </div>
        <div class="stat-item">
          <div class="stat-value">{{ userInfo.coupons }}</div>
          <div class="stat-label">优惠券</div>
        </div>
      </div>
    </div>

    <div class="info-section">
      <h2 class="section-title">基本信息</h2>
      <div class="info-list">
        <div class="info-item">
          <span class="info-label">姓名</span>
          <span class="info-value">{{ userInfo.name }}</span>
          <span class="info-action" @click="editInfo('name')">编辑</span>
        </div>
        <div class="info-item">
          <span class="info-label">性别</span>
          <span class="info-value">{{ userInfo.gender || '未设置' }}</span>
          <span class="info-action" @click="editInfo('gender')">编辑</span>
        </div>
        <div class="info-item">
          <span class="info-label">生日</span>
          <span class="info-value">{{ userInfo.birthday || '未设置' }}</span>
          <span class="info-action" @click="editInfo('birthday')">编辑</span>
        </div>
        <div class="info-item">
          <span class="info-label">联系电话</span>
          <span class="info-value">{{ userInfo.phone }}</span>
          <span class="info-action" @click="editInfo('phone')">编辑</span>
        </div>
        <div class="info-item">
          <span class="info-label">邮箱</span>
          <span class="info-value">{{ userInfo.email || '未设置' }}</span>
          <span class="info-action" @click="editInfo('email')">编辑</span>
        </div>
        <div class="info-item">
          <span class="info-label">地址</span>
          <span class="info-value">{{ userInfo.address || '未设置' }}</span>
          <span class="info-action" @click="editInfo('address')">编辑</span>
        </div>
      </div>
    </div>

    <div class="action-section">
      <button class="action-btn" @click="changePassword">修改密码</button>
      <button class="action-btn" @click="bindWechat">绑定微信</button>
      <button class="action-btn danger" @click="deleteAccount">注销账号</button>
    </div>
  </div>
</template>

<script>
export default {
  name: 'CustomerProfile',
  data() {
    return {
      userInfo: {
        name: '张女士',
        phone: '138****1234',
        avatar: '',
        membershipLevel: '黄金',
        points: 1280,
        balance: 880,
        coupons: 3,
        gender: '女',
        birthday: '1990-01-01',
        email: 'zhang@example.com',
        address: '北京市朝阳区'
      }
    }
  },
  methods: {
    editInfo(field) {
      uni.showToast({ title: `编辑${this.getFieldName(field)}`, icon: 'none' })
    },
    getFieldName(field) {
      const names = {
        name: '姓名',
        gender: '性别',
        birthday: '生日',
        phone: '联系电话',
        email: '邮箱',
        address: '地址'
      }
      return names[field] || field
    },
    changePassword() {
      uni.showToast({ title: '修改密码功能开发中', icon: 'none' })
    },
    bindWechat() {
      uni.showToast({ title: '绑定微信功能开发中', icon: 'none' })
    },
    deleteAccount() {
      uni.showModal({
        title: '确认注销',
        content: '注销账号后，您的所有数据将被删除，此操作不可恢复',
        success: (res) => {
          if (res.confirm) {
            uni.showToast({ title: '账号注销功能开发中', icon: 'none' })
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
.profile {
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

.profile-card {
  background-color: #fff;
  margin: 20px;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.avatar-section {
  display: flex;
  align-items: center;
  margin-bottom: 20px;
}

.avatar {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  overflow: hidden;
  margin-right: 20px;
  border: 2px solid #ff6b81;
}

.avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.user-info h2 {
  font-size: 18px;
  color: #333;
  margin: 0 0 5px 0;
}

.phone {
  font-size: 14px;
  color: #666;
  margin: 0 0 10px 0;
}

.member-badge {
  display: inline-block;
  padding: 4px 12px;
  background-color: #ff6b81;
  color: #fff;
  border-radius: 12px;
  font-size: 12px;
}

.stats-section {
  display: flex;
  justify-content: space-around;
  padding-top: 20px;
  border-top: 1px solid #eee;
}

.stat-item {
  text-align: center;
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

.info-section {
  background-color: #fff;
  margin: 20px;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.section-title {
  font-size: 16px;
  color: #333;
  margin-bottom: 15px;
  padding-bottom: 10px;
  border-bottom: 1px solid #eee;
}

.info-list {
  space-y: 15px;
}

.info-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px 0;
  border-bottom: 1px solid #f0f0f0;
}

.info-item:last-child {
  border-bottom: none;
}

.info-label {
  font-size: 14px;
  color: #666;
}

.info-value {
  font-size: 14px;
  color: #333;
  flex: 1;
  text-align: right;
  margin-right: 10px;
}

.info-action {
  font-size: 14px;
  color: #ff6b81;
  cursor: pointer;
}

.action-section {
  padding: 0 20px 20px;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.action-btn {
  padding: 15px;
  border: 1px solid #ddd;
  border-radius: 8px;
  background-color: #fff;
  font-size: 14px;
  color: #333;
  cursor: pointer;
  transition: all 0.2s;
}

.action-btn:hover {
  border-color: #ff6b81;
  color: #ff6b81;
}

.action-btn.danger {
  border-color: #F44336;
  color: #F44336;
}

.action-btn.danger:hover {
  background-color: #F44336;
  color: #fff;
}
</style>
