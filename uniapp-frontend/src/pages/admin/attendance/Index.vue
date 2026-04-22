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
          <option v-for="month in months" :key="month.value" :value="month.value">
            {{ month.label }}
          </option>
        </select>
      </div>
      <div class="filter-item">
        <label>选择员工：</label>
        <select v-model="selectedEmployee">
          <option value="">全部员工</option>
          <option v-for="employee in employees" :key="employee.id" :value="employee.id">
            {{ employee.user ? employee.user.name : employee.name }}
          </option>
        </select>
      </div>
      <button class="search-btn" @click="searchAttendance" :disabled="loading">
        {{ loading ? '查询中...' : '查询' }}
      </button>
    </div>

    <div class="summary-cards">
      <div class="summary-card">
        <div class="summary-value">{{ attendanceList.length }}</div>
        <div class="summary-label">出勤天数</div>
      </div>
      <div class="summary-card">
        <div class="summary-value">{{ attendanceList.filter(item => item.status === 'late').length }}</div>
        <div class="summary-label">迟到次数</div>
      </div>
      <div class="summary-card">
        <div class="summary-value">{{ attendanceList.filter(item => item.status === 'early').length }}</div>
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
import { attendanceAPI, employeeAPI } from '../../../api/index'

export default {
  name: 'AdminAttendance',
  data() {
    return {
      selectedMonth: this.getCurrentMonth(),
      selectedEmployee: '',
      attendanceList: [],
      employees: [],
      loading: false,
      loadingEmployees: false,
      months: []
    }
  },
  mounted() {
    this.generateMonths()
    this.loadEmployees()
  },
  methods: {
    getCurrentMonth() {
      const now = new Date()
      const year = now.getFullYear()
      const month = String(now.getMonth() + 1).padStart(2, '0')
      return `${year}-${month}`
    },
    generateMonths() {
      const now = new Date()
      const currentYear = now.getFullYear()
      const currentMonth = now.getMonth() + 1
      this.months = []
      
      // 生成当前年份的所有月份
      for (let month = 1; month <= 12; month++) {
        const monthStr = String(month).padStart(2, '0')
        this.months.push({
          value: `${currentYear}-${monthStr}`,
          label: `${currentYear}年${month}月`
        })
      }
      
      // 生成去年的最后几个月份
      for (let month = 10; month <= 12; month++) {
        const monthStr = String(month).padStart(2, '0')
        this.months.unshift({
          value: `${currentYear - 1}-${monthStr}`,
          label: `${currentYear - 1}年${month}月`
        })
      }
    },
    async loadEmployees() {
      this.loadingEmployees = true
      try {
        const employees = await employeeAPI.getAll()
        if (Array.isArray(employees)) {
          this.employees = employees
        }
      } catch (error) {
        console.error('加载员工列表失败:', error)
        if (typeof uni !== 'undefined') {
          uni.showToast({ title: '加载员工列表失败', icon: 'none' })
        }
      } finally {
        this.loadingEmployees = false
      }
    },
    async searchAttendance() {
      if (!this.selectedEmployee) {
        if (typeof uni !== 'undefined') {
          uni.showToast({ title: '请选择员工', icon: 'none' })
        }
        return
      }
      
      this.loading = true
      try {
        // 计算月份的开始和结束日期
        const [year, month] = this.selectedMonth.split('-')
        const startDate = new Date(year, month - 1, 1)
        const endDate = new Date(year, month, 0)
        
        // 格式化日期为YYYY-MM-DD
        const formatDate = (date) => {
          return date.toISOString().split('T')[0]
        }
        
        // 调用后端API获取考勤数据
        const data = await attendanceAPI.getByDateRange(this.selectedEmployee, formatDate(startDate), formatDate(endDate))
        
        if (Array.isArray(data)) {
          // 转换考勤数据格式
          this.attendanceList = data.map(item => {
            // 计算工作时长
            let workHours = '0'
            if (item.checkInTime && item.checkOutTime) {
              const checkIn = new Date(item.checkInTime)
              const checkOut = new Date(item.checkOutTime)
              const hours = (checkOut - checkIn) / (1000 * 60 * 60)
              workHours = hours.toFixed(2)
            }
            
            // 确定状态
            let status = 'normal'
            let statusText = '正常'
            if (item.checkInTime) {
              const checkIn = new Date(item.checkInTime)
              const nineAM = new Date(checkIn.getFullYear(), checkIn.getMonth(), checkIn.getDate(), 9, 0, 0)
              if (checkIn > nineAM) {
                status = 'late'
                statusText = '迟到'
              }
            }
            if (item.checkOutTime) {
              const checkOut = new Date(item.checkOutTime)
              const sixPM = new Date(checkOut.getFullYear(), checkOut.getMonth(), checkOut.getDate(), 18, 0, 0)
              if (checkOut < sixPM) {
                status = 'early'
                statusText = '早退'
              }
            }
            
            return {
              id: item.id,
              date: item.checkInTime ? new Date(item.checkInTime).toISOString().split('T')[0] : '',
              employeeName: item.employee ? item.employee.name : '',
              checkInTime: item.checkInTime ? new Date(item.checkInTime).toTimeString().substring(0, 5) : '',
              checkOutTime: item.checkOutTime ? new Date(item.checkOutTime).toTimeString().substring(0, 5) : '',
              workHours: workHours,
              status: status,
              statusText: statusText
            }
          })
          
          if (typeof uni !== 'undefined') {
            uni.showToast({ title: '查询成功', icon: 'success' })
          }
        }
      } catch (error) {
        console.error('查询考勤失败:', error)
        if (typeof uni !== 'undefined') {
          uni.showToast({ title: '查询失败，请重试', icon: 'none' })
        }
      } finally {
        this.loading = false
      }
    },
    editAttendance(item) {
      if (typeof uni !== 'undefined') {
        uni.showToast({ title: '修改考勤记录', icon: 'none' })
      }
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
