<template>
  <div class="attendance">
    <header class="header">
      <h1>考勤打卡</h1>
    </header>
    <div class="attendance-container">
      <div class="employee-info">
        <div class="avatar">
          <img src="../../static/avatar.png" alt="头像">
        </div>
        <div class="info">
          <h2>{{ employee.name }}</h2>
          <p>{{ employee.position }}</p>
          <p>{{ employee.employeeId }}</p>
        </div>
      </div>
      
      <div class="location-info">
        <div class="location-item">
          <span class="label">当前位置：</span>
          <span class="value">{{ locationInfo }}</span>
        </div>
        <div class="location-item">
          <span class="label">打卡范围：</span>
          <span class="value">门店半径100米内</span>
        </div>
      </div>
      
      <div class="attendance-status">
        <div class="status-item">
          <span class="label">今日状态：</span>
          <span class="value" :class="statusClass">{{ todayStatus }}</span>
        </div>
        <div class="status-item" v-if="checkInTime">
          <span class="label">上班时间：</span>
          <span class="value">{{ checkInTime }}</span>
        </div>
        <div class="status-item" v-if="checkOutTime">
          <span class="label">下班时间：</span>
          <span class="value">{{ checkOutTime }}</span>
        </div>
      </div>
      
      <div class="action-buttons">
        <button v-if="!checkInTime" class="check-in-btn" @click="checkIn">上班打卡</button>
        <button v-else-if="!checkOutTime" class="check-out-btn" @click="checkOut">下班打卡</button>
        <button v-else class="completed-btn" disabled>今日已完成打卡</button>
      </div>
      
      <div class="attendance-history">
        <h3>打卡历史</h3>
        <div class="history-list">
          <div v-for="record in attendanceHistory" :key="record.id" class="history-item">
            <div class="history-date">{{ record.date }}</div>
            <div class="history-time">
              <span>上班：{{ record.checkIn }}</span>
              <span v-if="record.checkOut">下班：{{ record.checkOut }}</span>
            </div>
            <div class="history-status" :class="record.statusClass">{{ record.status }}</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      employee: {
        name: '员工1',
        position: '美容师',
        employeeId: 'EMP001'
      },
      locationInfo: '获取位置中...',
      todayStatus: '未打卡',
      checkInTime: '',
      checkOutTime: '',
      attendanceHistory: [
        {
          id: 1,
          date: '2026-04-20',
          checkIn: '09:00',
          checkOut: '18:00',
          status: '正常',
          statusClass: 'status-normal'
        },
        {
          id: 2,
          date: '2026-04-19',
          checkIn: '09:10',
          checkOut: '18:00',
          status: '迟到',
          statusClass: 'status-late'
        },
        {
          id: 3,
          date: '2026-04-18',
          checkIn: '09:00',
          checkOut: '18:00',
          status: '正常',
          statusClass: 'status-normal'
        }
      ]
    }
  },
  computed: {
    statusClass() {
      switch (this.todayStatus) {
        case '正常':
          return 'status-normal';
        case '迟到':
          return 'status-late';
        case '旷工':
          return 'status-absent';
        default:
          return '';
      }
    }
  },
  onLoad() {
    this.getLocation();
    this.checkTodayStatus();
  },
  methods: {
    getLocation() {
      // 获取当前位置
      uni.getLocation({
        type: 'wgs84',
        success: (res) => {
          // 这里可以调用逆地理编码API获取具体地址
          this.locationInfo = `纬度: ${res.latitude}, 经度: ${res.longitude}`;
        },
        fail: (err) => {
          this.locationInfo = '获取位置失败，请检查定位权限';
        }
      });
    },
    checkTodayStatus() {
      // 模拟检查今日打卡状态
      const now = new Date();
      const hours = now.getHours();
      if (hours >= 9 && hours < 18) {
        this.checkInTime = '09:00';
        this.todayStatus = '正常';
      } else if (hours >= 18) {
        this.checkInTime = '09:00';
        this.checkOutTime = '18:00';
        this.todayStatus = '正常';
      }
    },
    checkIn() {
      // 模拟上班打卡
      uni.chooseImage({
        count: 1,
        success: (res) => {
          // 这里调用打卡API
          const now = new Date();
          this.checkInTime = `${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}`;
          this.todayStatus = '正常';
          uni.showToast({ title: '打卡成功', icon: 'success' });
        }
      });
    },
    checkOut() {
      // 模拟下班打卡
      uni.chooseImage({
        count: 1,
        success: (res) => {
          // 这里调用打卡API
          const now = new Date();
          this.checkOutTime = `${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}`;
          this.todayStatus = '正常';
          uni.showToast({ title: '打卡成功', icon: 'success' });
        }
      });
    }
  }
}
</script>

<style scoped>
.attendance {
  min-height: 100vh;
  background-color: #f5f5f5;
}

.header {
  padding: 20px;
  background-color: #fff;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  text-align: center;
}

.header h1 {
  font-size: 18px;
  color: #333;
}

.attendance-container {
  padding: 20px;
}

.employee-info {
  display: flex;
  align-items: center;
  padding: 20px;
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  margin-bottom: 20px;
}

.avatar img {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  margin-right: 20px;
}

.info h2 {
  font-size: 18px;
  color: #333;
  margin-bottom: 5px;
}

.info p {
  font-size: 14px;
  color: #666;
  margin: 0;
}

.location-info {
  padding: 15px;
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  margin-bottom: 20px;
}

.location-item {
  display: flex;
  justify-content: space-between;
  margin-bottom: 10px;
}

.location-item .label {
  font-size: 14px;
  color: #666;
}

.location-item .value {
  font-size: 14px;
  color: #333;
}

.attendance-status {
  padding: 15px;
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  margin-bottom: 20px;
}

.status-item {
  display: flex;
  justify-content: space-between;
  margin-bottom: 10px;
}

.status-item .label {
  font-size: 14px;
  color: #666;
}

.status-item .value {
  font-size: 14px;
  color: #333;
}

.status-normal {
  color: #4CAF50;
}

.status-late {
  color: #FF9800;
}

.status-absent {
  color: #F44336;
}

.action-buttons {
  display: flex;
  justify-content: center;
  margin-bottom: 20px;
}

.check-in-btn,
.check-out-btn,
.completed-btn {
  padding: 15px 40px;
  border: none;
  border-radius: 4px;
  font-size: 16px;
  font-weight: bold;
  cursor: pointer;
}

.check-in-btn {
  background-color: #4CAF50;
  color: #fff;
}

.check-out-btn {
  background-color: #2196F3;
  color: #fff;
}

.completed-btn {
  background-color: #9E9E9E;
  color: #fff;
  cursor: not-allowed;
}

.attendance-history {
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  padding: 20px;
}

.attendance-history h3 {
  font-size: 16px;
  color: #333;
  margin-bottom: 15px;
}

.history-list {
  max-height: 300px;
  overflow-y: auto;
}

.history-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 0;
  border-bottom: 1px solid #eee;
}

.history-date {
  font-size: 14px;
  color: #333;
  width: 80px;
}

.history-time {
  flex: 1;
  font-size: 14px;
  color: #666;
  text-align: center;
}

.history-status {
  font-size: 14px;
  font-weight: bold;
}
</style>