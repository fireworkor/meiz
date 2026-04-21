<template>
  <div class="reservation-add">
    <header class="header">
      <h1>添加预约</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>
    <div class="form-container">
      <form @submit.prevent="submitForm">
        <div class="form-group">
          <label>顾客</label>
          <select v-model="form.customerId">
            <option value="">请选择顾客</option>
            <option v-for="customer in customers" :key="customer.id" :value="customer.id">{{ customer.user.name }} ({{ customer.user.phone }})</option>
          </select>
        </div>
        <div class="form-group">
          <label>员工</label>
          <select v-model="form.employeeId">
            <option value="">请选择员工</option>
            <option v-for="employee in employees" :key="employee.id" :value="employee.id">{{ employee.user.name }} ({{ employee.position }})</option>
          </select>
        </div>
        <div class="form-group">
          <label>服务</label>
          <select v-model="form.serviceId">
            <option value="">请选择服务</option>
            <option v-for="service in services" :key="service.id" :value="service.id">{{ service.name }} - ¥{{ service.price }} ({{ service.duration }}分钟)</option>
          </select>
        </div>
        <div class="form-group">
          <label>房间</label>
          <select v-model="form.roomId">
            <option value="">请选择房间</option>
            <option v-for="room in rooms" :key="room.id" :value="room.id">{{ room.name }} ({{ room.type }})</option>
          </select>
        </div>
        <div class="form-group">
          <label>预约时间</label>
          <input type="datetime-local" v-model="form.reservationDate">
        </div>
        <div class="form-group">
          <label>来源</label>
          <select v-model="form.source">
            <option value="前台代约">前台代约</option>
            <option value="顾客自助预约">顾客自助预约</option>
          </select>
        </div>
        <button type="submit" class="submit-btn">提交</button>
      </form>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      form: {
        customerId: '',
        employeeId: '',
        serviceId: '',
        roomId: '',
        reservationDate: '',
        source: '前台代约'
      },
      customers: [
        {
          id: 1,
          user: {
            name: '顾客1',
            phone: '13800138002'
          }
        },
        {
          id: 2,
          user: {
            name: '顾客2',
            phone: '13800138003'
          }
        }
      ],
      employees: [
        {
          id: 1,
          user: {
            name: '员工1'
          },
          position: '美容师'
        },
        {
          id: 2,
          user: {
            name: '员工2'
          },
          position: '美容师'
        }
      ],
      services: [
        {
          id: 1,
          name: '面部护理',
          price: 200,
          duration: 60
        },
        {
          id: 2,
          name: '身体护理',
          price: 300,
          duration: 90
        },
        {
          id: 3,
          name: '美甲',
          price: 100,
          duration: 30
        }
      ],
      rooms: [
        {
          id: 1,
          name: 'VIP房1',
          type: 'VIP房'
        },
        {
          id: 2,
          name: '双人间1',
          type: '双人间'
        },
        {
          id: 3,
          name: '单人间1',
          type: '单人间'
        }
      ]
    }
  },
  methods: {
    goBack() {
      uni.navigateBack();
    },
    submitForm() {
      // 表单验证
      if (!this.form.customerId || !this.form.employeeId || !this.form.serviceId || !this.form.roomId || !this.form.reservationDate) {
        uni.showToast({ title: '请填写所有必填字段', icon: 'none' });
        return;
      }
      
      // 这里调用添加预约API
      console.log('提交表单:', this.form);
      uni.showToast({ title: '添加成功', icon: 'success' });
      setTimeout(() => {
        uni.navigateBack();
      }, 1000);
    }
  }
}
</script>

<style scoped>
.reservation-add {
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
  padding: 20px;
  background-color: #fff;
  margin: 10px;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
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
  font-size: 16px;
}

.submit-btn {
  width: 100%;
  padding: 14px;
  background-color: #ff6b81;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 16px;
  font-weight: bold;
  cursor: pointer;
  margin-top: 20px;
}

.submit-btn:hover {
  background-color: #ff4757;
}
</style>