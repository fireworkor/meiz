<template>
  <div class="inventory-add">
    <header class="header">
      <h1>入库</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="form-container">
      <div class="form-group">
        <label>产品</label>
        <select v-model="form.productId">
          <option value="">请选择产品</option>
          <option v-for="product in products" :key="product.id" :value="product.id">
            {{ product.name }} - ¥{{ product.price }}
          </option>
        </select>
      </div>

      <div class="form-group">
        <label>数量</label>
        <input type="number" v-model.number="form.quantity" placeholder="请输入数量">
      </div>

      <div class="form-group">
        <label>批次号</label>
        <input type="text" v-model="form.batchNumber" placeholder="请输入批次号">
      </div>

      <div class="form-group">
        <label>供应商</label>
        <input type="text" v-model="form.supplier" placeholder="请输入供应商">
      </div>

      <div class="form-group">
        <label>效期</label>
        <input type="date" v-model="form.expiryDate">
      </div>

      <button class="submit-btn" @click="handleSubmit" :disabled="loading">
        {{ loading ? '提交中...' : '入库' }}
      </button>
    </div>
  </div>
</template>

<script>
import { inventoryAPI, productAPI } from '../../../api/index'

export default {
  name: 'InventoryAdd',
  data() {
    return {
      form: {
        productId: '',
        quantity: 0,
        batchNumber: '',
        supplier: '',
        expiryDate: ''
      },
      products: [],
      loading: false
    }
  },
  mounted() {
    this.loadProducts()
  },
  methods: {
    async loadProducts() {
      try {
        const response = await productAPI.getAll()
        if (Array.isArray(response)) {
          this.products = response
        }
      } catch (error) {
        console.error('加载产品列表失败:', error)
      }
    },
    async handleSubmit() {
      if (!this.form.productId || !this.form.quantity) {
        alert('请填写必填项')
        return
      }

      this.loading = true
      try {
        const requestData = {
          productId: parseInt(this.form.productId),
          quantity: this.form.quantity,
          batchNumber: this.form.batchNumber,
          supplier: this.form.supplier,
          expiryDate: this.form.expiryDate || null
        }
        const response = await inventoryAPI.addStock(requestData)
        if (response.id) {
          alert('入库成功')
          this.$router.push('/admin/inventory/list')
        }
      } catch (error) {
        alert('入库失败')
      } finally {
        this.loading = false
      }
    },
    goBack() {
      this.$router.push('/admin/inventory/list')
    }
  }
}
</script>

<style scoped>
.inventory-add {
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
  background-color: #fff;
  padding: 20px;
  margin: 20px;
  border-radius: 8px;
}

.form-group {
  margin-bottom: 20px;
}

.form-group label {
  display: block;
  margin-bottom: 8px;
  font-size: 14px;
  color: #666;
}

.form-group input,
.form-group select {
  width: 100%;
  padding: 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
  box-sizing: border-box;
}

.submit-btn {
  width: 100%;
  padding: 14px;
  background-color: #ff6b81;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 16px;
  cursor: pointer;
}

.submit-btn:disabled {
  background-color: #ccc;
  cursor: not-allowed;
}
</style>