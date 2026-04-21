<template>
  <div class="employee-add">
    <header class="header">
      <h1>添加员工</h1>
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
          <label>工号</label>
          <input type="text" v-model="form.employeeId" placeholder="请输入工号">
        </div>
        <div class="form-group">
          <label>岗位</label>
          <select v-model="form.position">
            <option value="">请选择岗位</option>
            <option value="美容师">美容师</option>
            <option value="前台">前台</option>
            <option value="仓管">仓管</option>
            <option value="财务">财务</option>
          </select>
        </div>
        <div class="form-group">
          <label>入职时间</label>
          <input type="date" v-model="form.entryDate">
        </div>
        <div class="form-group">
          <label>身份证号</label>
          <input type="text" v-model="form.idCard" placeholder="请输入身份证号">
        </div>
        <div class="form-group">
          <label>紧急联系人</label>
          <input type="text" v-model="form.emergencyContact" placeholder="请输入紧急联系人">
        </div>
        <div class="form-group">
          <label>紧急联系电话</label>
          <input type="tel" v-model="form.emergencyPhone" placeholder="请输入紧急联系电话">
        </div>
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
        employeeId: '',
        position: '',
        entryDate: '',
        idCard: '',
        emergencyContact: '',
        emergencyPhone: '',
        status: '在职',
        skillTags: ''
      }
    }
  },
  methods: {
    goBack() {
      uni.navigateBack();
    },
    submitForm() {
      // 表单验证
      if (!this.form.username || !this.form.password || !this.form.name || !this.form.phone || !this.form.employeeId || !this.form.position || !this.form.entryDate || !this.form.idCard || !this.form.emergencyContact || !this.form.emergencyPhone) {
        uni.showToast({ title: '请填写所有必填字段', icon: 'none' });
        return;
      }
      
      // 这里调用添加员工API
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