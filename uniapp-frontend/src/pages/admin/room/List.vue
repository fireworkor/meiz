<template>
  <div class="room-list">
    <header class="header">
      <h1>房间管理</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="room-container">
      <div v-for="room in rooms" :key="room.id" class="room-item">
        <div class="room-header">
          <h3>{{ room.name }}</h3>
          <span :class="['status-badge', getStatusClass(room.status)]">
            {{ room.status }}
          </span>
        </div>
        <div class="room-info">
          <div class="info-row">
            <span class="label">类型：</span>
            <span class="value">{{ room.type }}</span>
          </div>
          <div class="info-row">
            <span class="label">容量：</span>
            <span class="value">{{ room.capacity }}人</span>
          </div>
        </div>
        <div class="room-actions">
          <button class="edit-btn" @click="editRoom(room)">编辑</button>
        </div>
      </div>
      <div v-if="rooms.length === 0" class="empty">
        <div class="empty-icon">🏠</div>
        <p>暂无房间数据</p>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'RoomList',
  data() {
    return {
      rooms: [
        { id: 1, name: 'VIP 1号房', type: 'VIP房', capacity: 2, status: '空闲' },
        { id: 2, name: 'VIP 2号房', type: 'VIP房', capacity: 2, status: '占用' },
        { id: 3, name: '单人间 1', type: '单人间', capacity: 1, status: '空闲' },
        { id: 4, name: '单人间 2', type: '单人间', capacity: 1, status: '清洁中' },
        { id: 5, name: '双人间 1', type: '双人间', capacity: 2, status: '空闲' }
      ]
    }
  },
  methods: {
    getStatusClass(status) {
      switch (status) {
        case '空闲': return 'status-idle'
        case '占用': return 'status-occupied'
        case '清洁中': return 'status-cleaning'
        default: return ''
      }
    },
    goBack() {
      this.$router.push('/admin/dashboard')
    },
    editRoom(room) {
      alert(`编辑房间: ${room.name}`)
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

.back-btn {
  padding: 8px 16px;
  background-color: #ff6b81;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.room-container {
  padding: 20px;
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 15px;
}

.room-item {
  background-color: #fff;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
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

.room-info {
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

.room-actions {
  display: flex;
  justify-content: flex-end;
}

.edit-btn {
  padding: 8px 16px;
  background-color: #2196F3;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

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
  margin: 0;
}
</style>