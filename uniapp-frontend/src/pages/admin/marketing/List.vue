<template>
  <div class="marketing-list">
    <header class="header">
      <h1>营销活动</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="toolbar">
      <div class="filter-group">
        <select v-model="filterStatus" @change="handleFilter">
          <option value="">全部状态</option>
          <option value="进行中">进行中</option>
          <option value="已结束">已结束</option>
          <option value="未开始">未开始</option>
        </select>
      </div>
      <button class="add-btn" @click="goToAdd">创建活动</button>
    </div>

    <div class="activity-container">
      <div v-for="activity in filteredActivities" :key="activity.id" class="activity-item">
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
            <span class="label">开始时间：</span>
            <span class="value">{{ formatDate(activity.startDate) }}</span>
          </div>
          <div class="info-row">
            <span class="label">结束时间：</span>
            <span class="value">{{ formatDate(activity.endDate) }}</span>
          </div>
          <div class="info-row" v-if="activity.discountRate">
            <span class="label">折扣力度：</span>
            <span class="value">{{ (activity.discountRate * 10).toFixed(1) }}折</span>
          </div>
          <div class="info-row" v-if="activity.description">
            <span class="label">活动描述：</span>
            <span class="value">{{ activity.description }}</span>
          </div>
        </div>
        <div class="activity-actions">
          <button class="edit-btn" @click="handleEdit(activity.id)">编辑</button>
          <button class="delete-btn" @click="handleDelete(activity.id)">删除</button>
        </div>
      </div>
      <div v-if="filteredActivities.length === 0" class="empty">
        <div class="empty-icon">📢</div>
        <p>暂无营销活动</p>
      </div>
    </div>
  </div>
</template>

<script>
import { marketingActivityAPI } from '../../../api/index'

export default {
  name: 'MarketingList',
  data() {
    return {
      activities: [],
      filterStatus: '',
      loading: false
    }
  },
  computed: {
    filteredActivities() {
      if (!this.filterStatus) {
        return this.activities.map(activity => ({
          ...activity,
          status: this.getActivityStatus(activity)
        }))
      }
      return this.activities
        .map(activity => ({
          ...activity,
          status: this.getActivityStatus(activity)
        }))
        .filter(activity => activity.status === this.filterStatus)
    }
  },
  mounted() {
    this.loadActivities()
  },
  methods: {
    async loadActivities() {
      this.loading = true
      try {
        const response = await marketingActivityAPI.getAll()
        if (Array.isArray(response)) {
          this.activities = response
        }
      } catch (error) {
        console.error('加载营销活动列表失败:', error)
      } finally {
        this.loading = false
      }
    },
    formatDate(date) {
      if (!date) return ''
      const d = new Date(date)
      return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
    },
    getActivityStatus(activity) {
      const now = new Date()
      const startDate = new Date(activity.startDate)
      const endDate = new Date(activity.endDate)
      
      if (now < startDate) {
        return '未开始'
      } else if (now > endDate) {
        return '已结束'
      } else {
        return '进行中'
      }
    },
    getStatusClass(status) {
      switch (status) {
        case '进行中': return 'status-active'
        case '已结束': return 'status-ended'
        case '未开始': return 'status-pending'
        default: return ''
      }
    },
    handleFilter() {
    },
    goBack() {
      this.$router.push('/admin/dashboard')
    },
    goToAdd() {
      this.$router.push('/admin/marketing/add')
    },
    handleEdit(id) {
      this.$router.push(`/admin/marketing/edit/${id}`)
    },
    async handleDelete(id) {
      if (typeof uni !== 'undefined') {
        try {
          await uni.showModal({
            title: '提示',
            content: '确定要删除该活动吗？',
            success: async (res) => {
              if (res.confirm) {
                try {
                  await marketingActivityAPI.delete(id)
                  uni.showToast({ title: '删除成功', icon: 'success' })
                  this.loadActivities()
                } catch (error) {
                  console.error('删除失败:', error)
                  uni.showToast({ title: '删除失败，请重试', icon: 'none' })
                }
              }
            }
          })
        } catch (error) {
          console.error('删除活动失败:', error)
        }
      } else {
        if (confirm('确定要删除该活动吗？')) {
          try {
            await marketingActivityAPI.delete(id)
            alert('删除成功')
            this.loadActivities()
          } catch (error) {
            alert('删除失败')
          }
        }
      }
    }
  }
}
</script>

<style scoped>
.marketing-list {
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

.activity-container {
  padding: 20px;
}

.activity-item {
  background-color: #fff;
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 15px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.activity-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
  padding-bottom: 15px;
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

.activity-actions {
  display: flex;
  gap: 10px;
}

.edit-btn,
.delete-btn {
  flex: 1;
  padding: 10px;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.edit-btn {
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
