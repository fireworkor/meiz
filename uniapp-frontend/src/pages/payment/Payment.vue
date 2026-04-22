<template>
  <div class="payment-page">
    <header class="header">
      <button class="back-btn" @click="goBack">← 返回</button>
      <h1>确认支付</h1>
    </header>
    
    <div class="order-section">
      <div class="section-title">订单详情</div>
      <div class="order-info">
        <div class="order-no">订单号：{{ orderNo }}</div>
        <div class="order-items">
          <div class="order-item" v-for="item in orderItems" :key="item.id">
            <span class="item-name">{{ item.name }}</span>
            <span class="item-quantity">x{{ item.quantity }}</span>
            <span class="item-price">¥{{ item.price }}</span>
          </div>
        </div>
      </div>
    </div>
    
    <div class="amount-section">
      <div class="amount-row">
        <span class="label">订单金额</span>
        <span class="value">¥{{ totalAmount }}</span>
      </div>
      <div class="amount-row discount" v-if="discount">
        <span class="label">优惠</span>
        <span class="value">-¥{{ discount }}</span>
      </div>
      <div class="amount-row total">
        <span class="label">实付金额</span>
        <span class="value">¥{{ payAmount }}</span>
      </div>
    </div>
    
    <div class="payment-section">
      <div class="section-title">选择支付方式</div>
      <div class="payment-methods">
        <div 
          class="method-item" 
          :class="{ active: selectedMethod === 'WXPAY' }"
          @click="selectMethod('WXPAY')"
        >
          <div class="method-icon wxpay-icon">
            <span class="icon-text">微</span>
          </div>
          <div class="method-info">
            <div class="method-name">微信支付</div>
            <div class="method-desc">推荐使用</div>
          </div>
          <div class="method-check" v-if="selectedMethod === 'WXPAY'">
            ✓
          </div>
        </div>
        
        <div 
          class="method-item" 
          :class="{ active: selectedMethod === 'ALIPAY' }"
          @click="selectMethod('ALIPAY')"
        >
          <div class="method-icon alipay-icon">
            <span class="icon-text">支</span>
          </div>
          <div class="method-info">
            <div class="method-name">支付宝</div>
            <div class="method-desc">快捷支付</div>
          </div>
          <div class="method-check" v-if="selectedMethod === 'ALIPAY'">
            ✓
          </div>
        </div>
        
        <div 
          class="method-item" 
          :class="{ active: selectedMethod === 'MEMBERCARD' }"
          @click="selectMethod('MEMBERCARD')"
        >
          <div class="method-icon membercard-icon">
            <span class="icon-text">卡</span>
          </div>
          <div class="method-info">
            <div class="method-name">会员卡支付</div>
            <div class="method-desc">余额支付</div>
          </div>
          <div class="method-check" v-if="selectedMethod === 'MEMBERCARD'">
            ✓
          </div>
        </div>
      </div>
    </div>
    
    <div class="bottom-bar">
      <div class="bottom-left">
        <span class="bottom-label">实付金额</span>
        <span class="bottom-amount">¥{{ payAmount }}</span>
      </div>
      <button 
        class="pay-btn" 
        :class="{ loading: isLoading }"
        @click="confirmPayment"
        :disabled="isLoading"
      >
        {{ isLoading ? '支付中...' : '立即支付' }}
      </button>
    </div>
    
    <div class="modal" v-if="showSuccessModal" @click.self="showSuccessModal = false">
      <div class="modal-content success-modal">
        <div class="success-icon">✓</div>
        <h3>支付成功</h3>
        <p>订单已完成支付</p>
        <div class="modal-buttons">
          <button class="confirm-btn" @click="goToOrderDetail">查看订单</button>
        </div>
      </div>
    </div>
    
    <div class="modal" v-if="showPayUrlModal" @click.self="showPayUrlModal = false">
      <div class="modal-content">
        <h3>请完成支付</h3>
        <p class="pay-hint">请点击下方链接在新窗口完成支付，支付完成后点击"已完成支付"</p>
        <a :href="payUrl" target="_blank" class="pay-link">
          点击前往支付 →
        </a>
        <div class="modal-buttons">
          <button class="cancel-btn" @click="showPayUrlModal = false">取消</button>
          <button class="confirm-btn" @click="simulateSuccess">模拟支付成功</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { paymentAPI } from '@/api/index'

export default {
  name: 'PaymentPage',
  data() {
    return {
      orderId: 1,
      orderNo: 'ORD20240422001',
      totalAmount: 298,
      discount: 0,
      payAmount: 298,
      selectedMethod: 'WXPAY',
      isLoading: false,
      showSuccessModal: false,
      showPayUrlModal: false,
      payUrl: '',
      currentPaymentNo: '',
      orderItems: [
        { id: 1, name: '面部护理套餐', quantity: 1, price: 298 }
      ],
      pollTimer: null
    }
  },
  created() {
    if (this.$route.query.orderId) {
      this.orderId = parseInt(this.$route.query.orderId)
    }
    if (this.$route.query.amount) {
      this.payAmount = parseFloat(this.$route.query.amount)
      this.totalAmount = this.payAmount
    }
  },
  methods: {
    selectMethod(method) {
      this.selectedMethod = method
    },
    
    async confirmPayment() {
      this.isLoading = true
      uni.showLoading({ title: '创建支付...' })
      
      try {
        const res = await paymentAPI.create({
          orderId: this.orderId,
          paymentType: this.selectedMethod
        })
        
        uni.hideLoading()
        
        if (res.code === '200' || res.success) {
          this.currentPaymentNo = res.paymentNo
          
          if (this.selectedMethod === 'MEMBERCARD') {
            this.paymentSuccess()
          } else {
            this.payUrl = res.paymentUrl || res.mwebUrl || res.alipayUrl
            this.showPayUrlModal = true
            this.startPolling()
          }
        } else {
          uni.showToast({ title: res.message || '支付创建失败', icon: 'none' })
        }
      } catch (err) {
        uni.hideLoading()
        uni.showToast({ title: '支付创建失败', icon: 'none' })
      } finally {
        this.isLoading = false
      }
    },
    
    async simulateSuccess() {
      this.showPayUrlModal = false
      this.stopPolling()
      
      try {
        await paymentAPI.sandboxSuccess(this.currentPaymentNo)
        this.paymentSuccess()
      } catch (err) {
        uni.showToast({ title: '模拟支付失败', icon: 'none' })
      }
    },
    
    paymentSuccess() {
      this.showSuccessModal = true
      uni.vibrateShort()
    },
    
    startPolling() {
      let count = 0
      this.pollTimer = setInterval(async () => {
        count++
        try {
          const res = await paymentAPI.queryStatus(this.currentPaymentNo)
          if (res.status === 'SUCCESS') {
            this.stopPolling()
            this.paymentSuccess()
          }
        } catch (err) {
          console.error('轮询失败', err)
        }
        
        if (count > 60) {
          this.stopPolling()
        }
      }, 2000)
    },
    
    stopPolling() {
      if (this.pollTimer) {
        clearInterval(this.pollTimer)
        this.pollTimer = null
      }
    },
    
    goToOrderDetail() {
      this.showSuccessModal = false
      this.$router.push('/customer/order/list')
    },
    
    goBack() {
      this.stopPolling()
      this.$router.back()
    }
  },
  
  beforeDestroy() {
    this.stopPolling()
  }
}
</script>

<style scoped>
.payment-page {
  min-height: 100vh;
  background-color: #f5f5f5;
  padding-bottom: 80px;
}

.header {
  display: flex;
  align-items: center;
  padding: 15px 20px;
  background-color: #fff;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.back-btn {
  padding: 8px 12px;
  background: none;
  border: none;
  font-size: 16px;
  cursor: pointer;
}

.header h1 {
  flex: 1;
  text-align: center;
  font-size: 18px;
  margin: 0;
  padding-right: 60px;
}

.order-section,
.amount-section,
.payment-section {
  background-color: #fff;
  margin: 15px;
  border-radius: 8px;
  padding: 15px;
}

.section-title {
  font-size: 16px;
  font-weight: bold;
  color: #333;
  margin-bottom: 15px;
  padding-bottom: 10px;
  border-bottom: 1px solid #eee;
}

.order-no {
  font-size: 14px;
  color: #666;
  margin-bottom: 15px;
}

.order-items {
  max-height: 200px;
  overflow-y: auto;
}

.order-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 0;
  border-bottom: 1px solid #f5f5f5;
}

.order-item:last-child {
  border-bottom: none;
}

.item-name {
  flex: 1;
  font-size: 14px;
  color: #333;
}

.item-quantity {
  margin: 0 10px;
  font-size: 14px;
  color: #666;
}

.item-price {
  font-size: 14px;
  font-weight: bold;
  color: #333;
}

.amount-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 0;
}

.amount-row.total {
  padding-top: 15px;
  margin-top: 10px;
  border-top: 1px solid #eee;
}

.amount-row .label {
  font-size: 14px;
  color: #666;
}

.amount-row .value {
  font-size: 16px;
  color: #333;
}

.amount-row.total .label {
  font-size: 16px;
  font-weight: bold;
}

.amount-row.total .value {
  font-size: 24px;
  font-weight: bold;
  color: #ff6b81;
}

.payment-methods {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.method-item {
  display: flex;
  align-items: center;
  padding: 15px;
  border: 1px solid #e0e0e0;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s;
}

.method-item.active {
  border-color: #ff6b81;
  background-color: #fff5f6;
}

.method-icon {
  width: 44px;
  height: 44px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 12px;
}

.method-icon .icon-text {
  color: #fff;
  font-size: 20px;
  font-weight: bold;
}

.wxpay-icon {
  background-color: #07c160;
}

.alipay-icon {
  background-color: #1677ff;
}

.membercard-icon {
  background-color: #ff6b81;
}

.method-info {
  flex: 1;
}

.method-name {
  font-size: 15px;
  font-weight: bold;
  color: #333;
  margin-bottom: 4px;
}

.method-desc {
  font-size: 12px;
  color: #999;
}

.method-check {
  width: 24px;
  height: 24px;
  background-color: #ff6b81;
  color: #fff;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  font-weight: bold;
}

.bottom-bar {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  background-color: #fff;
  display: flex;
  align-items: center;
  padding: 12px 20px;
  box-shadow: 0 -2px 8px rgba(0, 0, 0, 0.1);
}

.bottom-left {
  flex: 1;
}

.bottom-label {
  font-size: 14px;
  color: #666;
  margin-right: 8px;
}

.bottom-amount {
  font-size: 22px;
  font-weight: bold;
  color: #ff6b81;
}

.pay-btn {
  padding: 12px 40px;
  background-color: #ff6b81;
  color: #fff;
  border: none;
  border-radius: 22px;
  font-size: 16px;
  font-weight: bold;
  cursor: pointer;
}

.pay-btn.loading {
  opacity: 0.7;
  cursor: not-allowed;
}

.pay-btn:disabled {
  background-color: #ccc;
}

.modal {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 2000;
}

.modal-content {
  width: 90%;
  max-width: 360px;
  background-color: #fff;
  border-radius: 12px;
  padding: 30px;
  text-align: center;
}

.modal-content h3 {
  margin: 0 0 15px 0;
  font-size: 18px;
  color: #333;
}

.pay-hint {
  font-size: 14px;
  color: #666;
  margin-bottom: 20px;
  line-height: 1.6;
}

.pay-link {
  display: block;
  padding: 12px;
  background-color: #f5f5f5;
  border-radius: 8px;
  color: #ff6b81;
  text-decoration: none;
  margin-bottom: 20px;
  word-break: break-all;
}

.modal-buttons {
  display: flex;
  gap: 12px;
}

.modal-buttons button {
  flex: 1;
  padding: 12px;
  border: none;
  border-radius: 8px;
  font-size: 16px;
  cursor: pointer;
}

.cancel-btn {
  background-color: #f5f5f5;
  color: #666;
}

.confirm-btn {
  background-color: #ff6b81;
  color: #fff;
}

.success-modal .success-icon {
  width: 72px;
  height: 72px;
  background-color: #52c41a;
  color: #fff;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 40px;
  margin: 0 auto 20px;
}

.success-modal h3 {
  margin-bottom: 10px;
}

.success-modal p {
  font-size: 14px;
  color: #666;
  margin-bottom: 25px;
}
</style>
