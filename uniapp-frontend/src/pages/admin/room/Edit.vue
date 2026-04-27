<template>
  <view class="room-edit">
    <view class="header">
      <view class="back" @click="goBack">
        <text class="icon">&lt;</text>
      </view>
      <view class="title">编辑房间</view>
      <view class="placeholder"></view>
    </view>
    
    <scroll-view class="content" scroll-y>
      <form @submit.prevent="handleSubmit">
        <view class="form-item">
          <text class="label">房间名称</text>
          <input 
            v-model="formData.name" 
            placeholder="请输入房间名称"
            class="input"
          />
        </view>
        
        <view class="form-item">
          <text class="label">房间类型</text>
          <view class="select" @click="showTypePicker = true">
            <text v-if="formData.type">{{ getTypeLabel(formData.type) }}</text>
            <text v-else class="placeholder-text">请选择房间类型</text>
            <text class="icon">&gt;</text>
          </view>
        </view>
        
        <view class="form-item">
          <text class="label">容纳人数</text>
          <input 
            v-model.number="formData.capacity" 
            placeholder="请输入容纳人数"
            class="input"
            type="number"
          />
        </view>
        
        <view class="form-item">
          <text class="label">房间状态</text>
          <view class="select" @click="showStatusPicker = true">
            <text v-if="formData.status">{{ getStatusLabel(formData.status) }}</text>
            <text v-else class="placeholder-text">请选择房间状态</text>
            <text class="icon">&gt;</text>
          </view>
        </view>

        <view class="form-item">
          <text class="label">楼层</text>
          <input 
            v-model.number="formData.floor" 
            placeholder="请输入楼层"
            class="input"
            type="number"
          />
        </view>

        <view class="form-item">
          <text class="label">排序权重</text>
          <input 
            v-model.number="formData.displayOrder" 
            placeholder="数字越小排序越靠前"
            class="input"
            type="number"
          />
        </view>

        <view class="form-item">
          <text class="label">房间描述</text>
          <textarea
            v-model="formData.description" 
            placeholder="请输入房间描述（选填）"
            class="textarea"
            :rows="3"
          />
        </view>
        
        <view class="submit-button">
          <button type="primary" formType="submit" :disabled="loading">
            {{ loading ? '保存中...' : '保存修改' }}
          </button>
        </view>
      </form>
    </scroll-view>
    
    <uni-popup v-model="showTypePicker" type="bottom">
      <view class="popup-content">
        <view class="popup-header">
          <text class="cancel" @click="showTypePicker = false">取消</text>
          <text class="title">选择房间类型</text>
          <text class="confirm" @click="confirmType">确定</text>
        </view>
        <scroll-view class="picker-content" scroll-y>
          <view 
            v-for="type in typeOptions" 
            :key="type.value"
            class="picker-item"
            :class="{ active: selectedType === type.value }"
            @click="selectedType = type.value"
          >
            <text>{{ type.label }}</text>
          </view>
        </scroll-view>
      </view>
    </uni-popup>
    
    <uni-popup v-model="showStatusPicker" type="bottom">
      <view class="popup-content">
        <view class="popup-header">
          <text class="cancel" @click="showStatusPicker = false">取消</text>
          <text class="title">选择房间状态</text>
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
import { roomAPI } from '@/api'
import { toast, modal, navigate } from '@/utils/common'

export default {
  data() {
    return {
      roomId: '',
      formData: {
        name: '',
        type: '',
        capacity: '',
        status: '',
        floor: '',
        displayOrder: 0,
        description: ''
      },
      showTypePicker: false,
      showStatusPicker: false,
      selectedType: '',
      selectedStatus: '',
      loading: false,
      typeOptions: [
        { label: '美容院', value: 'BEAUTY' },
        { label: 'SPA室', value: 'SPA' },
        { label: '咨询室', value: 'CONSULTATION' },
        { label: '其他', value: 'OTHER' }
      ],
      statusOptions: [
        { label: '可用', value: 'AVAILABLE' },
        { label: '使用中', value: 'OCCUPIED' },
        { label: '维护中', value: 'MAINTENANCE' },
        { label: '不可用', value: 'UNAVAILABLE' }
      ]
    }
  },
  onLoad(options) {
    if (options.id) {
      this.roomId = options.id
      this.loadRoomData()
    }
  },
  methods: {
    goBack() {
      navigate.back()
    },
    getTypeLabel(value) {
      const type = this.typeOptions.find(t => t.value === value)
      return type ? type.label : ''
    },
    getStatusLabel(value) {
      const status = this.statusOptions.find(s => s.value === value)
      return status ? status.label : ''
    },
    async loadRoomData() {
      try {
        const res = await roomAPI.getById(this.roomId)
        if (res.success) {
          this.formData = {
            name: res.data.name,
            type: res.data.type,
            capacity: res.data.capacity,
            status: res.data.status,
            floor: res.data.floor || '',
            displayOrder: res.data.displayOrder || 0,
            description: res.data.description || ''
          }
          this.selectedType = res.data.type
          this.selectedStatus = res.data.status
        } else {
          toast.show({ title: '加载失败' })
        }
      } catch (error) {
        console.error('加载房间详情失败:', error)
        toast.show({ title: '加载失败' })
      }
    },
    confirmType() {
      this.formData.type = this.selectedType
      this.showTypePicker = false
    },
    confirmStatus() {
      this.formData.status = this.selectedStatus
      this.showStatusPicker = false
    },
    async handleSubmit() {
      if (!this.formData.name || !this.formData.type || !this.formData.capacity || !this.formData.status) {
        toast.show({ title: '请填写所有必填项' })
        return
      }
      
      this.loading = true
      try {
        const res = await roomAPI.update(this.roomId, this.formData)
        if (res && res.id) {
          toast.show({ title: '修改成功' })
          setTimeout(() => {
            navigate.back()
          }, 1000)
        } else {
          toast.show({ title: res.message || '修改失败' })
        }
      } catch (error) {
        console.error('修改房间失败:', error)
        toast.show({ title: '修改失败' })
      } finally {
        this.loading = false
      }
    }
  }
}
</script>

<style scoped>
.room-edit {
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