<template>
  <div class="coupon-list">
    <header class="header">
      <h1>卡券管理</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="toolbar">
      <div class="filter-group">
        <select v-model="filterStatus" @change="handleFilter">
          <option value="">全部状态</option>
          <option value="未使用">未使用</option>
          <option value="已使用">已使用</option>
          <option value="已过期">已过期</option>
        </select>
      </div>
      <button class="add-btn" @click="goToAdd">发放卡券</button>
    </div>

    <div class="coupon-container">
      <div v-for="coupon in filteredCoupons" :key="coupon.id" class="coupon-item">
        <div class="coupon-header">
          <h3>{{ coupon.name }}</h3>
          <span :class="['status-badge', getStatusClass(coupon.status)]">
            {{ coupon.status }}
          </span>
        </div>
        <div class="coupon-info">
          <div class="info-row">
            <span class="label">券号：</span>
            <span class="value">{{ coupon.couponNumber }}</span>
          </div>
          <div class="info-row">
            <span class="label">类型：</span>
            <span class="value">{{ coupon.type }}</span>
          </div>
          <div class="info-row" v-if="coupon.discountAmount">
            <span class="label">优惠金额：</span>
            <span class="value amount">¥{{ coupon.discountAmount }}</span>
          </div>
          <div class="info-row" v-if="coupon.discountRate">
            <span class="label">折扣率：</span>
            <span class="value">{{ (coupon.discountRate * 10).toFixed(1) }}折</span>
          </div>
          <div class="info-row" v-if="coupon.minAmount">
            <span class="label">满减条件：</span>
            <span class="value">满¥{{ coupon.minAmount }}</span>
          </div>
          <div class="info-row">
            <span class="label">有效期：</span>
            <span class="value">{{ formatDate(coupon.expiryDate) }}</span>
          </div>
        </div>
      </div>
      <div v-if="filteredCoupons.length === 0" class="empty">
        <div class="empty-icon">🎫</div>
        <p>暂无卡券</p>
      </div>
    </div>
  </div>
</template>

<script>
import { couponAPI } from '../../../api/index'

export default {
  name: 'CouponList',
  data() {
    return {
      coupons: [],
      filterStatus: '',
      loading: false
    }
  },
  computed: {
    filteredCoupons() {
      if (!this.filterStatus) {
        return this.coupons
      }
      return this.coupons.filter(coupon => coupon.status === this.filterStatus)
    }
  },
  mounted() {
    this.loadCoupons()
  },
  methods: {
    async loadCoupons() {
      this.loading = true
      try {
        const response = await couponAPI.getAll()
        if (Array.isArray(response)) {
          this.coupons = response
        }
      } catch (error) {
        console.error('加载卡券列表失败:', error)
      } finally {
        this.loading = false
      }
    },
    formatDate(date) {
      if (!date) return ''
      const d = new Date(date)
      return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
    },
    getStatusClass(status) {
      switch (status) {
        case '未使用': return 'status-unused'
        case '已使用': return 'status-used'
        case '已过期': return 'status-expired'
        default: return ''
      }
    },
    handleFilter() {
      // 筛选由computed属性处理
    },
    goBack() {
      this.$router.push('/admin/dashboard')
    },
    goToAdd() {
      this.$router.push('/admin/coupon/add')
    }
  }
}
</script>

<style scoped>
.coupon-list {
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

.back-btn,
.add-btn {
  padding: 8px 16px;
  background-color: #ff6b81;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px 20px;
  background-color: #fff;
  margin-bottom: 10px;
}

.filter-group select {
  padding: 8px 16px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.coupon-container {
  padding: 20px;
}

.coupon-item {
  background-color: #fff;
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 15px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.coupon-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
  padding-bottom: 15px;
  border-bottom: 1px solid #eee;
}

.coupon-header h3 {
  font-size: 16px;
  color: #333;
  margin: 0;
}

.status-badge {
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
}

.status-unused {
  background-color: #E3F2FD;
  color: #1976D2;
}

.status-used {
  background-color: #E8F5E9;
  color: #4CAF50;
}

.status-expired {
  background-color: #FFEBEE;
  color: #F44336;
}

.coupon-info {
  margin-bottom: 10px;
}

.info-row {
  display: flex;
  justify-content: space-between;
  margin-bottom: 8px;
}

.info-row .label {
  font-size: 14px;
  color: #666;
}

.info-row .value {
  font-size: 14px;
  color: #333;
}

.info-row .value.amount {
  font-weight: bold;
  color: #ff6b81;
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