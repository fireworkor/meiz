<template>
  <div class="staff-verification">
    <header class="header">
      <h1>扫码核销</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="scan-section">
      <div class="scan-title">扫描核销码进行验证</div>
      <div class="scan-input-container">
        <input 
          type="text" 
          v-model="scanCode" 
          placeholder="请输入或扫描核销码"
          @keyup.enter="handleVerify"
          class="scan-input"
        />
        <button class="verify-btn" @click="handleVerify">确认核销</button>
      </div>
      
      <div class="scan-hint">
        <p>📱 提示：您也可以使用扫码枪扫描核销码</p>
        <p>⌨️ 输入核销码后按回车键或点击"确认核销"按钮</p>
      </div>
    </div>

    <div class="recent-section">
      <h3>今日核销记录</h3>
      <div class="verification-list">
        <div class="verification-item" v-for="item in todayVerifications" :key="item.id">
          <div class="item-header">
            <span class="verification-code">{{ item.code }}</span>
            <span class="verification-type" :class="item.type">{{ getTypeName(item.type) }}</span>
          </div>
          <div class="item-body">
            <div class="customer-info">
              <span class="customer-name">{{ item.customerName }}</span>
              <span class="customer-phone">{{ item.customerPhone }}</span>
            </div>
            <div class="item-detail">{{ item.itemName }}</div>
          </div>
          <div class="item-footer">
            <span class="verify-time">{{ item.verifyTime }}</span>
            <span class="verify-status success">已核销</span>
          </div>
        </div>
      </div>
      <div class="empty-list" v-if="todayVerifications.length === 0">
        <div class="empty-icon">📋</div>
        <p>今日暂无核销记录</p>
      </div>
    </div>
  </div>
</template>

<script>
import { verificationAPI } from '../../../api/index'
import { toast, modal, navigate, loading } from '../../../utils/common'

export default {
  name: 'StaffVerification',
  data() {
    return {
      scanCode: '',
      todayVerifications: [
        {
          id: 1,
          code: 'VS8A3B2C1D',
          type: 'coupon',
          customerName: '张女士',
          customerPhone: '138****8888',
          itemName: '满100减20优惠券',
          verifyTime: '今天 10:30'
        },
        {
          id: 2,
          code: 'VS9B4C5D6E',
          type: 'points',
          customerName: '李女士',
          customerPhone: '139****9999',
          itemName: '积分兑换面膜',
          verifyTime: '今天 14:20'
        }
      ]
    }
  },
  methods: {
    getTypeName(type) {
      const names = {
        coupon: '优惠券',
        points: '积分兑换',
        product: '商品'
      };
      return names[type] || type;
    },
    handleVerify() {
      if (!this.scanCode) {
        toast.show({ title: '请输入核销码' });
        return;
      }
      
      // 模拟核销过程
      loading.show({ title: '核销中...' });
      setTimeout(() => {
        loading.hide();
        
        // 模拟核销成功
        modal.show({
          content: `核销码 ${this.scanCode} 验证成功！`,
          success: (res) => {
            // 添加到今日记录
            this.todayVerifications.unshift({
              id: Date.now(),
              code: this.scanCode,
              type: 'coupon',
              customerName: '顾客' + Math.floor(Math.random() * 100),
              customerPhone: '138****' + (1000 + Math.floor(Math.random() * 9000)),
              itemName: '优惠券/积分/商品核销',
              verifyTime: '今天 ' + new Date().toLocaleTimeString().slice(0, 5)
            });
            this.scanCode = '';
          }
        });
      }, 1000);
    },
    goBack() {
      this.$router.push('/staff/dashboard');
    }
  }
}
</script>

<style scoped>
.staff-verification {
  min-height: 100vh;
  background-color: #f5f5f5;
  padding-bottom: 20px;
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

.scan-section {
  margin: 20px;
  background-color: #fff;
  border-radius: 8px;
  padding: 30px 20px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  text-align: center;
}

.scan-title {
  font-size: 18px;
  color: #333;
  margin-bottom: 20px;
  font-weight: bold;
}

.scan-input-container {
  display: flex;
  gap: 10px;
  margin-bottom: 20px;
}

.scan-input {
  flex: 1;
  padding: 15px;
  border: 2px solid #ddd;
  border-radius: 8px;
  font-size: 16px;
  outline: none;
  transition: border-color 0.2s;
}

.scan-input:focus {
  border-color: #ff6b81;
}

.verify-btn {
  padding: 15px 30px;
  background-color: #ff6b81;
  color: #fff;
  border: none;
  border-radius: 8px;
  font-size: 16px;
  cursor: pointer;
  white-space: nowrap;
}

.scan-hint {
  background-color: #f5f5f5;
  padding: 15px;
  border-radius: 8px;
  text-align: left;
}

.scan-hint p {
  margin: 5px 0;
  font-size: 14px;
  color: #666;
}

.recent-section {
  margin: 0 20px;
}

.recent-section h3 {
  font-size: 16px;
  color: #333;
  margin-bottom: 15px;
}

.verification-list {
  background-color: #fff;
  border-radius: 8px;
  padding: 15px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.verification-item {
  padding: 15px;
  border-bottom: 1px solid #f0f0f0;
}

.verification-item:last-child {
  border-bottom: none;
}

.item-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.verification-code {
  font-family: monospace;
  font-size: 16px;
  font-weight: bold;
  color: #333;
}

.verification-type {
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: bold;
}

.verification-type.coupon {
  background-color: #E3F2FD;
  color: #1976D2;
}

.verification-type.points {
  background-color: #FFF3E0;
  color: #FF9800;
}

.verification-type.product {
  background-color: #E8F5E9;
  color: #4CAF50;
}

.item-body {
  margin-bottom: 10px;
}

.customer-info {
  display: flex;
  gap: 15px;
  margin-bottom: 5px;
}

.customer-name {
  font-size: 14px;
  color: #333;
  font-weight: bold;
}

.customer-phone {
  font-size: 14px;
  color: #666;
}

.item-detail {
  font-size: 14px;
  color: #666;
}

.item-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.verify-time {
  font-size: 12px;
  color: #999;
}

.verify-status {
  font-size: 12px;
  font-weight: bold;
  padding: 4px 8px;
  border-radius: 4px;
}

.verify-status.success {
  background-color: #E8F5E9;
  color: #4CAF50;
}

.empty-list {
  text-align: center;
  padding: 60px 20px;
  background-color: #fff;
  border-radius: 8px;
}

.empty-icon {
  font-size: 48px;
  margin-bottom: 20px;
}

.empty-list p {
  font-size: 14px;
  color: #666;
  margin: 0;
}
</style>
