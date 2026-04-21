<template>
  <div class="employee-list">
    <header class="header">
      <h1>员工管理</h1>
      <div class="header-actions">
        <button class="add-btn" @click="navigateToAdd">添加员工</button>
        <button class="back-btn" @click="goBack">返回</button>
      </div>
    </header>

    <div class="search-bar">
      <input type="text" v-model="searchKeyword" placeholder="搜索员工姓名或工号" @input="handleSearch">
      <select v-model="filterStatus" @change="handleSearch">
        <option value="">全部状态</option>
        <option value="在职">在职</option>
        <option value="离职">离职</option>
        <option value="休假">休假</option>
      </select>
    </div>

    <div class="employee-table">
      <table>
        <thead>
          <tr>
            <th>工号</th>
            <th>姓名</th>
            <th>岗位</th>
            <th>手机号</th>
            <th>入职时间</th>
            <th>状态</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="employee in filteredEmployees" :key="employee.id">
            <td>{{ employee.employeeId }}</td>
            <td>{{ employee.user.name }}</td>
            <td>{{ employee.position }}</td>
            <td>{{ employee.user.phone }}</td>
            <td>{{ formatDate(employee.entryDate) }}</td>
            <td>
              <span :class="['status-badge', getStatusClass(employee.status)]">
                {{ employee.status }}
              </span>
            </td>
            <td>
              <button class="edit-btn" @click="navigateToEdit(employee.id)">编辑</button>
              <button class="delete-btn" @click="handleDelete(employee.id)">删除</button>
            </td>
          </tr>
        </tbody>
      </table>

      <div v-if="loading" class="loading">加载中...</div>
      <div v-if="!loading && employees.length === 0" class="empty">暂无员工数据</div>
    </div>
  </div>
</template>

<script>
import { employeeAPI } from '../../../api/index'

export default {
  name: 'EmployeeList',
  data() {
    return {
      employees: [],
      searchKeyword: '',
      filterStatus: '',
      loading: false
    }
  },
  computed: {
    filteredEmployees() {
      return this.employees.filter(employee => {
        const matchKeyword = !this.searchKeyword ||
          employee.employeeId.includes(this.searchKeyword) ||
          (employee.user && employee.user.name && employee.user.name.includes(this.searchKeyword))
        const matchStatus = !this.filterStatus || employee.status === this.filterStatus
        return matchKeyword && matchStatus
      })
    }
  },
  mounted() {
    this.loadEmployees()
  },
  methods: {
    async loadEmployees() {
      this.loading = true
      try {
        const response = await employeeAPI.getAll()
        if (Array.isArray(response)) {
          this.employees = response
        }
      } catch (error) {
        console.error('加载员工列表失败:', error)
      } finally {
        this.loading = false
      }
    },
    formatDate(date) {
      if (!date) return ''
      const d = new Date(date)
      return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
    },
    getStatusClass(status) {
      switch (status) {
        case '在职': return 'status-active'
        case '离职': return 'status-inactive'
        case '休假': return 'status-leave'
        default: return ''
      }
    },
    handleSearch() {
      // 搜索由computed属性处理
    },
    navigateToAdd() {
      this.$router.push('/admin/employee/add')
    },
    navigateToEdit(id) {
      this.$router.push(`/admin/employee/edit?id=${id}`)
    },
    goBack() {
      this.$router.push('/admin/dashboard')
    },
    async handleDelete(id) {
      if (confirm('确定要删除该员工吗？')) {
        try {
          await employeeAPI.delete(id)
          this.loadEmployees()
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
.employee-list {
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

.employee-table {
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

.status-badge {
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
}

.status-active {
  background-color: #E8F5E9;
  color: #4CAF50;
}

.status-inactive {
  background-color: #FFEBEE;
  color: #F44336;
}

.status-leave {
  background-color: #FFF3E0;
  color: #FF9800;
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