<template>
  <div class="customer-add">
    <header class="header">
      <h1>添加顾客</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="form-container">
      <form @submit.prevent="handleSubmit">
        <div class="form-section">
          <h3>基本信息</h3>
          <div class="form-group">
            <label>姓名 *</label>
            <input type="text" v-model="form.name" placeholder="请输入姓名" required>
          </div>
          <div class="form-group">
            <label>手机号 *</label>
            <input type="tel" v-model="form.phone" placeholder="请输入手机号" required>
          </div>
        </div>

        <div class="form-section">
          <h3>详细信息</h3>
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
              <option value="小红书">小红书</option>
              <option value="美团">美团</option>
              <option value="朋友介绍">朋友介绍</option>
              <option value="其他">其他</option>
            </select>
          </div>
          <div class="form-group">
            <label>来源平台</label>
            <select v-model="form.sourcePlatform">
              <option value="">请选择来源平台</option>
              <option value="微信小程序">微信小程序</option>
              <option value="小红书小程序">小红书小程序</option>
              <option value="美团">美团</option>
              <option value="其他平台">其他平台</option>
            </select>
          </div>
        </div>

        <div class="form-section">
          <h3>肤质档案</h3>
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
        </div>

        <div class="form-section">
          <h3>消费偏好</h3>
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
        </div>

        <div class="form-section">
          <h3>标签</h3>
          <div class="form-group">
            <label>标签（用逗号分隔）</label>
            <input type="text" v-model="form.tags" placeholder="如: VIP, 新顾客, 老顾客">
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
import { customerAPI } from '../../../api/index'
import { toast, navigate } from '../../../utils/common'

export default {
  name: 'CustomerAdd',
  data() {
    return {
      form: {
        name: '',
        phone: '',
        gender: '',
        birthday: '',
        wechat: '',
        occupation: '',
        sourceChannel: '',
        sourcePlatform: '',
        skinType: '',
        allergyHistory: '',
        skinProblems: '',
        preferredItems: '',
        preferredEmployee: '',
        preferredTime: '',
        averageSpending: 0,
        tags: ''
      },
      loading: false
    }
  },
  methods: {
    goBack() {
      this.$router.push('/admin/customer/list')
    },
    async handleSubmit() {
      if (this.loading) return // 防止重复提交
      
      this.loading = true
      try {
        const response = await customerAPI.create(this.form)
        if (response && response.id) {
          toast.show({
            title: '添加成功',
            icon: 'success',
            duration: 2000
          })
          // 延迟跳转，让用户看到成功提示
          setTimeout(() => {
            this.$router.push('/admin/customer/list')
          }, 1500)
        } else {
          toast.show({
            title: '添加失败',
            icon: 'none',
            duration: 2000
          })
        }
      } catch (error) {
        console.error('添加顾客失败:', error)
        toast.show({
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