<template>
  <div class="attendance">
    <header class="header">
      <h1>考勤管理</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="filter-bar">
      <div class="filter-item">
        <label>选择月份：</label>
        <select v-model="selectedMonth">
          <option value="2024-01">2024年1月</option>
          <option value="2024-02">2024年2月</option>
          <option value="2024-03">2024年3月</option>
          <option value="2024-04">2024年4月</option>
        </select>
      </div>
      <div class="filter-item">
        <label>选择员工：</label>
        <select v-model="selectedEmployee">
          <option value="">全部员工</option>
          <option value="1">张美容师</option>
          <option value="2">李美容师</option>
          <option value="3">王美容师</option>
        </select>
      </div>
      <button class="search-btn" @click="searchAttendance">查询</button>
    </div>

    <div class="summary-cards">
      <div class="summary-card">
        <div class="summary-value">22</div>
        <div class="summary-label">出勤天数</div>
      </div>
      <div class="summary-card">
        <div class="summary-value">0</div>
        <div class="summary-label">迟到次数</div>
      </div>
      <div class="summary-card">
        <div class="summary-value">0</div>
        <div class="summary-label">早退次数</div>
      </div>
      <div class="summary-card">
        <div class="summary-value">0</div>
        <div class="summary-label">旷工天数</div>
      </div>
    </div>

    <div class="attendance-table">
      <table>
        <thead>
          <tr>
            <th>日期</th>
            <th>员工姓名</th>
            <th>签到时间</th>
            <th>签退时间</th>
            <th>工作时长</th>
            <th>状态</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="item in attendanceList" :key="item.id">
            <td>{{ item.date }}</td>
            <td>{{ item.employeeName }}</td>
            <td>{{ item.checkInTime }}</td>
            <td>{{ item.checkOutTime }}</td>
            <td>{{ item.workHours }}</td>
            <td :class="item.status">{{ item.statusText }}</td>
            <td>
              <button class="edit-btn" @click="editAttendance(item)">修改</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
export default {
  name: 'AdminAttendance',
  data() {
    return {
      selectedMonth: '2024-04',
      selectedEmployee: '',
      attendanceList: [
        {
          id: 1,
          date: '2024-04-20',
          employeeName: '张美容师',
          checkInTime: '09:00',
          checkOutTime: '18:00',
          workHours: '8.5',
          status: 'normal',
          statusText: '正常'
        },
        {
          id: 2,
          date: '2024-04-21',
          employeeName: '李美容师',
          checkInTime: '09:15',
          checkOutTime: '18:00',
          workHours: '8.25',
          status: 'late',
          statusText: '迟到'
        },
        {
          id: 3,
          date: '2024-04-22',
          employeeName: '王美容师',
          checkInTime: '08:55',
          checkOutTime: '17:30',
          workHours: '7.9',
          status: 'early',
          statusText: '早退'
        }
      ]
    }
  },
  methods: {
    searchAttendance() {
      uni.showToast({
        title: '查询成功',
        icon: 'success'
      })
    },
    editAttendance(item) {
      uni.showToast({
        title: '修改考勤记录',
        icon: 'none'
      })
    },
    goBack() {
      this.$router.push('/admin/dashboard')
    }
  }
}
</script>

<style scoped>
.attendance {
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

.filter-bar {
  display: flex;
  flex-wrap: wrap;
  gap: 15px;
  padding: 20px;
  background-color: #fff;
  margin: 10px;
  border-radius: 8px;
}

.filter-item {
  display: flex;
  align-items: center;
  gap: 10px;
}

.filter-item label {
  font-size: 14px;
  color: #666;
}

.filter-item select {
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.search-btn {
  padding: 8px 20px;
  background-color: #ff6b81;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
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

.attendance-table {
  margin: 0 10px 20px;
  background-color: #fff;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  overflow-x: auto;
}

.attendance-table table {
  width: 100%;
  border-collapse: collapse;
}

.attendance-table th,
.attendance-table td {
  padding: 12px;
  text-align: left;
  border-bottom: 1px solid #eee;
}

.attendance-table th {
  background-color: #fafafa;
  font-weight: bold;
  color: #333;
  font-size: 14px;
}

.attendance-table td {
  font-size: 14px;
  color: #666;
}

.normal {
  color: #4CAF50;
  font-weight: bold;
}

.late {
  color: #FF9800;
  font-weight: bold;
}

.early {
  color: #FF5722;
  font-weight: bold;
}

.edit-btn {
  padding: 5px 10px;
  background-color: #2196F3;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 12px;
  cursor: pointer;
}
</style>
