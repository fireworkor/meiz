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
      // 验证产品选择
      if (!this.form.productId) {
        if (typeof uni !== 'undefined') {
          uni.showToast({ title: '请选择产品', icon: 'none' })
        } else {
          alert('请选择产品')
        }
        return
      }
      
      // 验证数量
      if (!this.form.quantity || isNaN(this.form.quantity) || this.form.quantity <= 0) {
        if (typeof uni !== 'undefined') {
          uni.showToast({ title: '请输入有效的数量', icon: 'none' })
        } else {
          alert('请输入有效的数量')
        }
        return
      }
      
      // 验证批次号
      if (!this.form.batchNumber) {
        if (typeof uni !== 'undefined') {
          uni.showToast({ title: '请输入批次号', icon: 'none' })
        } else {
          alert('请输入批次号')
        }
        return
      }
      
      // 验证供应商
      if (!this.form.supplier) {
        if (typeof uni !== 'undefined') {
          uni.showToast({ title: '请输入供应商', icon: 'none' })
        } else {
          alert('请输入供应商')
        }
        return
      }
      
      // 验证效期
      if (this.form.expiryDate) {
        const expiryDate = new Date(this.form.expiryDate)
        const today = new Date()
        today.setHours(0, 0, 0, 0)
        if (expiryDate < today) {
          if (typeof uni !== 'undefined') {
            uni.showToast({ title: '效期应在未来', icon: 'none' })
          } else {
            alert('效期应在未来')
          }
          return
        }
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
          if (typeof uni !== 'undefined') {
            uni.showToast({ title: '入库成功', icon: 'success' })
            // 延迟跳转，让用户看到成功提示
            setTimeout(() => {
              this.$router.push('/admin/inventory/list')
            }, 1500)
          } else {
            alert('入库成功')
            this.$router.push('/admin/inventory/list')
          }
        } else {
          if (typeof uni !== 'undefined') {
            uni.showToast({ title: '入库失败', icon: 'none' })
          } else {
            alert('入库失败')
          }
        }
      } catch (error) {
        console.error('入库失败:', error)
        if (typeof uni !== 'undefined') {
          uni.showToast({ title: '入库失败，请重试', icon: 'none' })
        } else {
          alert('入库失败，请重试')
        }
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