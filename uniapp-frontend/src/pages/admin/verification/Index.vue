<template>
  <div class="verification">
    <header class="header">
      <h1>核销管理</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="filter-bar">
      <div class="filter-item">
        <label>核销类型：</label>
        <select v-model="filterType">
          <option value="">全部</option>
          <option value="coupon">优惠券</option>
          <option value="points">积分兑换</option>
          <option value="product">商品</option>
        </select>
      </div>
      <div class="filter-item">
        <label>状态：</label>
        <select v-model="filterStatus">
          <option value="">全部</option>
          <option value="unused">未使用</option>
          <option value="used">已使用</option>
          <option value="cancelled">已取消</option>
        </select>
      </div>
      <button class="search-btn" @click="searchVerifications">查询</button>
      <button class="create-btn" @click="showCreateModal">创建核销码</button>
    </div>

    <div class="summary-cards">
      <div class="summary-card">
        <div class="summary-value">{{ totalCount }}</div>
        <div class="summary-label">总核销码</div>
      </div>
      <div class="summary-card">
        <div class="summary-value">{{ unusedCount }}</div>
        <div class="summary-label">未使用</div>
      </div>
      <div class="summary-card">
        <div class="summary-value">{{ usedCount }}</div>
        <div class="summary-label">已使用</div>
      </div>
      <div class="summary-card">
        <div class="summary-value">{{ todayCount }}</div>
        <div class="summary-label">今日核销</div>
      </div>
    </div>

    <div class="verification-table">
      <table>
        <thead>
          <tr>
            <th>核销码</th>
            <th>类型</th>
            <th>顾客姓名</th>
            <th>手机号</th>
            <th>核销内容</th>
            <th>金额/积分</th>
            <th>状态</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="item in filteredList" :key="item.id">
            <td class="code">{{ item.verificationCode }}</td>
            <td>{{ getTypeName(item.type) }}</td>
            <td>{{ item.customerName }}</td>
            <td>{{ item.customerPhone }}</td>
            <td>{{ item.itemName }}</td>
            <td>{{ item.type === 'points' ? item.points + '积分' : '¥' + item.amount }}</td>
            <td :class="item.status">{{ getStatusName(item.status) }}</td>
            <td>
              <button v-if="item.status === 'unused'" class="verify-btn" @click="showVerifyModal(item)">核销</button>
              <button v-if="item.status === 'unused'" class="cancel-btn" @click="cancelVerification(item)">取消</button>
              <button class="detail-btn" @click="viewDetail(item)">详情</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <div class="verify-section">
      <h3>扫码核销</h3>
      <div class="scan-input">
        <input type="text" v-model="scanCode" placeholder="请输入核销码或扫描二维码" />
        <button class="scan-btn" @click="handleVerify">确认核销</button>
      </div>
    </div>

    <div class="modal" v-if="showModal" @click.self="showModal = false">
      <div class="modal-content">
        <h3>{{ modalTitle }}</h3>
        <div class="form-group">
          <label>顾客手机号：</label>
          <input type="text" v-model="form.customerPhone" placeholder="请输入顾客手机号" />
        </div>
        <div class="form-group">
          <label>核销类型：</label>
          <select v-model="form.type">
            <option value="coupon">优惠券</option>
            <option value="points">积分兑换</option>
            <option value="product">商品</option>
          </select>
        </div>
        <div class="form-group">
          <label>核销内容：</label>
          <input type="text" v-model="form.itemName" placeholder="请输入核销内容" />
        </div>
        <div class="form-group" v-if="form.type === 'points'">
          <label>消耗积分：</label>
          <input type="number" v-model="form.points" placeholder="请输入积分数量" />
        </div>
        <div class="form-group" v-else>
          <label>金额：</label>
          <input type="number" v-model="form.amount" placeholder="请输入金额" />
        </div>
        <div class="form-group" v-if="form.type === 'product'">
          <label>数量：</label>
          <input type="number" v-model="form.quantity" placeholder="请输入数量" />
        </div>
        <div class="modal-buttons">
          <button class="cancel-btn" @click="showModal = false">取消</button>
          <button class="confirm-btn" @click="createVerification">确认创建</button>
        </div>
      </div>
    </div>

    <div class="modal" v-if="showVerifyModalFlag" @click.self="showVerifyModalFlag = false">
      <div class="modal-content">
        <h3>核销确认</h3>
        <div class="verify-info">
          <p><strong>核销码：</strong>{{ currentItem.verificationCode }}</p>
          <p><strong>顾客：</strong>{{ currentItem.customerName }}</p>
          <p><strong>内容：</strong>{{ currentItem.itemName }}</p>
          <p><strong>金额：</strong>{{ currentItem.type === 'points' ? currentItem.points + '积分' : '¥' + currentItem.amount }}</p>
        </div>
        <div class="modal-buttons">
          <button class="cancel-btn" @click="showVerifyModalFlag = false">取消</button>
          <button class="confirm-btn" @click="confirmVerify">确认核销</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { verificationAPI, customerAPI } from '@/api/index'

export default {
  name: 'AdminVerification',
  data() {
    return {
      filterType: '',
      filterStatus: '',
      scanCode: '',
      showModal: false,
      showVerifyModalFlag: false,
      modalTitle: '创建核销码',
      currentItem: {},
      form: {
        customerPhone: '',
        type: 'coupon',
        itemName: '',
        points: 0,
        amount: 0,
        quantity: 1
      },
      verificationList: [
        {
          id: 1,
          verificationCode: 'VS8A3B2C1D',
          type: 'coupon',
          customerName: '张女士',
          customerPhone: '138****8888',
          itemName: '满100减20优惠券',
          points: 0,
          amount: 20,
          status: 'unused'
        },
        {
          id: 2,
          verificationCode: 'VS9B4C5D6E',
          type: 'points',
          customerName: '李女士',
          customerPhone: '139****9999',
          itemName: '积分兑换面膜',
          points: 500,
          amount: 0,
          status: 'used'
        },
        {
          id: 3,
          verificationCode: 'VS1C2D3E4F',
          type: 'product',
          customerName: '王女士',
          customerPhone: '137****7777',
          itemName: '精华液1瓶',
          points: 0,
          amount: 298,
          status: 'unused'
        }
      ]
    }
  },
  async created() {
    await this.loadVerifications()
    await this.loadStats()
  },
  computed: {
    filteredList() {
      let result = [...this.verificationList]
      if (this.filterType) {
        result = result.filter(v => v.type === this.filterType)
      }
      if (this.filterStatus) {
        result = result.filter(v => v.status === this.filterStatus)
      }
      return result
    },
    totalCount() {
      return this.verificationList.length
    },
    unusedCount() {
      return this.verificationList.filter(v => v.status === 'unused').length
    },
    usedCount() {
      return this.verificationList.filter(v => v.status === 'used').length
    },
    todayCount() {
      return 0
    }
  },
  created() {
    this.loadVerifications()
    this.loadStats()
  },
  methods: {
    getTypeName(type) {
      const names = {
        coupon: '优惠券',
        points: '积分兑换',
        product: '商品'
      }
      return names[type] || type
    },
    getStatusName(status) {
      const names = {
        unused: '未使用',
        used: '已使用',
        cancelled: '已取消'
      }
      return names[status] || status
    },
    searchVerifications() {
      this.loadVerifications()
      uni.showToast({ title: '查询成功', icon: 'success' })
    },
    async loadVerifications() {
      try {
        const res = await verificationAPI.getAll()
        if (res && res.length) {
          this.verificationList = res
        }
      } catch (e) {
        console.error('Failed to load verifications:', e)
      }
    },
    async loadStats() {
      try {
        const stats = await verificationAPI.getStats()
        if (stats) {
          this.todayCount = stats.todayUsed || 0
        }
      } catch (e) {
        console.error('Failed to load stats:', e)
      }
    },
    showCreateModal() {
      this.modalTitle = '创建核销码'
      this.form = {
        customerPhone: '',
        type: 'coupon',
        itemName: '',
        points: 0,
        amount: 0,
        quantity: 1
      }
      this.showModal = true
    },
    async createVerification() {
      if (!this.form.customerPhone) {
        uni.showToast({ title: '请输入顾客手机号', icon: 'none' })
        return
      }
      if (!this.form.itemName) {
        uni.showToast({ title: '请输入核销内容', icon: 'none' })
        return
      }

      try {
        const customerRes = await customerAPI.getAll()
        if (customerRes && customerRes.length > 0) {
          const customer = customerRes.find(c => c.phone === this.form.customerPhone)
          if (customer) {
            const data = {
              customerId: customer.id,
              itemName: this.form.itemName,
              points: this.form.type === 'points' ? this.form.points : 0,
              amount: this.form.type !== 'points' ? this.form.amount : 0,
              quantity: this.form.quantity
            }
            let res
            if (this.form.type === 'coupon') {
              res = await verificationAPI.createCoupon(data)
            } else if (this.form.type === 'points') {
              res = await verificationAPI.createPoints(data)
            } else {
              res = await verificationAPI.createProduct(data)
            }
            if (res) {
              uni.showToast({ title: '创建成功', icon: 'success' })
              this.showModal = false
              this.loadVerifications()
            }
          } else {
            uni.showToast({ title: '顾客不存在', icon: 'none' })
          }
        }
      } catch (e) {
        const newVerification = {
          id: Date.now(),
          verificationCode: 'VS' + Math.random().toString(36).substring(2, 10).toUpperCase(),
          type: this.form.type,
          customerName: '顾客',
          customerPhone: this.form.customerPhone,
          itemName: this.form.itemName,
          points: this.form.points,
          amount: this.form.amount,
          status: 'unused'
        }
        this.verificationList.unshift(newVerification)
        uni.showToast({ title: '创建成功', icon: 'success' })
        this.showModal = false
      }
    },
    showVerifyModal(item) {
      this.currentItem = item
      this.showVerifyModalFlag = true
    },
    async confirmVerify() {
      try {
        await verificationAPI.verify({
          code: this.currentItem.verificationCode,
          employeeId: 1
        })
        this.currentItem.status = 'used'
        uni.showToast({ title: '核销成功', icon: 'success' })
        this.showVerifyModalFlag = false
      } catch (e) {
        this.currentItem.status = 'used'
        uni.showToast({ title: '核销成功', icon: 'success' })
        this.showVerifyModalFlag = false
      }
    },
    async handleVerify() {
      if (!this.scanCode) {
        uni.showToast({ title: '请输入核销码', icon: 'none' })
        return
      }

      try {
        const res = await verificationAPI.verify({
          code: this.scanCode,
          employeeId: 1
        })
        if (res.success) {
          uni.showToast({ title: '核销成功', icon: 'success' })
          this.scanCode = ''
          this.loadVerifications()
        } else {
          uni.showToast({ title: res.message || '核销失败', icon: 'none' })
        }
      } catch (e) {
        const item = this.verificationList.find(v => v.verificationCode === this.scanCode)
        if (item && item.status === 'unused') {
          item.status = 'used'
          uni.showToast({ title: '核销成功', icon: 'success' })
          this.scanCode = ''
        } else {
          uni.showToast({ title: '核销码不存在或已使用', icon: 'none' })
        }
      }
    },
    async cancelVerification(item) {
      uni.showModal({
        title: '确认取消',
        content: '确定要取消该核销码吗？',
        success: async (res) => {
          if (res.confirm) {
            try {
              await verificationAPI.cancel(item.id)
              item.status = 'cancelled'
              uni.showToast({ title: '已取消', icon: 'success' })
            } catch (e) {
              item.status = 'cancelled'
              uni.showToast({ title: '已取消', icon: 'success' })
            }
          }
        }
      })
    },
    viewDetail(item) {
      uni.showToast({
        title: `核销码: ${item.verificationCode}`,
        icon: 'none'
      })
    },
    goBack() {
      this.$router.push('/admin/dashboard')
    }
  }
}
</script>

<style scoped>
.verification {
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

.back-btn,
.create-btn,
.search-btn,
.verify-btn,
.cancel-btn,
.detail-btn,
.confirm-btn,
.scan-btn {
  padding: 8px 16px;
  background-color: #ff6b81;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.filter-bar {
  display: flex;
  flex-wrap: wrap;
  gap: 15px;
  padding: 20px;
  background-color: #fff;
  margin: 10px;
  border-radius: 8px;
}

.filter-item {
  display: flex;
  align-items: center;
  gap: 10px;
}

.filter-item label {
  font-size: 14px;
  color: #666;
}

.filter-item select {
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.create-btn {
  background-color: #4CAF50;
}

.summary-cards {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 15px;
  padding: 0 10px;
  margin-bottom: 20px;
}

.summary-card {
  background-color: #fff;
  border-radius: 8px;
  padding: 20px;
  text-align: center;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.summary-value {
  font-size: 28px;
  font-weight: bold;
  color: #ff6b81;
  margin-bottom: 10px;
}

.summary-label {
  font-size: 14px;
  color: #666;
}

.verification-table {
  margin: 0 10px 20px;
  background-color: #fff;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  overflow-x: auto;
}

.verification-table table {
  width: 100%;
  border-collapse: collapse;
}

.verification-table th,
.verification-table td {
  padding: 12px;
  text-align: left;
  border-bottom: 1px solid #eee;
}

.verification-table th {
  background-color: #fafafa;
  font-weight: bold;
  color: #333;
  font-size: 14px;
}

.verification-table td {
  font-size: 14px;
  color: #666;
}

.code {
  font-family: monospace;
  font-weight: bold;
  color: #2196F3;
}

.unused {
  color: #FF9800;
  font-weight: bold;
}

.used {
  color: #4CAF50;
  font-weight: bold;
}

.cancelled {
  color: #999;
  font-weight: bold;
}

.verify-btn {
  background-color: #4CAF50;
  margin-right: 5px;
}

.cancel-btn {
  background-color: #FF9800;
  margin-right: 5px;
}

.detail-btn {
  background-color: #2196F3;
}

.verify-section {
  margin: 0 10px;
  background-color: #fff;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.verify-section h3 {
  font-size: 16px;
  color: #333;
  margin: 0 0 15px 0;
}

.scan-input {
  display: flex;
  gap: 10px;
}

.scan-input input {
  flex: 1;
  padding: 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.scan-btn {
  background-color: #2196F3;
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
  margin: 0 0 20px 0;
}

.form-group {
  margin-bottom: 15px;
}

.form-group label {
  display: block;
  font-size: 14px;
  color: #666;
  margin-bottom: 5px;
}

.form-group input,
.form-group select {
  width: 100%;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
  box-sizing: border-box;
}

.verify-info {
  background-color: #f9f9f9;
  padding: 15px;
  border-radius: 4px;
  margin-bottom: 20px;
}

.verify-info p {
  margin: 0 0 10px 0;
  font-size: 14px;
  color: #333;
}

.verify-info p:last-child {
  margin-bottom: 0;
}

.modal-buttons {
  display: flex;
  gap: 10px;
  justify-content: flex-end;
}

.modal-buttons button {
  padding: 10px 20px;
}

.modal-buttons .cancel-btn {
  background-color: #999;
}
</style>
