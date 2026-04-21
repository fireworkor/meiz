# 美妆店智慧管理系统 - 项目架构文档

## 1. 项目概述

### 1.1 项目简介

美妆店智慧管理系统是一套面向美容美发行业的管理软件，提供员工管理、顾客管理、预约管理、订单管理、会员管理、库存管理、营销活动管理等核心功能。系统支持管理员、员工、顾客三种角色，满足店铺日常运营管理的需求。

### 1.2 项目目标

- 实现店铺数字化管理，提升运营效率
- 优化顾客服务体验，增强客户粘性
- 规范业务流程，减少人为错误
- 提供数据统计支持，辅助经营决策

---

## 2. 技术架构

### 2.1 技术栈概览

| 层级 | 技术选型 | 说明 |
|------|----------|------|
| 后端框架 | Spring Boot 2.7.15 | 基于Java 8的Web应用框架 |
| 数据访问 | Spring Data JPA | 简化数据库操作 |
| 安全框架 | Spring Security | 认证授权管理 |
| 数据库 | MySQL 8.0 | 关系型数据库 |
| 前端框架 | Vue 2.x + uni-app | 跨平台前端框架 |
| 构建工具 | Maven / Vite | 项目构建和依赖管理 |
| 开发工具 | Node.js 14+ | 前端开发环境 |

### 2.2 系统架构图

```
┌─────────────────────────────────────────────────────────────────┐
│                         客户端层                                 │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐              │
│  │  管理端 Web  │  │  员工端 Web  │  │  顾客端 H5  │              │
│  │ (uniapp)    │  │ (uniapp)    │  │ (uniapp)    │              │
│  └─────────────┘  └─────────────┘  └─────────────┘              │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                         网关层 (可选)                             │
│                    Nginx / Spring Gateway                       │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                         服务层                                   │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │                    Spring Boot Application                   ││
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐      ││
│  │  │Controller│ │ Service  │ │Repository│ │   DTO    │      ││
│  │  └──────────┘ └──────────┘ └──────────┘ └──────────┘      ││
│  └─────────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                         数据层                                   │
│                    MySQL 8.0 Database                            │
└─────────────────────────────────────────────────────────────────┘
```

### 2.3 项目目录结构

```
project1/
├── java-backend/                    # Java后端项目
│   ├── src/main/java/com/beautyshop/
│   │   ├── Application.java         # 应用启动类
│   │   ├── config/                  # 配置类
│   │   │   └── SecurityConfig.java # 安全配置
│   │   ├── controller/             # 控制器层
│   │   │   ├── AttendanceController.java
│   │   │   ├── CardTypeController.java
│   │   │   ├── CommissionController.java
│   │   │   ├── CouponController.java
│   │   │   ├── CustomerController.java
│   │   │   ├── DashboardController.java
│   │   │   ├── EmployeeController.java
│   │   │   ├── InventoryController.java
│   │   │   ├── MarketingActivityController.java
│   │   │   ├── MembershipCardController.java
│   │   │   ├── OrderController.java
│   │   │   ├── ProductController.java
│   │   │   ├── ReservationController.java
│   │   │   ├── RoomController.java
│   │   │   ├── ScheduleController.java
│   │   │   ├── ShiftController.java
│   │   │   └── UserController.java
│   │   ├── dto/                     # 数据传输对象
│   │   │   ├── AttendanceCheckOutRequest.java
│   │   │   ├── AttendanceRequest.java
│   │   │   ├── CommissionRequest.java
│   │   │   ├── CouponRequest.java
│   │   │   ├── DashboardData.java
│   │   │   ├── InventoryRequest.java
│   │   │   ├── LoginRequest.java
│   │   │   ├── LoginResponse.java
│   │   │   ├── MembershipCardRequest.java
│   │   │   ├── ScheduleRequest.java
│   │   │   └── ShiftRequest.java
│   │   ├── entity/                  # 实体类
│   │   │   ├── Attendance.java
│   │   │   ├── CardType.java
│   │   │   ├── Commission.java
│   │   │   ├── Coupon.java
│   │   │   ├── Customer.java
│   │   │   ├── Employee.java
│   │   │   ├── Inventory.java
│   │   │   ├── MarketingActivity.java
│   │   │   ├── MembershipCard.java
│   │   │   ├── Order.java
│   │   │   ├── OrderItem.java
│   │   │   ├── Product.java
│   │   │   ├── Reservation.java
│   │   │   ├── Room.java
│   │   │   ├── Schedule.java
│   │   │   ├── Service.java
│   │   │   ├── Shift.java
│   │   │   └── User.java
│   │   ├── repository/              # 数据访问层
│   │   │   ├── AttendanceRepository.java
│   │   │   ├── CardTypeRepository.java
│   │   │   ├── CommissionRepository.java
│   │   │   ├── CouponRepository.java
│   │   │   ├── CustomerRepository.java
│   │   │   ├── EmployeeRepository.java
│   │   │   ├── InventoryRepository.java
│   │   │   ├── MarketingActivityRepository.java
│   │   │   ├── MembershipCardRepository.java
│   │   │   ├── OrderRepository.java
│   │   │   ├── ProductRepository.java
│   │   │   ├── ReservationRepository.java
│   │   │   ├── RoomRepository.java
│   │   │   ├── ScheduleRepository.java
│   │   │   ├── ShiftRepository.java
│   │   │   └── UserRepository.java
│   │   └── service/                # 业务逻辑层
│   │       ├── AttendanceService.java
│   │       ├── CardTypeService.java
│   │       ├── CommissionService.java
│   │       ├── CouponService.java
│   │       ├── CustomerService.java
│   │       ├── EmployeeService.java
│   │       ├── InventoryService.java
│   │       ├── MarketingActivityService.java
│   │       ├── MembershipCardService.java
│   │       ├── OrderService.java
│   │       ├── ProductService.java
│   │       ├── ReservationService.java
│   │       ├── RoomService.java
│   │       ├── ScheduleService.java
│   │       ├── ShiftService.java
│   │       └── UserService.java
│   ├── src/main/resources/
│   │   └── application.properties  # 应用配置
│   └── pom.xml                     # Maven依赖配置
│
├── uniapp-frontend/                 # Vue前端项目
│   ├── src/
│   │   ├── api/                    # API接口封装
│   │   ├── pages/                 # 页面组件
│   │   │   ├── admin/             # 管理端页面
│   │   │   ├── staff/             # 员工端页面
│   │   │   ├── customer/          # 顾客端页面
│   │   │   └── login/             # 登录页面
│   │   ├── router/                # 路由配置
│   │   ├── utils/                 # 工具函数
│   │   ├── App.vue                # 根组件
│   │   └── main.js                # 入口文件
│   ├── pages.json                 # 页面配置
│   ├── vite.config.js             # Vite配置
│   └── package.json               # NPM依赖配置
│
├── database.sql                     # 数据库脚本
└── docs/                           # 文档目录
    ├── README.md                   # 项目说明文档
    ├── API.md                     # API接口文档
    ├── ARCHITECTURE.md            # 架构设计文档
    ├── DATABASE.md                # 数据库设计文档
    ├── MODULES.md                 # 模块详细设计
    ├── DEPLOYMENT.md              # 部署指南
    └── DEVELOPER.md               # 开发指南
```

---

## 3. 模块架构

### 3.1 模块划分

系统按照业务领域划分为以下核心模块：

| 模块名称 | 模块说明 | 核心实体 |
|----------|----------|----------|
| 用户模块 | 用户认证、登录、权限管理 | User |
| 员工模块 | 员工信息管理、考勤、排班 | Employee, Attendance, Schedule, Shift |
| 顾客模块 | 顾客信息管理、会员体系 | Customer, MembershipCard |
| 预约模块 | 服务预约管理 | Reservation |
| 订单模块 | 订单处理、结算 | Order, OrderItem |
| 商品模块 | 商品管理、库存管理 | Product, Inventory |
| 营销模块 | 优惠券、活动管理 | Coupon, MarketingActivity |
| 房间模块 | 房间资源管理 | Room |
| 数据模块 | 数据统计、报表 | DashboardData |

### 3.2 模块依赖关系

```
                    ┌─────────────┐
                    │   用户模块   │
                    │  (User)     │
                    └──────┬──────┘
                           │
           ┌───────────────┼───────────────┐
           │               │               │
           ▼               ▼               ▼
    ┌─────────────┐ ┌─────────────┐ ┌─────────────┐
    │  员工模块   │ │  顾客模块   │ │  营销模块   │
    │(Employee)  │ │(Customer)  │ │(Marketing) │
    └──────┬──────┘ └──────┬──────┘ └──────┬──────┘
           │               │               │
           ▼               ▼               ▼
    ┌─────────────┐ ┌─────────────┐ ┌─────────────┐
    │   考勤模块   │ │  会员模块   │ │  优惠券模块  │
    │(Attendance)│ │(Membership)│ │ (Coupon)   │
    └──────┬──────┘ └──────┬──────┘ └─────────────┘
           │               │
           ▼               ▼
    ┌─────────────┐ ┌─────────────┐
    │   排班模块   │ │  预约模块   │
    │ (Schedule) │ │(Reservation)│
    └──────┬──────┘ └──────┬──────┘
           │               │
           └───────┬───────┘
                   ▼
            ┌─────────────┐
            │   订单模块   │
            │   (Order)   │
            └──────┬──────┘
                   │
           ┌───────┴───────┐
           ▼               ▼
    ┌─────────────┐ ┌─────────────┐
    │  商品模块   │ │  房间模块   │
    │ (Product)  │ │   (Room)   │
    └──────┬──────┘ └─────────────┘
           │
           ▼
    ┌─────────────┐
    │  库存模块   │
    │(Inventory) │
    └─────────────┘
```

---

## 4. 安全架构

### 4.1 认证机制

系统采用基于Token的认证机制：

1. **登录流程**
   - 用户提交用户名、密码、角色
   - 后端验证凭据，生成Token
   - 返回Token及相关用户信息
   - 客户端存储Token，后续请求携带

2. **Token传递**
   - 通过HTTP Header传递：`Authorization: Bearer <token>`
   - 也支持参数传递：`/api/users/login?token=<token>`

### 4.2 权限控制

基于Spring Security的权限控制：

| 角色 | 权限范围 |
|------|----------|
| admin | 全部功能 |
| staff | 员工相关功能、顾客服务功能 |
| customer | 个人信息、预约、订单、会员功能 |

### 4.3 安全配置

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {
    // 禁用CSRF
    // 禁用Session
    // 配置URL权限
    // 配置登录退出处理
}
```

---

## 5. 数据流架构

### 5.1 请求处理流程

```
客户端请求
    │
    ▼
Filter过滤器链 (Security)
    │
    ▼
DispatcherServlet
    │
    ▼
HandlerMapping → Controller
    │
    ▼
参数解析 → @RequestBody, @PathVariable等
    │
    ▼
Service业务处理
    │
    ▼
Repository数据访问
    │
    ▼
数据库
    │
    ▼
返回JSON响应
```

### 5.2 核心数据流

#### 预约服务流程
```
顾客创建预约
    │
    ▼
预约信息校验 (员工可用性、房间可用性)
    │
    ▼
保存预约记录 (status: 待确认)
    │
    ▼
通知员工 (消息通知)
    │
    ▼
员工确认预约 (status: 已确认)
    │
    ▼
顾客到店 (status: 已到店)
    │
    ▼
服务完成 (status: 已完成)
    │
    ▼
创建订单 → 结算
```

#### 订单处理流程
```
选择商品/服务
    │
    ▼
校验会员折扣
    │
    ▼
应用优惠券
    │
    ▼
计算总价
    │
    ▼
选择支付方式
    │
    ▼
创建订单
    │
    ▼
扣减库存 (如为商品)
    │
    ▼
计算员工提成
    │
    ▼
更新统计数据
```

---

## 6. 前端架构

### 6.1 页面结构

```
uniapp-frontend/
├── pages/
│   ├── admin/                     # 管理端
│   │   ├── dashboard.vue         # 管理首页
│   │   ├── employee/             # 员工管理
│   │   ├── customer/            # 顾客管理
│   │   ├── reservation/         # 预约管理
│   │   ├── checkout/            # 订单结算
│   │   ├── inventory/           # 库存管理
│   │   ├── member/              # 会员管理
│   │   ├── coupon/              # 优惠券管理
│   │   ├── marketing/           # 营销活动
│   │   ├── room/                # 房间管理
│   │   ├── schedule/            # 排班管理
│   │   ├── shift/              # 班次管理
│   │   ├── attendance/          # 考勤管理
│   │   ├── commission/          # 提成管理
│   │   └── service/             # 服务记录
│   │
│   ├── staff/                    # 员工端
│   │   ├── dashboard.vue        # 工作台
│   │   ├── attendance.vue       # 考勤打卡
│   │   ├── reservation/          # 预约查看
│   │   ├── checkout.vue         # 订单结算
│   │   ├── marketing.vue        # 营销推广
│   │   ├── performance.vue      # 业绩查看
│   │   ├── shift/               # 班次调换
│   │   └── notifications.vue   # 消息通知
│   │
│   ├── customer/                 # 顾客端
│   │   ├── dashboard.vue        # 个人中心
│   │   ├── reservation/         # 预约服务
│   │   ├── mall.vue             # 在线商城
│   │   ├── points.vue           # 积分中心
│   │   ├── activities.vue       # 营销活动
│   │   ├── evaluation.vue       # 评价中心
│   │   ├── promoter.vue         # 推广中心
│   │   └── notifications.vue    # 消息通知
│   │
│   └── login/
│       └── login.vue            # 登录页面
```

### 6.2 路由设计

采用基于角色的路由控制：

| 角色 | 访问路径 | 说明 |
|------|----------|------|
| admin | /pages/admin/* | 管理端页面 |
| staff | /pages/staff/* | 员工端页面 |
| customer | /pages/customer/* | 顾客端页面 |

### 6.3 API调用封装

统一封装HTTP请求：

```javascript
// utils/request.js
const request = (options) => {
  return new Promise((resolve, reject) => {
    uni.request({
      url: BASE_URL + options.url,
      method: options.method || 'GET',
      data: options.data,
      header: {
        'Authorization': uni.getStorageSync('token')
      },
      success: (res) => {
        if (res.data.success) {
          resolve(res.data)
        } else {
          uni.showToast({ title: res.data.message })
          reject(res.data)
        }
      }
    })
  })
}
```

---

## 7. 部署架构

### 7.1 开发环境

| 组件 | 版本要求 | 端口 |
|------|----------|------|
| JDK | 1.8+ | 8080 |
| Node.js | 14+ | 8081 |
| MySQL | 8.0+ | 3306 |
| Maven | 3.6+ | - |

### 7.2 生产环境建议

| 组件 | 建议配置 |
|------|----------|
| 应用服务器 | 2核4G ECS × 2 |
| 数据库 | 4核8G RDS MySQL 8.0 |
| 缓存 | Redis 4核8G |
| 负载均衡 | SLB |
| 对象存储 | OSS (图片存储) |

### 7.3 部署拓扑

```
                    ┌─────────────────┐
                    │   负载均衡器    │
                    │     (SLB)       │
                    └────────┬────────┘
                             │
              ┌──────────────┼──────────────┐
              │              │              │
              ▼              ▼              ▼
       ┌────────────┐ ┌────────────┐ ┌────────────┐
       │  应用服务器 │ │  应用服务器 │ │  应用服务器 │
       │   (Node1)  │ │   (Node2)  │ │   (Node3)  │
       └────────────┘ └────────────┘ └────────────┘
              │              │              │
              └──────────────┼──────────────┘
                             │
         ┌───────────────────┼───────────────────┐
         │                   │                   │
         ▼                   ▼                   ▼
  ┌────────────┐     ┌────────────┐     ┌────────────┐
  │   MySQL    │     │   Redis    │     │    OSS     │
  │  主从集群  │     │   缓存     │     │  文件存储  │
  └────────────┘     └────────────┘     └────────────┘
```

---

## 8. 版本信息

| 版本 | 日期 | 说明 |
|------|------|------|
| 1.0.0 | - | 初始版本 |

---

## 9. 附录

### 9.1 术语表

| 术语 | 说明 |
|------|------|
| 耗卡 | 使用会员卡中的次数或余额 |
| 提成 | 员工完成服务或销售后获得的佣金 |
| 班次 | 员工的工作时间段（早班/中班/晚班） |
| 储值卡 | 预先充值一定金额的会员卡 |
| 疗程卡 | 包含特定服务次数的会员卡 |

### 9.2 参考资料

- Spring Boot官方文档: https://spring.io/projects/spring-boot
- Vue官方文档: https://vuejs.org
- uni-app官方文档: https://uniapp.dcloud.io
- MySQL官方文档: https://dev.mysql.com/doc/
