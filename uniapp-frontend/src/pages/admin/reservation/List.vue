<template>
  <div class="reservation-list">
    <header class="header">
      <h1>预约管理</h1>
      <div class="header-actions">
        <button class="add-btn" @click="navigateToAdd">添加预约</button>
        <button class="back-btn" @click="goBack">返回</button>
      </div>
    </header>

    <div class="filter-bar">
      <select v-model="filterStatus" @change="handleFilter">
        <option value="">全部状态</option>
        <option value="待确认">待确认</option>
        <option value="已确认">已确认</option>
        <option value="已到店">已到店</option>
        <option value="已完成">已完成</option>
        <option value="已取消">已取消</option>
        <option value="爽约">爽约</option>
      </select>
      <input type="date" v-model="filterDate" @change="handleFilter">
    </div>

    <div class="reservation-table">
      <table>
        <thead>
          <tr>
            <th>预约时间</th>
            <th>顾客</th>
            <th>员工</th>
            <th>服务</th>
            <th>房间</th>
            <th>状态</th>
            <th>来源</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="reservation in filteredReservations" :key="reservation.id">
            <td>{{ formatDateTime(reservation.reservationDate) }}</td>
            <td>{{ reservation.customer && reservation.customer.user ? reservation.customer.user.name : '' }}</td>
            <td>{{ reservation.employee && reservation.employee.user ? reservation.employee.user.name : '' }}</td>
            <td>{{ reservation.service ? reservation.service.name : '' }}</td>
            <td>{{ reservation.room ? reservation.room.name : '' }}</td>
            <td>
              <span :class="['status-badge', getStatusClass(reservation.status)]">
                {{ reservation.status }}
              </span>
            </td>
            <td>{{ reservation.source }}</td>
            <td>
              <button class="edit-btn" @click="navigateToEdit(reservation.id)">编辑</button>
              <button class="status-btn" @click="showStatusDialog(reservation)">状态</button>
            </td>
          </tr>
        </tbody>
      </table>

      <div v-if="loading" class="loading">加载中...</div>
      <div v-if="!loading && reservations.length === 0" class="empty">暂无预约数据</div>
    </div>

    <div v-if="showDialog" class="dialog">
      <div class="dialog-content">
        <h3>更新预约状态</h3>
        <div class="form-group">
          <label>选择状态</label>
          <select v-model="newStatus">
            <option value="待确认">待确认</option>
            <option value="已确认">已确认</option>
            <option value="已到店">已到店</option>
            <option value="已完成">已完成</option>
            <option value="已取消">已取消</option>
            <option value="爽约">爽约</option>
          </select>
        </div>
        <div class="dialog-buttons">
          <button class="cancel-btn" @click="showDialog = false">取消</button>
          <button class="confirm-btn" @click="updateStatus">确定</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { reservationAPI } from '../../../api/index'

export default {
  name: 'ReservationList',
  data() {
    return {
      reservations: [],
      filterStatus: '',
      filterDate: '',
      loading: false,
      showDialog: false,
      selectedReservation: null,
      newStatus: ''
    }
  },
  computed: {
    filteredReservations() {
      return this.reservations.filter(reservation => {
        const matchStatus = !this.filterStatus || reservation.status === this.filterStatus
        const matchDate = !this.filterDate || this.formatDate(reservation.reservationDate) === this.filterDate
        return matchStatus && matchDate
      })
    }
  },
  mounted() {
    this.loadReservations()
  },
  methods: {
    async loadReservations() {
      this.loading = true
      try {
        const response = await reservationAPI.getAll()
        if (Array.isArray(response)) {
          this.reservations = response
        }
      } catch (error) {
        console.error('加载预约列表失败:', error)
      } finally {
        this.loading = false
      }
    },
    formatDateTime(date) {
      if (!date) return ''
      const d = new Date(date)
      return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')} ${String(d.getHours()).padStart(2, '0')}:${String(d.getMinutes()).padStart(2, '0')}`
    },
    formatDate(date) {
      if (!date) return ''
      const d = new Date(date)
      return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
    },
    getStatusClass(status) {
      switch (status) {
        case '待确认': return 'status-pending'
        case '已确认': return 'status-confirmed'
        case '已到店': return 'status-arrived'
        case '已完成': return 'status-completed'
        case '已取消': return 'status-cancelled'
        case '爽约': return 'status-noshow'
        default: return ''
      }
    },
    handleFilter() {
      // 筛选由computed属性处理
    },
    navigateToAdd() {
      this.$router.push('/admin/reservation/add')
    },
    navigateToEdit(id) {
      this.$router.push(`/admin/reservation/edit?id=${id}`)
    },
    goBack() {
      this.$router.push('/admin/dashboard')
    },
    showStatusDialog(reservation) {
      this.selectedReservation = reservation
      this.newStatus = reservation.status
      this.showDialog = true
    },
    async updateStatus() {
      if (!this.selectedReservation) return

      try {
        await reservationAPI.updateStatus(this.selectedReservation.id, this.newStatus)
        this.loadReservations()
        this.showDialog = false
        alert('状态更新成功')
      } catch (error) {
        alert('状态更新失败')
      }
    }
  }
}
</script>

<style scoped>
.reservation-list {
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

.add-btn,
.back-btn {
  padding: 8px 16px;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.add-btn {
  background-color: #ff6b81;
  color: #fff;
}

.back-btn {
  background-color: #9E9E9E;
  color: #fff;
}

.filter-bar {
  display: flex;
  padding: 15px 20px;
  background-color: #fff;
  margin: 10px 0;
  gap: 10px;
}

.filter-bar select,
.filter-bar input {
  flex: 1;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.reservation-table {
  background-color: #fff;
  margin: 10px 0;
  padding: 20px;
}

table {
  width: 100%;
  border-collapse: collapse;
}

th, td {
  padding: 12px;
  text-align: left;
  border-bottom: 1px solid #ddd;
}

th {
  background-color: #f2f2f2;
  font-weight: bold;
}

.status-badge {
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
}

.status-pending {
  background-color: #FFF3E0;
  color: #FF9800;
}

.status-confirmed {
  background-color: #E3F2FD;
  color: #1976D2;
}

.status-arrived {
  background-color: #E8F5E9;
  color: #4CAF50;
}

.status-completed {
  background-color: #E8F5E9;
  color: #4CAF50;
}

.status-cancelled {
  background-color: #FFEBEE;
  color: #F44336;
}

.status-noshow {
  background-color: #FFEBEE;
  color: #F44336;
}

.edit-btn,
.status-btn {
  padding: 6px 12px;
  border: none;
  border-radius: 4px;
  font-size: 12px;
  cursor: pointer;
  margin-right: 5px;
}

.edit-btn {
  background-color: #4CAF50;
  color: white;
}

.status-btn {
  background-color: #2196F3;
  color: white;
}

.loading,
.empty {
  text-align: center;
  padding: 20px;
  color: #666;
}

.dialog {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.dialog-content {
  background-color: #fff;
  padding: 20px;
  border-radius: 8px;
  width: 300px;
}

.dialog-content h3 {
  font-size: 16px;
  color: #333;
  margin-bottom: 20px;
}

.dialog-content .form-group {
  margin-bottom: 20px;
}

.dialog-content .form-group label {
  display: block;
  margin-bottom: 8px;
  font-size: 14px;
  color: #666;
}

.dialog-content .form-group select {
  width: 100%;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.dialog-buttons {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}

.cancel-btn,
.confirm-btn {
  padding: 8px 20px;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.cancel-btn {
  background-color: #9E9E9E;
  color: #fff;
}

.confirm-btn {
  background-color: #ff6b81;
  color: #fff;
}
</style>