<template>
  <div class="login-container">
    <div class="login-form">
      <h2>美妆店智慧管理系统</h2>
      <div class="form-group">
        <label>用户名</label>
        <input type="text" v-model="username" placeholder="请输入用户名">
      </div>
      <div class="form-group">
        <label>密码</label>
        <input type="password" v-model="password" placeholder="请输入密码">
      </div>
      <div class="form-group">
        <label>角色</label>
        <select v-model="role">
          <option value="admin">管理员</option>
          <option value="staff">员工</option>
          <option value="customer">顾客</option>
        </select>
      </div>
      <button class="login-btn" @click="login">登录</button>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      username: '',
      password: '',
      role: 'staff'
    }
  },
  methods: {
    login() {
      // 模拟登录验证
      if (this.username && this.password) {
        // 存储用户信息
        uni.setStorageSync('userInfo', {
          username: this.username,
          role: this.role
        })
        
        // 根据角色跳转不同工作台
        switch (this.role) {
          case 'admin':
            uni.navigateTo({ url: '/pages/admin/dashboard' })
            break
          case 'staff':
            uni.navigateTo({ url: '/pages/staff/dashboard' })
            break
          case 'customer':
            uni.navigateTo({ url: '/pages/customer/dashboard' })
            break
        }
      } else {
        uni.showToast({ title: '请输入用户名和密码', icon: 'none' })
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
  height: 100vh;
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