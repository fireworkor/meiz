<template>
  <div class="marketing-add">
    <header class="header">
      <h1>{{ isEdit ? '编辑活动' : '创建活动' }}</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="form-container">
      <div class="form-group">
        <label>活动名称</label>
        <input type="text" v-model="form.name" placeholder="请输入活动名称" />
      </div>

      <div class="form-group">
        <label>活动类型</label>
        <select v-model="form.type">
          <option value="">请选择类型</option>
          <option value="折扣活动">折扣活动</option>
          <option value="满减活动">满减活动</option>
          <option value="赠品活动">赠品活动</option>
          <option value="会员专享">会员专享</option>
          <option value="节日活动">节日活动</option>
        </select>
      </div>

      <div class="form-group" v-if="form.type === '折扣活动'">
        <label>折扣率</label>
        <input type="number" step="0.1" v-model="form.discountRate" placeholder="请输入折扣率（如：0.8 表示8折）" />
      </div>

      <div class="form-group" v-if="form.type === '满减活动'">
        <label>满减金额</label>
        <input type="number" v-model="form.minAmount" placeholder="请输入满减门槛金额" />
      </div>

      <div class="form-group" v-if="form.type === '满减活动'">
        <label>减免金额</label>
        <input type="number" v-model="form.discountAmount" placeholder="请输入减免金额" />
      </div>

      <div class="form-group">
        <label>开始时间</label>
        <input type="date" v-model="form.startDate" />
      </div>

      <div class="form-group">
        <label>结束时间</label>
        <input type="date" v-model="form.endDate" />
      </div>

      <div class="form-group">
        <label>活动描述</label>
        <textarea v-model="form.description" placeholder="请输入活动描述" rows="4"></textarea>
      </div>

      <div class="form-actions">
        <button class="submit-btn" @click="handleSubmit">{{ isEdit ? '保存修改' : '创建活动' }}</button>
      </div>
    </div>
  </div>
</template>

<script>
import { marketingActivityAPI } from '../../../api/index'

export default {
  name: 'MarketingAdd',
  data() {
    return {
      isEdit: false,
      activityId: null,
      form: {
        name: '',
        type: '',
        discountRate: null,
        minAmount: null,
        discountAmount: null,
        startDate: '',
        endDate: '',
        description: ''
      }
    }
  },
  mounted() {
    const path = this.$route.path
    if (path.includes('/edit/')) {
      this.isEdit = true
      this.activityId = this.$route.params.id
      this.loadActivity()
    }
  },
  methods: {
    async loadActivity() {
      try {
        const response = await marketingActivityAPI.getById(this.activityId)
        if (response) {
          this.form = {
            name: response.name || '',
            type: response.type || '',
            discountRate: response.discountRate || null,
            minAmount: response.minAmount || null,
            discountAmount: response.discountAmount || null,
            startDate: response.startDate || '',
            endDate: response.endDate || '',
            description: response.description || ''
          }
        }
      } catch (error) {
        console.error('加载活动详情失败:', error)
      }
    },
    async handleSubmit() {
      // 验证活动名称
      if (!this.form.name) {
        if (typeof uni !== 'undefined') {
          uni.showToast({ title: '请输入活动名称', icon: 'none' })
        } else {
          alert('请输入活动名称')
        }
        return
      }
      
      // 验证活动类型
      if (!this.form.type) {
        if (typeof uni !== 'undefined') {
          uni.showToast({ title: '请选择活动类型', icon: 'none' })
        } else {
          alert('请选择活动类型')
        }
        return
      }
      
      // 验证活动类型相关字段
      if (this.form.type === '折扣活动') {
        if (!this.form.discountRate || isNaN(this.form.discountRate) || this.form.discountRate <= 0 || this.form.discountRate >= 1) {
          if (typeof uni !== 'undefined') {
            uni.showToast({ title: '请输入有效的折扣率（0-1之间）', icon: 'none' })
          } else {
            alert('请输入有效的折扣率（0-1之间）')
          }
          return
        }
      } else if (this.form.type === '满减活动') {
        if (!this.form.minAmount || isNaN(this.form.minAmount) || this.form.minAmount <= 0) {
          if (typeof uni !== 'undefined') {
            uni.showToast({ title: '请输入有效的满减门槛金额', icon: 'none' })
          } else {
            alert('请输入有效的满减门槛金额')
          }
          return
        }
        if (!this.form.discountAmount || isNaN(this.form.discountAmount) || this.form.discountAmount <= 0) {
          if (typeof uni !== 'undefined') {
            uni.showToast({ title: '请输入有效的减免金额', icon: 'none' })
          } else {
            alert('请输入有效的减免金额')
          }
          return
        }
        if (this.form.discountAmount >= this.form.minAmount) {
          if (typeof uni !== 'undefined') {
            uni.showToast({ title: '减免金额应小于满减门槛', icon: 'none' })
          } else {
            alert('减免金额应小于满减门槛')
          }
          return
        }
      }
      
      // 验证日期
      if (!this.form.startDate) {
        if (typeof uni !== 'undefined') {
          uni.showToast({ title: '请选择开始时间', icon: 'none' })
        } else {
          alert('请选择开始时间')
        }
        return
      }
      if (!this.form.endDate) {
        if (typeof uni !== 'undefined') {
          uni.showToast({ title: '请选择结束时间', icon: 'none' })
        } else {
          alert('请选择结束时间')
        }
        return
      }
      
      // 验证开始时间应早于结束时间
      const startDate = new Date(this.form.startDate)
      const endDate = new Date(this.form.endDate)
      if (startDate >= endDate) {
        if (typeof uni !== 'undefined') {
          uni.showToast({ title: '开始时间应早于结束时间', icon: 'none' })
        } else {
          alert('开始时间应早于结束时间')
        }
        return
      }

      try {
        if (this.isEdit) {
          await marketingActivityAPI.update(this.activityId, this.form)
          if (typeof uni !== 'undefined') {
            uni.showToast({ title: '修改成功', icon: 'success' })
            setTimeout(() => {
              this.$router.push('/admin/marketing/list')
            }, 1500)
          } else {
            alert('修改成功')
            this.$router.push('/admin/marketing/list')
          }
        } else {
          await marketingActivityAPI.create(this.form)
          if (typeof uni !== 'undefined') {
            uni.showToast({ title: '创建成功', icon: 'success' })
            setTimeout(() => {
              this.$router.push('/admin/marketing/list')
            }, 1500)
          } else {
            alert('创建成功')
            this.$router.push('/admin/marketing/list')
          }
        }
      } catch (error) {
        console.error('保存活动失败:', error)
        if (typeof uni !== 'undefined') {
          uni.showToast({ title: '保存失败，请重试', icon: 'none' })
        } else {
          alert('保存失败，请重试')
        }
      }
    },
    goBack() {
      this.$router.push('/admin/marketing/list')
    }
  }
}
</script>

<style scoped>
.marketing-add {
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
}

.form-group {
  background-color: #fff;
  border-radius: 8px;
  padding: 15px;
  margin-bottom: 15px;
}

.form-group label {
  display: block;
  font-size: 14px;
  color: #666;
  margin-bottom: 10px;
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
  padding: 20px;
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
</style>
