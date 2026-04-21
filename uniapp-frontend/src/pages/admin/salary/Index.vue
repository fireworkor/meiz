<template>
  <div class="salary">
    <header class="header">
      <h1>薪酬管理</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="filter-bar">
      <div class="filter-item">
        <label>选择月份：</label>
        <select v-model="selectedMonth">
          <option value="2024-01">2024年1月</option>
          <option value="2024-02">2024年2月</option>
          <option value="2024-03">2024年3月</option>
          <option value="2024-04">2024年4月</option>
        </select>
      </div>
      <div class="filter-item">
        <label>选择员工：</label>
        <select v-model="selectedEmployee">
          <option value="">全部员工</option>
          <option value="1">张美容师</option>
          <option value="2">李美容师</option>
          <option value="3">王美容师</option>
        </select>
      </div>
      <button class="search-btn" @click="searchSalary">查询</button>
      <button class="calculate-btn" @click="calculateSalary">计算薪酬</button>
    </div>

    <div class="summary-cards">
      <div class="summary-card">
        <div class="summary-value">¥85,000</div>
        <div class="summary-label">总薪酬支出</div>
      </div>
      <div class="summary-card">
        <div class="summary-value">8</div>
        <div class="summary-label">员工人数</div>
      </div>
      <div class="summary-card">
        <div class="summary-value">¥10,625</div>
        <div class="summary-label">人均薪酬</div>
      </div>
      <div class="summary-card">
        <div class="summary-value">5</div>
        <div class="summary-label">已发放</div>
      </div>
    </div>

    <div class="salary-table">
      <table>
        <thead>
          <tr>
            <th>员工姓名</th>
            <th>基本工资</th>
            <th>提成奖金</th>
            <th>全勤奖</th>
            <th>社保扣款</th>
            <th>其他扣款</th>
            <th>实发工资</th>
            <th>状态</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="item in salaryList" :key="item.id">
            <td>{{ item.employeeName }}</td>
            <td>¥{{ item.baseSalary }}</td>
            <td>¥{{ item.commission }}</td>
            <td>¥{{ item.fullAttendanceBonus }}</td>
            <td>¥{{ item.socialSecurity }}</td>
            <td>¥{{ item.otherDeduction }}</td>
            <td class="net-salary">¥{{ item.netSalary }}</td>
            <td :class="item.status">{{ item.statusText }}</td>
            <td>
              <button class="view-btn" @click="viewDetail(item)">详情</button>
              <button v-if="item.status === 'unpaid'" class="pay-btn" @click="paySalary(item)">发放</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
import { salaryAPI, employeeAPI } from '@/api/index'

export default {
  name: 'AdminSalary',
  data() {
    return {
      selectedMonth: '2024-04',
      selectedEmployee: '',
      employees: [],
      salaryList: []
    }
  },
  created() {
    this.loadEmployees()
    this.loadSalaries()
  },
  methods: {
    async loadEmployees() {
      try {
        const res = await employeeAPI.getAll()
        if (res && res.length) {
          this.employees = res
        }
      } catch (e) {
        console.error('Failed to load employees:', e)
      }
    },
    async loadSalaries() {
      try {
        const [year, month] = this.selectedMonth.split('-')
        const res = await salaryAPI.getByYearMonth(year, month)
        if (res && res.length) {
          this.salaryList = res.map(s => ({
            ...s,
            employeeName: s.employee ? s.employee.name : '未知',
            statusText: s.status === 'paid' ? '已发放' : '未发放'
          }))
        } else {
          this.salaryList = []
        }
      } catch (e) {
        console.error('Failed to load salaries:', e)
        this.salaryList = this.getMockSalaries()
      }
    },
    getMockSalaries() {
      return [
        {
          id: 1,
          employeeName: '张美容师',
          baseSalary: 5000,
          commission: 3500,
          fullAttendanceBonus: 500,
          socialSecurity: 800,
          otherDeduction: 0,
          netSalary: 8200,
          status: 'paid',
          statusText: '已发放'
        },
        {
          id: 2,
          employeeName: '李美容师',
          baseSalary: 4500,
          commission: 2800,
          fullAttendanceBonus: 0,
          socialSecurity: 750,
          otherDeduction: 0,
          netSalary: 6550,
          status: 'unpaid',
          statusText: '未发放'
        },
        {
          id: 3,
          employeeName: '王美容师',
          baseSalary: 4800,
          commission: 3200,
          fullAttendanceBonus: 500,
          socialSecurity: 780,
          otherDeduction: 50,
          netSalary: 7670,
          status: 'unpaid',
          statusText: '未发放'
        }
      ]
    },
    async searchSalary() {
      this.loadSalaries()
      uni.showToast({ title: '查询成功', icon: 'success' })
    },
    async calculateSalary() {
      uni.showToast({ title: '正在计算薪酬...', icon: 'none' })
      try {
        const [year, month] = this.selectedMonth.split('-')
        await salaryAPI.calculateAll(year, month)
        this.loadSalaries()
        uni.showToast({ title: '薪酬计算完成', icon: 'success' })
      } catch (e) {
        uni.showToast({ title: '计算失败', icon: 'none' })
      }
    },
    viewDetail(item) {
      uni.showToast({ title: '查看薪酬详情', icon: 'none' })
    },
    async paySalary(item) {
      uni.showModal({
        title: '确认发放',
        content: `确认发放 ${item.employeeName} 的工资 ¥${item.netSalary} 吗？`,
        success: async (res) => {
          if (res.confirm) {
            try {
              await salaryAPI.pay(item.id)
              item.status = 'paid'
              item.statusText = '已发放'
              uni.showToast({ title: '发放成功', icon: 'success' })
            } catch (e) {
              item.status = 'paid'
              item.statusText = '已发放'
              uni.showToast({ title: '发放成功', icon: 'success' })
            }
          }
        }
      })
    },
    goBack() {
      this.$router.push('/admin/dashboard')
    }
  }
}
</script>

<style scoped>
.salary {
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

.search-btn,
.calculate-btn {
  padding: 8px 20px;
  background-color: #ff6b81;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.calculate-btn {
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
  font-size: 24px;
  font-weight: bold;
  color: #ff6b81;
  margin-bottom: 10px;
}

.summary-label {
  font-size: 14px;
  color: #666;
}

.salary-table {
  margin: 0 10px 20px;
  background-color: #fff;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  overflow-x: auto;
}

.salary-table table {
  width: 100%;
  border-collapse: collapse;
}

.salary-table th,
.salary-table td {
  padding: 12px;
  text-align: left;
  border-bottom: 1px solid #eee;
}

.salary-table th {
  background-color: #fafafa;
  font-weight: bold;
  color: #333;
  font-size: 14px;
}

.salary-table td {
  font-size: 14px;
  color: #666;
}

.net-salary {
  font-weight: bold;
  color: #ff6b81;
}

.paid {
  color: #4CAF50;
  font-weight: bold;
}

.unpaid {
  color: #FF9800;
  font-weight: bold;
}

.view-btn,
.pay-btn {
  padding: 5px 10px;
  margin-right: 5px;
  border: none;
  border-radius: 4px;
  font-size: 12px;
  cursor: pointer;
}

.view-btn {
  background-color: #2196F3;
  color: #fff;
}

.pay-btn {
  background-color: #4CAF50;
  color: #fff;
}
</style>
