<template>
  <div class="schedule-edit">
    <header class="header">
      <h1>编辑排班</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="form-container">
      <div class="form-group">
        <label>员工</label>
        <select v-model="form.employeeId" disabled>
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

      <div class="button-group">
        <button class="delete-btn" @click="handleDelete">删除</button>
        <button class="submit-btn" @click="handleSubmit" :disabled="loading">
          {{ loading ? '提交中...' : '保存' }}
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import { scheduleAPI, employeeAPI } from '../../../api/index'

export default {
  name: 'ScheduleEdit',
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
      loading: false,
      scheduleId: null
    }
  },
  mounted() {
    this.loadEmployees()
    if (this.$route.query.id) {
      this.scheduleId = this.$route.query.id
      this.loadSchedule(this.scheduleId)
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
    async loadSchedule(id) {
      try {
        const response = await scheduleAPI.getById(id)
        if (response) {
          this.form.employeeId = response.employee ? response.employee.id : ''
          this.form.scheduleDate = response.scheduleDate ? response.scheduleDate.split('T')[0] : ''
          this.form.shiftType = response.shiftType
          this.form.startTime = response.startTime
          this.form.endTime = response.endTime
          this.form.notes = response.notes
        }
      } catch (error) {
        console.error('加载排班信息失败:', error)
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
        const response = await scheduleAPI.update(this.scheduleId, requestData)
        if (response.id) {
          alert('保存成功')
          this.$router.push('/admin/schedule/list')
        }
      } catch (error) {
        alert('保存失败')
      } finally {
        this.loading = false
      }
    },
    async handleDelete() {
      if (!confirm('确定要删除这个排班吗？')) {
        return
      }

      try {
        await scheduleAPI.delete(this.scheduleId)
        alert('删除成功')
        this.$router.push('/admin/schedule/list')
      } catch (error) {
        alert('删除失败')
      }
    },
    goBack() {
      this.$router.push('/admin/schedule/list')
    }
  }
}
</script>

<style scoped>
.schedule-edit {
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

.form-group input:disabled,
.form-group select:disabled {
  background-color: #f5f5f5;
}

.form-group textarea {
  min-height: 80px;
  resize: vertical;
}

.button-group {
  display: flex;
  gap: 10px;
}

.delete-btn {
  flex: 1;
  padding: 14px;
  background-color: #f44336;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 16px;
  cursor: pointer;
}

.submit-btn {
  flex: 1;
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