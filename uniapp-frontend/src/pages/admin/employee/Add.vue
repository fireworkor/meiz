<template>
  <div class="employee-add">
    <header class="header">
      <h1>添加员工</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="form-container">
      <form @submit.prevent="handleSubmit">
        <div class="form-section">
          <h3>基本信息</h3>
          <div class="form-group">
            <label>用户名 *</label>
            <input type="text" v-model="form.user.username" placeholder="请输入用户名" required>
          </div>
          <div class="form-group">
            <label>密码 *</label>
            <input type="password" v-model="form.user.password" placeholder="请输入密码" required>
          </div>
          <div class="form-group">
            <label>姓名 *</label>
            <input type="text" v-model="form.user.name" placeholder="请输入姓名" required>
          </div>
          <div class="form-group">
            <label>手机号 *</label>
            <input type="tel" v-model="form.user.phone" placeholder="请输入手机号" required>
          </div>
        </div>

        <div class="form-section">
          <h3>员工信息</h3>
          <div class="form-group">
            <label>工号 *</label>
            <input type="text" v-model="form.employeeId" placeholder="请输入工号" required>
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
            <input type="text" v-model="form.idCard" placeholder="请输入身份证号" required>
          </div>
        </div>

        <div class="form-section">
          <h3>紧急联系人</h3>
          <div class="form-group">
            <label>联系人姓名 *</label>
            <input type="text" v-model="form.emergencyContact" placeholder="请输入紧急联系人姓名" required>
          </div>
          <div class="form-group">
            <label>联系人电话 *</label>
            <input type="tel" v-model="form.emergencyPhone" placeholder="请输入紧急联系人电话" required>
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
          <button type="submit" class="submit-btn" :disabled="loading">
            {{ loading ? '提交中...' : '提交' }}
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
import { employeeAPI } from '../../../api/index'

export default {
  name: 'EmployeeAdd',
  data() {
    return {
      form: {
        user: {
          username: '',
          password: '',
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
      loading: false
    }
  },
  methods: {
    goBack() {
      this.$router.push('/admin/employee/list')
    },
    async handleSubmit() {
      if (this.loading) return // 防止重复提交
      
      this.loading = true
      try {
        const response = await employeeAPI.create(this.form)
        if (response && response.id) {
          uni.showToast({
            title: '添加成功',
            icon: 'success',
            duration: 2000
          })
          // 延迟跳转，让用户看到成功提示
          setTimeout(() => {
            this.$router.push('/admin/employee/list')
          }, 1500)
        } else {
          uni.showToast({
            title: '添加失败',
            icon: 'none',
            duration: 2000
          })
        }
      } catch (error) {
        console.error('添加员工失败:', error)
        uni.showToast({
          title: '添加失败，请重试',
          icon: 'none',
          duration: 2000
        })
      } finally {
        this.loading = false
      }
    }
  }
}
</script>

<style scoped>
.employee-add {
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