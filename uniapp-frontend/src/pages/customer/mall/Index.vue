<template>
  <div class="mall">
    <header class="header">
      <h1>在线商城</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="search-bar">
      <input type="text" v-model="searchKeyword" placeholder="搜索商品" />
      <button class="search-btn" @click="searchProducts">搜索</button>
    </div>

    <div class="category-tabs">
      <div class="tab" :class="{ active: activeCategory === 'all' }" @click="activeCategory = 'all'">
        全部
      </div>
      <div class="tab" :class="{ active: activeCategory === 'skincare' }" @click="activeCategory = 'skincare'">
        护肤品
      </div>
      <div class="tab" :class="{ active: activeCategory === 'makeup' }" @click="activeCategory = 'makeup'">
        彩妆
      </div>
      <div class="tab" :class="{ active: activeCategory === 'tools' }" @click="activeCategory = 'tools'">
        工具
      </div>
      <div class="tab" :class="{ active: activeCategory === 'gift' }" @click="activeCategory = 'gift'">
        礼品
      </div>
    </div>

    <div class="product-list">
      <div v-for="product in filteredProducts" :key="product.id" class="product-item" @click="viewProductDetail(product.id)">
        <div class="product-image">
          <img :src="product.image" :alt="product.name" />
          <div class="product-tag" v-if="product.discount">
            {{ product.discount }}折
          </div>
        </div>
        <div class="product-info">
          <h3 class="product-name">{{ product.name }}</h3>
          <p class="product-description">{{ product.description }}</p>
          <div class="product-price">
            <span class="price">{{ product.price }}</span>
            <span class="original-price" v-if="product.originalPrice">{{ product.originalPrice }}</span>
          </div>
          <div class="product-stats">
            <span class="sales">已售{{ product.sales }}件</span>
            <button class="add-cart-btn" @click.stop="addToCart(product.id)">加入购物车</button>
          </div>
        </div>
      </div>
      <div v-if="filteredProducts.length === 0" class="empty">
        <div class="empty-icon">🛍️</div>
        <p>暂无商品</p>
      </div>
    </div>

    <div class="cart-bar" v-if="cartCount > 0">
      <div class="cart-info">
        <span class="cart-count">{{ cartCount }}</span>
        <span class="cart-text">购物车</span>
      </div>
      <button class="checkout-btn" @click="goToCheckout">去结算</button>
    </div>
  </div>
</template>

<script>
export default {
  name: 'CustomerMall',
  data() {
    return {
      searchKeyword: '',
      activeCategory: 'all',
      cartCount: 5,
      products: [
        {
          id: 1,
          name: '面部护理套装',
          description: '深层清洁+补水保湿',
          price: '¥298',
          originalPrice: '¥398',
          discount: '7.5',
          sales: 128,
          category: 'skincare',
          image: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=skincare%20set%20products&image_size=square'
        },
        {
          id: 2,
          name: '口红套装',
          description: '持久显色，不易脱色',
          price: '¥198',
          originalPrice: '¥268',
          discount: '7.4',
          sales: 256,
          category: 'makeup',
          image: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=lipstick%20set%20makeup&image_size=square'
        },
        {
          id: 3,
          name: '化妆刷套装',
          description: '专业化妆工具',
          price: '¥128',
          sales: 89,
          category: 'tools',
          image: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=makeup%20brush%20set&image_size=square'
        },
        {
          id: 4,
          name: '面膜礼盒',
          description: '10片装，深层补水',
          price: '¥168',
          originalPrice: '¥228',
          discount: '7.4',
          sales: 156,
          category: 'gift',
          image: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=face%20mask%20gift%20box&image_size=square'
        },
        {
          id: 5,
          name: '精华液',
          description: '抗老化，提亮肤色',
          price: '¥398',
          originalPrice: '¥498',
          discount: '8.0',
          sales: 78,
          category: 'skincare',
          image: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=serum%20bottle%20skincare&image_size=square'
        },
        {
          id: 6,
          name: '眼影盘',
          description: '12色眼影，多色可选',
          price: '¥158',
          sales: 134,
          category: 'makeup',
          image: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=eyeshadow%20palette%20makeup&image_size=square'
        }
      ]
    }
  },
  computed: {
    filteredProducts() {
      let result = [...this.products]
      
      if (this.activeCategory !== 'all') {
        result = result.filter(p => p.category === this.activeCategory)
      }
      
      if (this.searchKeyword) {
        const keyword = this.searchKeyword.toLowerCase()
        result = result.filter(p => 
          p.name.toLowerCase().includes(keyword) ||
          p.description.toLowerCase().includes(keyword)
        )
      }
      
      return result
    }
  },
  methods: {
    searchProducts() {
      // 搜索逻辑已在computed中处理
    },
    viewProductDetail(productId) {
      uni.showToast({ title: `查看商品详情 ${productId}`, icon: 'none' })
    },
    addToCart(productId) {
      this.cartCount++
      uni.showToast({ title: '已加入购物车', icon: 'success' })
    },
    goToCheckout() {
      uni.showToast({ title: '去结算功能开发中', icon: 'none' })
    },
    goBack() {
      this.$router.push('/customer/dashboard')
    }
  }
}
</script>

<style scoped>
.mall {
  min-height: 100vh;
  background-color: #f5f5f5;
  padding-bottom: 60px;
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

.search-bar {
  display: flex;
  padding: 15px 20px;
  background-color: #fff;
  margin-bottom: 10px;
}

.search-bar input {
  flex: 1;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px 0 0 4px;
  font-size: 14px;
}

.search-btn {
  padding: 10px 15px;
  background-color: #ff6b81;
  color: #fff;
  border: none;
  border-radius: 0 4px 4px 0;
  cursor: pointer;
}

.category-tabs {
  display: flex;
  background-color: #fff;
  margin-bottom: 10px;
  overflow-x: auto;
}

.tab {
  padding: 15px 20px;
  font-size: 14px;
  color: #666;
  cursor: pointer;
  white-space: nowrap;
  border-bottom: 2px solid transparent;
}

.tab.active {
  color: #ff6b81;
  border-bottom-color: #ff6b81;
  font-weight: bold;
}

.product-list {
  padding: 0 20px;
}

.product-item {
  background-color: #fff;
  border-radius: 8px;
  padding: 15px;
  margin-bottom: 15px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  cursor: pointer;
  transition: transform 0.2s;
}

.product-item:hover {
  transform: translateY(-2px);
}

.product-image {
  position: relative;
  margin-bottom: 15px;
}

.product-image img {
  width: 100%;
  height: 200px;
  object-fit: cover;
  border-radius: 8px;
}

.product-tag {
  position: absolute;
  top: 10px;
  right: 10px;
  background-color: #ff6b81;
  color: #fff;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
}

.product-name {
  font-size: 16px;
  color: #333;
  margin: 0 0 5px 0;
}

.product-description {
  font-size: 14px;
  color: #666;
  margin: 0 0 10px 0;
  line-height: 1.4;
}

.product-price {
  margin-bottom: 10px;
}

.price {
  font-size: 18px;
  font-weight: bold;
  color: #ff6b81;
  margin-right: 10px;
}

.original-price {
  font-size: 14px;
  color: #999;
  text-decoration: line-through;
}

.product-stats {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.sales {
  font-size: 12px;
  color: #999;
}

.add-cart-btn {
  padding: 6px 12px;
  background-color: #ff6b81;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 12px;
  cursor: pointer;
}

.empty {
  text-align: center;
  padding: 60px 20px;
  background-color: #fff;
  border-radius: 8px;
  color: #999;
}

.empty-icon {
  font-size: 48px;
  margin-bottom: 20px;
}

.empty p {
  font-size: 16px;
  margin: 0;
}

.cart-bar {
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
  z-index: 1000;
}

.cart-info {
  display: flex;
  align-items: center;
}

.cart-count {
  width: 20px;
  height: 20px;
  background-color: #ff6b81;
  color: #fff;
  border-radius: 50%;
  font-size: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 10px;
}

.cart-text {
  font-size: 14px;
  color: #333;
}

.checkout-btn {
  padding: 10px 20px;
  background-color: #ff6b81;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}
</style>
