<template>
  <div class="service-records">
    <header class="header">
      <h1>服务记录</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="toolbar">
      <div class="filter-group">
        <input type="date" v-model="startDate" @change="handleFilter">
        <span>至</span>
        <input type="date" v-model="endDate" @change="handleFilter">
      </div>
    </div>

    <div class="records-container">
      <div v-for="record in filteredRecords" :key="record.id" class="record-item">
        <div class="record-header">
          <h3>{{ record.service ? record.service.name : '' }}</h3>
          <span class="record-date">{{ formatDate(record.serviceDate) }}</span>
        </div>
        <div class="record-info">
          <div class="info-row">
            <span class="label">顾客：</span>
            <span class="value">{{ record.customer && record.customer.user ? record.customer.user.name : '' }}</span>
          </div>
          <div class="info-row">
            <span class="label">美容师：</span>
            <span class="value">{{ record.employee && record.employee.user ? record.employee.user.name : '' }}</span>
          </div>
          <div class="info-row">
            <span class="label">订单号：</span>
            <span class="value">#{{ record.order ? record.order.id : '' }}</span>
          </div>
          <div class="info-row">
            <span class="label">金额：</span>
            <span class="value amount">¥{{ record.amount }}</span>
          </div>
        </div>
        <div class="record-notes" v-if="record.notes">
          <span class="label">备注：</span>
          <span class="value">{{ record.notes }}</span>
        </div>
      </div>
      <div v-if="filteredRecords.length === 0" class="empty">
        <div class="empty-icon">📋</div>
        <p>暂无服务记录</p>
      </div>
    </div>
  </div>
</template>

<script>
import { orderAPI } from '../../../api/index'

export default {
  name: 'ServiceRecords',
  data() {
    return {
      records: [],
      startDate: this.getDefaultStartDate(),
      endDate: this.getDefaultEndDate(),
      loading: false
    }
  },
  computed: {
    filteredRecords() {
      if (!this.startDate && !this.endDate) {
        return this.records
      }
      return this.records.filter(record => {
        if (!record.serviceDate) return false
        const recordDate = new Date(record.serviceDate)
        if (this.startDate) {
          const start = new Date(this.startDate)
          start.setHours(0, 0, 0, 0)
          if (recordDate < start) return false
        }
        if (this.endDate) {
          const end = new Date(this.endDate)
          end.setHours(23, 59, 59, 999)
          if (recordDate > end) return false
        }
        return true
      })
    }
  },
  mounted() {
    this.loadRecords()
  },
  methods: {
    async loadRecords() {
      this.loading = true
      try {
        const response = await orderAPI.getAll()
        if (Array.isArray(response)) {
          this.records = response
        }
      } catch (error) {
        console.error('加载服务记录失败:', error)
      } finally {
        this.loading = false
      }
    },
    formatDate(date) {
      if (!date) return ''
      const d = new Date(date)
      return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')} ${String(d.getHours()).padStart(2, '0')}:${String(d.getMinutes()).padStart(2, '0')}`
    },
    getDefaultStartDate() {
      const now = new Date()
      return `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-01`
    },
    getDefaultEndDate() {
      const now = new Date()
      return `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`
    },
    handleFilter() {
      // 筛选由computed属性处理
    },
    goBack() {
      this.$router.push('/admin/dashboard')
    }
  }
}
</script>

<style scoped>
.service-records {
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

.toolbar {
  display: flex;
  align-items: center;
  padding: 15px 20px;
  background-color: #fff;
  margin-bottom: 10px;
}

.filter-group {
  display: flex;
  align-items: center;
  gap: 10px;
}

.filter-group input {
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.filter-group span {
  color: #666;
}

.records-container {
  padding: 20px;
}

.record-item {
  background-color: #fff;
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 15px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.record-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
  padding-bottom: 15px;
  border-bottom: 1px solid #eee;
}

.record-header h3 {
  font-size: 16px;
  color: #333;
  margin: 0;
}

.record-date {
  font-size: 12px;
  color: #999;
}

.record-info {
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

.record-notes {
  padding-top: 10px;
  border-top: 1px solid #eee;
}

.record-notes .label {
  font-size: 14px;
  color: #666;
}

.record-notes .value {
  font-size: 14px;
  color: #333;
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