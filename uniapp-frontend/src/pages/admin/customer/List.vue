<template>
  <div class="customer-list">
    <header class="header">
      <h1>顾客档案</h1>
      <div class="header-actions">
        <button class="add-btn" @click="navigateToAdd">添加顾客</button>
        <button class="back-btn" @click="goBack">返回</button>
      </div>
    </header>

    <div class="search-bar">
      <input type="text" v-model="searchKeyword" placeholder="搜索顾客姓名或手机号" @input="handleSearch">
      <select v-model="filterGender" @change="handleSearch">
        <option value="">全部性别</option>
        <option value="男">男</option>
        <option value="女">女</option>
      </select>
    </div>

    <div class="customer-table">
      <table>
        <thead>
          <tr>
            <th>姓名</th>
            <th>手机号</th>
            <th>性别</th>
            <th>生日</th>
            <th>来源渠道</th>
            <th>客单价</th>
            <th>标签</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="customer in filteredCustomers" :key="customer.id">
            <td>{{ customer.user ? customer.user.name : '' }}</td>
            <td>{{ customer.user ? customer.user.phone : '' }}</td>
            <td>{{ customer.gender }}</td>
            <td>{{ formatDate(customer.birthday) }}</td>
            <td>{{ customer.sourceChannel }}</td>
            <td>¥{{ customer.averageSpending || 0 }}</td>
            <td>
              <span v-for="(tag, index) in getTags(customer.tags)" :key="index" class="tag">
                {{ tag }}
              </span>
            </td>
            <td>
              <button class="edit-btn" @click="navigateToEdit(customer.id)">编辑</button>
              <button class="delete-btn" @click="handleDelete(customer.id)">删除</button>
            </td>
          </tr>
        </tbody>
      </table>

      <div v-if="loading" class="loading">加载中...</div>
      <div v-if="!loading && customers.length === 0" class="empty">暂无顾客数据</div>
    </div>
  </div>
</template>

<script>
import { customerAPI } from '../../../api/index'
import { toast, modal, navigate } from '../../../utils/common'

export default {
  name: 'CustomerList',
  data() {
    return {
      customers: [],
      searchKeyword: '',
      filterGender: '',
      loading: false
    }
  },
  computed: {
    filteredCustomers() {
      return this.customers.filter(customer => {
        const matchKeyword = !this.searchKeyword ||
          (customer.user && customer.user.name && customer.user.name.includes(this.searchKeyword)) ||
          (customer.user && customer.user.phone && customer.user.phone.includes(this.searchKeyword))
        const matchGender = !this.filterGender || customer.gender === this.filterGender
        return matchKeyword && matchGender
      })
    }
  },
  mounted() {
    this.loadCustomers()
  },
  methods: {
    async loadCustomers() {
      this.loading = true
      try {
        const response = await customerAPI.getAll()
        if (Array.isArray(response)) {
          this.customers = response
        }
      } catch (error) {
        console.error('加载顾客列表失败:', error)
        toast.show({ title: '加载顾客列表失败' })
      } finally {
        this.loading = false
      }
    },
    formatDate(date) {
      if (!date) return ''
      const d = new Date(date)
      return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
    },
    getTags(tags) {
      if (!tags) return []
      return tags.split(',').filter(t => t.trim())
    },
    handleSearch() {
      // 搜索由computed属性处理
    },
    navigateToAdd() {
      this.$router.push('/admin/customer/add')
    },
    navigateToEdit(id) {
      this.$router.push(`/admin/customer/edit?id=${id}`)
    },
    goBack() {
      this.$router.push('/admin/dashboard')
    },
    handleDelete(id) {
      modal.show({
        content: '确定要删除该顾客吗？',
        success: async (res) => {
          if (res.confirm) {
            try {
              await customerAPI.delete(id)
              this.loadCustomers()
              toast.show({ title: '删除成功' })
            } catch (error) {
              console.error('删除顾客失败:', error)
              toast.show({ title: '删除失败，请重试' })
            }
          }
        }
      })
    }
  }
}
</script>

<style scoped>
.customer-list {
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

.header-actions {
  display: flex;
  gap: 10px;
}

.add-btn,
.back-btn {
  padding: 8px 16px;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.add-btn {
  background-color: #ff6b81;
  color: #fff;
}

.back-btn {
  background-color: #9E9E9E;
  color: #fff;
}

.search-bar {
  display: flex;
  padding: 15px 20px;
  background-color: #fff;
  margin: 10px 0;
  gap: 10px;
}

.search-bar input {
  flex: 1;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.search-bar select {
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.customer-table {
  background-color: #fff;
  margin: 10px 0;
  padding: 20px;
}

table {
  width: 100%;
  border-collapse: collapse;
}

th, td {
  padding: 12px;
  text-align: left;
  border-bottom: 1px solid #ddd;
}

th {
  background-color: #f2f2f2;
  font-weight: bold;
}

.tag {
  display: inline-block;
  padding: 2px 6px;
  background-color: #E3F2FD;
  color: #1976D2;
  border-radius: 4px;
  font-size: 12px;
  margin-right: 4px;
  margin-bottom: 2px;
}

.edit-btn,
.delete-btn {
  padding: 6px 12px;
  border: none;
  border-radius: 4px;
  font-size: 12px;
  cursor: pointer;
  margin-right: 5px;
}

.edit-btn {
  background-color: #4CAF50;
  color: white;
}

.delete-btn {
  background-color: #f44336;
  color: white;
}

.loading,
.empty {
  text-align: center;
  padding: 20px;
  color: #666;
}
</style>