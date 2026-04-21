<template>
  <div class="customer-add">
    <header class="header">
      <h1>添加顾客</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>
    <div class="form-container">
      <form @submit.prevent="submitForm">
        <div class="form-group">
          <label>用户名</label>
          <input type="text" v-model="form.username" placeholder="请输入用户名">
        </div>
        <div class="form-group">
          <label>密码</label>
          <input type="password" v-model="form.password" placeholder="请输入密码">
        </div>
        <div class="form-group">
          <label>姓名</label>
          <input type="text" v-model="form.name" placeholder="请输入姓名">
        </div>
        <div class="form-group">
          <label>手机号</label>
          <input type="tel" v-model="form.phone" placeholder="请输入手机号">
        </div>
        <div class="form-group">
          <label>性别</label>
          <select v-model="form.gender">
            <option value="">请选择性别</option>
            <option value="男">男</option>
            <option value="女">女</option>
          </select>
        </div>
        <div class="form-group">
          <label>生日</label>
          <input type="date" v-model="form.birthday">
        </div>
        <div class="form-group">
          <label>微信号</label>
          <input type="text" v-model="form.wechat" placeholder="请输入微信号">
        </div>
        <div class="form-group">
          <label>职业</label>
          <input type="text" v-model="form.occupation" placeholder="请输入职业">
        </div>
        <div class="form-group">
          <label>来源渠道</label>
          <select v-model="form.sourceChannel">
            <option value="">请选择来源渠道</option>
            <option value="微信">微信</option>
            <option value="美团">美团</option>
            <option value="朋友介绍">朋友介绍</option>
            <option value="其他">其他</option>
          </select>
        </div>
        <div class="form-group">
          <label>肤质类型</label>
          <input type="text" v-model="form.skinType" placeholder="请输入肤质类型">
        </div>
        <div class="form-group">
          <label>过敏史</label>
          <input type="text" v-model="form.allergyHistory" placeholder="请输入过敏史">
        </div>
        <div class="form-group">
          <label>皮肤问题</label>
          <input type="text" v-model="form.skinProblems" placeholder="请输入皮肤问题">
        </div>
        <div class="form-group">
          <label>偏好项目</label>
          <input type="text" v-model="form.preferredItems" placeholder="请输入偏好项目">
        </div>
        <div class="form-group">
          <label>偏好美容师</label>
          <input type="text" v-model="form.preferredEmployee" placeholder="请输入偏好美容师">
        </div>
        <div class="form-group">
          <label>偏好时间段</label>
          <input type="text" v-model="form.preferredTime" placeholder="请输入偏好时间段">
        </div>
        <div class="form-group">
          <label>客单价</label>
          <input type="number" v-model="form.averageSpending" placeholder="请输入客单价">
        </div>
        <div class="form-group">
          <label>标签</label>
          <input type="text" v-model="form.tags" placeholder="请输入标签，用逗号分隔">
        </div>
        <button type="submit" class="submit-btn">提交</button>
      </form>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      form: {
        username: '',
        password: '',
        name: '',
        phone: '',
        gender: '',
        birthday: '',
        wechat: '',
        occupation: '',
        sourceChannel: '',
        skinType: '',
        allergyHistory: '',
        skinProblems: '',
        preferredItems: '',
        preferredEmployee: '',
        preferredTime: '',
        averageSpending: 0,
        tags: ''
      }
    }
  },
  methods: {
    goBack() {
      uni.navigateBack();
    },
    submitForm() {
      // 表单验证
      if (!this.form.username || !this.form.password || !this.form.name || !this.form.phone || !this.form.gender || !this.form.sourceChannel) {
        uni.showToast({ title: '请填写所有必填字段', icon: 'none' });
        return;
      }
      
      // 这里调用添加顾客API
      console.log('提交表单:', this.form);
      uni.showToast({ title: '添加成功', icon: 'success' });
      setTimeout(() => {
        uni.navigateBack();
      }, 1000);
    }
  }
}
</script>

<style scoped>
.customer-add {
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
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
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

.submit-btn {
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

.submit-btn:hover {
  background-color: #ff4757;
}
</style>