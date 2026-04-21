<template>
  <div class="schedule-list">
    <header class="header">
      <h1>员工排班</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="toolbar">
      <div class="date-selector">
        <button class="nav-btn" @click="prevMonth">&lt;</button>
        <span class="current-month">{{ currentMonthText }}</span>
        <button class="nav-btn" @click="nextMonth">&gt;</button>
      </div>
      <button class="add-btn" @click="goToAdd">添加排班</button>
    </div>

    <div class="schedule-container">
      <div class="schedule-grid">
        <div class="grid-header">
          <div class="grid-cell date-cell">日期</div>
          <div v-for="employee in employees" :key="employee.id" class="grid-cell employee-cell">
            {{ employee.user ? employee.user.name : '' }}
          </div>
        </div>
        <div class="grid-body">
          <div v-for="day in daysInMonth" :key="day.date" class="grid-row">
            <div class="grid-cell date-cell" :class="{ 'weekend': day.isWeekend, 'today': day.isToday }">
              <div class="day-number">{{ day.dayNumber }}</div>
              <div class="day-week">{{ day.weekDay }}</div>
            </div>
            <div v-for="employee in employees" :key="employee.id" class="grid-cell employee-cell">
              <div v-for="schedule in getScheduleForEmployeeAndDay(employee.id, day.date)" :key="schedule.id" class="schedule-item" :class="'shift-' + schedule.shiftType" @click="editSchedule(schedule)">
                {{ schedule.shiftType }}
              </div>
              <div v-if="!getScheduleForEmployeeAndDay(employee.id, day.date).length" class="no-schedule" @click="addScheduleForDay(employee.id, day.date)">
                +
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="shift-legend">
        <div class="legend-item">
          <span class="legend-color morning"></span>
          <span>早班</span>
        </div>
        <div class="legend-item">
          <span class="legend-color afternoon"></span>
          <span>中班</span>
        </div>
        <div class="legend-item">
          <span class="legend-color evening"></span>
          <span>晚班</span>
        </div>
        <div class="legend-item">
          <span class="legend-color rest"></span>
          <span>休息</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { scheduleAPI, employeeAPI } from '../../../api/index'

export default {
  name: 'ScheduleList',
  data() {
    return {
      schedules: [],
      employees: [],
      currentYear: new Date().getFullYear(),
      currentMonth: new Date().getMonth()
    }
  },
  computed: {
    currentMonthText() {
      return `${this.currentYear}年${this.currentMonth + 1}月`
    },
    daysInMonth() {
      const days = []
      const firstDay = new Date(this.currentYear, this.currentMonth, 1)
      const lastDay = new Date(this.currentYear, this.currentMonth + 1, 0)
      const today = new Date()

      for (let d = new Date(firstDay); d <= lastDay; d.setDate(d.getDate() + 1)) {
        const date = new Date(d)
        days.push({
          date: new Date(date),
          dayNumber: date.getDate(),
          weekDay: ['日', '一', '二', '三', '四', '五', '六'][date.getDay()],
          isWeekend: date.getDay() === 0 || date.getDay() === 6,
          isToday: date.toDateString() === today.toDateString()
        })
      }
      return days
    }
  },
  mounted() {
    this.loadEmployees()
    this.loadSchedules()
  },
  methods: {
    async loadEmployees() {
      try {
        const response = await employeeAPI.getAll()
        if (Array.isArray(response)) {
          this.employees = response
        }
      } catch (error) {
        console.error('加载员工列表失败:', error)
      }
    },
    async loadSchedules() {
      try {
        const startDate = new Date(this.currentYear, this.currentMonth, 1)
        const endDate = new Date(this.currentYear, this.currentMonth + 1, 0)
        const response = await scheduleAPI.getByDateRange(this.formatDate(startDate), this.formatDate(endDate))
        if (Array.isArray(response)) {
          this.schedules = response
        }
      } catch (error) {
        console.error('加载排班列表失败:', error)
      }
    },
    formatDate(date) {
      const d = new Date(date)
      return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
    },
    getScheduleForEmployeeAndDay(employeeId, date) {
      const dateStr = this.formatDate(date)
      return this.schedules.filter(s => {
        if (!s.employee || s.employee.id !== employeeId) return false
        const scheduleDate = new Date(s.scheduleDate)
        return this.formatDate(scheduleDate) === dateStr
      })
    },
    prevMonth() {
      if (this.currentMonth === 0) {
        this.currentMonth = 11
        this.currentYear--
      } else {
        this.currentMonth--
      }
      this.loadSchedules()
    },
    nextMonth() {
      if (this.currentMonth === 11) {
        this.currentMonth = 0
        this.currentYear++
      } else {
        this.currentMonth++
      }
      this.loadSchedules()
    },
    goBack() {
      this.$router.push('/admin/dashboard')
    },
    goToAdd() {
      this.$router.push('/admin/schedule/add')
    },
    addScheduleForDay(employeeId, date) {
      this.$router.push({
        path: '/admin/schedule/add',
        query: { employeeId: employeeId, date: this.formatDate(date) }
      })
    },
    editSchedule(schedule) {
      this.$router.push({
        path: '/admin/schedule/edit',
        query: { id: schedule.id }
      })
    }
  }
}
</script>

<style scoped>
.schedule-list {
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

.date-selector {
  display: flex;
  align-items: center;
}

.nav-btn {
  width: 36px;
  height: 36px;
  border: 1px solid #ddd;
  background-color: #fff;
  border-radius: 4px;
  font-size: 16px;
  cursor: pointer;
}

.current-month {
  margin: 0 20px;
  font-size: 16px;
  font-weight: bold;
  color: #333;
}

.schedule-container {
  background-color: #fff;
  padding: 20px;
}

.schedule-grid {
  overflow-x: auto;
}

.grid-header {
  display: flex;
  background-color: #f5f5f5;
  border-bottom: 1px solid #ddd;
  position: sticky;
  top: 0;
}

.grid-cell {
  padding: 10px;
  text-align: center;
  min-width: 100px;
  border-right: 1px solid #eee;
}

.date-cell {
  min-width: 80px;
  background-color: #fafafa;
}

.grid-row {
  display: flex;
  border-bottom: 1px solid #eee;
}

.grid-row:last-child {
  border-bottom: none;
}

.day-number {
  font-size: 16px;
  font-weight: bold;
  color: #333;
}

.day-week {
  font-size: 12px;
  color: #666;
}

.weekend .day-number,
.weekend .day-week {
  color: #ff6b81;
}

.today .day-number {
  background-color: #ff6b81;
  color: #fff;
  border-radius: 50%;
  width: 24px;
  height: 24px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
}

.schedule-item {
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  cursor: pointer;
  margin-bottom: 4px;
}

.shift-早班 {
  background-color: #E3F2FD;
  color: #1976D2;
}

.shift-中班 {
  background-color: #E8F5E9;
  color: #4CAF50;
}

.shift-晚班 {
  background-color: #FFF3E0;
  color: #FF9800;
}

.shift-休息 {
  background-color: #FFEBEE;
  color: #F44336;
}

.no-schedule {
  color: #ccc;
  cursor: pointer;
  font-size: 20px;
}

.no-schedule:hover {
  color: #ff6b81;
}

.shift-legend {
  display: flex;
  justify-content: center;
  gap: 30px;
  margin-top: 20px;
  padding-top: 20px;
  border-top: 1px solid #eee;
}

.legend-item {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
}

.legend-color {
  width: 20px;
  height: 20px;
  border-radius: 4px;
}

.legend-color.morning {
  background-color: #E3F2FD;
}

.legend-color.afternoon {
  background-color: #E8F5E9;
}

.legend-color.evening {
  background-color: #FFF3E0;
}

.legend-color.rest {
  background-color: #FFEBEE;
}
</style>