<template>
  <div class="employee-list">
    <header class="header">
      <h1>员工管理</h1>
      <button class="add-btn" @click="navigateToAdd">添加员工</button>
    </header>
    <div class="search-bar">
      <input type="text" v-model="searchKeyword" placeholder="搜索员工姓名或工号">
      <button class="search-btn" @click="search">搜索</button>
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
          <tr v-for="employee in employees" :key="employee.id">
            <td>{{ employee.employeeId }}</td>
            <td>{{ employee.user.name }}</td>
            <td>{{ employee.position }}</td>
            <td>{{ employee.user.phone }}</td>
            <td>{{ formatDate(employee.entryDate) }}</td>
            <td>{{ employee.status }}</td>
            <td>
              <button class="edit-btn" @click="navigateToEdit(employee.id)">编辑</button>
              <button class="delete-btn" @click="deleteEmployee(employee.id)">删除</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      employees: [
        {
          id: 1,
          employeeId: 'EMP001',
          user: {
            name: '员工1',
            phone: '13800138001'
          },
          position: '美容师',
          entryDate: new Date('2023-01-01'),
          status: '在职'
        },
        {
          id: 2,
          employeeId: 'EMP002',
          user: {
            name: '员工2',
            phone: '13800138003'
          },
          position: '前台',
          entryDate: new Date('2023-02-01'),
          status: '在职'
        }
      ],
      searchKeyword: ''
    }
  },
  methods: {
    formatDate(date) {
      if (!date) return '';
      const d = new Date(date);
      return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
    },
    navigateToAdd() {
      uni.navigateTo({ url: '/pages/admin/employee/add' });
    },
    navigateToEdit(id) {
      uni.navigateTo({ url: `/pages/admin/employee/edit?id=${id}` });
    },
    deleteEmployee(id) {
      uni.showModal({
        title: '确认删除',
        content: '确定要删除该员工吗？',
        success: (res) => {
          if (res.confirm) {
            // 这里调用删除API
            this.employees = this.employees.filter(emp => emp.id !== id);
            uni.showToast({ title: '删除成功', icon: 'success' });
          }
        }
      });
    },
    search() {
      // 这里调用搜索API
      uni.showToast({ title: '搜索功能开发中', icon: 'none' });
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

.add-btn {
  padding: 8px 16px;
  background-color: #ff6b81;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.search-bar {
  display: flex;
  padding: 15px 20px;
  background-color: #fff;
  margin: 10px 0;
}

.search-bar input {
  flex: 1;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px 0 0 4px;
  font-size: 14px;
}

.search-btn {
  padding: 10px 20px;
  background-color: #ff6b81;
  color: #fff;
  border: none;
  border-radius: 0 4px 4px 0;
  font-size: 14px;
  cursor: pointer;
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

.edit-btn, .delete-btn {
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
</style>