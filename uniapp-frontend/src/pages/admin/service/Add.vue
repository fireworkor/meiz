<template>
  <view class="service-add">
    <view class="header">
      <view class="back" @click="goBack">
        <text class="icon">&lt;</text>
      </view>
      <view class="title">添加服务</view>
      <view class="placeholder"></view>
    </view>
    
    <scroll-view class="content" scroll-y>
      <form @submit.prevent="handleSubmit">
        <!-- 服务名称 -->
        <view class="form-item">
          <text class="label">服务名称</text>
          <input 
            v-model="formData.name" 
            placeholder="请输入服务名称"
            class="input"
          />
        </view>
        
        <!-- 服务分类 -->
        <view class="form-item">
          <text class="label">服务分类</text>
          <input 
            v-model="formData.category" 
            placeholder="请输入服务分类"
            class="input"
          />
        </view>
        
        <!-- 服务价格 -->
        <view class="form-item">
          <text class="label">服务价格</text>
          <input 
            v-model.number="formData.price" 
            placeholder="请输入服务价格"
            class="input"
            type="number"
          />
        </view>
        
        <!-- 服务时长 -->
        <view class="form-item">
          <text class="label">服务时长（分钟）</text>
          <input 
            v-model.number="formData.duration" 
            placeholder="请输入服务时长"
            class="input"
            type="number"
          />
        </view>
        
        <!-- 服务描述 -->
        <view class="form-item">
          <text class="label">服务描述</text>
          <textarea 
            v-model="formData.description" 
            placeholder="请输入服务描述"
            class="textarea"
            rows="4"
          ></textarea>
        </view>
        
        <!-- 佣金比例 -->
        <view class="form-item">
          <text class="label">佣金比例（%）</text>
          <input 
            v-model.number="formData.commissionRate" 
            placeholder="请输入佣金比例"
            class="input"
            type="number"
          />
        </view>
        
        <!-- 服务状态 -->
        <view class="form-item">
          <text class="label">服务状态</text>
          <view class="select" @click="showStatusPicker = true">
            <text v-if="formData.status">{{ getStatusLabel(formData.status) }}</text>
            <text v-else class="placeholder-text">请选择服务状态</text>
            <text class="icon">&gt;</text>
          </view>
        </view>
        
        <view class="submit-button">
          <button type="primary" formType="submit" :disabled="loading">
            {{ loading ? '添加中...' : '添加服务' }}
          </button>
        </view>
      </form>
    </scroll-view>
    
    <!-- 状态选择器 -->
    <uni-popup v-model="showStatusPicker" type="bottom">
      <view class="popup-content">
        <view class="popup-header">
          <text class="cancel" @click="showStatusPicker = false">取消</text>
          <text class="title">选择服务状态</text>
          <text class="confirm" @click="confirmStatus">确定</text>
        </view>
        <scroll-view class="picker-content" scroll-y>
          <view 
            v-for="status in statusOptions" 
            :key="status.value"
            class="picker-item"
            :class="{ active: selectedStatus === status.value }"
            @click="selectedStatus = status.value"
          >
            <text>{{ status.label }}</text>
          </view>
        </scroll-view>
      </view>
    </uni-popup>
  </view>
</template>

<script>
import { serviceAPI } from '@/api'

export default {
  data() {
    return {
      formData: {
        name: '',
        category: '',
        price: '',
        duration: '',
        description: '',
        commissionRate: '',
        status: ''
      },
      showStatusPicker: false,
      selectedStatus: '',
      loading: false,
      statusOptions: [
        { label: '启用', value: 'active' },
        { label: '禁用', value: 'inactive' }
      ]
    }
  },
  methods: {
    goBack() {
      uni.navigateBack()
    },
    getStatusLabel(value) {
      const status = this.statusOptions.find(s => s.value === value)
      return status ? status.label : ''
    },
    confirmStatus() {
      this.formData.status = this.selectedStatus
      this.showStatusPicker = false
    },
    async handleSubmit() {
      if (this.loading) return // 防止重复提交
      
      // 验证表单
      if (!this.formData.name || !this.formData.category || !this.formData.price || !this.formData.duration || !this.formData.status) {
        uni.showToast({ title: '请填写所有必填项', icon: 'none' })
        return
      }
      
      this.loading = true
      try {
        const res = await serviceAPI.create(this.formData)
        if (res && res.id) {
          uni.showToast({
            title: '添加成功',
            icon: 'success',
            duration: 2000
          })
          // 延迟跳转，让用户看到成功提示
          setTimeout(() => {
            uni.navigateBack()
          }, 1500)
        } else {
          uni.showToast({
            title: '添加失败',
            icon: 'none',
            duration: 2000
          })
        }
      } catch (error) {
        console.error('添加服务失败:', error)
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
.service-add {
  min-height: 100vh;
  background-color: #f5f5f5;
}

.header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 20rpx;
  background-color: #fff;
  border-bottom: 1rpx solid #eee;
}

.back {
  width: 60rpx;
  height: 60rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.icon {
  font-size: 32rpx;
  color: #333;
}

.title {
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
}

.placeholder {
  width: 60rpx;
}

.content {
  padding: 20rpx;
}

.form-item {
  background-color: #fff;
  padding: 20rpx;
  margin-bottom: 20rpx;
  border-radius: 10rpx;
  box-shadow: 0 2rpx 4rpx rgba(0, 0, 0, 0.1);
}

.label {
  display: block;
  font-size: 28rpx;
  color: #666;
  margin-bottom: 10rpx;
}

.input {
  width: 100%;
  padding: 15rpx;
  border: 1rpx solid #ddd;
  border-radius: 5rpx;
  font-size: 28rpx;
}

.textarea {
  width: 100%;
  padding: 15rpx;
  border: 1rpx solid #ddd;
  border-radius: 5rpx;
  font-size: 28rpx;
  min-height: 120rpx;
}

.select {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 15rpx;
  border: 1rpx solid #ddd;
  border-radius: 5rpx;
}

.placeholder-text {
  color: #999;
}

.submit-button {
  margin-top: 40rpx;
  margin-bottom: 40rpx;
}

.submit-button button {
  width: 100%;
  height: 80rpx;
  font-size: 32rpx;
  border-radius: 10rpx;
}

.popup-content {
  background-color: #fff;
  border-radius: 20rpx 20rpx 0 0;
  max-height: 80vh;
}

.popup-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 20rpx;
  border-bottom: 1rpx solid #eee;
}

.popup-header .cancel,
.popup-header .confirm {
  font-size: 28rpx;
  color: #999;
}

.popup-header .confirm {
  color: #007aff;
}

.popup-header .title {
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
}

.picker-content {
  max-height: 60vh;
  padding: 20rpx;
}

.picker-item {
  padding: 20rpx;
  border-bottom: 1rpx solid #f0f0f0;
  font-size: 28rpx;
}

.picker-item.active {
  color: #007aff;
  font-weight: bold;
}
</style>