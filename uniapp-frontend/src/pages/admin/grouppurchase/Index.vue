<template>
  <div class="group-purchase">
    <header class="header">
      <h1>团购管理</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="filter-bar">
      <div class="filter-item">
        <label>状态：</label>
        <select v-model="filterStatus">
          <option value="">全部</option>
          <option value="active">进行中</option>
          <option value="pending">待开始</option>
          <option value="ended">已结束</option>
          <option value="sold_out">已售罄</option>
        </select>
      </div>
      <div class="filter-item">
        <label>分类：</label>
        <select v-model="filterCategory">
          <option value="">全部分类</option>
          <option value="beauty">美容美体</option>
          <option value="spa">SPA养生</option>
          <option value="hair">美发造型</option>
          <option value="nail">美甲彩妆</option>
        </select>
      </div>
      <button class="search-btn" @click="searchGroupPurchases">查询</button>
      <button class="create-btn" @click="showCreateModal">添加团购</button>
    </div>

    <div class="summary-cards">
      <div class="summary-card">
        <div class="summary-value">{{ stats.total }}</div>
        <div class="summary-label">总团购数</div>
      </div>
      <div class="summary-card">
        <div class="summary-value">{{ stats.active }}</div>
        <div class="summary-label">进行中</div>
      </div>
      <div class="summary-card">
        <div class="summary-value">{{ stats.totalSold }}</div>
        <div class="summary-label">总已售</div>
      </div>
      <div class="summary-card">
        <div class="summary-value">{{ stats.totalParticipants }}</div>
        <div class="summary-label">总参与人次</div>
      </div>
    </div>

    <div class="group-purchase-table">
      <table>
        <thead>
          <tr>
            <th>团购名称</th>
            <th>原价</th>
            <th>团购价</th>
            <th>成团人数</th>
            <th>已参与</th>
            <th>已售</th>
            <th>库存</th>
            <th>状态</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="item in filteredList" :key="item.id">
            <td>{{ item.title }}</td>
            <td>¥{{ item.originalPrice }}</td>
            <td class="group-price">¥{{ item.groupPrice }}</td>
            <td>{{ item.minMembers }}-{{ item.maxMembers }}人</td>
            <td>{{ item.currentMembers }}人</td>
            <td>{{ item.soldCount }}</td>
            <td>{{ item.stock }}</td>
            <td :class="item.status">{{ getStatusName(item.status) }}</td>
            <td>
              <button class="view-btn" @click="viewDetail(item)">详情</button>
              <button class="edit-btn" @click="editGroupPurchase(item)">编辑</button>
              <button class="delete-btn" @click="deleteGroupPurchase(item)">删除</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <div class="modal" v-if="showModal" @click.self="showModal = false">
      <div class="modal-content">
        <h3>{{ modalTitle }}</h3>
        <div class="form-group">
          <label>团购标题：</label>
          <input type="text" v-model="form.title" placeholder="请输入团购标题" />
        </div>
        <div class="form-group">
          <label>副标题：</label>
          <input type="text" v-model="form.subtitle" placeholder="请输入副标题" />
        </div>
        <div class="form-row">
          <div class="form-group">
            <label>原价：</label>
            <input type="number" v-model="form.originalPrice" placeholder="原价" />
          </div>
          <div class="form-group">
            <label>团购价：</label>
            <input type="number" v-model="form.groupPrice" placeholder="团购价" />
          </div>
        </div>
        <div class="form-row">
          <div class="form-group">
            <label>最低成团人数：</label>
            <input type="number" v-model="form.minMembers" placeholder="最低成团人数" />
          </div>
          <div class="form-group">
            <label>最高人数：</label>
            <input type="number" v-model="form.maxMembers" placeholder="最高人数" />
          </div>
        </div>
        <div class="form-row">
          <div class="form-group">
            <label>库存：</label>
            <input type="number" v-model="form.stock" placeholder="库存" />
          </div>
          <div class="form-group">
            <label>分类：</label>
            <select v-model="form.category">
              <option value="beauty">美容美体</option>
              <option value="spa">SPA养生</option>
              <option value="hair">美发造型</option>
              <option value="nail">美甲彩妆</option>
            </select>
          </div>
        </div>
        <div class="form-group">
          <label>有效期天数：</label>
          <input type="number" v-model="form.validityDays" placeholder="有效期天数" />
        </div>
        <div class="form-group">
          <label>详细描述：</label>
          <textarea v-model="form.details" placeholder="请输入详细描述" rows="4"></textarea>
        </div>
        <div class="modal-buttons">
          <button class="cancel-btn" @click="showModal = false">取消</button>
          <button class="confirm-btn" @click="saveGroupPurchase">保存</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { groupPurchaseAPI } from '@/api/index'

export default {
  name: 'AdminGroupPurchase',
  data() {
    return {
      filterStatus: '',
      filterCategory: '',
      showModal: false,
      modalTitle: '添加团购',
      editingId: null,
      loading: false,
      form: {
        title: '',
        subtitle: '',
        originalPrice: 0,
        groupPrice: 0,
        minMembers: 2,
        maxMembers: 10,
        stock: 100,
        category: 'beauty',
        validityDays: 30,
        details: ''
      },
      groupPurchaseList: []
    }
  },
  mounted() {
    this.loadGroupPurchases()
  },
  computed: {
    filteredList() {
      let result = [...this.groupPurchaseList]
      if (this.filterStatus) {
        result = result.filter(item => item.status === this.filterStatus)
      }
      if (this.filterCategory) {
        result = result.filter(item => item.category === this.filterCategory)
      }
      return result
    },
    stats() {
      return {
        total: this.groupPurchaseList.length,
        active: this.groupPurchaseList.filter(item => item.status === 'active').length,
        totalSold: this.groupPurchaseList.reduce((sum, item) => sum + (item.soldCount || 0), 0),
        totalParticipants: this.groupPurchaseList.reduce((sum, item) => sum + (item.currentMembers || 0), 0)
      }
    }
  },
  methods: {
    async loadGroupPurchases() {
      this.loading = true
      try {
        const response = await groupPurchaseAPI.getAll()
        if (Array.isArray(response)) {
          this.groupPurchaseList = response
        }
      } catch (error) {
        console.error('加载团购列表失败:', error)
        if (typeof uni !== 'undefined') {
          uni.showToast({ title: '加载失败，请重试', icon: 'none' })
        }
      } finally {
        this.loading = false
      }
    },
    getStatusName(status) {
      const names = {
        pending: '待开始',
        active: '进行中',
        ended: '已结束',
        sold_out: '已售罄'
      }
      return names[status] || status
    },
    searchGroupPurchases() {
      // 搜索由computed属性处理
      if (typeof uni !== 'undefined') {
        uni.showToast({ title: '查询成功', icon: 'success' })
      }
    },
    showCreateModal() {
      this.modalTitle = '添加团购'
      this.editingId = null
      this.form = {
        title: '',
        subtitle: '',
        originalPrice: 0,
        groupPrice: 0,
        minMembers: 2,
        maxMembers: 10,
        stock: 100,
        category: 'beauty',
        validityDays: 30,
        details: ''
      }
      this.showModal = true
    },
    editGroupPurchase(item) {
      this.modalTitle = '编辑团购'
      this.editingId = item.id
      this.form = {
        title: item.title,
        subtitle: item.subtitle,
        originalPrice: item.originalPrice,
        groupPrice: item.groupPrice,
        minMembers: item.minMembers,
        maxMembers: item.maxMembers,
        stock: item.stock,
        category: item.category,
        validityDays: item.validityDays,
        details: item.details || ''
      }
      this.showModal = true
    },
    async saveGroupPurchase() {
      // 验证表单
      if (!this.form.title) {
        if (typeof uni !== 'undefined') {
          uni.showToast({ title: '请输入标题', icon: 'none' })
        } else {
          alert('请输入标题')
        }
        return
      }
      
      if (!this.form.originalPrice || isNaN(this.form.originalPrice) || this.form.originalPrice <= 0) {
        if (typeof uni !== 'undefined') {
          uni.showToast({ title: '请输入有效的原价', icon: 'none' })
        } else {
          alert('请输入有效的原价')
        }
        return
      }
      
      if (!this.form.groupPrice || isNaN(this.form.groupPrice) || this.form.groupPrice <= 0) {
        if (typeof uni !== 'undefined') {
          uni.showToast({ title: '请输入有效的团购价', icon: 'none' })
        } else {
          alert('请输入有效的团购价')
        }
        return
      }
      
      if (this.form.groupPrice >= this.form.originalPrice) {
        if (typeof uni !== 'undefined') {
          uni.showToast({ title: '团购价应低于原价', icon: 'none' })
        } else {
          alert('团购价应低于原价')
        }
        return
      }
      
      if (!this.form.minMembers || isNaN(this.form.minMembers) || this.form.minMembers <= 0) {
        if (typeof uni !== 'undefined') {
          uni.showToast({ title: '请输入有效的最少人数', icon: 'none' })
        } else {
          alert('请输入有效的最少人数')
        }
        return
      }
      
      if (!this.form.maxMembers || isNaN(this.form.maxMembers) || this.form.maxMembers <= 0) {
        if (typeof uni !== 'undefined') {
          uni.showToast({ title: '请输入有效的最多人数', icon: 'none' })
        } else {
          alert('请输入有效的最多人数')
        }
        return
      }
      
      if (this.form.minMembers > this.form.maxMembers) {
        if (typeof uni !== 'undefined') {
          uni.showToast({ title: '最少人数应小于等于最多人数', icon: 'none' })
        } else {
          alert('最少人数应小于等于最多人数')
        }
        return
      }
      
      if (!this.form.stock || isNaN(this.form.stock) || this.form.stock < 0) {
        if (typeof uni !== 'undefined') {
          uni.showToast({ title: '请输入有效的库存', icon: 'none' })
        } else {
          alert('请输入有效的库存')
        }
        return
      }
      
      if (this.form.validityDays && (isNaN(this.form.validityDays) || this.form.validityDays <= 0)) {
        if (typeof uni !== 'undefined') {
          uni.showToast({ title: '请输入有效的有效期天数', icon: 'none' })
        } else {
          alert('请输入有效的有效期天数')
        }
        return
      }
      
      try {
        if (this.editingId) {
          // 更新团购
          const response = await groupPurchaseAPI.update(this.editingId, this.form)
          if (response && response.id) {
            if (typeof uni !== 'undefined') {
              uni.showToast({ title: '更新成功', icon: 'success' })
            } else {
              alert('更新成功')
            }
            this.showModal = false
            this.loadGroupPurchases()
          } else {
            if (typeof uni !== 'undefined') {
              uni.showToast({ title: '更新失败', icon: 'none' })
            } else {
              alert('更新失败')
            }
          }
        } else {
          // 创建团购
          const response = await groupPurchaseAPI.create(this.form)
          if (response && response.id) {
            if (typeof uni !== 'undefined') {
              uni.showToast({ title: '创建成功', icon: 'success' })
            } else {
              alert('创建成功')
            }
            this.showModal = false
            this.loadGroupPurchases()
          } else {
            if (typeof uni !== 'undefined') {
              uni.showToast({ title: '创建失败', icon: 'none' })
            } else {
              alert('创建失败')
            }
          }
        }
      } catch (error) {
        console.error('保存团购失败:', error)
        if (typeof uni !== 'undefined') {
          uni.showToast({ title: '保存失败，请重试', icon: 'none' })
        } else {
          alert('保存失败，请重试')
        }
      }
    },
    viewDetail(item) {
      if (typeof uni !== 'undefined') {
        uni.showToast({ title: '查看详情', icon: 'none' })
      } else {
        alert('查看详情')
      }
    },
    deleteGroupPurchase(item) {
      if (typeof uni !== 'undefined') {
        uni.showModal({
          title: '确认删除',
          content: '确定要删除该团购吗？',
          success: async (res) => {
            if (res.confirm) {
              try {
                await groupPurchaseAPI.delete(item.id)
                if (typeof uni !== 'undefined') {
                  uni.showToast({ title: '删除成功', icon: 'success' })
                }
                this.loadGroupPurchases()
              } catch (error) {
                console.error('删除团购失败:', error)
                if (typeof uni !== 'undefined') {
                  uni.showToast({ title: '删除失败，请重试', icon: 'none' })
                }
              }
            }
          }
        })
      } else {
        if (confirm('确定要删除该团购吗？')) {
          (async () => {
            try {
              await groupPurchaseAPI.delete(item.id)
              alert('删除成功')
              this.loadGroupPurchases()
            } catch (error) {
              console.error('删除团购失败:', error)
              alert('删除失败，请重试')
            }
          })()
        }
      }
    },
    goBack() {
      this.$router.push('/admin/dashboard')
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

.back-btn,
.create-btn,
.search-btn,
.view-btn,
.edit-btn,
.delete-btn,
.confirm-btn {
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

.group-purchase-table {
  margin: 0 10px 20px;
  background-color: #fff;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  overflow-x: auto;
}

.group-purchase-table table {
  width: 100%;
  border-collapse: collapse;
}

.group-purchase-table th,
.group-purchase-table td {
  padding: 12px;
  text-align: left;
  border-bottom: 1px solid #eee;
}

.group-purchase-table th {
  background-color: #fafafa;
  font-weight: bold;
  color: #333;
  font-size: 14px;
}

.group-purchase-table td {
  font-size: 14px;
  color: #666;
}

.group-price {
  color: #ff6b81;
  font-weight: bold;
}

.pending {
  color: #FF9800;
  font-weight: bold;
}

.active {
  color: #4CAF50;
  font-weight: bold;
}

.ended {
  color: #999;
  font-weight: bold;
}

.sold_out {
  color: #F44336;
  font-weight: bold;
}

.view-btn {
  background-color: #2196F3;
  margin-right: 5px;
}

.edit-btn {
  background-color: #FF9800;
  margin-right: 5px;
}

.delete-btn {
  background-color: #F44336;
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
  max-width: 500px;
  max-height: 80vh;
  overflow-y: auto;
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
  resize: none;
}

.form-row {
  display: flex;
  gap: 15px;
}

.form-row .form-group {
  flex: 1;
}

.modal-buttons {
  display: flex;
  gap: 10px;
  justify-content: flex-end;
  margin-top: 20px;
}

.modal-buttons button {
  padding: 10px 20px;
}

.modal-buttons .cancel-btn {
  background-color: #999;
}
</style>
