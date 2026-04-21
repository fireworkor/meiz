<template>
  <div class="evaluation">
    <header class="header">
      <h1>评价系统</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="evaluation-section">
      <h2 class="section-title">我的评价</h2>
      <div class="evaluation-list">
        <div v-for="item in evaluations" :key="item.id" class="evaluation-item">
          <div class="evaluation-header">
            <div class="service-info">
              <h3 class="service-name">{{ item.serviceName }}</h3>
              <div class="service-time">{{ item.serviceTime }}</div>
            </div>
            <div class="rating">
              <span v-for="star in 5" :key="star" :class="['star', star <= item.rating ? 'active' : '']">
                ★
              </span>
            </div>
          </div>
          <div class="evaluation-content">
            <p class="evaluation-text">{{ item.content }}</p>
            <div class="evaluation-images" v-if="item.images && item.images.length > 0">
              <img v-for="(image, index) in item.images" :key="index" :src="image" :alt="'评价图片' + (index + 1)" />
            </div>
          </div>
          <div class="evaluation-footer">
            <span class="evaluation-date">{{ item.evaluationDate }}</span>
            <span class="evaluation-status" v-if="item.status === '已回复'">
              <span class="status-dot"></span> 已回复
            </span>
          </div>
        </div>
        <div v-if="evaluations.length === 0" class="empty">
          <div class="empty-icon">⭐</div>
          <p>暂无评价记录</p>
        </div>
      </div>
    </div>

    <div class="to-evaluate-section">
      <h2 class="section-title">待评价</h2>
      <div class="to-evaluate-list">
        <div v-for="item in toEvaluate" :key="item.id" class="to-evaluate-item">
          <div class="service-info">
            <h3 class="service-name">{{ item.serviceName }}</h3>
            <div class="service-time">{{ item.serviceTime }}</div>
          </div>
          <button class="evaluate-btn" @click="startEvaluate(item.id)">去评价</button>
        </div>
        <div v-if="toEvaluate.length === 0" class="empty">
          <div class="empty-icon">📋</div>
          <p>暂无待评价服务</p>
        </div>
      </div>
    </div>

    <!-- 评价弹窗 -->
    <div class="evaluation-modal" v-if="showEvaluateModal">
      <div class="modal-content">
        <div class="modal-header">
          <h3>评价服务</h3>
          <button class="close-btn" @click="showEvaluateModal = false">×</button>
        </div>
        <div class="modal-body">
          <div class="rating-section">
            <label>服务评分</label>
            <div class="rating-input">
              <span v-for="star in 5" :key="star" :class="['star', star <= evaluateForm.rating ? 'active' : '']" @click="evaluateForm.rating = star">
                ★
              </span>
            </div>
          </div>
          <div class="content-section">
            <label>评价内容</label>
            <textarea v-model="evaluateForm.content" placeholder="请输入您的评价..." rows="4"></textarea>
          </div>
          <div class="image-section">
            <label>上传图片（可选）</label>
            <div class="image-upload">
              <div class="upload-btn" @click="uploadImage">
                <span class="upload-icon">+</span>
                <span class="upload-text">添加图片</span>
              </div>
              <div v-for="(image, index) in evaluateForm.images" :key="index" class="uploaded-image">
                <img :src="image" :alt="'上传图片' + (index + 1)" />
                <button class="delete-btn" @click="removeImage(index)">×</button>
              </div>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button class="cancel-btn" @click="showEvaluateModal = false">取消</button>
          <button class="submit-btn" @click="submitEvaluation">提交评价</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'CustomerEvaluation',
  data() {
    return {
      showEvaluateModal: false,
      evaluateForm: {
        rating: 5,
        content: '',
        images: []
      },
      evaluations: [
        {
          id: 1,
          serviceName: '面部护理',
          serviceTime: '2024-04-20 14:30',
          evaluationDate: '2024-04-20 16:00',
          rating: 5,
          content: '服务非常好，技师手法专业，环境舒适，下次还会再来！',
          images: [
            'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=beauty%20salon%20interior%20nice&image_size=square',
            'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=facial%20treatment%20setup&image_size=square'
          ],
          status: '已回复'
        },
        {
          id: 2,
          serviceName: '身体按摩',
          serviceTime: '2024-04-15 10:00',
          evaluationDate: '2024-04-15 11:30',
          rating: 4,
          content: '按摩师技术不错，就是时间有点短，总体满意。',
          images: [],
          status: '已回复'
        }
      ],
      toEvaluate: [
        {
          id: 1,
          serviceName: '头部护理',
          serviceTime: '2024-04-22 09:30'
        },
        {
          id: 2,
          serviceName: '背部护理',
          serviceTime: '2024-04-21 16:00'
        }
      ]
    }
  },
  methods: {
    startEvaluate(serviceId) {
      this.evaluateForm = {
        rating: 5,
        content: '',
        images: []
      }
      this.showEvaluateModal = true
    },
    uploadImage() {
      // 模拟上传图片
      this.evaluateForm.images.push('https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=beauty%20salon%20service&image_size=square')
    },
    removeImage(index) {
      this.evaluateForm.images.splice(index, 1)
    },
    submitEvaluation() {
      if (!this.evaluateForm.content) {
        uni.showToast({ title: '请输入评价内容', icon: 'none' })
        return
      }
      
      // 模拟提交
      uni.showToast({ title: '评价成功', icon: 'success' })
      this.showEvaluateModal = false
      
      // 更新待评价列表
      this.toEvaluate.shift()
      
      // 添加到评价列表
      this.evaluations.unshift({
        id: Date.now(),
        serviceName: '头部护理',
        serviceTime: '2024-04-22 09:30',
        evaluationDate: new Date().toLocaleString(),
        rating: this.evaluateForm.rating,
        content: this.evaluateForm.content,
        images: this.evaluateForm.images,
        status: '待回复'
      })
    },
    goBack() {
      this.$router.push('/customer/dashboard')
    }
  }
}
</script>

<style scoped>
.evaluation {
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

.section-title {
  font-size: 16px;
  color: #333;
  margin: 20px 0 15px 20px;
}

.evaluation-list,
.to-evaluate-list {
  padding: 0 20px;
}

.evaluation-item,
.to-evaluate-item {
  background-color: #fff;
  border-radius: 8px;
  padding: 15px;
  margin-bottom: 15px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.evaluation-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 15px;
  padding-bottom: 10px;
  border-bottom: 1px solid #eee;
}

.service-info h3 {
  font-size: 16px;
  color: #333;
  margin: 0 0 5px 0;
}

.service-time {
  font-size: 12px;
  color: #999;
}

.rating {
  display: flex;
  gap: 2px;
}

.star {
  font-size: 16px;
  color: #ddd;
  cursor: pointer;
}

.star.active {
  color: #ffd700;
}

.evaluation-content {
  margin-bottom: 15px;
}

.evaluation-text {
  font-size: 14px;
  color: #333;
  line-height: 1.4;
  margin: 0 0 10px 0;
}

.evaluation-images {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

.evaluation-images img {
  width: 80px;
  height: 80px;
  object-fit: cover;
  border-radius: 4px;
}

.evaluation-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 10px;
  border-top: 1px solid #f0f0f0;
}

.evaluation-date {
  font-size: 12px;
  color: #999;
}

.evaluation-status {
  font-size: 12px;
  color: #4CAF50;
  display: flex;
  align-items: center;
}

.status-dot {
  width: 6px;
  height: 6px;
  background-color: #4CAF50;
  border-radius: 50%;
  margin-right: 5px;
}

.to-evaluate-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.evaluate-btn {
  padding: 8px 16px;
  background-color: #ff6b81;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.evaluation-modal {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal-content {
  background-color: #fff;
  border-radius: 8px;
  width: 90%;
  max-width: 500px;
  max-height: 80vh;
  overflow-y: auto;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  border-bottom: 1px solid #eee;
}

.modal-header h3 {
  font-size: 16px;
  color: #333;
  margin: 0;
}

.close-btn {
  font-size: 24px;
  background: none;
  border: none;
  cursor: pointer;
  color: #999;
}

.modal-body {
  padding: 20px;
}

.rating-section,
.content-section,
.image-section {
  margin-bottom: 20px;
}

.rating-section label,
.content-section label,
.image-section label {
  display: block;
  font-size: 14px;
  color: #333;
  margin-bottom: 10px;
}

.rating-input {
  display: flex;
  gap: 10px;
}

.rating-input .star {
  font-size: 24px;
}

.content-section textarea {
  width: 100%;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
  resize: vertical;
  box-sizing: border-box;
}

.image-upload {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

.upload-btn {
  width: 80px;
  height: 80px;
  border: 2px dashed #ddd;
  border-radius: 4px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s;
}

.upload-btn:hover {
  border-color: #ff6b81;
}

.upload-icon {
  font-size: 24px;
  color: #999;
  margin-bottom: 5px;
}

.upload-text {
  font-size: 12px;
  color: #999;
}

.uploaded-image {
  position: relative;
  width: 80px;
  height: 80px;
}

.uploaded-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 4px;
}

.delete-btn {
  position: absolute;
  top: -8px;
  right: -8px;
  width: 20px;
  height: 20px;
  background-color: #F44336;
  color: #fff;
  border: none;
  border-radius: 50%;
  font-size: 14px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
}

.modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  padding: 20px;
  border-top: 1px solid #eee;
}

.cancel-btn {
  padding: 10px 20px;
  border: 1px solid #ddd;
  background-color: #fff;
  color: #333;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.submit-btn {
  padding: 10px 20px;
  background-color: #ff6b81;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
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
