<template>
  <div class="group-purchase">
    <header class="header">
      <h1>本地生活团购</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="banner">
      <img src="https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=beauty%20spa%20promotion%20banner&image_size=wide" alt="团购banner" />
    </div>

    <div class="category-tabs">
      <div class="tab" :class="{ active: activeCategory === '' }" @click="activeCategory = ''">
        全部
      </div>
      <div class="tab" :class="{ active: activeCategory === 'beauty' }" @click="activeCategory = 'beauty'">
        美容美体
      </div>
      <div class="tab" :class="{ active: activeCategory === 'spa' }" @click="activeCategory = 'spa'">
        SPA养生
      </div>
      <div class="tab" :class="{ active: activeCategory === 'hair' }" @click="activeCategory = 'hair'">
        美发造型
      </div>
      <div class="tab" :class="{ active: activeCategory === 'nail' }" @click="activeCategory = 'nail'">
        美甲彩妆
      </div>
    </div>

    <div class="group-list">
      <div class="group-card" v-for="item in filteredList" :key="item.id" @click="viewDetail(item)">
        <div class="card-image">
          <img :src="item.image || getDefaultImage(item.category)" :alt="item.title" />
          <div class="discount-tag">{{ getDiscount(item) }}折</div>
          <div class="status-tag" v-if="item.status !== 'active'" :class="item.status">
            {{ getStatusName(item.status) }}
          </div>
        </div>
        <div class="card-content">
          <h3 class="card-title">{{ item.title }}</h3>
          <p class="card-subtitle">{{ item.subtitle }}</p>
          <div class="price-info">
            <span class="group-price">¥{{ item.groupPrice }}</span>
            <span class="original-price">¥{{ item.originalPrice }}</span>
          </div>
          <div class="progress-section">
            <div class="progress-bar">
              <div class="progress-fill" :style="{ width: getProgressWidth(item) + '%' }"></div>
            </div>
            <div class="progress-info">
              <span class="member-count">{{ item.currentMembers }}人已参与</span>
              <span class="need-count">还差{{ getNeedMembers(item) }}人成团</span>
            </div>
          </div>
          <div class="card-footer">
            <span class="validity">有效期：{{ item.validityDays }}天</span>
            <button class="join-btn" @click.stop="showJoinModal(item)">立即参团</button>
          </div>
        </div>
      </div>
    </div>

    <div class="modal" v-if="showModal" @click.self="showModal = false">
      <div class="modal-content">
        <h3>参团详情</h3>
        <div class="group-info" v-if="selectedGroup">
          <img :src="selectedGroup.image || getDefaultImage(selectedGroup.category)" alt="团购图片" />
          <h4>{{ selectedGroup.title }}</h4>
          <p>{{ selectedGroup.subtitle }}</p>
          <div class="price-row">
            <span class="label">团购价：</span>
            <span class="price">¥{{ selectedGroup.groupPrice }}</span>
          </div>
          <div class="member-row">
            <span class="label">已参与：</span>
            <span class="value">{{ selectedGroup.currentMembers }}人</span>
          </div>
          <div class="member-row">
            <span class="label">还差：</span>
            <span class="value highlight">{{ getNeedMembers(selectedGroup) }}人成团</span>
          </div>
        </div>
        <div class="modal-buttons">
          <button class="cancel-btn" @click="showModal = false">取消</button>
          <button class="confirm-btn" @click="joinGroup">确定参团</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { groupPurchaseAPI } from '@/api/index'

export default {
  name: 'CustomerGroupPurchase',
  data() {
    return {
      activeCategory: '',
      showModal: false,
      selectedGroup: null,
      groupPurchaseList: [
        {
          id: 1,
          title: '面部护理套餐',
          subtitle: '深层清洁+补水保湿',
          originalPrice: 398,
          groupPrice: 268,
          minMembers: 2,
          maxMembers: 5,
          currentMembers: 3,
          stock: 50,
          category: 'beauty',
          status: 'active',
          validityDays: 30,
          image: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=skincare%20facial%20treatment&image_size=square'
        },
        {
          id: 2,
          title: '全身SPA套餐',
          subtitle: '60分钟全身按摩+精油护理',
          originalPrice: 598,
          groupPrice: 398,
          minMembers: 3,
          maxMembers: 8,
          currentMembers: 5,
          stock: 30,
          category: 'spa',
          status: 'active',
          validityDays: 30,
          image: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=spa%20massage%20relaxation&image_size=square'
        },
        {
          id: 3,
          title: '美发套餐',
          subtitle: '洗剪吹+烫发/染发二选一',
          originalPrice: 328,
          groupPrice: 198,
          minMembers: 2,
          maxMembers: 6,
          currentMembers: 1,
          stock: 0,
          category: 'hair',
          status: 'active',
          validityDays: 60,
          image: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=hair%20salon%20service&image_size=square'
        },
        {
          id: 4,
          title: '美甲彩妆套餐',
          subtitle: '精致美甲+新娘妆/日常妆',
          originalPrice: 458,
          groupPrice: 298,
          minMembers: 2,
          maxMembers: 4,
          currentMembers: 2,
          stock: 20,
          category: 'nail',
          status: 'active',
          validityDays: 30,
          image: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=nail%20art%20beauty&image_size=square'
        }
      ]
    }
  },
  computed: {
    filteredList() {
      if (!this.activeCategory) {
        return this.groupPurchaseList.filter(item => item.status === 'active' && item.stock > 0)
      }
      return this.groupPurchaseList.filter(item =>
        item.category === this.activeCategory &&
        item.status === 'active' &&
        item.stock > 0
      )
    }
  },
  methods: {
    getDiscount(item) {
      if (!item.originalPrice || item.originalPrice === 0) return 0
      return Math.round((item.groupPrice / item.originalPrice) * 100) / 10
    },
    getStatusName(status) {
      const names = {
        pending: '即将开始',
        active: '进行中',
        ended: '已结束',
        sold_out: '已售罄'
      }
      return names[status] || status
    },
    getProgressWidth(item) {
      if (!item.minMembers) return 0
      return Math.min(100, (item.currentMembers / item.minMembers) * 100)
    },
    getNeedMembers(item) {
      return Math.max(0, item.minMembers - item.currentMembers)
    },
    getDefaultImage(category) {
      const images = {
        beauty: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=beauty%20skincare&image_size=square',
        spa: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=spa%20relaxation&image_size=square',
        hair: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=hair%20salon&image_size=square',
        nail: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=nail%20art&image_size=square'
      }
      return images[category] || images.beauty
    },
    viewDetail(item) {
      uni.showToast({ title: '查看团购详情', icon: 'none' })
    },
    showJoinModal(item) {
      this.selectedGroup = item
      this.showModal = true
    },
    joinGroup() {
      if (!this.selectedGroup) return

      uni.showModal({
        title: '确认参团',
        content: `确认参加"${this.selectedGroup.title}"团购吗？`,
        success: (res) => {
          if (res.confirm) {
            this.selectedGroup.currentMembers++
            uni.showToast({ title: '参团成功', icon: 'success' })
            this.showModal = false
          }
        }
      })
    },
    goBack() {
      this.$router.push('/customer/dashboard')
    }
  }
}
</script>

<style scoped>
.group-purchase {
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

.banner {
  margin: 10px;
}

.banner img {
  width: 100%;
  height: 120px;
  object-fit: cover;
  border-radius: 8px;
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

.group-list {
  padding: 0 10px;
}

.group-card {
  background-color: #fff;
  border-radius: 8px;
  margin-bottom: 15px;
  overflow: hidden;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.card-image {
  position: relative;
  height: 160px;
}

.card-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.discount-tag {
  position: absolute;
  top: 10px;
  left: 10px;
  background-color: #ff6b81;
  color: #fff;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: bold;
}

.status-tag {
  position: absolute;
  top: 10px;
  right: 10px;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: bold;
}

.status-tag.pending,
.status-tag.ended {
  background-color: #999;
  color: #fff;
}

.status-tag.sold_out {
  background-color: #F44336;
  color: #fff;
}

.card-content {
  padding: 15px;
}

.card-title {
  font-size: 16px;
  color: #333;
  margin: 0 0 5px 0;
  font-weight: bold;
}

.card-subtitle {
  font-size: 12px;
  color: #999;
  margin: 0 0 10px 0;
}

.price-info {
  display: flex;
  align-items: baseline;
  margin-bottom: 10px;
}

.group-price {
  font-size: 20px;
  color: #ff6b81;
  font-weight: bold;
  margin-right: 10px;
}

.original-price {
  font-size: 12px;
  color: #999;
  text-decoration: line-through;
}

.progress-section {
  margin-bottom: 10px;
}

.progress-bar {
  height: 8px;
  background-color: #f0f0f0;
  border-radius: 4px;
  overflow: hidden;
  margin-bottom: 5px;
}

.progress-fill {
  height: 100%;
  background: linear-gradient(90deg, #ff6b81, #ff9a9a);
  border-radius: 4px;
  transition: width 0.3s;
}

.progress-info {
  display: flex;
  justify-content: space-between;
  font-size: 12px;
  color: #666;
}

.need-count {
  color: #ff6b81;
}

.card-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 10px;
  border-top: 1px solid #f0f0f0;
}

.validity {
  font-size: 12px;
  color: #999;
}

.join-btn {
  padding: 8px 20px;
  background-color: #ff6b81;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
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
  max-width: 400px;
  background-color: #fff;
  border-radius: 8px;
  padding: 20px;
}

.modal-content h3 {
  font-size: 18px;
  color: #333;
  margin: 0 0 15px 0;
  text-align: center;
}

.group-info img {
  width: 100%;
  height: 150px;
  object-fit: cover;
  border-radius: 8px;
  margin-bottom: 15px;
}

.group-info h4 {
  font-size: 16px;
  color: #333;
  margin: 0 0 5px 0;
}

.group-info p {
  font-size: 12px;
  color: #999;
  margin: 0 0 15px 0;
}

.price-row,
.member-row {
  display: flex;
  justify-content: space-between;
  margin-bottom: 10px;
  font-size: 14px;
}

.price-row .label,
.member-row .label {
  color: #666;
}

.price-row .price {
  color: #ff6b81;
  font-weight: bold;
  font-size: 18px;
}

.member-row .value.highlight {
  color: #ff6b81;
  font-weight: bold;
}

.modal-buttons {
  display: flex;
  gap: 10px;
  margin-top: 20px;
}

.modal-buttons button {
  flex: 1;
  padding: 12px;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.cancel-btn {
  background-color: #f0f0f0;
  color: #666;
}

.confirm-btn {
  background-color: #ff6b81;
  color: #fff;
}
</style>
