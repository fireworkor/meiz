<template>
  <view class="room-list">
    <header class="header">
      <h1>房间管理</h1>
      <div class="header-actions">
        <button class="add-btn" @click="goToAdd">添加房间</button>
        <button class="back-btn" @click="goBack">返回</button>
      </div>
    </header>

    <view class="search-bar">
      <input 
        v-model="searchKeyword" 
        placeholder="搜索房间名称/描述"
        class="search-input"
        @confirm="handleSearch"
      />
      <button class="search-btn" @click="handleSearch">搜索</button>
    </view>

    <view class="filter-bar">
      <view class="filter-group">
        <text class="filter-label">状态:</text>
        <view class="filter-options">
          <view 
            v-for="status in statusOptions" 
            :key="status.value"
            :class="['filter-chip', { active: selectedStatus === status.value }]"
            @click="toggleStatusFilter(status.value)"
          >
            {{ status.label }}
          </view>
        </view>
      </view>
    </view>

    <view class="batch-actions" v-if="selectedRooms.length > 0">
      <text class="selected-count">已选择 {{ selectedRooms.length }} 项</text>
      <button class="batch-delete-btn" @click="handleBatchDelete">批量删除</button>
      <button class="cancel-btn" @click="cancelSelection">取消</button>
    </view>

    <view class="room-container">
      <view v-for="room in rooms" :key="room.id" class="room-item">
        <view class="room-checkbox" @click="toggleSelection(room.id)">
          <view :class="['checkbox', { checked: selectedRooms.includes(room.id) }]">
            <text v-if="selectedRooms.includes(room.id)">✓</text>
          </view>
        </view>
        <view class="room-content" @click="editRoom(room)">
          <view class="room-header">
            <h3>{{ room.name }}</h3>
            <span :class="['status-badge', getStatusClass(room.status)]">
              {{ getStatusLabel(room.status) }}
            </span>
          </view>
          <view class="room-info">
            <view class="info-row">
              <span class="label">类型：</span>
              <span class="value">{{ getTypeLabel(room.type) }}</span>
            </view>
            <view class="info-row">
              <span class="label">容量：</span>
              <span class="value">{{ room.capacity }}人</span>
            </view>
            <view class="info-row" v-if="room.floor">
              <span class="label">楼层：</span>
              <span class="value">{{ room.floor }}楼</span>
            </view>
            <view class="info-row" v-if="room.description">
              <span class="label">描述：</span>
              <span class="value">{{ room.description }}</span>
            </view>
          </view>
          <view class="quick-status">
            <text class="quick-label">快速切换状态:</text>
            <view class="quick-options">
              <view 
                v-for="status in statusOptions.filter(s => s.value !== room.status)" 
                :key="status.value"
                :class="['quick-chip', getStatusClass(status.value)]"
                @click.stop="quickUpdateStatus(room.id, status.value)"
              >
                {{ status.label }}
              </view>
            </view>
          </view>
        </view>
        <view class="room-actions">
          <button class="edit-btn" @click="editRoom(room)">编辑</button>
          <button class="delete-btn" @click="deleteRoom(room)">删除</button>
        </view>
      </view>
      <view v-if="loading" class="loading">加载中...</view>
      <view v-if="!loading && rooms.length === 0" class="empty">
        <view class="empty-icon">🏠</view>
        <p>暂无房间数据</p>
        <button class="add-first-btn" @click="goToAdd">添加第一个房间</button>
      </view>
    </view>
  </view>
</template>

<script>
import { roomAPI } from '../../../api/index'

export default {
  name: 'RoomList',
  data() {
    return {
      rooms: [],
      loading: false,
      searchKeyword: '',
      selectedStatus: '',
      selectedRooms: [],
      typeOptions: [
        { label: '全部', value: '' },
        { label: '美容院', value: 'BEAUTY' },
        { label: 'SPA室', value: 'SPA' },
        { label: '咨询室', value: 'CONSULTATION' },
        { label: '其他', value: 'OTHER' }
      ],
      statusOptions: [
        { label: '全部', value: '' },
        { label: '可用', value: 'AVAILABLE' },
        { label: '使用中', value: 'OCCUPIED' },
        { label: '维护中', value: 'MAINTENANCE' },
        { label: '不可用', value: 'UNAVAILABLE' }
      ]
    }
  },
  mounted() {
    this.loadRooms()
  },
  methods: {
    async loadRooms() {
      this.loading = true
      try {
        const response = await roomAPI.search(this.searchKeyword, this.selectedStatus, '')
        if (Array.isArray(response)) {
          this.rooms = response
        }
      } catch (error) {
        console.error('加载房间列表失败:', error)
        if (typeof uni !== 'undefined') {
          uni.showToast({ title: '加载房间列表失败', icon: 'none' })
        } else {
          alert('加载房间列表失败')
        }
      } finally {
        this.loading = false
      }
    },
    handleSearch() {
      this.loadRooms()
    },
    toggleStatusFilter(status) {
      this.selectedStatus = status
      this.loadRooms()
    },
    getStatusClass(status) {
      switch (status) {
        case 'AVAILABLE': return 'status-idle'
        case 'OCCUPIED': return 'status-occupied'
        case 'MAINTENANCE': return 'status-cleaning'
        case 'UNAVAILABLE': return 'status-unavailable'
        default: return ''
      }
    },
    getStatusLabel(status) {
      const statusOption = this.statusOptions.find(s => s.value === status)
      return statusOption ? statusOption.label : status
    },
    getTypeLabel(type) {
      const typeOption = this.typeOptions.find(t => t.value === type)
      return typeOption ? typeOption.label : type
    },
    goBack() {
      this.$router.push('/admin/dashboard')
    },
    goToAdd() {
      this.$router.push('/admin/room/add')
    },
    editRoom(room) {
      this.$router.push(`/admin/room/edit?id=${room.id}`)
    },
    toggleSelection(roomId) {
      const index = this.selectedRooms.indexOf(roomId)
      if (index > -1) {
        this.selectedRooms.splice(index, 1)
      } else {
        this.selectedRooms.push(roomId)
      }
    },
    cancelSelection() {
      this.selectedRooms = []
    },
    async quickUpdateStatus(roomId, status) {
      try {
        await roomAPI.updateStatus(roomId, status)
        this.loadRooms()
        if (typeof uni !== 'undefined') {
          uni.showToast({ title: '状态已更新', icon: 'success' })
        }
      } catch (error) {
        console.error('更新状态失败:', error)
        if (typeof uni !== 'undefined') {
          uni.showToast({ title: '更新失败', icon: 'none' })
        }
      }
    },
    deleteRoom(room) {
      if (typeof uni !== 'undefined') {
        uni.showModal({
          title: '确认删除',
          content: `确定要删除房间 "${room.name}" 吗？`,
          success: async (res) => {
            if (res.confirm) {
              try {
                await roomAPI.delete(room.id)
                this.loadRooms()
                uni.showToast({ title: '删除成功', icon: 'success' })
              } catch (error) {
                console.error('删除房间失败:', error)
                uni.showToast({ title: '删除失败，请重试', icon: 'none' })
              }
            }
          }
        })
      } else {
        if (confirm(`确定要删除房间 "${room.name}" 吗？`)) {
          (async () => {
            try {
              await roomAPI.delete(room.id)
              this.loadRooms()
              alert('删除成功')
            } catch (error) {
              console.error('删除房间失败:', error)
              alert('删除失败，请重试')
            }
          })()
        }
      }
    },
    handleBatchDelete() {
      if (this.selectedRooms.length === 0) return
      
      if (typeof uni !== 'undefined') {
        uni.showModal({
          title: '确认批量删除',
          content: `确定要删除选中的 ${this.selectedRooms.length} 个房间吗？`,
          success: async (res) => {
            if (res.confirm) {
              try {
                await roomAPI.batchDelete(this.selectedRooms)
                this.selectedRooms = []
                this.loadRooms()
                uni.showToast({ title: '批量删除成功', icon: 'success' })
              } catch (error) {
                console.error('批量删除房间失败:', error)
                uni.showToast({ title: '批量删除失败，请重试', icon: 'none' })
              }
            }
          }
        })
      } else {
        if (confirm(`确定要删除选中的 ${this.selectedRooms.length} 个房间吗？`)) {
          (async () => {
            try {
              await roomAPI.batchDelete(this.selectedRooms)
              this.selectedRooms = []
              this.loadRooms()
              alert('批量删除成功')
            } catch (error) {
              console.error('批量删除房间失败:', error)
              alert('批量删除失败，请重试')
            }
          })()
        }
      }
    }
  }
}
</script>

<style scoped>
.room-list {
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

.header-actions {
  display: flex;
  gap: 10px;
}

.back-btn,
.add-btn {
  padding: 8px 16px;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.back-btn {
  background-color: #9E9E9E;
  color: #fff;
}

.add-btn {
  background-color: #4CAF50;
  color: #fff;
}

.search-bar {
  display: flex;
  padding: 15px 20px;
  background-color: #fff;
  gap: 10px;
}

.search-input {
  flex: 1;
  padding: 10px 15px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.search-btn {
  padding: 10px 20px;
  background-color: #2196F3;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 14px;
}

.filter-bar {
  padding: 10px 20px;
  background-color: #fff;
  border-bottom: 1px solid #eee;
}

.filter-group {
  display: flex;
  align-items: center;
  gap: 10px;
}

.filter-label {
  font-size: 14px;
  color: #666;
}

.filter-options {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.filter-chip {
  padding: 4px 12px;
  border: 1px solid #ddd;
  border-radius: 16px;
  font-size: 12px;
  color: #666;
  background-color: #fff;
}

.filter-chip.active {
  background-color: #2196F3;
  color: #fff;
  border-color: #2196F3;
}

.batch-actions {
  display: flex;
  align-items: center;
  padding: 12px 20px;
  background-color: #FFF3E0;
  gap: 10px;
}

.selected-count {
  flex: 1;
  font-size: 14px;
  color: #FF9800;
}

.batch-delete-btn {
  padding: 6px 16px;
  background-color: #F44336;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 14px;
}

.cancel-btn {
  padding: 6px 16px;
  background-color: #9E9E9E;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 14px;
}

.room-container {
  padding: 20px;
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 15px;
}

.room-item {
  position: relative;
  background-color: #fff;
  border-radius: 8px;
  padding: 20px;
  padding-left: 45px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.room-checkbox {
  position: absolute;
  left: 12px;
  top: 20px;
}

.checkbox {
  width: 22px;
  height: 22px;
  border: 2px solid #ddd;
  border-radius: 4px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  color: #fff;
}

.checkbox.checked {
  background-color: #4CAF50;
  border-color: #4CAF50;
}

.room-content {
  cursor: pointer;
}

.room-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
  padding-bottom: 15px;
  border-bottom: 1px solid #eee;
}

.room-header h3 {
  font-size: 16px;
  color: #333;
  margin: 0;
}

.status-badge {
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
}

.status-idle {
  background-color: #E8F5E9;
  color: #4CAF50;
}

.status-occupied {
  background-color: #FFEBEE;
  color: #F44336;
}

.status-cleaning {
  background-color: #FFF3E0;
  color: #FF9800;
}

.status-unavailable {
  background-color: #ECEFF1;
  color: #607D8B;
}

.room-info {
  margin-bottom: 12px;
}

.info-row {
  display: flex;
  justify-content: space-between;
  margin-bottom: 6px;
  font-size: 13px;
}

.info-row .label {
  color: #666;
}

.info-row .value {
  color: #333;
  max-width: 120px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.quick-status {
  padding-top: 10px;
  border-top: 1px dashed #eee;
}

.quick-label {
  font-size: 11px;
  color: #999;
  display: block;
  margin-bottom: 6px;
}

.quick-options {
  display: flex;
  gap: 6px;
}

.quick-chip {
  padding: 2px 8px;
  border-radius: 10px;
  font-size: 11px;
}

.quick-chip.status-idle {
  background-color: #E8F5E9;
  color: #4CAF50;
}

.quick-chip.status-occupied {
  background-color: #FFEBEE;
  color: #F44336;
}

.quick-chip.status-cleaning {
  background-color: #FFF3E0;
  color: #FF9800;
}

.quick-chip.status-unavailable {
  background-color: #ECEFF1;
  color: #607D8B;
}

.room-actions {
  display: flex;
  gap: 10px;
  justify-content: flex-end;
  margin-top: 12px;
}

.edit-btn,
.delete-btn {
  padding: 6px 12px;
  border: none;
  border-radius: 4px;
  font-size: 12px;
  cursor: pointer;
}

.edit-btn {
  background-color: #2196F3;
  color: #fff;
}

.delete-btn {
  background-color: #F44336;
  color: #fff;
}

.loading,
.empty {
  grid-column: 1 / -1;
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
  margin: 0 0 20px 0;
}

.add-first-btn {
  padding: 10px 20px;
  background-color: #4CAF50;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
  margin-top: 10px;
}
</style>