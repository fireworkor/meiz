<template>
  <div class="reservation-list">
    <header class="header">
      <h1>预约管理</h1>
      <button class="add-btn" @click="navigateToAdd">添加预约</button>
    </header>
    <div class="filter-bar">
      <select v-model="filterStatus">
        <option value="">全部状态</option>
        <option value="待确认">待确认</option>
        <option value="已确认">已确认</option>
        <option value="已到店">已到店</option>
        <option value="已完成">已完成</option>
        <option value="已取消">已取消</option>
        <option value="爽约">爽约</option>
      </select>
      <input type="date" v-model="filterDate">
      <button class="filter-btn" @click="filterReservations">筛选</button>
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
          <tr v-for="reservation in reservations" :key="reservation.id">
            <td>{{ formatDateTime(reservation.reservationDate) }}</td>
            <td>{{ reservation.customer.user.name }}</td>
            <td>{{ reservation.employee.user.name }}</td>
            <td>{{ reservation.service.name }}</td>
            <td>{{ reservation.room.name }}</td>
            <td>{{ reservation.status }}</td>
            <td>{{ reservation.source }}</td>
            <td>
              <button class="edit-btn" @click="navigateToEdit(reservation.id)">编辑</button>
              <button class="status-btn" @click="updateStatus(reservation.id)">更新状态</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      reservations: [
        {
          id: 1,
          reservationDate: new Date('2026-04-21 14:00:00'),
          customer: {
            user: {
              name: '顾客1'
            }
          },
          employee: {
            user: {
              name: '员工1'
            }
          },
          service: {
            name: '面部护理'
          },
          room: {
            name: 'VIP房1'
          },
          status: '待确认',
          source: '前台代约'
        },
        {
          id: 2,
          reservationDate: new Date('2026-04-21 15:00:00'),
          customer: {
            user: {
              name: '顾客2'
            }
          },
          employee: {
            user: {
              name: '员工2'
            }
          },
          service: {
            name: '身体护理'
          },
          room: {
            name: '双人间1'
          },
          status: '已确认',
          source: '顾客自助预约'
        }
      ],
      filterStatus: '',
      filterDate: ''
    }
  },
  methods: {
    formatDateTime(date) {
      if (!date) return '';
      const d = new Date(date);
      return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')} ${String(d.getHours()).padStart(2, '0')}:${String(d.getMinutes()).padStart(2, '0')}`;
    },
    navigateToAdd() {
      uni.navigateTo({ url: '/pages/admin/reservation/add' });
    },
    navigateToEdit(id) {
      uni.navigateTo({ url: `/pages/admin/reservation/edit?id=${id}` });
    },
    updateStatus(id) {
      // 这里调用更新状态API
      uni.showToast({ title: '状态更新功能开发中', icon: 'none' });
    },
    filterReservations() {
      // 这里调用筛选API
      uni.showToast({ title: '筛选功能开发中', icon: 'none' });
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

.add-btn {
  padding: 8px 16px;
  background-color: #ff6b81;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
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

.filter-btn {
  padding: 10px 20px;
  background-color: #ff6b81;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
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
</style>