<template>
  <div class="employee-edit">
    <header class="header">
      <h1>编辑员工</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="form-container" v-if="!loading">
      <form @submit.prevent="handleSubmit">
        <div class="form-section">
          <h3>基本信息</h3>
          <div class="form-group">
            <label>用户名</label>
            <input type="text" v-model="form.user.username" disabled>
          </div>
          <div class="form-group">
            <label>姓名 *</label>
            <input type="text" v-model="form.user.name" required>
          </div>
          <div class="form-group">
            <label>手机号 *</label>
            <input type="tel" v-model="form.user.phone" required>
          </div>
        </div>

        <div class="form-section">
          <h3>员工信息</h3>
          <div class="form-group">
            <label>工号</label>
            <input type="text" v-model="form.employeeId" disabled>
          </div>
          <div class="form-group">
            <label>岗位 *</label>
            <select v-model="form.position" required>
              <option value="">请选择岗位</option>
              <option value="美容师">美容师</option>
              <option value="前台">前台</option>
              <option value="仓管">仓管</option>
              <option value="财务">财务</option>
            </select>
          </div>
          <div class="form-group">
            <label>入职时间 *</label>
            <input type="date" v-model="form.entryDate" required>
          </div>
          <div class="form-group">
            <label>身份证号 *</label>
            <input type="text" v-model="form.idCard" required>
          </div>
        </div>

        <div class="form-section">
          <h3>紧急联系人</h3>
          <div class="form-group">
            <label>联系人姓名 *</label>
            <input type="text" v-model="form.emergencyContact" required>
          </div>
          <div class="form-group">
            <label>联系人电话 *</label>
            <input type="tel" v-model="form.emergencyPhone" required>
          </div>
        </div>

        <div class="form-section">
          <h3>其他信息</h3>
          <div class="form-group">
            <label>状态</label>
            <select v-model="form.status">
              <option value="在职">在职</option>
              <option value="离职">离职</option>
              <option value="休假">休假</option>
            </select>
          </div>
          <div class="form-group">
            <label>技能标签</label>
            <input type="text" v-model="form.skillTags" placeholder="请输入技能标签，用逗号分隔">
          </div>
        </div>

        <div class="form-actions">
          <button type="button" class="cancel-btn" @click="goBack">取消</button>
          <button type="submit" class="submit-btn" :disabled="submitting">
            {{ submitting ? '提交中...' : '提交' }}
          </button>
        </div>
      </form>
    </div>

    <div v-else class="loading">加载中...</div>
  </div>
</template>

<script>
import { employeeAPI } from '../../../api/index'

export default {
  name: 'EmployeeEdit',
  data() {
    return {
      form: {
        user: {
          username: '',
          name: '',
          phone: ''
        },
        employeeId: '',
        position: '',
        entryDate: '',
        idCard: '',
        emergencyContact: '',
        emergencyPhone: '',
        status: '在职',
        skillTags: ''
      },
      loading: true,
      submitting: false
    }
  },
  mounted() {
    this.loadEmployee()
  },
  methods: {
    async loadEmployee() {
      const id = this.$route.query.id
      if (!id) {
        this.goBack()
        return
      }

      try {
        const response = await employeeAPI.getById(id)
        if (response) {
          this.form = response
        }
      } catch (error) {
        console.error('加载员工信息失败:', error)
      } finally {
        this.loading = false
      }
    },
    goBack() {
      this.$router.push('/admin/employee/list')
    },
    async handleSubmit() {
      this.submitting = true
      try {
        const id = this.$route.query.id
        const response = await employeeAPI.update(id, this.form)
        if (response.id) {
          alert('更新成功')
          this.$router.push('/admin/employee/list')
        }
      } catch (error) {
        alert('更新失败')
      } finally {
        this.submitting = false
      }
    }
  }
}
</script>

<style scoped>
.employee-edit {
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

.form-group input:disabled {
  background-color: #f5f5f5;
  color: #999;
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

.loading {
  text-align: center;
  padding: 40px;
  color: #666;
}
</style>