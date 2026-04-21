# 前端开发文档

## 项目概述

本项目是一个美妆店智慧管理系统的前端应用，基于 Vue 2.x 开发，使用 Vue Router 进行路由管理。

## 技术栈

- **框架**: Vue 2.6.x
- **路由**: Vue Router 3.x
- **构建工具**: Vue CLI (或 Vite)
- **语言**: JavaScript (ES6+)
- **样式**: CSS3 (scoped style)

## 项目结构

```
uniapp-frontend/
├── public/
│   └── index.html
├── src/
│   ├── api/
│   │   └── index.js          # API 接口定义
│   ├── pages/
│   │   ├── admin/            # 管理员页面
│   │   ├── staff/            # 员工页面
│   │   ├── customer/         # 顾客页面
│   │   └── login/            # 登录页面
│   ├── router/
│   │   └── index.js          # 路由配置
│   ├── utils/
│   │   └── request.js        # 请求工具
│   ├── App.vue
│   └── main.js
├── package.json
└── vue.config.js
```

## 核心功能模块

### 1. 登录模块 (Login)

**文件位置**: `src/pages/login/Login.vue`

**功能说明**:
- 用户登录验证
- 角色选择(管理员/员工/顾客)
- 登录状态存储
- 路由跳转

**使用说明**:
```javascript
// 登录凭据
- 管理员: admin / admin123
- 员工: staff / staff123
- 顾客: customer / customer123
```

### 2. 管理员模块 (Admin)

**文件位置**: `src/pages/admin/`

**包含页面**:
- 仪表板 (Dashboard)
- 员工管理 (Employee)
- 顾客管理 (Customer)
- 预约管理 (Reservation)
- 排班管理 (Schedule)
- 班次管理 (Shift)
- 考勤管理 (Attendance)
- 薪酬管理 (Salary)
- 开单收银 (Checkout)
- 订单管理 (Order)
- 库存管理 (Inventory)
- 提成管理 (Commission)
- 会员体系 (Member)
- 优惠券管理 (Coupon)
- 营销活动 (Marketing)
- 数据分析 (Data)
- 房间管理 (Room)
- 服务记录 (Service)

### 3. 员工模块 (Staff)

**文件位置**: `src/pages/staff/`

**包含页面**:
- 仪表板 (Dashboard)
- 考勤打卡 (Attendance)
- 今日预约 (Reservation)
- 业绩查询 (Performance)
- 营销推广 (Marketing)
- 开单收银 (Checkout)
- 调班申请 (Shift)
- 消息通知 (Notifications)

### 4. 顾客模块 (Customer)

**文件位置**: `src/pages/customer/`

**包含页面**:
- 仪表板 (Dashboard)
- 个人资料 (Profile)
- 预约服务 (Reservation)
- 消费记录 (Consumption)
- 在线商城 (Mall)
- 积分商城 (Points)
- 营销活动 (Activities)
- 评价系统 (Evaluation)
- 消息通知 (Notifications)
- 推广员功能 (Promoter)

## API 接口管理

### 文件位置

`src/api/index.js`

### 使用方式

```javascript
import { userAPI, employeeAPI, customerAPI } from '@/api/index'

// 用户登录
const result = await userAPI.login({
  username: 'admin',
  password: 'admin123',
  role: 'admin'
})

// 获取员工列表
const employees = await employeeAPI.getAll()

// 添加员工
await employeeAPI.create({
  name: '张美容师',
  phone: '13800138000',
  position: '高级美容师'
})
```

## 请求工具

### 文件位置

`src/utils/request.js`

### 功能说明

- 统一的 API 基础 URL 配置
- 请求拦截处理
- 响应拦截处理
- 错误处理

### 配置说明

```javascript
const API_BASE_URL = 'http://localhost:8080/api'
```

## 路由管理

### 文件位置

`src/router/index.js`

### 路由结构

```javascript
// 登录路由
/login

// 管理员路由
/admin/dashboard
/admin/employee/*
/admin/customer/*
/admin/reservation/*
/admin/schedule/*
/admin/shift/*
/admin/attendance
/admin/salary
/admin/checkout
/admin/inventory/*
/admin/commission/*
/admin/member/*
/admin/coupon/*
/admin/marketing/*
/admin/room/*
/admin/service/*
/admin/dashboard/data

// 员工路由
/staff/dashboard
/staff/attendance
/staff/reservation/today
/staff/performance
/staff/marketing
/staff/checkout
/staff/shift/apply
/staff/notifications

// 顾客路由
/customer/dashboard
/customer/profile
/customer/reservation/*
/customer/consumption
/customer/mall
/customer/points
/customer/activities
/customer/evaluation
/customer/notifications
/customer/promoter
```

## 组件开发规范

### 1. 组件命名

- 使用 PascalCase 命名组件文件
- 组件内部使用 kebab-case 引用
- 页面组件使用 Index.vue 作为文件名

### 2. 代码结构

```vue
<template>
  <div class="component-name">
    <!-- 组件内容 -->
  </div>
</template>

<script>
export default {
  name: 'ComponentName',
  data() {
    return {
      // 数据
    }
  },
  computed: {
    // 计算属性
  },
  methods: {
    // 方法
  }
}
</script>

<style scoped>
/* 样式 */
</style>
```

### 3. 样式规范

- 使用 scoped style 避免样式污染
- 统一使用 rem 或 px 单位
- 颜色使用变量或统一的颜色值
- 布局使用 Flexbox 或 Grid

## 状态管理

### 使用 localStorage

```javascript
// 存储用户信息
localStorage.setItem('userInfo', JSON.stringify({
  username: 'admin',
  role: 'admin',
  token: 'mock-token'
}))

// 获取用户信息
const userInfo = JSON.parse(localStorage.getItem('userInfo'))

// 清除用户信息
localStorage.removeItem('userInfo')
```

## 开发指南

### 安装依赖

```bash
npm install
```

### 启动开发服务器

```bash
npm run dev
```

### 构建生产版本

```bash
npm run build
```

### 代码检查

```bash
npm run lint
```

## 常见问题

### 1. 路由跳转失败

**问题**: 点击导航没有反应

**解决方案**:
- 检查路由配置是否正确
- 检查路由路径是否匹配
- 检查组件是否正确导入

### 2. API 请求失败

**问题**: 接口请求返回错误

**解决方案**:
- 检查后端服务是否启动
- 检查 API 基础 URL 配置
- 检查网络连接
- 查看浏览器控制台错误信息

### 3. 样式不生效

**问题**: 样式没有正确应用

**解决方案**:
- 检查是否使用 scoped
- 检查样式优先级
- 检查选择器是否正确

## 浏览器支持

- Chrome (推荐)
- Firefox
- Safari
- Edge
- 移动端浏览器

## 开发工具推荐

- **IDE**: VS Code
- **Vue DevTools**: 浏览器扩展
- **调试工具**: Chrome DevTools

## 更新日志

### v1.0.0 (2024-04-22)

- ✅ 完成基础登录功能
- ✅ 完成管理员模块
- ✅ 完成员工模块
- ✅ 完成顾客模块
- ✅ 添加考勤管理功能
- ✅ 添加薪酬管理功能
- ✅ 完善文档
