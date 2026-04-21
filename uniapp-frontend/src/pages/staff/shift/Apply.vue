<template>
  <div class="shift-apply">
    <header class="header">
      <h1>申请调班</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="apply-form">
      <div class="form-group">
        <label>申请日期</label>
        <input type="date" v-model="form.applyDate" />
      </div>
      
      <div class="form-group">
        <label>原班次</label>
        <select v-model="form.originalShift">
          <option value="">请选择原班次</option>
          <option value="早班">早班 (09:00-17:00)</option>
          <option value="晚班">晚班 (14:00-22:00)</option>
          <option value="全天">全天 (09:00-22:00)</option>
        </select>
      </div>
      
      <div class="form-group">
        <label>申请班次</label>
        <select v-model="form.requestedShift">
          <option value="">请选择申请班次</option>
          <option value="早班">早班 (09:00-17:00)</option>
          <option value="晚班">晚班 (14:00-22:00)</option>
          <option value="全天">全天 (09:00-22:00)</option>
        </select>
      </div>
      
      <div class="form-group">
        <label>调班原因</label>
        <textarea v-model="form.reason" placeholder="请输入调班原因" rows="4"></textarea>
      </div>
      
      <div class="form-group">
        <label>备注</label>
        <textarea v-model="form.remark" placeholder="请输入备注信息" rows="2"></textarea>
      </div>
      
      <div class="form-actions">
        <button class="submit-btn" @click="handleSubmit">提交申请</button>
      </div>
    </div>

    <div class="history-section">
      <h2 class="section-title">调班历史</h2>
      <div class="history-list">
        <div v-for="record in shiftHistory" :key="record.id" class="history-item">
          <div class="history-header">
            <span class="history-date">{{ record.applyDate }}</span>
            <span :class="['status-badge', getStatusClass(record.status)]">
              {{ record.status }}
            </span>
          </div>
          <div class="history-detail">
            <div class="detail-row">
              <span class="label">原班次：</span>
              <span class="value">{{ record.originalShift }}</span>
            </div>
            <div class="detail-row">
              <span class="label">申请班次：</span>
              <span class="value">{{ record.requestedShift }}</span>
            </div>
            <div class="detail-row" v-if="record.reason">
              <span class="label">原因：</span>
              <span class="value">{{ record.reason }}</span>
            </div>
          </div>
        </div>
        <div v-if="shiftHistory.length === 0" class="empty">
          <div class="empty-icon">📋</div>
          <p>暂无调班记录</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'StaffShiftApply',
  data() {
    return {
      form: {
        applyDate: '',
        originalShift: '',
        requestedShift: '',
        reason: '',
        remark: ''
      },
      shiftHistory: [
        {
          id: 1,
          applyDate: '2024-04-10',
          originalShift: '早班',
          requestedShift: '晚班',
          reason: '个人原因需要调整',
          status: '已批准'
        },
        {
          id: 2,
          applyDate: '2024-04-01',
          originalShift: '晚班',
          requestedShift: '早班',
          reason: '家中有事',
          status: '已拒绝'
        }
      ]
    }
  },
  mounted() {
    this.form.applyDate = new Date().toISOString().split('T')[0]
  },
  methods: {
    async handleSubmit() {
      if (!this.form.applyDate) {
        uni.showToast({ title: '请选择申请日期', icon: 'none' })
        return
      }
      if (!this.form.originalShift) {
        uni.showToast({ title: '请选择原班次', icon: 'none' })
        return
      }
      if (!this.form.requestedShift) {
        uni.showToast({ title: '请选择申请班次', icon: 'none' })
        return
      }
      if (!this.form.reason) {
        uni.showToast({ title: '请输入调班原因', icon: 'none' })
        return
      }

      try {
        // 模拟提交
        console.log('提交调班申请:', this.form)
        uni.showToast({ title: '申请提交成功', icon: 'success' })
        
        // 重置表单
        this.form = {
          applyDate: new Date().toISOString().split('T')[0],
          originalShift: '',
          requestedShift: '',
          reason: '',
          remark: ''
        }
        
        // 更新历史记录
        this.shiftHistory.unshift({
          id: Date.now(),
          applyDate: this.form.applyDate,
          originalShift: this.form.originalShift,
          requestedShift: this.form.requestedShift,
          reason: this.form.reason,
          status: '待审批'
        })
      } catch (error) {
        console.error('提交申请失败:', error)
        uni.showToast({ title: '提交失败', icon: 'none' })
      }
    },
    getStatusClass(status) {
      switch (status) {
        case '已批准': return 'status-approved'
        case '已拒绝': return 'status-rejected'
        case '待审批': return 'status-pending'
        default: return ''
      }
    },
    goBack() {
      this.$router.push('/staff/dashboard')
    }
  }
}
</script>

<style scoped>
.shift-apply {
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

.apply-form {
  padding: 20px;
  background-color: #fff;
  margin-bottom: 20px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.form-group {
  margin-bottom: 15px;
}

.form-group label {
  display: block;
  font-size: 14px;
  color: #666;
  margin-bottom: 8px;
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
  resize: vertical;
}

.form-actions {
  margin-top: 20px;
}

.submit-btn {
  width: 100%;
  padding: 15px;
  background-color: #ff6b81;
  color: #fff;
  border: none;
  border-radius: 8px;
  font-size: 16px;
  cursor: pointer;
}

.section-title {
  font-size: 16px;
  color: #333;
  margin: 20px 0 15px 20px;
}

.history-list {
  padding: 0 20px 20px;
}

.history-item {
  background-color: #fff;
  border-radius: 8px;
  padding: 15px;
  margin-bottom: 15px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.history-header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 10px;
  padding-bottom: 10px;
  border-bottom: 1px solid #eee;
}

.history-date {
  font-size: 14px;
  color: #666;
}

.status-badge {
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
}

.status-approved {
  background-color: #E8F5E9;
  color: #4CAF50;
}

.status-rejected {
  background-color: #FFEBEE;
  color: #F44336;
}

.status-pending {
  background-color: #FFF3E0;
  color: #FF9800;
}

.history-detail {
  margin-top: 10px;
}

.detail-row {
  margin-bottom: 8px;
}

.detail-row .label {
  font-size: 14px;
  color: #666;
  margin-right: 10px;
}

.detail-row .value {
  font-size: 14px;
  color: #333;
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
