<template>
  <div class="login-container">
    <div class="login-form">
      <h2>美妆店智慧管理系统</h2>
      <div class="form-group">
        <label>用户名</label>
        <input type="text" v-model="loginForm.username" placeholder="请输入用户名">
      </div>
      <div class="form-group">
        <label>密码</label>
        <input type="password" v-model="loginForm.password" placeholder="请输入密码">
      </div>
      <div class="form-group">
        <label>角色</label>
        <select v-model="loginForm.role">
          <option value="admin">管理员</option>
          <option value="staff">员工</option>
          <option value="customer">顾客</option>
        </select>
      </div>
      <button class="login-btn" @click="handleLogin" :disabled="loading">
        {{ loading ? '登录中...' : '登录' }}
      </button>
    </div>
  </div>
</template>

<script>
import { userAPI } from '../../api/index.js'

export default {
  name: 'Login',
  data() {
    return {
      loginForm: {
        username: '',
        password: '',
        role: 'staff'
      },
      loading: false
    }
  },
  methods: {
    async handleLogin() {
      if (!this.loginForm.username || !this.loginForm.password) {
        alert('请输入用户名和密码')
        return
      }

      this.loading = true
      try {
        // 实际调用后端API
        const response = await userAPI.login(this.loginForm)
        
        if (response.success) {
          localStorage.setItem('userInfo', JSON.stringify({
            username: response.username,
            role: response.role,
            token: response.token
          }))

          switch (response.role) {
            case 'admin':
              this.$router.push('/admin/dashboard')
              break
            case 'staff':
              this.$router.push('/staff/dashboard')
              break
            case 'customer':
              this.$router.push('/customer/dashboard')
              break
          }
        } else {
          alert(response.message || '登录失败')
        }
      } catch (error) {
        alert('登录失败，请检查网络连接')
        console.error('登录错误:', error)
      } finally {
        this.loading = false
      }
    }
  }
}
</script>

<style scoped>
.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background-color: #f5f5f5;
}

.login-form {
  width: 90%;
  max-width: 400px;
  padding: 30px;
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.login-form h2 {
  text-align: center;
  margin-bottom: 30px;
  color: #333;
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
.form-group select {
  width: 100%;
  padding: 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 16px;
  box-sizing: border-box;
}

.login-btn {
  width: 100%;
  padding: 14px;
  background-color: #ff6b81;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 16px;
  font-weight: bold;
  cursor: pointer;
  margin-top: 20px;
}

.login-btn:hover {
  background-color: #ff4757;
}
</style>