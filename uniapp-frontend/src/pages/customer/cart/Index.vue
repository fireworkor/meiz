<template>
  <div class="cart">
    <header class="header">
      <h1>购物车</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="cart-content" v-if="cartItems.length > 0">
      <div class="cart-item" v-for="item in cartItems" :key="item.id">
        <div class="item-checkbox">
          <input type="checkbox" v-model="item.selected" @change="updateSelected" />
        </div>
        <div class="item-image">
          <img :src="item.image" :alt="item.name" />
        </div>
        <div class="item-info">
          <h3 class="item-name">{{ item.name }}</h3>
          <p class="item-spec">{{ item.spec }}</p>
          <div class="item-bottom">
            <span class="item-price">{{ item.price }}</span>
            <div class="quantity-control">
              <button class="qty-btn" @click="decreaseQuantity(item)">-</button>
              <input type="number" v-model="item.quantity" @change="updateQuantity(item)" min="1" />
              <button class="qty-btn" @click="increaseQuantity(item)">+</button>
            </div>
          </div>
        </div>
        <button class="delete-btn" @click="removeItem(item)">删除</button>
      </div>

      <div class="cart-summary">
        <div class="summary-info">
          <label class="select-all">
            <input type="checkbox" v-model="selectAll" @change="toggleSelectAll" />
            全选
          </label>
          <div class="summary-text">
            <span>共{{ selectedCount }}件商品</span>
            <span class="total-price">合计：{{ totalPrice }}</span>
          </div>
        </div>
        <button class="checkout-btn" @click="goToCheckout" :disabled="selectedCount === 0">
          去结算
        </button>
      </div>
    </div>

    <div class="empty-cart" v-else>
      <div class="empty-icon">🛒</div>
      <p>购物车是空的</p>
      <button class="shop-btn" @click="goToMall">去逛逛</button>
    </div>

    <div class="recommended-section">
      <h3>猜你喜欢</h3>
      <div class="recommended-list">
        <div class="recommended-item" v-for="product in recommendedProducts" :key="product.id" @click="viewProduct(product.id)">
          <img :src="product.image" :alt="product.name" />
          <p class="recommended-name">{{ product.name }}</p>
          <p class="recommended-price">{{ product.price }}</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'CustomerCart',
  data() {
    return {
      selectAll: false,
      cartItems: [
        {
          id: 1,
          name: '面部护理套装',
          spec: '套装',
          price: '¥298',
          originalPrice: '¥398',
          quantity: 1,
          selected: false,
          image: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=skincare%20set%20products&image_size=square'
        },
        {
          id: 2,
          name: '口红套装',
          spec: '正装',
          price: '¥198',
          originalPrice: '¥268',
          quantity: 2,
          selected: false,
          image: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=lipstick%20set%20makeup&image_size=square'
        },
        {
          id: 3,
          name: '精华液',
          spec: '标准装',
          price: '¥398',
          quantity: 1,
          selected: false,
          image: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=serum%20bottle%20skincare&image_size=square'
        }
      ],
      recommendedProducts: [
        {
          id: 4,
          name: '面膜礼盒',
          price: '¥168',
          image: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=face%20mask%20gift%20box&image_size=square'
        },
        {
          id: 5,
          name: '眼影盘',
          price: '¥158',
          image: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=eyeshadow%20palette%20makeup&image_size=square'
        },
        {
          id: 6,
          name: '化妆刷套装',
          price: '¥128',
          image: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=makeup%20brush%20set&image_size=square'
        },
        {
          id: 7,
          name: '睫毛膏',
          price: '¥88',
          image: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=mascara%20makeup&image_size=square'
        }
      ]
    }
  },
  computed: {
    selectedCount() {
      return this.cartItems.filter(item => item.selected).length
    },
    totalPrice() {
      const selectedItems = this.cartItems.filter(item => item.selected)
      let total = 0
      selectedItems.forEach(item => {
        const price = parseFloat(item.price.replace('¥', ''))
        total += price * item.quantity
      })
      return '¥' + total.toFixed(2)
    }
  },
  methods: {
    decreaseQuantity(item) {
      if (item.quantity > 1) {
        item.quantity--
      }
    },
    increaseQuantity(item) {
      item.quantity++
    },
    updateQuantity(item) {
      if (item.quantity < 1) {
        item.quantity = 1
      }
    },
    removeItem(item) {
      uni.showModal({
        title: '确认删除',
        content: '确定要删除这个商品吗？',
        success: (res) => {
          if (res.confirm) {
            const index = this.cartItems.indexOf(item)
            if (index > -1) {
              this.cartItems.splice(index, 1)
            }
          }
        }
      })
    },
    toggleSelectAll() {
      this.cartItems.forEach(item => {
        item.selected = this.selectAll
      })
    },
    updateSelected() {
      const allSelected = this.cartItems.every(item => item.selected)
      this.selectAll = allSelected
    },
    goToCheckout() {
      this.$router.push('/customer/order/confirm')
    },
    goToMall() {
      this.$router.push('/customer/mall')
    },
    viewProduct(id) {
      this.$router.push(`/customer/mall/product?id=${id}`)
    },
    goBack() {
      this.$router.push('/customer/mall')
    }
  }
}
</script>

<style scoped>
.cart {
  min-height: 100vh;
  background-color: #f5f5f5;
  padding-bottom: 140px;
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

.cart-content {
  padding: 15px 20px;
}

.cart-item {
  display: flex;
  align-items: flex-start;
  background-color: #fff;
  border-radius: 8px;
  padding: 15px;
  margin-bottom: 15px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.item-checkbox {
  margin-right: 10px;
  padding-top: 30px;
}

.item-checkbox input {
  width: 18px;
  height: 18px;
}

.item-image {
  margin-right: 15px;
}

.item-image img {
  width: 80px;
  height: 80px;
  object-fit: cover;
  border-radius: 4px;
}

.item-info {
  flex: 1;
}

.item-name {
  font-size: 14px;
  color: #333;
  margin: 0 0 5px 0;
  font-weight: bold;
}

.item-spec {
  font-size: 12px;
  color: #999;
  margin: 0 0 10px 0;
}

.item-bottom {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.item-price {
  font-size: 16px;
  color: #ff6b81;
  font-weight: bold;
}

.quantity-control {
  display: flex;
  align-items: center;
}

.qty-btn {
  width: 24px;
  height: 24px;
  border: 1px solid #ddd;
  background-color: #fff;
  cursor: pointer;
  font-size: 14px;
}

.quantity-control input {
  width: 40px;
  height: 24px;
  border: 1px solid #ddd;
  text-align: center;
  font-size: 14px;
  margin: 0 5px;
}

.delete-btn {
  padding: 5px 10px;
  background-color: transparent;
  color: #999;
  border: none;
  font-size: 12px;
  cursor: pointer;
  margin-left: 10px;
}

.cart-summary {
  position: fixed;
  bottom: 60px;
  left: 0;
  right: 0;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px 20px;
  background-color: #fff;
  box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.1);
}

.summary-info {
  flex: 1;
}

.select-all {
  display: flex;
  align-items: center;
  font-size: 14px;
  color: #333;
  margin-bottom: 5px;
}

.select-all input {
  margin-right: 5px;
}

.summary-text {
  display: flex;
  flex-direction: column;
  font-size: 12px;
  color: #666;
}

.total-price {
  font-size: 16px;
  color: #ff6b81;
  font-weight: bold;
  margin-top: 5px;
}

.checkout-btn {
  padding: 12px 30px;
  background-color: #ff6b81;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.checkout-btn:disabled {
  background-color: #ccc;
  cursor: not-allowed;
}

.empty-cart {
  text-align: center;
  padding: 100px 20px;
  background-color: #fff;
  margin: 15px;
  border-radius: 8px;
}

.empty-icon {
  font-size: 64px;
  margin-bottom: 20px;
}

.empty-cart p {
  font-size: 16px;
  color: #666;
  margin: 0 0 20px 0;
}

.shop-btn {
  padding: 10px 30px;
  background-color: #ff6b81;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.recommended-section {
  padding: 20px;
}

.recommended-section h3 {
  font-size: 16px;
  color: #333;
  margin: 0 0 15px 0;
}

.recommended-list {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 15px;
}

.recommended-item {
  background-color: #fff;
  border-radius: 8px;
  padding: 10px;
  cursor: pointer;
}

.recommended-item img {
  width: 100%;
  height: 120px;
  object-fit: cover;
  border-radius: 4px;
  margin-bottom: 10px;
}

.recommended-name {
  font-size: 14px;
  color: #333;
  margin: 0 0 5px 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.recommended-price {
  font-size: 14px;
  color: #ff6b81;
  margin: 0;
  font-weight: bold;
}
</style>
