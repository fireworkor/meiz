<template>
  <div class="member-list">
    <header class="header">
      <h1>会员体系</h1>
      <button class="back-btn" @click="goBack">返回</button>
    </header>

    <div class="toolbar">
      <button class="add-btn" @click="goToAdd">办理会员卡</button>
    </div>

    <div class="member-container">
      <div v-for="card in membershipCards" :key="card.id" class="member-card">
        <div class="card-header">
          <h3>{{ card.customer && card.customer.user ? card.customer.user.name : '' }}</h3>
          <span :class="['status-badge', getStatusClass(card.status)]">
            {{ card.status }}
          </span>
        </div>
        <div class="card-info">
          <div class="card-number">{{ card.cardNumber }}</div>
          <div class="card-type">{{ card.cardType }}</div>
        </div>
        <div class="card-balance">
          <div class="balance-item">
            <span class="label">余额</span>
            <span class="value">¥{{ card.balance }}</span>
          </div>
          <div class="balance-item">
            <span class="label">积分</span>
            <span class="value">{{ card.points }}</span>
          </div>
          <div class="balance-item">
            <span class="label">折扣</span>
            <span class="value">{{ card.discountRate ? (card.discountRate * 10).toFixed(1) + '折' : '-' }}</span>
          </div>
        </div>
        <div class="card-actions">
          <button class="recharge-btn" @click="showRecharge(card)">充值</button>
          <button class="consume-btn" @click="showConsume(card)">消费</button>
        </div>
      </div>
      <div v-if="membershipCards.length === 0" class="empty">
        <div class="empty-icon">💎</div>
        <p>暂无会员卡</p>
      </div>
    </div>

    <div v-if="showModal" class="modal">
      <div class="modal-content">
        <h3>{{ modalType === 'recharge' ? '充值' : '消费' }}</h3>
        <div class="form-group">
          <label>金额</label>
          <input type="number" v-model.number="modalAmount" placeholder="请输入金额">
        </div>
        <div class="modal-buttons">
          <button class="cancel-btn" @click="closeModal">取消</button>
          <button class="confirm-btn" @click="handleModalConfirm">确认</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { membershipCardAPI } from '../../../api/index'

export default {
  name: 'MemberList',
  data() {
    return {
      membershipCards: [],
      showModal: false,
      modalType: '',
      modalAmount: 0,
      selectedCard: null
    }
  },
  mounted() {
    this.loadMembershipCards()
  },
  methods: {
    async loadMembershipCards() {
      try {
        const response = await membershipCardAPI.getAll()
        if (Array.isArray(response)) {
          this.membershipCards = response
        }
      } catch (error) {
        console.error('加载会员卡列表失败:', error)
      }
    },
    getStatusClass(status) {
      switch (status) {
        case '正常': return 'status-active'
        case '冻结': return 'status-frozen'
        case '过期': return 'status-expired'
        default: return ''
      }
    },
    goBack() {
      this.$router.push('/admin/dashboard')
    },
    goToAdd() {
      this.$router.push('/admin/member/add')
    },
    showRecharge(card) {
      this.selectedCard = card
      this.modalType = 'recharge'
      this.modalAmount = 0
      this.showModal = true
    },
    showConsume(card) {
      this.selectedCard = card
      this.modalType = 'consume'
      this.modalAmount = 0
      this.showModal = true
    },
    closeModal() {
      this.showModal = false
      this.selectedCard = null
    },
    async handleModalConfirm() {
      if (!this.modalAmount || this.modalAmount <= 0) {
        alert('请输入正确的金额')
        return
      }

      try {
        if (this.modalType === 'recharge') {
          await membershipCardAPI.recharge(this.selectedCard.id, this.modalAmount)
          alert('充值成功')
        } else {
          await membershipCardAPI.consume(this.selectedCard.id, this.modalAmount)
          alert('消费成功')
        }
        this.closeModal()
        this.loadMembershipCards()
      } catch (error) {
        alert('操作失败')
      }
    }
  }
}
</script>

<style scoped>
.member-list {
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

.back-btn,
.add-btn {
  padding: 8px 16px;
  background-color: #ff6b81;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.toolbar {
  display: flex;
  justify-content: flex-end;
  padding: 15px 20px;
  background-color: #fff;
  margin-bottom: 10px;
}

.member-container {
  padding: 20px;
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 15px;
}

.member-card {
  background-color: #fff;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}

.card-header h3 {
  font-size: 16px;
  color: #333;
  margin: 0;
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

.status-frozen {
  background-color: #FFF3E0;
  color: #FF9800;
}

.status-expired {
  background-color: #FFEBEE;
  color: #F44336;
}

.card-info {
  margin-bottom: 15px;
}

.card-number {
  font-size: 14px;
  color: #666;
  margin-bottom: 5px;
}

.card-type {
  font-size: 18px;
  font-weight: bold;
  color: #ff6b81;
}

.card-balance {
  display: flex;
  justify-content: space-between;
  padding: 15px 0;
  border-top: 1px solid #eee;
  border-bottom: 1px solid #eee;
  margin-bottom: 15px;
}

.balance-item {
  text-align: center;
}

.balance-item .label {
  display: block;
  font-size: 12px;
  color: #666;
  margin-bottom: 5px;
}

.balance-item .value {
  font-size: 16px;
  font-weight: bold;
  color: #333;
}

.card-actions {
  display: flex;
  gap: 10px;
}

.recharge-btn,
.consume-btn {
  flex: 1;
  padding: 8px;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.recharge-btn {
  background-color: #4CAF50;
  color: #fff;
}

.consume-btn {
  background-color: #2196F3;
  color: #fff;
}

.empty {
  grid-column: 1 / -1;
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

.modal {
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
  padding: 20px;
  width: 300px;
}

.modal-content h3 {
  font-size: 16px;
  color: #333;
  margin-bottom: 20px;
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

.form-group input {
  width: 100%;
  padding: 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
  box-sizing: border-box;
}

.modal-buttons {
  display: flex;
  gap: 10px;
}

.cancel-btn,
.confirm-btn {
  flex: 1;
  padding: 10px;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.cancel-btn {
  background-color: #9E9E9E;
  color: #fff;
}

.confirm-btn {
  background-color: #ff6b81;
  color: #fff;
}
</style>