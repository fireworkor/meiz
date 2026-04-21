<template>
  <div class="product-detail">
    <header class="header">
      <h1>商品详情</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="product-content" v-if="product">
      <div class="product-image">
        <img :src="product.image" :alt="product.name" />
        <div class="product-tag" v-if="product.discount">{{ product.discount }}折</div>
      </div>

      <div class="product-info">
        <h2 class="product-name">{{ product.name }}</h2>
        <p class="product-description">{{ product.description }}</p>

        <div class="price-section">
          <div class="current-price">{{ product.price }}</div>
          <div class="original-price" v-if="product.originalPrice">{{ product.originalPrice }}</div>
        </div>

        <div class="product-meta">
          <div class="meta-item">
            <span class="meta-label">已售</span>
            <span class="meta-value">{{ product.sales }}件</span>
          </div>
          <div class="meta-item">
            <span class="meta-label">库存</span>
            <span class="meta-value">{{ product.stock }}件</span>
          </div>
          <div class="meta-item">
            <span class="meta-label">分类</span>
            <span class="meta-value">{{ getCategoryName(product.category) }}</span>
          </div>
        </div>
      </div>

      <div class="product-details">
        <h3>商品详情</h3>
        <div class="detail-content">
          <p>品牌：美妆精选</p>
          <p>产地：上海</p>
          <p>保质期：3年</p>
          <p>适用肤质：所有肤质</p>
          <p>规格：标准装</p>
        </div>
      </div>

      <div class="reviews-section">
        <h3>商品评价</h3>
        <div class="review-item" v-for="review in reviews" :key="review.id">
          <div class="review-header">
            <div class="reviewer-info">
              <span class="reviewer-name">{{ review.userName }}</span>
              <div class="review-rating">
                <span v-for="n in 5" :key="n" :class="{ filled: n <= review.rating }">★</span>
              </div>
            </div>
            <span class="review-date">{{ review.date }}</span>
          </div>
          <p class="review-content">{{ review.content }}</p>
        </div>
        <div class="no-reviews" v-if="reviews.length === 0">
          暂无评价
        </div>
      </div>
    </div>

    <div class="bottom-bar">
      <div class="action-icons">
        <div class="icon-item" @click="toggleFavorite">
          <span class="icon">{{ isFavorite ? '❤️' : '🤍' }}</span>
          <span class="icon-label">收藏</span>
        </div>
        <div class="icon-item" @click="goToCart">
          <span class="icon">🛒</span>
          <span class="icon-label">购物车</span>
          <span class="badge" v-if="cartCount > 0">{{ cartCount }}</span>
        </div>
      </div>
      <div class="action-buttons">
        <button class="add-cart-btn" @click="addToCart">加入购物车</button>
        <button class="buy-now-btn" @click="buyNow">立即购买</button>
      </div>
    </div>

    <div class="spec-modal" v-if="showSpecModal" @click.self="showSpecModal = false">
      <div class="spec-content">
        <h3>选择规格</h3>
        <div class="spec-options">
          <div class="spec-item" v-for="spec in product.specs" :key="spec" :class="{ selected: selectedSpec === spec }" @click="selectedSpec = spec">
            {{ spec }}
          </div>
        </div>
        <div class="quantity-selector">
          <span>数量：</span>
          <button @click="quantity > 1 && quantity--">-</button>
          <input type="number" v-model="quantity" min="1" />
          <button @click="quantity++">+</button>
        </div>
        <button class="confirm-btn" @click="confirmAddToCart">确认</button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ProductDetail',
  data() {
    return {
      productId: null,
      product: null,
      cartCount: 5,
      isFavorite: false,
      showSpecModal: false,
      selectedSpec: '',
      quantity: 1,
      reviews: [
        {
          id: 1,
          userName: '爱美的张女士',
          rating: 5,
          date: '2024-04-20',
          content: '非常好用，保湿效果很明显，皮肤变得很光滑'
        },
        {
          id: 2,
          userName: '美妆达人',
          rating: 4,
          date: '2024-04-18',
          content: '包装精美，使用感不错，会回购'
        }
      ],
      allProducts: [
        {
          id: 1,
          name: '面部护理套装',
          description: '深层清洁+补水保湿，包含洁面乳、爽肤水、乳液三件套',
          price: '¥298',
          originalPrice: '¥398',
          discount: '7.5',
          sales: 128,
          stock: 50,
          category: 'skincare',
          specs: ['套装', '单品'],
          image: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=skincare%20set%20products&image_size=square'
        },
        {
          id: 2,
          name: '口红套装',
          description: '持久显色，不易脱色，包含3支热门色号',
          price: '¥198',
          originalPrice: '¥268',
          discount: '7.4',
          sales: 256,
          stock: 100,
          category: 'makeup',
          specs: ['正装', '迷你装'],
          image: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=lipstick%20set%20makeup&image_size=square'
        },
        {
          id: 3,
          name: '化妆刷套装',
          description: '专业化妆工具，12支全套',
          price: '¥128',
          sales: 89,
          stock: 30,
          category: 'tools',
          specs: ['专业版', '入门版'],
          image: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=makeup%20brush%20set&image_size=square'
        }
      ]
    }
  },
  created() {
    this.productId = this.$route.query.id || 1
    this.loadProduct()
  },
  methods: {
    loadProduct() {
      this.product = this.allProducts.find(p => p.id == this.productId) || this.allProducts[0]
      if (this.product && this.product.specs && this.product.specs.length > 0) {
        this.selectedSpec = this.product.specs[0]
      }
    },
    getCategoryName(category) {
      const names = {
        skincare: '护肤品',
        makeup: '彩妆',
        tools: '工具',
        gift: '礼品'
      }
      return names[category] || category
    },
    toggleFavorite() {
      this.isFavorite = !this.isFavorite
      uni.showToast({
        title: this.isFavorite ? '已收藏' : '已取消收藏',
        icon: 'success'
      })
    },
    goToCart() {
      this.$router.push('/customer/cart')
    },
    addToCart() {
      if (this.product.specs && this.product.specs.length > 1) {
        this.showSpecModal = true
      } else {
        this.confirmAddToCart()
      }
    },
    confirmAddToCart() {
      this.cartCount++
      this.showSpecModal = false
      uni.showToast({
        title: '已加入购物车',
        icon: 'success'
      })
    },
    buyNow() {
      uni.showToast({
        title: '正在跳转到结算...',
        icon: 'none'
      })
      setTimeout(() => {
        this.$router.push({
          path: '/customer/order/confirm',
          query: { productId: this.product.id, quantity: this.quantity }
        })
      }, 1000)
    },
    goBack() {
      this.$router.push('/customer/mall')
    }
  }
}
</script>

<style scoped>
.product-detail {
  min-height: 100vh;
  background-color: #f5f5f5;
  padding-bottom: 80px;
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

.product-content {
  padding: 20px;
}

.product-image {
  position: relative;
  margin-bottom: 20px;
}

.product-image img {
  width: 100%;
  height: 300px;
  object-fit: cover;
  border-radius: 8px;
}

.product-tag {
  position: absolute;
  top: 15px;
  right: 15px;
  background-color: #ff6b81;
  color: #fff;
  padding: 6px 12px;
  border-radius: 4px;
  font-size: 14px;
  font-weight: bold;
}

.product-info {
  background-color: #fff;
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 15px;
}

.product-name {
  font-size: 18px;
  color: #333;
  margin: 0 0 10px 0;
}

.product-description {
  font-size: 14px;
  color: #666;
  margin: 0 0 15px 0;
  line-height: 1.5;
}

.price-section {
  display: flex;
  align-items: baseline;
  margin-bottom: 15px;
}

.current-price {
  font-size: 24px;
  font-weight: bold;
  color: #ff6b81;
  margin-right: 15px;
}

.original-price {
  font-size: 14px;
  color: #999;
  text-decoration: line-through;
}

.product-meta {
  display: flex;
  justify-content: space-between;
  padding-top: 15px;
  border-top: 1px solid #f0f0f0;
}

.meta-item {
  text-align: center;
}

.meta-label {
  display: block;
  font-size: 12px;
  color: #999;
  margin-bottom: 5px;
}

.meta-value {
  font-size: 14px;
  color: #333;
  font-weight: bold;
}

.product-details {
  background-color: #fff;
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 15px;
}

.product-details h3 {
  font-size: 16px;
  color: #333;
  margin: 0 0 15px 0;
}

.detail-content p {
  font-size: 14px;
  color: #666;
  margin: 0 0 8px 0;
  line-height: 1.5;
}

.reviews-section {
  background-color: #fff;
  border-radius: 8px;
  padding: 20px;
}

.reviews-section h3 {
  font-size: 16px;
  color: #333;
  margin: 0 0 15px 0;
}

.review-item {
  padding: 15px 0;
  border-bottom: 1px solid #f0f0f0;
}

.review-item:last-child {
  border-bottom: none;
}

.review-header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 10px;
}

.reviewer-info {
  display: flex;
  align-items: center;
}

.reviewer-name {
  font-size: 14px;
  color: #333;
  margin-right: 10px;
}

.review-rating span {
  color: #ddd;
  font-size: 12px;
}

.review-rating span.filled {
  color: #ffb800;
}

.review-date {
  font-size: 12px;
  color: #999;
}

.review-content {
  font-size: 14px;
  color: #666;
  margin: 0;
  line-height: 1.5;
}

.no-reviews {
  text-align: center;
  color: #999;
  padding: 20px;
}

.bottom-bar {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 20px;
  background-color: #fff;
  box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.1);
}

.action-icons {
  display: flex;
  gap: 20px;
}

.icon-item {
  position: relative;
  text-align: center;
  cursor: pointer;
}

.icon {
  font-size: 20px;
  display: block;
}

.icon-label {
  font-size: 10px;
  color: #666;
}

.badge {
  position: absolute;
  top: -5px;
  right: -5px;
  background-color: #ff6b81;
  color: #fff;
  font-size: 10px;
  padding: 2px 5px;
  border-radius: 10px;
}

.action-buttons {
  display: flex;
  gap: 10px;
}

.add-cart-btn,
.buy-now-btn {
  padding: 10px 20px;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.add-cart-btn {
  background-color: #ffb800;
  color: #333;
}

.buy-now-btn {
  background-color: #ff6b81;
  color: #fff;
}

.spec-modal {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: flex-end;
  z-index: 2000;
}

.spec-content {
  width: 100%;
  background-color: #fff;
  border-radius: 16px 16px 0 0;
  padding: 20px;
}

.spec-content h3 {
  font-size: 16px;
  color: #333;
  margin: 0 0 15px 0;
}

.spec-options {
  display: flex;
  gap: 10px;
  margin-bottom: 20px;
}

.spec-item {
  padding: 8px 16px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.spec-item.selected {
  border-color: #ff6b81;
  background-color: #fff0f2;
  color: #ff6b81;
}

.quantity-selector {
  display: flex;
  align-items: center;
  margin-bottom: 20px;
}

.quantity-selector span {
  font-size: 14px;
  color: #333;
  margin-right: 10px;
}

.quantity-selector button {
  width: 30px;
  height: 30px;
  border: 1px solid #ddd;
  background-color: #fff;
  cursor: pointer;
}

.quantity-selector input {
  width: 50px;
  height: 30px;
  border: 1px solid #ddd;
  text-align: center;
  margin: 0 5px;
}

.confirm-btn {
  width: 100%;
  padding: 12px;
  background-color: #ff6b81;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 16px;
  cursor: pointer;
}
</style>
