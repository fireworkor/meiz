<template>
  <div class="customer-list">
    <header class="header">
      <h1>顾客档案</h1>
      <button class="add-btn" @click="navigateToAdd">添加顾客</button>
    </header>
    <div class="search-bar">
      <input type="text" v-model="searchKeyword" placeholder="搜索顾客姓名或手机号">
      <button class="search-btn" @click="search">搜索</button>
    </div>
    <div class="filter-bar">
      <select v-model="filterGender">
        <option value="">性别</option>
        <option value="男">男</option>
        <option value="女">女</option>
      </select>
      <select v-model="filterTag">
        <option value="">标签</option>
        <option value="VIP">VIP</option>
        <option value="新顾客">新顾客</option>
        <option value="老顾客">老顾客</option>
      </select>
      <select v-model="filterSource">
        <option value="">来源渠道</option>
        <option value="微信">微信</option>
        <option value="美团">美团</option>
        <option value="朋友介绍">朋友介绍</option>
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
          <tr v-for="customer in customers" :key="customer.id">
            <td>{{ customer.user.name }}</td>
            <td>{{ customer.user.phone }}</td>
            <td>{{ customer.gender }}</td>
            <td>{{ formatDate(customer.birthday) }}</td>
            <td>{{ customer.sourceChannel }}</td>
            <td>{{ customer.averageSpending }}</td>
            <td>{{ customer.tags }}</td>
            <td>
              <button class="edit-btn" @click="navigateToEdit(customer.id)">编辑</button>
              <button class="delete-btn" @click="deleteCustomer(customer.id)">删除</button>
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
      customers: [
        {
          id: 1,
          user: {
            name: '顾客1',
            phone: '13800138002'
          },
          gender: '女',
          birthday: new Date('1990-01-01'),
          sourceChannel: '微信',
          averageSpending: 500,
          tags: 'VIP,老顾客'
        },
        {
          id: 2,
          user: {
            name: '顾客2',
            phone: '13800138003'
          },
          gender: '男',
          birthday: new Date('1992-03-15'),
          sourceChannel: '美团',
          averageSpending: 300,
          tags: '新顾客'
        }
      ],
      searchKeyword: '',
      filterGender: '',
      filterTag: '',
      filterSource: ''
    }
  },
  methods: {
    formatDate(date) {
      if (!date) return '';
      const d = new Date(date);
      return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
    },
    navigateToAdd() {
      uni.navigateTo({ url: '/pages/admin/customer/add' });
    },
    navigateToEdit(id) {
      uni.navigateTo({ url: `/pages/admin/customer/edit?id=${id}` });
    },
    deleteCustomer(id) {
      uni.showModal({
        title: '确认删除',
        content: '确定要删除该顾客吗？',
        success: (res) => {
          if (res.confirm) {
            // 这里调用删除API
            this.customers = this.customers.filter(cust => cust.id !== id);
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

.filter-bar {
  display: flex;
  padding: 15px 20px;
  background-color: #fff;
  margin: 10px 0;
  gap: 10px;
}

.filter-bar select {
  flex: 1;
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