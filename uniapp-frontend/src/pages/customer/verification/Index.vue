<template>
  <div class="customer-verification">
    <header class="header">
      <h1>我的核销码</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="tabs">
      <div class="tab" :class="{ active: activeTab === 'unused' }" @click="activeTab = 'unused'">
        未使用 ({{ unusedCount }})
      </div>
      <div class="tab" :class="{ active: activeTab === 'used' }" @click="activeTab = 'used'">
        已使用 ({{ usedCount }})
      </div>
      <div class="tab" :class="{ active: activeTab === 'all' }" @click="activeTab = 'all'">
        全部 ({{ totalCount }})
      </div>
    </div>

    <div class="summary-bar">
      <div class="summary-item">
        <span class="label">可用积分:</span>
        <span class="value">{{ availablePoints }}</span>
      </div>
      <div class="summary-item">
        <span class="label">可用优惠券:</span>
        <span class="value">{{ unusedCount }}</span>
      </div>
    </div>

    <div class="verification-list">
      <div class="verification-card" v-for="item in filteredList" :key="item.id">
        <div class="card-header">
          <span class="card-type" :class="item.type">{{ getTypeName(item.type) }}</span>
          <span class="card-status" :class="item.status">{{ getStatusName(item.status) }}</span>
        </div>
        <div class="card-body">
          <h3 class="item-name">{{ item.itemName }}</h3>
          <p class="item-value" v-if="item.type === 'points'">
            <span class="value-icon">🎁</span>
            <span class="value-amount">{{ item.points }} 积分</span>
          </p>
          <p class="item-value" v-else>
            <span class="value-icon">¥</span>
            <span class="value-amount">{{ formatAmount(item.amount) }}</span>
          </p>
          <div class="verification-code">
            <span class="code-label">核销码：</span>
            <span class="code-value">{{ item.verificationCode }}</span>
            <button class="copy-btn" @click="copyCode(item.verificationCode)">复制</button>
          </div>
        </div>
        <div class="card-footer">
          <span class="create-time">创建时间：{{ formatDate(item.createdAt) }}</span>
          <span class="used-time" v-if="item.usedAt">使用时间：{{ formatDate(item.usedAt) }}</span>
        </div>
      </div>

      <div class="empty-list" v-if="filteredList.length === 0">
        <div class="empty-icon">📋</div>
        <p>暂无核销码</p>
      </div>
    </div>

    <div class="scan-section">
      <h3>扫描核销</h3>
      <div class="scan-input">
        <input type="text" v-model="scanCode" placeholder="请输入核销码" />
        <button class="scan-btn" @click="handleScan">扫码使用</button>
      </div>
    </div>
  </div>
</template>

<script>
import { verificationAPI } from '@/api/index'

export default {
  name: 'CustomerVerification',
  data() {
    return {
      activeTab: 'unused',
      scanCode: '',
      verificationList: [
        {
          id: 1,
          verificationCode: 'VS8A3B2C1D',
          type: 'coupon',
          itemName: '满100减20优惠券',
          points: 0,
          amount: 20,
          status: 'unused',
          createdAt: '2024-04-20 10:00:00',
          usedAt: null,
          usedBy: null
        },
        {
          id: 2,
          verificationCode: 'VS9B4C5D6E',
          type: 'points',
          itemName: '积分兑换面膜',
          points: 500,
          amount: 0,
          status: 'used',
          createdAt: '2024-04-15 14:30:00',
          usedAt: '2024-04-18 16:20:00',
          usedBy: '张美容师'
        },
        {
          id: 3,
          verificationCode: 'VS1C2D3E4F',
          type: 'product',
          itemName: '精华液1瓶',
          points: 0,
          amount: 298,
          status: 'unused',
          createdAt: '2024-04-22 09:00:00',
          usedAt: null,
          usedBy: null
        },
        {
          id: 4,
          verificationCode: 'VS5G6H7I8J',
          type: 'coupon',
          itemName: '新用户专享8折券',
          points: 0,
          amount: 0,
          status: 'cancelled',
          createdAt: '2024-04-10 11:00:00',
          usedAt: null,
          usedBy: null
        }
      ]
    }
  },
  computed: {
    filteredList() {
      if (this.activeTab === 'all') {
        return this.verificationList
      }
      return this.verificationList.filter(item => item.status === this.activeTab)
    },
    totalCount() {
      return this.verificationList.length
    },
    unusedCount() {
      return this.verificationList.filter(v => v.status === 'unused').length
    },
    usedCount() {
      return this.verificationList.filter(v => v.status === 'used').length
    },
    availablePoints() {
      const unusedPoints = this.verificationList
        .filter(v => v.type === 'points' && v.status === 'unused')
        .reduce((sum, v) => sum + (v.points || 0), 0)
      return unusedPoints + 500
    }
  },
  methods: {
    getTypeName(type) {
      const names = {
        coupon: '优惠券',
        points: '积分兑换',
        product: '商品'
      }
      return names[type] || type
    },
    getStatusName(status) {
      const names = {
        unused: '未使用',
        used: '已使用',
        cancelled: '已取消'
      }
      return names[status] || status
    },
    formatAmount(amount) {
      if (!amount || amount === 0) return '0.00'
      return parseFloat(amount).toFixed(2)
    },
    formatDate(dateStr) {
      if (!dateStr) return '-'
      const date = new Date(dateStr)
      return date.toLocaleDateString() + ' ' + date.toLocaleTimeString()
    },
    copyCode(code) {
      uni.setClipboardData({
        data: code,
        success: () => {
          uni.showToast({ title: '已复制到剪贴板', icon: 'success' })
        }
      })
    },
    handleScan() {
      if (!this.scanCode) {
        uni.showToast({ title: '请输入核销码', icon: 'none' })
        return
      }

      const item = this.verificationList.find(v => v.verificationCode === this.scanCode)
      if (item) {
        if (item.status === 'unused') {
          uni.showToast({ title: '该核销码可在门店使用', icon: 'success' })
        } else if (item.status === 'used') {
          uni.showToast({ title: '该核销码已使用', icon: 'none' })
        } else {
          uni.showToast({ title: '该核销码已取消', icon: 'none' })
        }
      } else {
        uni.showToast({ title: '未找到该核销码', icon: 'none' })
      }
    },
    goBack() {
      this.$router.push('/customer/dashboard')
    }
  }
}
</script>

<style scoped>
.customer-verification {
  min-height: 100vh;
  background-color: #f5f5f5;
  padding-bottom: 20px;
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

.tabs {
  display: flex;
  background-color: #fff;
  margin-bottom: 10px;
}

.tab {
  flex: 1;
  padding: 15px 10px;
  font-size: 14px;
  color: #666;
  text-align: center;
  cursor: pointer;
  border-bottom: 2px solid transparent;
}

.tab.active {
  color: #ff6b81;
  border-bottom-color: #ff6b81;
  font-weight: bold;
}

.verification-list {
  padding: 15px;
}

.verification-card {
  background-color: #fff;
  border-radius: 8px;
  padding: 15px;
  margin-bottom: 15px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}

.card-type {
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: bold;
}

.card-type.coupon {
  background-color: #E3F2FD;
  color: #1976D2;
}

.card-type.points {
  background-color: #FFF3E0;
  color: #FF9800;
}

.card-type.product {
  background-color: #E8F5E9;
  color: #4CAF50;
}

.card-status {
  font-size: 12px;
  font-weight: bold;
}

.card-status.unused {
  color: #FF9800;
}

.card-status.used {
  color: #4CAF50;
}

.card-status.cancelled {
  color: #999;
}

.card-body {
  padding-bottom: 12px;
  border-bottom: 1px solid #f0f0f0;
}

.item-name {
  font-size: 16px;
  color: #333;
  margin: 0 0 10px 0;
  font-weight: bold;
}

.item-value {
  margin: 0 0 10px 0;
  display: flex;
  align-items: center;
}

.value-icon {
  font-size: 20px;
  margin-right: 8px;
}

.value-amount {
  font-size: 20px;
  color: #ff6b81;
  font-weight: bold;
}

.verification-code {
  display: flex;
  align-items: center;
  background-color: #f5f5f5;
  padding: 8px 12px;
  border-radius: 4px;
}

.code-label {
  font-size: 12px;
  color: #666;
  margin-right: 8px;
}

.code-value {
  flex: 1;
  font-size: 14px;
  font-weight: bold;
  color: #333;
  font-family: monospace;
}

.copy-btn {
  padding: 4px 8px;
  background-color: #2196F3;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 12px;
  cursor: pointer;
}

.card-footer {
  display: flex;
  justify-content: space-between;
  padding-top: 12px;
  font-size: 12px;
  color: #999;
}

.empty-list {
  text-align: center;
  padding: 60px 20px;
  background-color: #fff;
  border-radius: 8px;
}

.empty-icon {
  font-size: 48px;
  margin-bottom: 20px;
}

.empty-list p {
  font-size: 14px;
  color: #666;
  margin: 0;
}

.scan-section {
  margin: 0 15px;
  background-color: #fff;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.scan-section h3 {
  font-size: 16px;
  color: #333;
  margin: 0 0 15px 0;
}

.scan-input {
  display: flex;
  gap: 10px;
}

.scan-input input {
  flex: 1;
  padding: 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.scan-btn {
  padding: 12px 20px;
  background-color: #ff6b81;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.summary-bar {
  display: flex;
  justify-content: space-around;
  padding: 15px;
  background-color: #fff;
  margin: 10px 15px;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.summary-item {
  text-align: center;
}

.summary-item .label {
  display: block;
  font-size: 12px;
  color: #999;
  margin-bottom: 5px;
}

.summary-item .value {
  font-size: 18px;
  color: #ff6b81;
  font-weight: bold;
}
</style>
