<template>
  <div class="inventory-edit">
    <header class="header">
      <h1>编辑库存</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="form-container" v-if="!loading && inventory">
      <div class="form-group">
        <label>产品</label>
        <select v-model="form.productId" disabled>
          <option value="">请选择产品</option>
          <option v-for="product in products" :key="product.id" :value="product.id">
            {{ product.name }} - ¥{{ product.price }}
          </option>
        </select>
      </div>

      <div class="form-group">
        <label>库存数量</label>
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

      <button class="submit-btn" @click="handleSubmit" :disabled="submitting">
        {{ submitting ? '提交中...' : '保存' }}
      </button>
    </div>

    <div class="loading-container" v-if="loading">
      <div class="loading-text">加载中...</div>
    </div>

    <div class="error-container" v-if="!loading && !inventory">
      <div class="error-text">库存记录不存在</div>
    </div>
  </div>
</template>

<script>
import { inventoryAPI, productAPI } from '../../../api/index'

export default {
  name: 'InventoryEdit',
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
      inventory: null,
      loading: false,
      submitting: false
    }
  },
  mounted() {
    this.loadProducts()
    this.loadInventory()
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
    async loadInventory() {
      const inventoryId = this.$route.query.id
      if (!inventoryId) {
        this.showError('缺少库存记录ID')
        return
      }

      this.loading = true
      try {
        const response = await inventoryAPI.getById(inventoryId)
        if (response) {
          this.inventory = response
          this.form.productId = response.product ? response.product.id : ''
          this.form.quantity = response.quantity
          this.form.batchNumber = response.batchNumber || ''
          this.form.supplier = response.supplier || ''
          this.form.expiryDate = response.expiryDate ? this.formatDateForInput(response.expiryDate) : ''
        } else {
          this.showError('库存记录不存在')
        }
      } catch (error) {
        console.error('加载库存记录失败:', error)
        this.showError('加载库存记录失败')
      } finally {
        this.loading = false
      }
    },
    formatDateForInput(dateString) {
      if (!dateString) return ''
      const date = new Date(dateString)
      return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`
    },
    showError(message) {
      if (typeof uni !== 'undefined') {
        uni.showToast({ title: message, icon: 'none' })
      } else {
        alert(message)
      }
    },
    async handleSubmit() {
      if (!this.form.productId) {
        this.showError('请选择产品')
        return
      }

      if (!this.form.quantity || isNaN(this.form.quantity) || this.form.quantity < 0) {
        this.showError('请输入有效的数量')
        return
      }

      if (!this.form.batchNumber) {
        this.showError('请输入批次号')
        return
      }

      if (!this.form.supplier) {
        this.showError('请输入供应商')
        return
      }

      this.submitting = true
      try {
        const requestData = {
          productId: parseInt(this.form.productId),
          quantity: this.form.quantity,
          batchNumber: this.form.batchNumber,
          supplier: this.form.supplier,
          expiryDate: this.form.expiryDate || null
        }
        const response = await inventoryAPI.update(this.inventory.id, requestData)
        if (response.id) {
          if (typeof uni !== 'undefined') {
            uni.showToast({ title: '保存成功', icon: 'success' })
            setTimeout(() => {
              this.$router.push('/admin/inventory/list')
            }, 1500)
          } else {
            alert('保存成功')
            this.$router.push('/admin/inventory/list')
          }
        } else {
          this.showError('保存失败')
        }
      } catch (error) {
        console.error('保存失败:', error)
        this.showError('保存失败，请重试')
      } finally {
        this.submitting = false
      }
    },
    goBack() {
      this.$router.push('/admin/inventory/list')
    }
  }
}
</script>

<style scoped>
.inventory-edit {
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

.form-group select:disabled {
  background-color: #f5f5f5;
  color: #999;
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

.loading-container,
.error-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 50vh;
  background-color: #fff;
  margin: 20px;
  border-radius: 8px;
}

.loading-text,
.error-text {
  font-size: 16px;
  color: #666;
}
</style>