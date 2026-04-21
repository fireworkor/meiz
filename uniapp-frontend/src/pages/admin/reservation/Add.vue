<template>
  <div class="reservation-add">
    <header class="header">
      <h1>添加预约</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="form-container">
      <form @submit.prevent="handleSubmit">
        <div class="form-section">
          <h3>预约信息</h3>
          <div class="form-group">
            <label>顾客 *</label>
            <select v-model="form.customerId" required @change="onCustomerChange">
              <option value="">请选择顾客</option>
              <option v-for="customer in customers" :key="customer.id" :value="customer.id">
                {{ customer.user ? customer.user.name : '' }} ({{ customer.user ? customer.user.phone : '' }})
              </option>
            </select>
          </div>
          <div class="form-group">
            <label>员工 *</label>
            <select v-model="form.employeeId" required>
              <option value="">请选择员工</option>
              <option v-for="employee in employees" :key="employee.id" :value="employee.id">
                {{ employee.user ? employee.user.name : '' }} ({{ employee.position }})
              </option>
            </select>
          </div>
          <div class="form-group">
            <label>服务项目 *</label>
            <select v-model="form.serviceId" required>
              <option value="">请选择服务</option>
              <option v-for="service in services" :key="service.id" :value="service.id">
                {{ service.name }} - ¥{{ service.price }} ({{ service.duration }}分钟)
              </option>
            </select>
          </div>
          <div class="form-group">
            <label>房间 *</label>
            <select v-model="form.roomId" required>
              <option value="">请选择房间</option>
              <option v-for="room in rooms" :key="room.id" :value="room.id">
                {{ room.name }} ({{ room.type }})
              </option>
            </select>
          </div>
          <div class="form-group">
            <label>预约时间 *</label>
            <input type="datetime-local" v-model="form.reservationDate" required>
          </div>
          <div class="form-group">
            <label>来源</label>
            <select v-model="form.source">
              <option value="前台代约">前台代约</option>
              <option value="顾客自助预约">顾客自助预约</option>
            </select>
          </div>
        </div>

        <div class="form-actions">
          <button type="button" class="cancel-btn" @click="goBack">取消</button>
          <button type="submit" class="submit-btn" :disabled="loading">
            {{ loading ? '提交中...' : '提交' }}
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
import { customerAPI, employeeAPI, reservationAPI } from '../../../api/index'

export default {
  name: 'ReservationAdd',
  data() {
    return {
      customers: [],
      employees: [],
      services: [
        { id: 1, name: '面部护理', price: 200, duration: 60 },
        { id: 2, name: '身体护理', price: 300, duration: 90 },
        { id: 3, name: '美甲', price: 100, duration: 30 }
      ],
      rooms: [
        { id: 1, name: 'VIP房1', type: 'VIP房' },
        { id: 2, name: '双人间1', type: '双人间' },
        { id: 3, name: '单人间1', type: '单人间' }
      ],
      form: {
        customerId: '',
        employeeId: '',
        serviceId: '',
        roomId: '',
        reservationDate: '',
        source: '前台代约'
      },
      loading: false
    }
  },
  mounted() {
    this.loadCustomers()
    this.loadEmployees()
  },
  methods: {
    async loadCustomers() {
      try {
        const response = await customerAPI.getAll()
        if (Array.isArray(response)) {
          this.customers = response
        }
      } catch (error) {
        console.error('加载顾客列表失败:', error)
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
    onCustomerChange() {
      // 顾客变更时的处理
    },
    goBack() {
      this.$router.push('/admin/reservation/list')
    },
    async handleSubmit() {
      if (!this.form.customerId || !this.form.employeeId || !this.form.serviceId || !this.form.roomId || !this.form.reservationDate) {
        alert('请填写所有必填字段')
        return
      }

      this.loading = true
      try {
        const customer = this.customers.find(c => c.id === this.form.customerId)
        const employee = this.employees.find(e => e.id === this.form.employeeId)
        const service = this.services.find(s => s.id === this.form.serviceId)
        const room = this.rooms.find(r => r.id === this.form.roomId)

        const reservationData = {
          customer: customer,
          employee: employee,
          service: service,
          room: room,
          reservationDate: new Date(this.form.reservationDate),
          source: this.form.source
        }

        const response = await reservationAPI.create(reservationData)
        if (response.id) {
          alert('添加成功')
          this.$router.push('/admin/reservation/list')
        }
      } catch (error) {
        alert('添加失败')
      } finally {
        this.loading = false
      }
    }
  }
}
</script>

<style scoped>
.reservation-add {
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

.form-container {
  padding: 20px;
  background-color: #fff;
  margin: 10px;
  border-radius: 8px;
}

.form-section {
  margin-bottom: 30px;
}

.form-section h3 {
  font-size: 16px;
  color: #333;
  margin-bottom: 15px;
  padding-bottom: 10px;
  border-bottom: 1px solid #eee;
}

.form-group {
  margin-bottom: 15px;
}

.form-group label {
  display: block;
  margin-bottom: 8px;
  font-size: 14px;
  color: #666;
}

.form-group input,
.form-group select {
  width: 100%;
  padding: 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
  box-sizing: border-box;
}

.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  margin-top: 20px;
}

.cancel-btn,
.submit-btn {
  padding: 12px 30px;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.cancel-btn {
  background-color: #9E9E9E;
  color: #fff;
}

.submit-btn {
  background-color: #ff6b81;
  color: #fff;
}

.submit-btn:disabled {
  background-color: #ccc;
  cursor: not-allowed;
}
</style>