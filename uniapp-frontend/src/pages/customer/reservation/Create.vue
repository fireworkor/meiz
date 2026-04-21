<template>
  <div class="customer-reservation">
    <header class="header">
      <h1>预约服务</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="reservation-container">
      <div class="step-indicator">
        <div :class="['step', { active: step >= 1, completed: step > 1 }]">
          <span class="step-num">1</span>
          <span class="step-text">选择服务</span>
        </div>
        <div class="step-line"></div>
        <div :class="['step', { active: step >= 2, completed: step > 2 }]">
          <span class="step-num">2</span>
          <span class="step-text">选择员工</span>
        </div>
        <div class="step-line"></div>
        <div :class="['step', { active: step >= 3, completed: step > 3 }]">
          <span class="step-num">3</span>
          <span class="step-text">选择时间</span>
        </div>
        <div class="step-line"></div>
        <div :class="['step', { active: step >= 4 }]">
          <span class="step-num">4</span>
          <span class="step-text">确认信息</span>
        </div>
      </div>

      <div class="step-content">
        <div v-if="step === 1" class="step1">
          <h3>选择服务项目</h3>
          <div class="service-list">
            <div v-for="service in services" :key="service.id" :class="['service-item', { selected: selectedService && selectedService.id === service.id }]" @click="selectService(service)">
              <div class="service-info">
                <h4>{{ service.name }}</h4>
                <p>{{ service.description || service.duration + '分钟' }}</p>
                <p class="price">¥{{ service.price }}</p>
              </div>
              <span v-if="selectedService && selectedService.id === service.id" class="selected-icon">✓</span>
            </div>
          </div>
        </div>

        <div v-if="step === 2" class="step2">
          <h3>选择美容师</h3>
          <div class="employee-list">
            <div v-for="employee in employees" :key="employee.id" :class="['employee-item', { selected: selectedEmployee && selectedEmployee.id === employee.id }]" @click="selectEmployee(employee)">
              <div class="employee-info">
                <h4>{{ employee.user ? employee.user.name : '' }}</h4>
                <p>{{ employee.position }}</p>
                <p v-if="employee.skillTags">{{ employee.skillTags }}</p>
              </div>
              <span v-if="selectedEmployee && selectedEmployee.id === employee.id" class="selected-icon">✓</span>
            </div>
          </div>
        </div>

        <div v-if="step === 3" class="step3">
          <h3>选择预约时间</h3>
          <div class="date-selector">
            <button class="date-btn" @click="prevDate">&lt;</button>
            <div class="current-date">{{ selectedDateText }}</div>
            <button class="date-btn" @click="nextDate">&gt;</button>
          </div>
          <div class="time-slots">
            <div v-for="time in availableTimeSlots" :key="time" :class="['time-slot', { selected: selectedTime === time }]" @click="selectTime(time)">
              {{ time }}
            </div>
          </div>
        </div>

        <div v-if="step === 4" class="step4">
          <h3>确认预约信息</h3>
          <div class="reservation-summary">
            <div class="summary-item">
              <span>服务项目：</span>
              <span>{{ selectedService ? selectedService.name : '' }}</span>
            </div>
            <div class="summary-item">
              <span>美容师：</span>
              <span>{{ selectedEmployee && selectedEmployee.user ? selectedEmployee.user.name : '' }}</span>
            </div>
            <div class="summary-item">
              <span>预约时间：</span>
              <span>{{ selectedDateText }} {{ selectedTime }}</span>
            </div>
            <div class="summary-item total">
              <span>服务价格：</span>
              <span class="total-price">¥{{ selectedService ? selectedService.price : 0 }}</span>
            </div>
          </div>
          <div class="customer-info">
            <h4>顾客信息</h4>
            <div class="info-item">
              <span>姓名：</span>
              <span>{{ userInfo.name || '' }}</span>
            </div>
            <div class="info-item">
              <span>手机号：</span>
              <span>{{ userInfo.phone || '' }}</span>
            </div>
          </div>
        </div>
      </div>

      <div class="step-buttons">
        <button class="prev-btn" @click="prevStep" v-if="step > 1">上一步</button>
        <button class="next-btn" @click="nextStep" v-if="step < 4" :disabled="!canNext">下一步</button>
        <button class="submit-btn" @click="submitReservation" v-if="step === 4" :disabled="loading">
          {{ loading ? '提交中...' : '确认预约' }}
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import { employeeAPI, reservationAPI } from '../../../api/index'

export default {
  name: 'CustomerReservation',
  data() {
    return {
      step: 1,
      services: [
        { id: 1, name: '面部护理', description: '深层清洁补水', price: 200, duration: 60 },
        { id: 2, name: '身体护理', description: '全身按摩放松', price: 300, duration: 90 },
        { id: 3, name: '美甲', description: '专业美甲服务', price: 100, duration: 30 }
      ],
      employees: [],
      selectedService: null,
      selectedEmployee: null,
      selectedDate: new Date(),
      selectedTime: '',
      availableTimeSlots: [
        '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
        '14:00', '14:30', '15:00', '15:30', '16:00', '16:30', '17:00'
      ],
      loading: false,
      userInfo: {}
    }
  },
  computed: {
    selectedDateText() {
      const d = this.selectedDate
      return `${d.getFullYear()}年${d.getMonth() + 1}月${d.getDate()}日`
    },
    canNext() {
      switch (this.step) {
        case 1: return !!this.selectedService
        case 2: return !!this.selectedEmployee
        case 3: return !!this.selectedTime
        default: return true
      }
    }
  },
  mounted() {
    this.loadEmployees()
    this.loadUserInfo()
  },
  methods: {
    loadUserInfo() {
      const userStr = localStorage.getItem('userInfo')
      if (userStr) {
        this.userInfo = JSON.parse(userStr)
      }
    },
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
    selectService(service) {
      this.selectedService = service
    },
    selectEmployee(employee) {
      this.selectedEmployee = employee
    },
    prevDate() {
      const newDate = new Date(this.selectedDate)
      newDate.setDate(newDate.getDate() - 1)
      this.selectedDate = newDate
      this.selectedTime = ''
    },
    nextDate() {
      const newDate = new Date(this.selectedDate)
      newDate.setDate(newDate.getDate() + 1)
      this.selectedDate = newDate
      this.selectedTime = ''
    },
    selectTime(time) {
      this.selectedTime = time
    },
    prevStep() {
      if (this.step > 1) this.step--
    },
    nextStep() {
      if (this.canNext && this.step < 4) this.step++
    },
    goBack() {
      this.$router.push('/customer/dashboard')
    },
    async submitReservation() {
      this.loading = true
      try {
        const reservationDate = new Date(this.selectedDate)
        const [hours, minutes] = this.selectedTime.split(':')
        reservationDate.setHours(parseInt(hours), parseInt(minutes), 0, 0)

        const reservationData = {
          customer: {
            user: {
              name: this.userInfo.name || '顾客',
              phone: this.userInfo.phone || ''
            }
          },
          employee: this.selectedEmployee,
          service: this.selectedService,
          reservationDate: reservationDate,
          source: '顾客自助预约'
        }

        const response = await reservationAPI.create(reservationData)
        if (response.id) {
          alert('预约成功')
          this.$router.push('/customer/dashboard')
        }
      } catch (error) {
        alert('预约失败')
      } finally {
        this.loading = false
      }
    }
  }
}
</script>

<style scoped>
.customer-reservation {
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

.reservation-container {
  padding: 20px;
}

.step-indicator {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-bottom: 30px;
}

.step {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.step-num {
  width: 30px;
  height: 30px;
  border-radius: 50%;
  background-color: #ddd;
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  margin-bottom: 5px;
}

.step.active .step-num {
  background-color: #ff6b81;
}

.step.completed .step-num {
  background-color: #4CAF50;
}

.step-text {
  font-size: 12px;
  color: #666;
}

.step.active .step-text {
  color: #ff6b81;
}

.step-line {
  width: 50px;
  height: 2px;
  background-color: #ddd;
  margin: 0 10px;
  margin-bottom: 20px;
}

.step-content {
  background-color: #fff;
  border-radius: 8px;
  padding: 20px;
  min-height: 400px;
}

.step-content h3 {
  font-size: 16px;
  color: #333;
  margin-bottom: 20px;
}

.service-list,
.employee-list {
  max-height: 300px;
  overflow-y: auto;
}

.service-item,
.employee-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px;
  border: 1px solid #eee;
  border-radius: 4px;
  margin-bottom: 10px;
  cursor: pointer;
}

.service-item:hover,
.employee-item:hover {
  background-color: #f5f5f5;
}

.service-item.selected,
.employee-item.selected {
  border-color: #ff6b81;
  background-color: #FFF5F5;
}

.service-info h4,
.employee-info h4 {
  font-size: 14px;
  color: #333;
  margin-bottom: 5px;
}

.service-info p,
.employee-info p {
  font-size: 12px;
  color: #666;
  margin: 0;
}

.service-info .price {
  font-size: 14px;
  font-weight: bold;
  color: #ff6b81;
}

.selected-icon {
  width: 20px;
  height: 20px;
  border-radius: 50%;
  background-color: #ff6b81;
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
}

.date-selector {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-bottom: 20px;
}

.date-btn {
  width: 40px;
  height: 40px;
  border: 1px solid #ddd;
  background-color: #fff;
  border-radius: 4px;
  font-size: 18px;
  cursor: pointer;
}

.current-date {
  margin: 0 20px;
  font-size: 16px;
  color: #333;
}

.time-slots {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 10px;
}

.time-slot {
  padding: 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  text-align: center;
  cursor: pointer;
  font-size: 14px;
}

.time-slot:hover {
  background-color: #f5f5f5;
}

.time-slot.selected {
  border-color: #ff6b81;
  background-color: #FFF5F5;
  color: #ff6b81;
}

.reservation-summary,
.customer-info {
  margin-bottom: 20px;
}

.reservation-summary h3,
.customer-info h4 {
  font-size: 14px;
  color: #333;
  margin-bottom: 15px;
}

.summary-item,
.info-item {
  display: flex;
  justify-content: space-between;
  padding: 10px 0;
  border-bottom: 1px solid #eee;
}

.summary-item.total {
  font-weight: bold;
  border-bottom: none;
  margin-top: 10px;
}

.total-price {
  color: #ff6b81;
  font-size: 16px;
}

.step-buttons {
  display: flex;
  justify-content: center;
  gap: 20px;
  margin-top: 20px;
}

.prev-btn,
.next-btn,
.submit-btn {
  padding: 12px 40px;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.prev-btn {
  background-color: #9E9E9E;
  color: #fff;
}

.next-btn,
.submit-btn {
  background-color: #ff6b81;
  color: #fff;
}

.next-btn:disabled,
.submit-btn:disabled {
  background-color: #ccc;
  cursor: not-allowed;
}
</style>