<template>
  <view class="grouppurchase-edit">
    <view class="header">
      <view class="back" @click="goBack">
        <text class="icon">&lt;</text>
      </view>
      <view class="title">编辑团购活动</view>
      <view class="placeholder"></view>
    </view>
    
    <scroll-view class="content" scroll-y>
      <form @submit.prevent="handleSubmit">
        <!-- 活动标题 -->
        <view class="form-item">
          <text class="label">活动标题</text>
          <input 
            v-model="formData.title" 
            placeholder="请输入活动标题"
            class="input"
          />
        </view>
        
        <!-- 副标题 -->
        <view class="form-item">
          <text class="label">副标题</text>
          <input 
            v-model="formData.subtitle" 
            placeholder="请输入副标题"
            class="input"
          />
        </view>
        
        <!-- 描述 -->
        <view class="form-item">
          <text class="label">活动描述</text>
          <textarea 
            v-model="formData.description" 
            placeholder="请输入活动描述"
            class="textarea"
            rows="4"
          ></textarea>
        </view>
        
        <!-- 原价 -->
        <view class="form-item">
          <text class="label">原价</text>
          <input 
            v-model.number="formData.originalPrice" 
            placeholder="请输入原价"
            class="input"
            type="number"
          />
        </view>
        
        <!-- 团购价 -->
        <view class="form-item">
          <text class="label">团购价</text>
          <input 
            v-model.number="formData.groupPrice" 
            placeholder="请输入团购价"
            class="input"
            type="number"
          />
        </view>
        
        <!-- 最少人数 -->
        <view class="form-item">
          <text class="label">最少人数</text>
          <input 
            v-model.number="formData.minMembers" 
            placeholder="请输入最少人数"
            class="input"
            type="number"
          />
        </view>
        
        <!-- 最多人数 -->
        <view class="form-item">
          <text class="label">最多人数</text>
          <input 
            v-model.number="formData.maxMembers" 
            placeholder="请输入最多人数"
            class="input"
            type="number"
          />
        </view>
        
        <!-- 库存 -->
        <view class="form-item">
          <text class="label">库存</text>
          <input 
            v-model.number="formData.stock" 
            placeholder="请输入库存"
            class="input"
            type="number"
          />
        </view>
        
        <!-- 分类 -->
        <view class="form-item">
          <text class="label">分类</text>
          <input 
            v-model="formData.category" 
            placeholder="请输入分类"
            class="input"
          />
        </view>
        
        <!-- 有效期天数 -->
        <view class="form-item">
          <text class="label">有效期天数</text>
          <input 
            v-model.number="formData.validityDays" 
            placeholder="请输入有效期天数"
            class="input"
            type="number"
          />
        </view>
        
        <!-- 状态 -->
        <view class="form-item">
          <text class="label">状态</text>
          <view class="select" @click="showStatusPicker = true">
            <text v-if="formData.status">{{ getStatusLabel(formData.status) }}</text>
            <text v-else class="placeholder-text">请选择状态</text>
            <text class="icon">&gt;</text>
          </view>
        </view>
        
        <view class="submit-button">
          <button type="primary" formType="submit">保存修改</button>
        </view>
      </form>
    </scroll-view>
    
    <!-- 状态选择器 -->
    <uni-popup v-model="showStatusPicker" type="bottom">
      <view class="popup-content">
        <view class="popup-header">
          <text class="cancel" @click="showStatusPicker = false">取消</text>
          <text class="title">选择状态</text>
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
import { groupPurchaseAPI } from '@/api'

export default {
  data() {
    return {
      groupPurchaseId: '',
      formData: {
        title: '',
        subtitle: '',
        description: '',
        originalPrice: '',
        groupPrice: '',
        minMembers: '',
        maxMembers: '',
        stock: '',
        category: '',
        validityDays: '',
        status: ''
      },
      showStatusPicker: false,
      selectedStatus: '',
      statusOptions: [
        { label: '待审核', value: 'pending' },
        { label: '进行中', value: 'active' },
        { label: '已结束', value: 'ended' },
        { label: '已取消', value: 'cancelled' }
      ]
    }
  },
  onLoad(options) {
    if (options.id) {
      this.groupPurchaseId = options.id
      this.loadGroupPurchaseData()
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
    async loadGroupPurchaseData() {
      try {
        const res = await groupPurchaseAPI.getById(this.groupPurchaseId)
        if (res) {
          this.formData = {
            title: res.title,
            subtitle: res.subtitle,
            description: res.description,
            originalPrice: res.originalPrice,
            groupPrice: res.groupPrice,
            minMembers: res.minMembers,
            maxMembers: res.maxMembers,
            stock: res.stock,
            category: res.category,
            validityDays: res.validityDays,
            status: res.status
          }
          this.selectedStatus = res.status
        }
      } catch (error) {
        console.error('加载团购活动详情失败:', error)
        uni.showToast({ title: '加载失败', icon: 'none' })
      }
    },
    confirmStatus() {
      this.formData.status = this.selectedStatus
      this.showStatusPicker = false
    },
    async handleSubmit() {
      // 验证表单
      if (!this.formData.title || !this.formData.originalPrice || !this.formData.groupPrice || !this.formData.minMembers || !this.formData.maxMembers || !this.formData.stock || !this.formData.status) {
        uni.showToast({ title: '请填写所有必填项', icon: 'none' })
        return
      }
      
      try {
        const res = await groupPurchaseAPI.update(this.groupPurchaseId, this.formData)
        if (res && res.id) {
          uni.showToast({
            title: '修改成功',
            icon: 'success',
            duration: 2000
          })
          setTimeout(() => {
            uni.navigateBack()
          }, 1500)
        } else {
          uni.showToast({
            title: '修改失败',
            icon: 'none',
            duration: 2000
          })
        }
      } catch (error) {
        console.error('修改团购活动失败:', error)
        uni.showToast({
          title: '修改失败，请重试',
          icon: 'none',
          duration: 2000
        })
      }
    }
  }
}
</script>

<style scoped>
.grouppurchase-edit {
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