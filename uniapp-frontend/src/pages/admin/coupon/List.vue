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
          <option value="unused">未使用</option>
          <option value="used">已使用</option>
          <option value="expired">已过期</option>
        </select>
      </div>
      <button class="add-btn" @click="goToAdd">发放卡券</button>
    </div>

    <div class="summary-cards">
      <div class="summary-card">
        <div class="summary-value">{{ totalCount }}</div>
        <div class="summary-label">总卡券</div>
      </div>
      <div class="summary-card">
        <div class="summary-value">{{ unusedCount }}</div>
        <div class="summary-label">未使用</div>
      </div>
      <div class="summary-card">
        <div class="summary-value">{{ usedCount }}</div>
        <div class="summary-label">已使用</div>
      </div>
      <div class="summary-card">
        <div class="summary-value">{{ expiredCount }}</div>
        <div class="summary-label">已过期</div>
      </div>
    </div>

    <div class="coupon-container">
      <div v-for="coupon in filteredCoupons" :key="coupon.id" class="coupon-item">
        <div class="coupon-header">
          <h3>{{ coupon.name }}</h3>
          <span :class="['status-badge', getStatusClass(coupon.status)]">
            {{ getStatusName(coupon.status) }}
          </span>
        </div>
        <div class="coupon-info">
          <div class="info-row">
            <span class="label">券号：</span>
            <span class="value">{{ coupon.couponNumber }}</span>
          </div>
          <div class="info-row">
            <span class="label">类型：</span>
            <span class="value">{{ getTypeName(coupon.type) }}</span>
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
        <div class="coupon-actions">
          <button v-if="coupon.status === 'unused'" class="use-btn" @click="handleUse(coupon)">核销</button>
          <button class="delete-btn" @click="handleDelete(coupon)">删除</button>
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
      let result = [...this.coupons]
      if (this.filterStatus) {
        result = result.filter(coupon => coupon.status === this.filterStatus)
      }
      return result.map(coupon => ({
        ...coupon,
        status: this.getComputedStatus(coupon)
      }))
    },
    totalCount() {
      return this.coupons.length
    },
    unusedCount() {
      return this.coupons.filter(c => this.getComputedStatus(c) === 'unused').length
    },
    usedCount() {
      return this.coupons.filter(c => this.getComputedStatus(c) === 'used').length
    },
    expiredCount() {
      return this.coupons.filter(c => this.getComputedStatus(c) === 'expired').length
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
    getComputedStatus(coupon) {
      if (coupon.status === 'used') return 'used'
      if (coupon.expiryDate) {
        const now = new Date()
        const expiryDate = new Date(coupon.expiryDate)
        if (now > expiryDate) return 'expired'
      }
      return coupon.status || 'unused'
    },
    formatDate(date) {
      if (!date) return ''
      const d = new Date(date)
      return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
    },
    getStatusName(status) {
      const names = {
        unused: '未使用',
        used: '已使用',
        expired: '已过期'
      }
      return names[status] || status
    },
    getTypeName(type) {
      const names = {
        DISCOUNT: '折扣券',
        CASH: '满减券',
        GIFT: '礼品券'
      }
      return names[type] || type
    },
    getStatusClass(status) {
      switch (status) {
        case 'unused': return 'status-unused'
        case 'used': return 'status-used'
        case 'expired': return 'status-expired'
        default: return ''
      }
    },
    handleFilter() {
    },
    async handleUse(coupon) {
      if (typeof uni !== 'undefined') {
        uni.showModal({
          title: '确认核销',
          content: `确定要核销卡券"${coupon.name}"吗？`,
          success: async (res) => {
            if (res.confirm) {
              try {
                await couponAPI.use(coupon.id)
                uni.showToast({ title: '核销成功', icon: 'success' })
                this.loadCoupons()
              } catch (error) {
                console.error('核销失败:', error)
                uni.showToast({ title: '核销失败', icon: 'none' })
              }
            }
          }
        })
      } else {
        if (confirm(`确定要核销卡券"${coupon.name}"吗？`)) {
          try {
            await couponAPI.use(coupon.id)
            alert('核销成功')
            this.loadCoupons()
          } catch (error) {
            console.error('核销失败:', error)
            alert('核销失败')
          }
        }
      }
    },
    async handleDelete(coupon) {
      if (typeof uni !== 'undefined') {
        uni.showModal({
          title: '确认删除',
          content: `确定要删除卡券"${coupon.name}"吗？`,
          success: async (res) => {
            if (res.confirm) {
              try {
                await couponAPI.delete(coupon.id)
                uni.showToast({ title: '删除成功', icon: 'success' })
                this.loadCoupons()
              } catch (error) {
                console.error('删除失败:', error)
                uni.showToast({ title: '删除失败', icon: 'none' })
              }
            }
          }
        })
      } else {
        if (confirm(`确定要删除卡券"${coupon.name}"吗？`)) {
          try {
            await couponAPI.delete(coupon.id)
            alert('删除成功')
            this.loadCoupons()
          } catch (error) {
            console.error('删除失败:', error)
            alert('删除失败')
          }
        }
      }
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

.summary-cards {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 15px;
  padding: 0 10px;
  margin-bottom: 20px;
}

.summary-card {
  background-color: #fff;
  border-radius: 8px;
  padding: 20px;
  text-align: center;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.summary-value {
  font-size: 28px;
  font-weight: bold;
  color: #ff6b81;
  margin-bottom: 10px;
}

.summary-label {
  font-size: 14px;
  color: #666;
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

.coupon-actions {
  display: flex;
  gap: 10px;
  margin-top: 15px;
  padding-top: 15px;
  border-top: 1px solid #eee;
}

.use-btn,
.delete-btn {
  flex: 1;
  padding: 10px;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.use-btn {
  background-color: #4CAF50;
  color: #fff;
}

.delete-btn {
  background-color: #F44336;
  color: #fff;
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