<template>
  <div class="inventory-list">
    <header class="header">
      <h1>库存管理</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="toolbar">
      <div class="filter-group">
        <select v-model="filterType" @change="handleFilter">
          <option value="">全部</option>
          <option value="low-stock">低库存预警</option>
          <option value="expiring">效期预警</option>
        </select>
      </div>
      <button class="add-btn" @click="goToAdd">入库</button>
    </div>

    <div class="inventory-container">
      <div v-for="item in filteredInventories" :key="item.id" class="inventory-item">
        <div class="inventory-header">
          <h3>{{ item.product ? item.product.name : '' }}</h3>
          <span :class="['status-badge', getStatusClass(item)]">
            {{ getStatusText(item) }}
          </span>
        </div>
        <div class="inventory-info">
          <div class="info-row">
            <span class="label">库存数量：</span>
            <span class="value" :class="{ 'low-stock': item.quantity < 10 }">{{ item.quantity }}</span>
          </div>
          <div class="info-row">
            <span class="label">批次号：</span>
            <span class="value">{{ item.batchNumber || '-' }}</span>
          </div>
          <div class="info-row">
            <span class="label">供应商：</span>
            <span class="value">{{ item.supplier || '-' }}</span>
          </div>
          <div class="info-row">
            <span class="label">效期：</span>
            <span class="value" :class="{ 'expiring': isExpiring(item) }">
              {{ item.expiryDate ? formatDate(item.expiryDate) : '-' }}
            </span>
          </div>
        </div>
        <div class="inventory-actions">
          <button class="edit-btn" @click="editInventory(item)">编辑</button>
          <button class="delete-btn" @click="deleteInventory(item)">删除</button>
        </div>
      </div>
      <div v-if="filteredInventories.length === 0" class="empty">
        <div class="empty-icon">📦</div>
        <p>暂无库存记录</p>
      </div>
    </div>
  </div>
</template>

<script>
import { inventoryAPI } from '../../../api/index'

export default {
  name: 'InventoryList',
  data() {
    return {
      inventories: [],
      filterType: '',
      loading: false
    }
  },
  computed: {
    filteredInventories() {
      if (!this.filterType) {
        return this.inventories
      }
      if (this.filterType === 'low-stock') {
        return this.inventories.filter(item => item.quantity < 10)
      }
      if (this.filterType === 'expiring') {
        const thirtyDaysLater = new Date()
        thirtyDaysLater.setDate(thirtyDaysLater.getDate() + 30)
        return this.inventories.filter(item => {
          if (!item.expiryDate) return false
          return new Date(item.expiryDate) < thirtyDaysLater
        })
      }
      return this.inventories
    }
  },
  mounted() {
    this.loadInventories()
  },
  methods: {
    async loadInventories() {
      this.loading = true
      try {
        const response = await inventoryAPI.getAll()
        if (Array.isArray(response)) {
          this.inventories = response
        }
      } catch (error) {
        console.error('加载库存列表失败:', error)
        if (typeof uni !== 'undefined') {
          uni.showToast({ title: '加载库存列表失败', icon: 'none' })
        } else {
          alert('加载库存列表失败')
        }
      } finally {
        this.loading = false
      }
    },
    formatDate(date) {
      if (!date) return ''
      const d = new Date(date)
      return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
    },
    isExpiring(item) {
      if (!item.expiryDate) return false
      const thirtyDaysLater = new Date()
      thirtyDaysLater.setDate(thirtyDaysLater.getDate() + 30)
      return new Date(item.expiryDate) < thirtyDaysLater
    },
    getStatusClass(item) {
      if (item.quantity < 10) return 'status-low'
      if (this.isExpiring(item)) return 'status-expiring'
      return 'status-normal'
    },
    getStatusText(item) {
      if (item.quantity < 10) return '低库存'
      if (this.isExpiring(item)) return '效期预警'
      return '正常'
    },
    handleFilter() {
      // 筛选由computed属性处理
    },
    goBack() {
      this.$router.push('/admin/dashboard')
    },
    goToAdd() {
      this.$router.push('/admin/inventory/add')
    },
    editInventory(item) {
      this.$router.push({
        path: '/admin/inventory/edit',
        query: { id: item.id }
      })
    },
    async deleteInventory(item) {
      if (typeof uni !== 'undefined') {
        uni.showModal({
          title: '确认删除',
          content: '确定要删除这个库存记录吗？',
          success: async (res) => {
            if (res.confirm) {
              try {
                await inventoryAPI.delete(item.id)
                this.loadInventories()
                if (typeof uni !== 'undefined') {
                  uni.showToast({ title: '删除成功', icon: 'success' })
                }
              } catch (error) {
                console.error('删除库存失败:', error)
                if (typeof uni !== 'undefined') {
                  uni.showToast({ title: '删除失败，请重试', icon: 'none' })
                }
              }
            }
          }
        })
      } else {
        if (!confirm('确定要删除这个库存记录吗？')) {
          return
        }

        try {
          await inventoryAPI.delete(item.id)
          this.loadInventories()
          alert('删除成功')
        } catch (error) {
          alert('删除失败')
        }
      }
    }
  }
}
</script>

<style scoped>
.inventory-list {
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

.back-btn,
.add-btn {
  padding: 8px 16px;
  background-color: #ff6b81;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px 20px;
  background-color: #fff;
  margin-bottom: 10px;
}

.filter-group select {
  padding: 8px 16px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.inventory-container {
  padding: 20px;
}

.inventory-item {
  background-color: #fff;
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 15px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.inventory-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
  padding-bottom: 15px;
  border-bottom: 1px solid #eee;
}

.inventory-header h3 {
  font-size: 16px;
  color: #333;
  margin: 0;
}

.status-badge {
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
}

.status-normal {
  background-color: #E8F5E9;
  color: #4CAF50;
}

.status-low {
  background-color: #FFEBEE;
  color: #F44336;
}

.status-expiring {
  background-color: #FFF3E0;
  color: #FF9800;
}

.inventory-info {
  margin-bottom: 15px;
}

.info-row {
  display: flex;
  justify-content: space-between;
  margin-bottom: 8px;
}

.info-row .label {
  font-size: 14px;
  color: #666;
}

.info-row .value {
  font-size: 14px;
  color: #333;
}

.info-row .value.low-stock {
  color: #F44336;
  font-weight: bold;
}

.info-row .value.expiring {
  color: #FF9800;
  font-weight: bold;
}

.inventory-actions {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  padding-top: 15px;
  border-top: 1px solid #eee;
}

.edit-btn {
  padding: 8px 20px;
  background-color: #2196F3;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.delete-btn {
  padding: 8px 20px;
  background-color: #F44336;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 14px;
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
</style>