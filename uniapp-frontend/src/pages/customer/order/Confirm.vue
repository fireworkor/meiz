<template>
  <div class="order-confirm">
    <header class="header">
      <h1>确认订单</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="order-content">
      <div class="address-section" @click="selectAddress">
        <div class="section-icon">📍</div>
        <div class="address-info" v-if="selectedAddress">
          <div class="address-top">
            <span class="receiver">{{ selectedAddress.name }}</span>
            <span class="phone">{{ selectedAddress.phone }}</span>
            <span class="default-tag" v-if="selectedAddress.isDefault">默认</span>
          </div>
          <p class="address-detail">{{ selectedAddress.province }}{{ selectedAddress.city }}{{ selectedAddress.district }}{{ selectedAddress.detail }}</p>
        </div>
        <div class="no-address" v-else>
          <span>请添加收货地址</span>
        </div>
        <div class="arrow">›</div>
      </div>

      <div class="products-section">
        <h3>商品清单</h3>
        <div class="product-item" v-for="item in orderItems" :key="item.id">
          <img :src="item.image" :alt="item.name" />
          <div class="product-info">
            <h4>{{ item.name }}</h4>
            <p class="product-spec">{{ item.spec }}</p>
          </div>
          <div class="product-right">
            <span class="price">{{ item.price }}</span>
            <span class="quantity">x{{ item.quantity }}</span>
          </div>
        </div>
      </div>

      <div class="coupon-section" @click="selectCoupon">
        <div class="section-label">优惠券</div>
        <div class="section-value">
          <span v-if="selectedCoupon">{{ selectedCoupon.name }} (-¥{{ selectedCoupon.value }})</span>
          <span v-else class="no-value">请选择优惠券</span>
          <span class="arrow">›</span>
        </div>
      </div>

      <div class="points-section">
        <div class="section-label">积分抵扣</div>
        <div class="section-value">
          <span class="points-balance">可用{{ availablePoints }}积分</span>
          <label class="switch">
            <input type="checkbox" v-model="usePoints" @change="calculateTotal" />
            <span class="slider"></span>
          </label>
        </div>
      </div>

      <div class="order-summary">
        <h3>订单金额</h3>
        <div class="summary-row">
          <span>商品总价</span>
          <span>{{ subtotal }}</span>
        </div>
        <div class="summary-row">
          <span>运费</span>
          <span>{{ shipping }}</span>
        </div>
        <div class="summary-row" v-if="selectedCoupon">
          <span>优惠券</span>
          <span class="discount">-¥{{ selectedCoupon.value }}</span>
        </div>
        <div class="summary-row" v-if="usePoints">
          <span>积分抵扣</span>
          <span class="discount">-¥{{ pointsDeduction }}</span>
        </div>
        <div class="summary-row total">
          <span>实付金额</span>
          <span class="total-price">{{ totalPrice }}</span>
        </div>
      </div>

      <div class="payment-section">
        <h3>支付方式</h3>
        <div class="payment-list">
          <label class="payment-item" :class="{ selected: paymentMethod === 'wechat' }">
            <input type="radio" v-model="paymentMethod" value="wechat" />
            <span class="payment-icon">💳</span>
            <span class="payment-name">微信支付</span>
          </label>
          <label class="payment-item" :class="{ selected: paymentMethod === 'alipay' }">
            <input type="radio" v-model="paymentMethod" value="alipay" />
            <span class="payment-icon">💰</span>
            <span class="payment-name">支付宝</span>
          </label>
          <label class="payment-item" :class="{ selected: paymentMethod === 'card' }">
            <input type="radio" v-model="paymentMethod" value="card" />
            <span class="payment-icon">💳</span>
            <span class="payment-name">会员卡支付</span>
          </label>
        </div>
      </div>

      <div class="remark-section">
        <h3>订单备注</h3>
        <textarea v-model="remark" placeholder="请输入订单备注（选填）" rows="3"></textarea>
      </div>
    </div>

    <div class="bottom-bar">
      <div class="total-info">
        <span class="label">合计：</span>
        <span class="amount">{{ totalPrice }}</span>
      </div>
      <button class="submit-btn" @click="submitOrder">提交订单</button>
    </div>
  </div>
</template>

<script>
export default {
  name: 'OrderConfirm',
  data() {
    return {
      orderItems: [
        {
          id: 1,
          name: '面部护理套装',
          spec: '套装',
          price: '¥298',
          quantity: 1,
          image: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=skincare%20set%20products&image_size=square'
        },
        {
          id: 2,
          name: '口红套装',
          spec: '正装',
          price: '¥198',
          quantity: 2,
          image: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=lipstick%20set%20makeup&image_size=square'
        }
      ],
      selectedAddress: {
        id: 1,
        name: '张女士',
        phone: '138****8888',
        province: '上海市',
        city: '上海市',
        district: '浦东新区',
        detail: '某某路888号某某小区1号楼101室',
        isDefault: true
      },
      addresses: [
        {
          id: 1,
          name: '张女士',
          phone: '138****8888',
          province: '上海市',
          city: '上海市',
          district: '浦东新区',
          detail: '某某路888号某某小区1号楼101室',
          isDefault: true
        },
        {
          id: 2,
          name: '李先生',
          phone: '139****9999',
          province: '北京市',
          city: '北京市',
          district: '朝阳区',
          detail: '某某街999号某某大厦',
          isDefault: false
        }
      ],
      selectedCoupon: null,
      coupons: [
        { id: 1, name: '新人满100减20', value: 20, condition: 100 },
        { id: 2, name: '满200减50', value: 50, condition: 200 },
        { id: 3, name: '满500减120', value: 120, condition: 500 }
      ],
      availablePoints: 500,
      usePoints: false,
      pointsDeduction: 0,
      paymentMethod: 'wechat',
      remark: '',
      subtotal: '¥694.00',
      shipping: '¥0.00'
    }
  },
  computed: {
    totalPrice() {
      let total = parseFloat(this.subtotal.replace('¥', ''))
      if (this.selectedCoupon) {
        total -= this.selectedCoupon.value
      }
      if (this.usePoints) {
        total -= this.pointsDeduction
      }
      return '¥' + total.toFixed(2)
    }
  },
  methods: {
    selectAddress() {
      uni.showToast({ title: '选择收货地址', icon: 'none' })
    },
    selectCoupon() {
      uni.showToast({ title: '选择优惠券', icon: 'none' })
    },
    calculateTotal() {
      if (this.usePoints) {
        this.pointsDeduction = Math.min(50, this.availablePoints / 100)
      } else {
        this.pointsDeduction = 0
      }
    },
    submitOrder() {
      if (!this.selectedAddress) {
        uni.showToast({ title: '请选择收货地址', icon: 'none' })
        return
      }

      uni.showModal({
        title: '确认提交订单',
        content: `确认提交订单，金额：${this.totalPrice}？`,
        success: (res) => {
          if (res.confirm) {
            uni.showToast({ title: '订单提交成功', icon: 'success' })
            setTimeout(() => {
              this.$router.push('/customer/order/list')
            }, 1500)
          }
        }
      })
    },
    goBack() {
      this.$router.push('/customer/cart')
    }
  }
}
</script>

<style scoped>
.order-confirm {
  min-height: 100vh;
  background-color: #f5f5f5;
  padding-bottom: 70px;
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

.order-content {
  padding: 15px;
}

.address-section {
  display: flex;
  align-items: center;
  background-color: #fff;
  border-radius: 8px;
  padding: 15px;
  margin-bottom: 15px;
  cursor: pointer;
}

.section-icon {
  font-size: 24px;
  margin-right: 15px;
}

.address-info {
  flex: 1;
}

.address-top {
  display: flex;
  align-items: center;
  margin-bottom: 8px;
}

.receiver {
  font-size: 16px;
  font-weight: bold;
  color: #333;
  margin-right: 10px;
}

.phone {
  font-size: 14px;
  color: #666;
  margin-right: 10px;
}

.default-tag {
  background-color: #ff6b81;
  color: #fff;
  font-size: 10px;
  padding: 2px 6px;
  border-radius: 4px;
}

.address-detail {
  font-size: 14px;
  color: #666;
  margin: 0;
  line-height: 1.4;
}

.no-address {
  flex: 1;
  color: #999;
  font-size: 14px;
}

.arrow {
  font-size: 20px;
  color: #999;
}

.products-section {
  background-color: #fff;
  border-radius: 8px;
  padding: 15px;
  margin-bottom: 15px;
}

.products-section h3 {
  font-size: 16px;
  color: #333;
  margin: 0 0 15px 0;
}

.product-item {
  display: flex;
  align-items: center;
  padding: 10px 0;
  border-bottom: 1px solid #f0f0f0;
}

.product-item:last-child {
  border-bottom: none;
}

.product-item img {
  width: 60px;
  height: 60px;
  object-fit: cover;
  border-radius: 4px;
  margin-right: 12px;
}

.product-info {
  flex: 1;
}

.product-info h4 {
  font-size: 14px;
  color: #333;
  margin: 0 0 5px 0;
}

.product-spec {
  font-size: 12px;
  color: #999;
  margin: 0;
}

.product-right {
  text-align: right;
}

.price {
  display: block;
  font-size: 14px;
  color: #333;
  font-weight: bold;
}

.quantity {
  display: block;
  font-size: 12px;
  color: #999;
  margin-top: 5px;
}

.coupon-section,
.points-section {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background-color: #fff;
  border-radius: 8px;
  padding: 15px;
  margin-bottom: 15px;
}

.section-label {
  font-size: 14px;
  color: #333;
}

.section-value {
  display: flex;
  align-items: center;
}

.no-value {
  color: #999;
  font-size: 14px;
}

.points-balance {
  font-size: 14px;
  color: #666;
  margin-right: 10px;
}

.switch {
  position: relative;
  width: 44px;
  height: 24px;
}

.switch input {
  opacity: 0;
  width: 0;
  height: 0;
}

.slider {
  position: absolute;
  cursor: pointer;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: #ccc;
  transition: 0.3s;
  border-radius: 24px;
}

.slider:before {
  position: absolute;
  content: "";
  height: 18px;
  width: 18px;
  left: 3px;
  bottom: 3px;
  background-color: white;
  transition: 0.3s;
  border-radius: 50%;
}

input:checked + .slider {
  background-color: #ff6b81;
}

input:checked + .slider:before {
  transform: translateX(20px);
}

.order-summary {
  background-color: #fff;
  border-radius: 8px;
  padding: 15px;
  margin-bottom: 15px;
}

.order-summary h3 {
  font-size: 16px;
  color: #333;
  margin: 0 0 15px 0;
}

.summary-row {
  display: flex;
  justify-content: space-between;
  font-size: 14px;
  color: #666;
  margin-bottom: 10px;
}

.summary-row:last-child {
  margin-bottom: 0;
}

.summary-row.discount {
  color: #4CAF50;
}

.summary-row.total {
  padding-top: 15px;
  border-top: 1px solid #f0f0f0;
  font-weight: bold;
}

.total-price {
  font-size: 18px;
  color: #ff6b81;
}

.payment-section {
  background-color: #fff;
  border-radius: 8px;
  padding: 15px;
  margin-bottom: 15px;
}

.payment-section h3 {
  font-size: 16px;
  color: #333;
  margin: 0 0 15px 0;
}

.payment-list {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 10px;
}

.payment-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 15px 10px;
  border: 1px solid #ddd;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s;
}

.payment-item.selected {
  border-color: #ff6b81;
  background-color: #fff0f2;
}

.payment-item input {
  display: none;
}

.payment-icon {
  font-size: 24px;
  margin-bottom: 8px;
}

.payment-name {
  font-size: 12px;
  color: #333;
}

.remark-section {
  background-color: #fff;
  border-radius: 8px;
  padding: 15px;
}

.remark-section h3 {
  font-size: 16px;
  color: #333;
  margin: 0 0 10px 0;
}

.remark-section textarea {
  width: 100%;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
  resize: none;
  box-sizing: border-box;
}

.bottom-bar {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px 20px;
  background-color: #fff;
  box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.1);
}

.total-info {
  display: flex;
  align-items: baseline;
}

.total-info .label {
  font-size: 14px;
  color: #666;
}

.total-info .amount {
  font-size: 20px;
  font-weight: bold;
  color: #ff6b81;
}

.submit-btn {
  padding: 12px 40px;
  background-color: #ff6b81;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 16px;
  cursor: pointer;
}
</style>
