<template>
  <div class="order-list">
    <header class="header">
      <h1>我的订单</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="order-tabs">
      <div class="tab" :class="{ active: activeTab === 'all' }" @click="activeTab = 'all'">
        全部
      </div>
      <div class="tab" :class="{ active: activeTab === 'pending' }" @click="activeTab = 'pending'">
        待付款
      </div>
      <div class="tab" :class="{ active: activeTab === 'paid' }" @click="activeTab = 'paid'">
        待发货
      </div>
      <div class="tab" :class="{ active: activeTab === 'shipped' }" @click="activeTab = 'shipped'">
        待收货
      </div>
      <div class="tab" :class="{ active: activeTab === 'completed' }" @click="activeTab = 'completed'">
        已完成
      </div>
    </div>

    <div class="order-content">
      <div class="order-item" v-for="order in filteredOrders" :key="order.id">
        <div class="order-header">
          <span class="order-no">订单号：{{ order.orderNo }}</span>
          <span class="order-status" :class="order.status">{{ getStatusText(order.status) }}</span>
        </div>

        <div class="order-products">
          <div class="product-item" v-for="product in order.products" :key="product.id">
            <img :src="product.image" :alt="product.name" />
            <div class="product-info">
              <h4>{{ product.name }}</h4>
              <p class="product-spec">{{ product.spec }}</p>
            </div>
            <div class="product-right">
              <span class="price">{{ product.price }}</span>
              <span class="quantity">x{{ product.quantity }}</span>
            </div>
          </div>
        </div>

        <div class="order-footer">
          <div class="order-info">
            <span class="order-time">{{ order.createTime }}</span>
            <span class="order-total">共{{ order.totalQuantity }}件商品，实付<span class="total-price">{{ order.totalAmount }}</span></span>
          </div>
          <div class="order-actions">
            <button v-if="order.status === 'pending'" class="btn-cancel" @click="cancelOrder(order)">取消订单</button>
            <button v-if="order.status === 'pending'" class="btn-pay" @click="payOrder(order)">立即付款</button>
            <button v-if="order.status === 'shipped'" class="btn-confirm" @click="confirmReceive(order)">确认收货</button>
            <button v-if="order.status === 'completed'" class="btn-review" @click="reviewOrder(order)">去评价</button>
            <button class="btn-detail" @click="viewDetail(order)">查看详情</button>
          </div>
        </div>
      </div>

      <div class="empty-orders" v-if="filteredOrders.length === 0">
        <div class="empty-icon">📦</div>
        <p>暂无订单</p>
        <button class="shop-btn" @click="goToMall">去逛逛</button>
      </div>
    </div>
  </div>
</template>

<script>
import { orderAPI } from '@/api/index'
import { toast, modal, navigate, loading } from '@/utils/common'

export default {
  name: 'OrderList',
  data() {
    return {
      activeTab: 'all',
      orders: [
        {
          id: 1,
          orderNo: 'BS202404220001',
          status: 'pending',
          createTime: '2024-04-22 14:30:25',
          totalQuantity: 2,
          totalAmount: '¥694.00',
          products: [
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
              quantity: 1,
              image: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=lipstick%20set%20makeup&image_size=square'
            }
          ]
        },
        {
          id: 2,
          orderNo: 'BS202404210002',
          status: 'shipped',
          createTime: '2024-04-21 10:20:15',
          totalQuantity: 1,
          totalAmount: '¥168.00',
          products: [
            {
              id: 3,
              name: '面膜礼盒',
              spec: '10片装',
              price: '¥168',
              quantity: 1,
              image: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=face%20mask%20gift%20box&image_size=square'
            }
          ]
        },
        {
          id: 3,
          orderNo: 'BS202404150003',
          status: 'completed',
          createTime: '2024-04-15 16:45:30',
          totalQuantity: 3,
          totalAmount: '¥524.00',
          products: [
            {
              id: 4,
              name: '精华液',
              spec: '标准装',
              price: '¥398',
              quantity: 1,
              image: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=serum%20bottle%20skincare&image_size=square'
            },
            {
              id: 5,
              name: '眼影盘',
              spec: '12色',
              price: '¥158',
              quantity: 1,
              image: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=eyeshadow%20palette%20makeup&image_size=square'
            }
          ]
        }
      ]
    }
  },
  computed: {
    filteredOrders() {
      if (this.activeTab === 'all') {
        return this.orders
      }
      return this.orders.filter(order => order.status === this.activeTab)
    }
  },
  methods: {
    getStatusText(status) {
      const statusMap = {
        pending: '待付款',
        paid: '待发货',
        shipped: '待收货',
        completed: '已完成',
        cancelled: '已取消'
      }
      return statusMap[status] || status
    },
    cancelOrder(order) {
      modal.show({
        content: '确定要取消该订单吗？',
        success: (res) => {
          if (res.confirm) {
            order.status = 'cancelled'
            toast.show({ title: '订单已取消' })
          }
        }
      })
    },
    payOrder(order) {
      toast.show({ title: '正在发起支付...' })
      setTimeout(() => {
        order.status = 'paid'
        toast.show({ title: '支付成功' })
      }, 1500)
    },
    confirmReceive(order) {
      modal.show({
        content: '确认已收到货物吗？',
        success: (res) => {
          if (res.confirm) {
            order.status = 'completed'
            toast.show({ title: '已确认收货' })
          }
        }
      })
    },
    reviewOrder(order) {
      toast.show({ title: '跳转到评价页面' })
    },
    viewDetail(order) {
      toast.show({ title: '查看订单详情' })
    },
    goToMall() {
      this.$router.push('/customer/mall')
    },
    goBack() {
      this.$router.push('/customer/dashboard')
    }
  }
}
</script>

<style scoped>
.order-list {
  min-height: 100vh;
  background-color: #f5f5f5;
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

.order-tabs {
  display: flex;
  background-color: #fff;
  margin-bottom: 10px;
}

.tab {
  flex: 1;
  padding: 15px 10px;
  font-size: 14px;
  color: #666;
  text-align: center;
  cursor: pointer;
  border-bottom: 2px solid transparent;
}

.tab.active {
  color: #ff6b81;
  border-bottom-color: #ff6b81;
  font-weight: bold;
}

.order-content {
  padding: 15px;
}

.order-item {
  background-color: #fff;
  border-radius: 8px;
  padding: 15px;
  margin-bottom: 15px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.order-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
  padding-bottom: 10px;
  border-bottom: 1px solid #f0f0f0;
}

.order-no {
  font-size: 12px;
  color: #999;
}

.order-status {
  font-size: 14px;
  font-weight: bold;
}

.order-status.pending {
  color: #FF9800;
}

.order-status.paid {
  color: #2196F3;
}

.order-status.shipped {
  color: #9C27B0;
}

.order-status.completed {
  color: #4CAF50;
}

.order-products {
  margin-bottom: 15px;
}

.product-item {
  display: flex;
  align-items: center;
  padding: 10px 0;
  border-bottom: 1px solid #f5f5f5;
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

.order-footer {
  padding-top: 15px;
  border-top: 1px solid #f0f0f0;
}

.order-info {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}

.order-time {
  font-size: 12px;
  color: #999;
}

.order-total {
  font-size: 12px;
  color: #666;
}

.total-price {
  font-size: 14px;
  color: #ff6b81;
  font-weight: bold;
  margin-left: 5px;
}

.order-actions {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}

.order-actions button {
  padding: 6px 12px;
  border: none;
  border-radius: 4px;
  font-size: 12px;
  cursor: pointer;
}

.btn-cancel {
  background-color: #f5f5f5;
  color: #666;
}

.btn-pay,
.btn-confirm,
.btn-review {
  background-color: #ff6b81;
  color: #fff;
}

.btn-detail {
  background-color: #fff;
  color: #333;
  border: 1px solid #ddd;
}

.empty-orders {
  text-align: center;
  padding: 60px 20px;
  background-color: #fff;
  border-radius: 8px;
}

.empty-icon {
  font-size: 48px;
  margin-bottom: 20px;
}

.empty-orders p {
  font-size: 14px;
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
</style>
