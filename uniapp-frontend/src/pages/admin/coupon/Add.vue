<template>
  <div class="coupon-add">
    <header class="header">
      <h1>发放卡券</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="form-container">
      <div class="form-group">
        <label>卡券名称</label>
        <input type="text" v-model="form.name" placeholder="请输入卡券名称" />
      </div>

      <div class="form-group">
        <label>卡券类型</label>
        <select v-model="form.type">
          <option value="">请选择类型</option>
          <option value="满减券">满减券</option>
          <option value="折扣券">折扣券</option>
          <option value="礼品券">礼品券</option>
        </select>
      </div>

      <div class="form-group" v-if="form.type === '满减券'">
        <label>优惠金额</label>
        <input type="number" v-model="form.discountAmount" placeholder="请输入优惠金额" />
      </div>

      <div class="form-group" v-if="form.type === '满减券'">
        <label>满减条件（最低消费）</label>
        <input type="number" v-model="form.minAmount" placeholder="请输入最低消费金额" />
      </div>

      <div class="form-group" v-if="form.type === '折扣券'">
        <label>折扣率</label>
        <input type="number" step="0.1" v-model="form.discountRate" placeholder="请输入折扣率（如：0.8 表示8折）" />
      </div>

      <div class="form-group">
        <label>有效期至</label>
        <input type="date" v-model="form.expiryDate" />
      </div>

      <div class="form-group">
        <label>关联客户</label>
        <select v-model="form.customerId">
          <option value="">请选择客户</option>
          <option v-for="customer in customers" :key="customer.id" :value="customer.id">
            {{ customer.name }} - {{ customer.phone }}
          </option>
        </select>
      </div>

      <div class="form-group">
        <label>备注</label>
        <textarea v-model="form.remark" placeholder="请输入备注信息" rows="3"></textarea>
      </div>

      <div class="form-actions">
        <button class="submit-btn" @click="handleSubmit">确认发放</button>
      </div>
    </div>
  </div>
</template>

<script>
import { couponAPI, customerAPI } from '../../../api/index'

export default {
  name: 'CouponAdd',
  data() {
    return {
      form: {
        name: '',
        type: '',
        discountAmount: null,
        discountRate: null,
        minAmount: null,
        expiryDate: '',
        customerId: '',
        remark: ''
      },
      customers: []
    }
  },
  mounted() {
    this.loadCustomers()
  },
  methods: {
    async loadCustomers() {
      try {
        const response = await customerAPI.getAll()
        if (Array.isArray(response)) {
          this.customers = response
        }
      } catch (error) {
        console.error('加载客户列表失败:', error)
      }
    },
    async handleSubmit() {
      if (!this.form.name) {
        uni.showToast({ title: '请输入卡券名称', icon: 'none' })
        return
      }
      if (!this.form.type) {
        uni.showToast({ title: '请选择卡券类型', icon: 'none' })
        return
      }
      if (!this.form.expiryDate) {
        uni.showToast({ title: '请选择有效期', icon: 'none' })
        return
      }
      if (!this.form.customerId) {
        uni.showToast({ title: '请选择关联客户', icon: 'none' })
        return
      }

      try {
        const submitData = { ...this.form }
        if (submitData.type !== '满减券') {
          submitData.discountAmount = null
          submitData.minAmount = null
        }
        if (submitData.type !== '折扣券') {
          submitData.discountRate = null
        }

        await couponAPI.create(submitData)
        uni.showToast({ title: '发放成功', icon: 'success' })
        setTimeout(() => {
          this.$router.push('/admin/coupon/list')
        }, 1500)
      } catch (error) {
        console.error('发放卡券失败:', error)
        uni.showToast({ title: '发放失败', icon: 'none' })
      }
    },
    goBack() {
      this.$router.push('/admin/coupon/list')
    }
  }
}
</script>

<style scoped>
.coupon-add {
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

.form-container {
  padding: 20px;
}

.form-group {
  background-color: #fff;
  border-radius: 8px;
  padding: 15px;
  margin-bottom: 15px;
}

.form-group label {
  display: block;
  font-size: 14px;
  color: #666;
  margin-bottom: 10px;
}

.form-group input,
.form-group select,
.form-group textarea {
  width: 100%;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
  box-sizing: border-box;
}

.form-group textarea {
  resize: vertical;
}

.form-actions {
  padding: 20px;
}

.submit-btn {
  width: 100%;
  padding: 15px;
  background-color: #ff6b81;
  color: #fff;
  border: none;
  border-radius: 8px;
  font-size: 16px;
  cursor: pointer;
}
</style>
