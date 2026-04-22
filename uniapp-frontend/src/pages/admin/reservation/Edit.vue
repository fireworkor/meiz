<template>
  <view class="reservation-edit">
    <view class="header">
      <view class="back" @click="goBack">
        <text class="icon">&lt;</text>
      </view>
      <view class="title">编辑预约</view>
      <view class="placeholder"></view>
    </view>
    
    <scroll-view class="content" scroll-y>
      <form @submit.prevent="handleSubmit">
        <!-- 客户选择 -->
        <view class="form-item">
          <text class="label">客户</text>
          <view class="select" @click="showCustomerPicker = true">
            <text v-if="selectedCustomer">{{ selectedCustomer.name }} ({{ selectedCustomer.phone }})</text>
            <text v-else class="placeholder-text">请选择客户</text>
            <text class="icon">&gt;</text>
          </view>
        </view>
        
        <!-- 员工选择 -->
        <view class="form-item">
          <text class="label">员工</text>
          <view class="select" @click="showEmployeePicker = true">
            <text v-if="selectedEmployee">{{ selectedEmployee.name }}</text>
            <text v-else class="placeholder-text">请选择员工</text>
            <text class="icon">&gt;</text>
          </view>
        </view>
        
        <!-- 服务选择 -->
        <view class="form-item">
          <text class="label">服务</text>
          <view class="select" @click="showServicePicker = true">
            <text v-if="selectedService">{{ selectedService.name }} ¥{{ selectedService.price }}</text>
            <text v-else class="placeholder-text">请选择服务</text>
            <text class="icon">&gt;</text>
          </view>
        </view>
        
        <!-- 房间选择 -->
        <view class="form-item">
          <text class="label">房间</text>
          <view class="select" @click="showRoomPicker = true">
            <text v-if="selectedRoom">{{ selectedRoom.name }}</text>
            <text v-else class="placeholder-text">请选择房间</text>
            <text class="icon">&gt;</text>
          </view>
        </view>
        
        <!-- 预约日期 -->
        <view class="form-item">
          <text class="label">预约日期</text>
          <view class="input-container">
            <picker
              mode="date"
              :value="formData.reservationDate"
              start="2024-01-01"
              end="2025-12-31"
              @change="handleDateChange"
            >
              <view class="picker">
                <text v-if="formData.reservationDate">{{ formData.reservationDate }}</text>
                <text v-else class="placeholder-text">请选择日期</text>
              </view>
            </picker>
          </view>
        </view>
        
        <!-- 状态选择 -->
        <view class="form-item">
          <text class="label">状态</text>
          <view class="select" @click="showStatusPicker = true">
            <text>{{ formData.status || '请选择状态' }}</text>
            <text class="icon">&gt;</text>
          </view>
        </view>
        
        <!-- 来源选择 -->
        <view class="form-item">
          <text class="label">来源</text>
          <view class="select" @click="showSourcePicker = true">
            <text>{{ formData.source || '请选择来源' }}</text>
            <text class="icon">&gt;</text>
          </view>
        </view>
        
        <view class="submit-button">
          <button type="primary" formType="submit">保存修改</button>
        </view>
      </form>
    </scroll-view>
    
    <!-- 客户选择器 -->
    <uni-popup v-model="showCustomerPicker" type="bottom">
      <view class="popup-content">
        <view class="popup-header">
          <text class="cancel" @click="showCustomerPicker = false">取消</text>
          <text class="title">选择客户</text>
          <text class="confirm" @click="confirmCustomer">确定</text>
        </view>
        <scroll-view class="picker-content" scroll-y>
          <view 
            v-for="customer in customers" 
            :key="customer.id"
            class="picker-item"
            :class="{ active: selectedCustomerId === customer.id }"
            @click="selectedCustomerId = customer.id"
          >
            <text>{{ customer.name }} ({{ customer.phone }})</text>
          </view>
        </scroll-view>
      </view>
    </uni-popup>
    
    <!-- 员工选择器 -->
    <uni-popup v-model="showEmployeePicker" type="bottom">
      <view class="popup-content">
        <view class="popup-header">
          <text class="cancel" @click="showEmployeePicker = false">取消</text>
          <text class="title">选择员工</text>
          <text class="confirm" @click="confirmEmployee">确定</text>
        </view>
        <scroll-view class="picker-content" scroll-y>
          <view 
            v-for="employee in employees" 
            :key="employee.id"
            class="picker-item"
            :class="{ active: selectedEmployeeId === employee.id }"
            @click="selectedEmployeeId = employee.id"
          >
            <text>{{ employee.name }}</text>
          </view>
        </scroll-view>
      </view>
    </uni-popup>
    
    <!-- 服务选择器 -->
    <uni-popup v-model="showServicePicker" type="bottom">
      <view class="popup-content">
        <view class="popup-header">
          <text class="cancel" @click="showServicePicker = false">取消</text>
          <text class="title">选择服务</text>
          <text class="confirm" @click="confirmService">确定</text>
        </view>
        <scroll-view class="picker-content" scroll-y>
          <view 
            v-for="service in services" 
            :key="service.id"
            class="picker-item"
            :class="{ active: selectedServiceId === service.id }"
            @click="selectedServiceId = service.id"
          >
            <text>{{ service.name }} ¥{{ service.price }}</text>
          </view>
        </scroll-view>
      </view>
    </uni-popup>
    
    <!-- 房间选择器 -->
    <uni-popup v-model="showRoomPicker" type="bottom">
      <view class="popup-content">
        <view class="popup-header">
          <text class="cancel" @click="showRoomPicker = false">取消</text>
          <text class="title">选择房间</text>
          <text class="confirm" @click="confirmRoom">确定</text>
        </view>
        <scroll-view class="picker-content" scroll-y>
          <view 
            v-for="room in rooms" 
            :key="room.id"
            class="picker-item"
            :class="{ active: selectedRoomId === room.id }"
            @click="selectedRoomId = room.id"
          >
            <text>{{ room.name }} ({{ room.type }})</text>
          </view>
        </scroll-view>
      </view>
    </uni-popup>
    
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
    
    <!-- 来源选择器 -->
    <uni-popup v-model="showSourcePicker" type="bottom">
      <view class="popup-content">
        <view class="popup-header">
          <text class="cancel" @click="showSourcePicker = false">取消</text>
          <text class="title">选择来源</text>
          <text class="confirm" @click="confirmSource">确定</text>
        </view>
        <scroll-view class="picker-content" scroll-y>
          <view 
            v-for="source in sourceOptions" 
            :key="source.value"
            class="picker-item"
            :class="{ active: selectedSource === source.value }"
            @click="selectedSource = source.value"
          >
            <text>{{ source.label }}</text>
          </view>
        </scroll-view>
      </view>
    </uni-popup>
  </view>
</template>

<script>
import { reservationAPI } from '@/api'

export default {
  data() {
    return {
      reservationId: '',
      formData: {
        customerId: '',
        employeeId: '',
        serviceId: '',
        roomId: '',
        reservationDate: '',
        status: '',
        source: ''
      },
      customers: [],
      employees: [],
      services: [],
      rooms: [],
      selectedCustomer: null,
      selectedEmployee: null,
      selectedService: null,
      selectedRoom: null,
      selectedCustomerId: '',
      selectedEmployeeId: '',
      selectedServiceId: '',
      selectedRoomId: '',
      selectedStatus: '',
      selectedSource: '',
      showCustomerPicker: false,
      showEmployeePicker: false,
      showServicePicker: false,
      showRoomPicker: false,
      showStatusPicker: false,
      showSourcePicker: false,
      statusOptions: [
        { label: '待确认', value: 'pending' },
        { label: '已确认', value: 'confirmed' },
        { label: '已完成', value: 'completed' },
        { label: '已取消', value: 'cancelled' }
      ],
      sourceOptions: [
        { label: '在线预约', value: 'online' },
        { label: '电话预约', value: 'phone' },
        { label: '到店预约', value: 'walk_in' }
      ]
    }
  },
  onLoad(options) {
    if (options.id) {
      this.reservationId = options.id
      this.loadReservationData()
    }
    this.loadBasicData()
  },
  methods: {
    goBack() {
      uni.navigateBack()
    },
    async loadBasicData() {
      // 加载基础数据
      await Promise.all([
        this.loadCustomers(),
        this.loadEmployees(),
        this.loadServices(),
        this.loadRooms()
      ])
    },
    async loadCustomers() {
      try {
        const res = await reservationAPI.getCustomers()
        this.customers = res.data || []
      } catch (error) {
        console.error('加载客户列表失败:', error)
      }
    },
    async loadEmployees() {
      try {
        const res = await reservationAPI.getEmployees()
        this.employees = res.data || []
      } catch (error) {
        console.error('加载员工列表失败:', error)
      }
    },
    async loadServices() {
      try {
        const res = await reservationAPI.getServices()
        this.services = res.data || []
      } catch (error) {
        console.error('加载服务列表失败:', error)
      }
    },
    async loadRooms() {
      try {
        const res = await reservationAPI.getRooms()
        this.rooms = res.data || []
      } catch (error) {
        console.error('加载房间列表失败:', error)
      }
    },
    async loadReservationData() {
      try {
        const res = await reservationAPI.getReservationById(this.reservationId)
        if (res.success) {
          const reservation = res.data
          this.formData = {
            customerId: reservation.customerId,
            employeeId: reservation.employeeId,
            serviceId: reservation.serviceId,
            roomId: reservation.roomId,
            reservationDate: reservation.reservationDate,
            status: reservation.status,
            source: reservation.source
          }
          
          // 设置选中的对象
          this.selectedCustomer = this.customers.find(c => c.id === reservation.customerId)
          this.selectedEmployee = this.employees.find(e => e.id === reservation.employeeId)
          this.selectedService = this.services.find(s => s.id === reservation.serviceId)
          this.selectedRoom = this.rooms.find(r => r.id === reservation.roomId)
          this.selectedStatus = reservation.status
          this.selectedSource = reservation.source
        }
      } catch (error) {
        console.error('加载预约详情失败:', error)
        uni.showToast({ title: '加载失败', icon: 'none' })
      }
    },
    handleDateChange(e) {
      this.formData.reservationDate = e.detail.value
    },
    confirmCustomer() {
      if (this.selectedCustomerId) {
        this.selectedCustomer = this.customers.find(c => c.id === this.selectedCustomerId)
        this.formData.customerId = this.selectedCustomerId
      }
      this.showCustomerPicker = false
    },
    confirmEmployee() {
      if (this.selectedEmployeeId) {
        this.selectedEmployee = this.employees.find(e => e.id === this.selectedEmployeeId)
        this.formData.employeeId = this.selectedEmployeeId
      }
      this.showEmployeePicker = false
    },
    confirmService() {
      if (this.selectedServiceId) {
        this.selectedService = this.services.find(s => s.id === this.selectedServiceId)
        this.formData.serviceId = this.selectedServiceId
      }
      this.showServicePicker = false
    },
    confirmRoom() {
      if (this.selectedRoomId) {
        this.selectedRoom = this.rooms.find(r => r.id === this.selectedRoomId)
        this.formData.roomId = this.selectedRoomId
      }
      this.showRoomPicker = false
    },
    confirmStatus() {
      this.formData.status = this.selectedStatus
      this.showStatusPicker = false
    },
    confirmSource() {
      this.formData.source = this.selectedSource
      this.showSourcePicker = false
    },
    async handleSubmit() {
      // 验证表单
      if (!this.formData.customerId || !this.formData.employeeId || !this.formData.serviceId || !this.formData.roomId || !this.formData.reservationDate || !this.formData.status || !this.formData.source) {
        uni.showToast({ title: '请填写所有必填项', icon: 'none' })
        return
      }
      
      try {
        const res = await reservationAPI.updateReservation(this.reservationId, this.formData)
        if (res.success) {
          uni.showToast({ title: '修改成功', icon: 'success' })
          setTimeout(() => {
            uni.navigateBack()
          }, 1000)
        } else {
          uni.showToast({ title: res.message || '修改失败', icon: 'none' })
        }
      } catch (error) {
        console.error('修改预约失败:', error)
        uni.showToast({ title: '修改失败', icon: 'none' })
      }
    }
  }
}
</script>

<style scoped>
.reservation-edit {
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

.select {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 15rpx 0;
  border-bottom: 1rpx solid #eee;
}

.placeholder-text {
  color: #999;
}

.input-container {
  padding: 15rpx 0;
}

.picker {
  padding: 10rpx 0;
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