<template>
  <div class="schedule-add">
    <header class="header">
      <h1>添加排班</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="form-container">
      <div class="form-group">
        <label>员工</label>
        <select v-model="form.employeeId">
          <option value="">请选择员工</option>
          <option v-for="employee in employees" :key="employee.id" :value="employee.id">
            {{ employee.user ? employee.user.name : '' }}
          </option>
        </select>
      </div>

      <div class="form-group">
        <label>日期</label>
        <input type="date" v-model="form.scheduleDate">
      </div>

      <div class="form-group">
        <label>班次</label>
        <select v-model="form.shiftType">
          <option value="">请选择班次</option>
          <option value="早班">早班</option>
          <option value="中班">中班</option>
          <option value="晚班">晚班</option>
          <option value="休息">休息</option>
        </select>
      </div>

      <div class="form-group">
        <label>开始时间</label>
        <input type="time" v-model="form.startTime">
      </div>

      <div class="form-group">
        <label>结束时间</label>
        <input type="time" v-model="form.endTime">
      </div>

      <div class="form-group">
        <label>备注</label>
        <textarea v-model="form.notes" placeholder="请输入备注"></textarea>
      </div>

      <button class="submit-btn" @click="handleSubmit" :disabled="loading">
        {{ loading ? '提交中...' : '提交' }}
      </button>
    </div>
  </div>
</template>

<script>
import { scheduleAPI, employeeAPI } from '../../../api/index'

export default {
  name: 'ScheduleAdd',
  data() {
    return {
      form: {
        employeeId: '',
        scheduleDate: '',
        shiftType: '',
        startTime: '',
        endTime: '',
        status: '正常',
        notes: ''
      },
      employees: [],
      loading: false
    }
  },
  mounted() {
    this.loadEmployees()
    if (this.$route.query.employeeId) {
      this.form.employeeId = this.$route.query.employeeId
    }
    if (this.$route.query.date) {
      this.form.scheduleDate = this.$route.query.date
    }
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
    async handleSubmit() {
      if (!this.form.employeeId || !this.form.scheduleDate || !this.form.shiftType) {
        alert('请填写必填项')
        return
      }

      this.loading = true
      try {
        const requestData = {
          employeeId: parseInt(this.form.employeeId),
          scheduleDate: this.form.scheduleDate,
          shiftType: this.form.shiftType,
          startTime: this.form.startTime,
          endTime: this.form.endTime,
          status: this.form.status,
          notes: this.form.notes
        }
        const response = await scheduleAPI.create(requestData)
        if (response.id) {
          alert('添加成功')
          this.$router.push('/admin/schedule/list')
        }
      } catch (error) {
        alert('添加失败')
      } finally {
        this.loading = false
      }
    },
    goBack() {
      this.$router.push('/admin/schedule/list')
    }
  }
}
</script>

<style scoped>
.schedule-add {
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
  background-color: #fff;
  padding: 20px;
  margin: 20px;
  border-radius: 8px;
}

.form-group {
  margin-bottom: 20px;
}

.form-group label {
  display: block;
  margin-bottom: 8px;
  font-size: 14px;
  color: #666;
}

.form-group input,
.form-group select,
.form-group textarea {
  width: 100%;
  padding: 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
  box-sizing: border-box;
}

.form-group textarea {
  min-height: 80px;
  resize: vertical;
}

.submit-btn {
  width: 100%;
  padding: 14px;
  background-color: #ff6b81;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 16px;
  cursor: pointer;
}

.submit-btn:disabled {
  background-color: #ccc;
  cursor: not-allowed;
}
</style>