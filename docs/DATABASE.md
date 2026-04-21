# 美妆店智慧管理系统 - 数据库设计文档

## 1. 数据库概述

### 1.1 数据库信息

| 属性 | 值 |
|------|-----|
| 数据库名称 | beauty_shop |
| 字符集 | utf8mb4 |
| 排序规则 | utf8mb4_unicode_ci |
| MySQL版本 | 8.0+ |

### 1.2 ER图总览

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│    users    │────▶│  employees   │────▶│ attendances │
│  (用户表)   │     │   (员工表)   │     │  (考勤表)   │
└─────────────┘     └─────────────┘     └─────────────┘
                          │
                          ▼
                    ┌─────────────┐     ┌─────────────┐
                    │  schedules  │────▶│   shifts    │
                    │  (排班表)    │     │  (班次表)   │
                    └─────────────┘     └─────────────┘
                          │
                          ▼
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│ customers   │────▶│ reservations│────▶│    rooms    │
│  (顾客表)   │     │  (预约表)   │     │  (房间表)   │
└─────────────┘     └─────────────┘     └─────────────┘
       │
       ▼
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   members   │────▶│ member_cards│     │ commissions │
│  (会员表)   │     │ (会员卡表)  │     │  (提成表)   │
└─────────────┘     └─────────────┘     └─────────────┘
                          │
                          ▼
                    ┌─────────────┐     ┌─────────────┐
                    │   orders    │────▶│ order_items │
                    │  (订单表)   │     │ (订单项表)  │
                    └─────────────┘     └─────────────┘
                          │
       ┌──────────────────┼──────────────────┐
       ▼                  ▼                  ▼
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  services   │     │  products   │     │   coupons   │
│  (服务表)   │     │  (产品表)   │     │ (优惠券表)  │
└─────────────┘     └──────┬──────┘     └─────────────┘
                           │
                           ▼
                    ┌─────────────┐
                    │  inventory  │
                    │  (库存表)   │
                    └─────────────┘
```

---

## 2. 数据表详细设计

### 2.1 用户表 (users)

存储系统用户信息，包括管理员、员工、顾客三种角色。

| 字段名 | 数据类型 | 约束 | 说明 |
|--------|----------|------|------|
| id | BIGINT | PRIMARY KEY, AUTO_INCREMENT | 用户ID |
| username | VARCHAR(50) | UNIQUE, NOT NULL | 用户名 |
| password | VARCHAR(100) | NOT NULL | 密码（加密存储） |
| role | VARCHAR(20) | NOT NULL | 角色：admin/staff/customer |
| name | VARCHAR(50) | NOT NULL | 姓名 |
| phone | VARCHAR(20) | UNIQUE, NOT NULL | 手机号 |
| avatar | VARCHAR(255) | NULL | 头像URL |
| created_at | DATETIME | DEFAULT CURRENT_TIMESTAMP | 创建时间 |
| updated_at | DATETIME | DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP | 更新时间 |

**索引设计：**
- PRIMARY KEY (id)
- UNIQUE INDEX idx_username (username)
- UNIQUE INDEX idx_phone (phone)
- INDEX idx_role (role)

**说明：**
- password字段使用BCrypt加密存储
- role字段用于区分用户角色，决定可访问的功能模块

---

### 2.2 员工表 (employees)

存储员工详细信息。

| 字段名 | 数据类型 | 约束 | 说明 |
|--------|----------|------|------|
| id | BIGINT | PRIMARY KEY, AUTO_INCREMENT | 员工ID |
| user_id | BIGINT | FOREIGN KEY, NOT NULL | 关联用户ID |
| position | VARCHAR(50) | NOT NULL | 职位 |
| entry_date | DATE | NOT NULL | 入职日期 |
| employee_id | VARCHAR(20) | UNIQUE, NOT NULL | 员工工号 |
| id_card | VARCHAR(20) | NOT NULL | 身份证号 |
| emergency_contact | VARCHAR(50) | NOT NULL | 紧急联系人 |
| emergency_phone | VARCHAR(20) | NOT NULL | 紧急联系电话 |
| status | VARCHAR(20) | NOT NULL | 状态：在职/离职/休假 |
| skill_tags | VARCHAR(255) | NULL | 擅长项目标签，逗号分隔 |

**索引设计：**
- PRIMARY KEY (id)
- UNIQUE INDEX idx_employee_id (employee_id)
- INDEX idx_user_id (user_id)
- INDEX idx_status (status)

**说明：**
- 一个用户可以关联一个员工信息
- skill_tags示例：面部护理,身体SPA,美甲

---

### 2.3 考勤表 (attendances)

记录员工考勤打卡信息。

| 字段名 | 数据类型 | 约束 | 说明 |
|--------|----------|------|------|
| id | BIGINT | PRIMARY KEY, AUTO_INCREMENT | 记录ID |
| employee_id | BIGINT | FOREIGN KEY, NOT NULL | 员工ID |
| check_in_time | DATETIME | NOT NULL | 签到时间 |
| check_out_time | DATETIME | NULL | 签退时间 |
| check_in_location | VARCHAR(255) | NULL | 签到位置 |
| check_out_location | VARCHAR(255) | NULL | 签退位置 |
| check_in_photo | VARCHAR(255) | NULL | 签到照片 |
| check_out_photo | VARCHAR(255) | NULL | 签退照片 |
| status | VARCHAR(20) | NOT NULL | 状态：正常/迟到/旷工 |

**索引设计：**
- PRIMARY KEY (id)
- INDEX idx_employee_id (employee_id)
- INDEX idx_check_in_time (check_in_time)
- INDEX idx_status (status)

**说明：**
- 每次考勤包含签到和签退两次记录
- status根据签到时间和班次时间自动判定

---

### 2.4 顾客表 (customers)

存储顾客详细信息。

| 字段名 | 数据类型 | 约束 | 说明 |
|--------|----------|------|------|
| id | BIGINT | PRIMARY KEY, AUTO_INCREMENT | 顾客ID |
| user_id | BIGINT | FOREIGN KEY, NOT NULL | 关联用户ID |
| birthday | DATE | NULL | 生日 |
| gender | VARCHAR(10) | NULL | 性别 |
| wechat | VARCHAR(50) | NULL | 微信号 |
| occupation | VARCHAR(50) | NULL | 职业 |
| source_channel | VARCHAR(50) | NULL | 来源渠道 |
| skin_type | VARCHAR(50) | NULL | 肤质类型 |
| allergy_history | VARCHAR(255) | NULL | 过敏史 |
| skin_problems | VARCHAR(255) | NULL | 皮肤问题 |
| preferred_items | VARCHAR(255) | NULL | 偏好项目 |
| preferred_employee | VARCHAR(50) | NULL | 偏好美容师 |
| preferred_time | VARCHAR(50) | NULL | 偏好时间段 |
| average_spending | DECIMAL(10,2) | NULL | 平均消费金额 |
| tags | VARCHAR(255) | NULL | 顾客标签，逗号分隔 |

**索引设计：**
- PRIMARY KEY (id)
- INDEX idx_user_id (user_id)
- INDEX idx_source_channel (source_channel)
- INDEX idx_tags (tags)

**说明：**
- 用于顾客画像分析，支持精准营销
- skin_type示例：干性、油性、混合性、敏感性
- source_channel示例：线上推广、朋友推荐、线下活动

---

### 2.5 服务表 (services)

存储服务项目信息。

| 字段名 | 数据类型 | 约束 | 说明 |
|--------|----------|------|------|
| id | BIGINT | PRIMARY KEY, AUTO_INCREMENT | 服务ID |
| name | VARCHAR(50) | NOT NULL | 服务名称 |
| description | VARCHAR(255) | NULL | 服务描述 |
| price | DECIMAL(10,2) | NOT NULL | 服务价格 |
| duration | INT | NOT NULL | 服务时长（分钟） |
| status | VARCHAR(20) | NOT NULL | 状态：启用/禁用 |

**索引设计：**
- PRIMARY KEY (id)
- INDEX idx_status (status)

---

### 2.6 产品表 (products)

存储商品信息。

| 字段名 | 数据类型 | 约束 | 说明 |
|--------|----------|------|------|
| id | BIGINT | PRIMARY KEY, AUTO_INCREMENT | 产品ID |
| name | VARCHAR(50) | NOT NULL | 产品名称 |
| description | VARCHAR(255) | NULL | 产品描述 |
| price | DECIMAL(10,2) | NOT NULL | 零售价格 |
| cost_price | DECIMAL(10,2) | NOT NULL | 成本价格 |
| category | VARCHAR(50) | NOT NULL | 产品分类 |
| status | VARCHAR(20) | NOT NULL | 状态：启用/禁用 |

**索引设计：**
- PRIMARY KEY (id)
- INDEX idx_category (category)
- INDEX idx_status (status)

---

### 2.7 库存表 (inventory)

管理产品库存信息。

| 字段名 | 数据类型 | 约束 | 说明 |
|--------|----------|------|------|
| id | BIGINT | PRIMARY KEY, AUTO_INCREMENT | 库存记录ID |
| product_id | BIGINT | FOREIGN KEY, NOT NULL | 产品ID |
| quantity | INT | NOT NULL | 库存数量 |
| batch_number | VARCHAR(50) | NULL | 批次号 |
| supplier | VARCHAR(50) | NULL | 供应商 |
| expiry_date | DATE | NULL | 有效期 |

**索引设计：**
- PRIMARY KEY (id)
- INDEX idx_product_id (product_id)
- INDEX idx_expiry_date (expiry_date)

**说明：**
- 支持多批次管理
- 可用于库存预警

---

### 2.8 订单表 (orders)

存储订单主表信息。

| 字段名 | 数据类型 | 约束 | 说明 |
|--------|----------|------|------|
| id | BIGINT | PRIMARY KEY, AUTO_INCREMENT | 订单ID |
| customer_id | BIGINT | FOREIGN KEY, NOT NULL | 顾客ID |
| employee_id | BIGINT | FOREIGN KEY, NOT NULL | 服务员工ID |
| order_date | DATETIME | NOT NULL | 订单日期 |
| total_amount | DECIMAL(10,2) | NOT NULL | 订单总金额 |
| payment_method | VARCHAR(50) | NOT NULL | 支付方式 |
| status | VARCHAR(20) | NOT NULL | 订单状态 |

**索引设计：**
- PRIMARY KEY (id)
- INDEX idx_customer_id (customer_id)
- INDEX idx_employee_id (employee_id)
- INDEX idx_order_date (order_date)
- INDEX idx_status (status)

**字段说明：**
- payment_method: 现金/微信/支付宝/银行卡/储值余额
- status: 待支付/已支付/已完成/已退款

---

### 2.9 订单项表 (order_items)

存储订单明细信息。

| 字段名 | 数据类型 | 约束 | 说明 |
|--------|----------|------|------|
| id | BIGINT | PRIMARY KEY, AUTO_INCREMENT | 订单项ID |
| order_id | BIGINT | FOREIGN KEY, NOT NULL | 订单ID |
| item_type | VARCHAR(20) | NOT NULL | 项目类型：service/product |
| item_id | BIGINT | NOT NULL | 项目ID（服务或产品ID） |
| quantity | INT | NOT NULL | 数量 |
| price | DECIMAL(10,2) | NOT NULL | 单价 |

**索引设计：**
- PRIMARY KEY (id)
- INDEX idx_order_id (order_id)

**说明：**
- item_type区分是服务还是产品
- 支持一个订单包含多种服务和产品

---

### 2.10 预约表 (reservations)

存储预约服务信息。

| 字段名 | 数据类型 | 约束 | 说明 |
|--------|----------|------|------|
| id | BIGINT | PRIMARY KEY, AUTO_INCREMENT | 预约ID |
| customer_id | BIGINT | FOREIGN KEY, NOT NULL | 顾客ID |
| employee_id | BIGINT | FOREIGN KEY, NOT NULL | 服务员工ID |
| service_id | BIGINT | FOREIGN KEY, NOT NULL | 服务ID |
| room_id | BIGINT | FOREIGN KEY, NOT NULL | 房间ID |
| reservation_date | DATETIME | NOT NULL | 预约时间 |
| status | VARCHAR(20) | NOT NULL | 预约状态 |
| source | VARCHAR(20) | NOT NULL | 预约来源 |

**索引设计：**
- PRIMARY KEY (id)
- INDEX idx_customer_id (customer_id)
- INDEX idx_employee_id (employee_id)
- INDEX idx_service_id (service_id)
- INDEX idx_reservation_date (reservation_date)
- INDEX idx_status (status)

**字段说明：**
- status: 待确认/已确认/已到店/已完成/已取消/爽约
- source: 前台代约/顾客自助预约

---

### 2.11 排班表 (schedules)

管理员工排班信息。

| 字段名 | 数据类型 | 约束 | 说明 |
|--------|----------|------|------|
| id | BIGINT | PRIMARY KEY, AUTO_INCREMENT | 排班ID |
| employee_id | BIGINT | FOREIGN KEY, NOT NULL | 员工ID |
| schedule_date | DATE | NOT NULL | 排班日期 |
| shift_type | VARCHAR(20) | NOT NULL | 班次类型 |
| start_time | TIME | NULL | 开始时间 |
| end_time | TIME | NULL | 结束时间 |

**索引设计：**
- PRIMARY KEY (id)
- INDEX idx_employee_id (employee_id)
- INDEX idx_schedule_date (schedule_date)

**字段说明：**
- shift_type: 早班/中班/晚班/休息

---

### 2.12 房间表 (rooms)

管理店铺房间资源。

| 字段名 | 数据类型 | 约束 | 说明 |
|--------|----------|------|------|
| id | BIGINT | PRIMARY KEY, AUTO_INCREMENT | 房间ID |
| name | VARCHAR(50) | NOT NULL | 房间名称 |
| type | VARCHAR(20) | NOT NULL | 房间类型 |
| capacity | INT | NOT NULL | 容量 |
| status | VARCHAR(20) | NOT NULL | 房间状态 |

**索引设计：**
- PRIMARY KEY (id)
- INDEX idx_type (type)
- INDEX idx_status (status)

**字段说明：**
- type: VIP房/双人间/单人间
- status: 占用/空闲/清洁中

---

### 2.13 会员表 (members)

存储会员基本信息。

| 字段名 | 数据类型 | 约束 | 说明 |
|--------|----------|------|------|
| id | BIGINT | PRIMARY KEY, AUTO_INCREMENT | 会员ID |
| customer_id | BIGINT | FOREIGN KEY, NOT NULL | 关联顾客ID |
| member_level | VARCHAR(20) | NOT NULL | 会员等级 |
| points | INT | DEFAULT 0 | 积分余额 |
| join_date | DATETIME | NOT NULL | 加入日期 |
| expiry_date | DATETIME | NULL | 有效期 |

**索引设计：**
- PRIMARY KEY (id)
- INDEX idx_customer_id (customer_id)
- INDEX idx_member_level (member_level)

**会员等级：**
- 普通会员
- 银卡会员
- 金卡会员
- 钻石卡会员

---

### 2.14 会员卡表 (member_cards)

管理会员持有的各种卡片。

| 字段名 | 数据类型 | 约束 | 说明 |
|--------|----------|------|------|
| id | BIGINT | PRIMARY KEY, AUTO_INCREMENT | 会员卡ID |
| member_id | BIGINT | FOREIGN KEY, NOT NULL | 会员ID |
| card_type | VARCHAR(20) | NOT NULL | 卡类型 |
| card_number | VARCHAR(50) | UNIQUE, NOT NULL | 卡号 |
| balance | DECIMAL(10,2) | DEFAULT 0 | 储值余额 |
| remaining_times | INT | DEFAULT 0 | 剩余次数 |
| discount_rate | DECIMAL(5,2) | DEFAULT 100 | 折扣率 |
| start_date | DATETIME | NOT NULL | 生效日期 |
| end_date | DATETIME | NULL | 失效日期 |
| status | VARCHAR(20) | NOT NULL | 卡状态 |

**索引设计：**
- PRIMARY KEY (id)
- UNIQUE INDEX idx_card_number (card_number)
- INDEX idx_member_id (member_id)
- INDEX idx_status (status)

**卡类型说明：**
- 储值卡：预先充值，消费时扣除余额
- 疗程卡：包含特定服务次数
- 折扣卡：享受指定折扣优惠
- 时段卡：在特定时间段有效
- 组合卡：结合多种功能的综合卡

---

### 2.15 提成表 (commissions)

记录员工提成信息。

| 字段名 | 数据类型 | 约束 | 说明 |
|--------|----------|------|------|
| id | BIGINT | PRIMARY KEY, AUTO_INCREMENT | 提成ID |
| employee_id | BIGINT | FOREIGN KEY, NOT NULL | 员工ID |
| order_id | BIGINT | FOREIGN KEY, NOT NULL | 订单ID |
| commission_type | VARCHAR(20) | NOT NULL | 提成类型 |
| amount | DECIMAL(10,2) | NOT NULL | 提成金额 |
| commission_date | DATETIME | NOT NULL | 提成日期 |
| status | VARCHAR(20) | NOT NULL | 结算状态 |

**索引设计：**
- PRIMARY KEY (id)
- INDEX idx_employee_id (employee_id)
- INDEX idx_order_id (order_id)
- INDEX idx_commission_date (commission_date)
- INDEX idx_status (status)

**提成类型：**
- 服务提成：完成服务项目
- 销售产品提成：销售产品
- 办卡提成：办理会员卡
- 耗卡提成：会员使用卡内余额/次数
- 全员营销佣金：推广活动佣金

---

### 2.16 优惠券表 (coupons)

存储优惠券信息。

| 字段名 | 数据类型 | 约束 | 说明 |
|--------|----------|------|------|
| id | BIGINT | PRIMARY KEY, AUTO_INCREMENT | 优惠券ID |
| name | VARCHAR(100) | NOT NULL | 优惠券名称 |
| type | VARCHAR(20) | NOT NULL | 优惠类型 |
| value | DECIMAL(10,2) | NOT NULL | 优惠值 |
| min_amount | DECIMAL(10,2) | NULL | 最低消费金额 |
| total_count | INT | NOT NULL | 发放总量 |
| remain_count | INT | NOT NULL | 剩余数量 |
| start_date | DATETIME | NOT NULL | 开始日期 |
| end_date | DATETIME | NOT NULL | 结束日期 |
| status | VARCHAR(20) | NOT NULL | 状态 |

**索引设计：**
- PRIMARY KEY (id)
- INDEX idx_type (type)
- INDEX idx_status (status)

**优惠类型：**
- 满减券：满一定金额减指定金额
- 折扣券：享受指定折扣
- 代金券：抵扣指定金额

---

### 2.17 营销活动表 (marketing_activities)

管理营销活动信息。

| 字段名 | 数据类型 | 约束 | 说明 |
|--------|----------|------|------|
| id | BIGINT | PRIMARY KEY, AUTO_INCREMENT | 活动ID |
| title | VARCHAR(100) | NOT NULL | 活动标题 |
| description | VARCHAR(255) | NULL | 活动描述 |
| type | VARCHAR(50) | NOT NULL | 活动类型 |
| start_date | DATETIME | NOT NULL | 开始时间 |
| end_date | DATETIME | NOT NULL | 结束时间 |
| status | VARCHAR(20) | NOT NULL | 状态 |

**索引设计：**
- PRIMARY KEY (id)
- INDEX idx_type (type)
- INDEX idx_status (status)
- INDEX idx_date (start_date, end_date)

---

### 2.18 交班表 (shifts)

记录员工交班信息。

| 字段名 | 数据类型 | 约束 | 说明 |
|--------|----------|------|------|
| id | BIGINT | PRIMARY KEY, AUTO_INCREMENT | 交班记录ID |
| employee_id | BIGINT | FOREIGN KEY, NOT NULL | 员工ID |
| shift_date | DATETIME | NOT NULL | 交班日期 |
| cash_amount | DECIMAL(10,2) | NOT NULL | 现金金额 |
| wechat_amount | DECIMAL(10,2) | NOT NULL | 微信金额 |
| alipay_amount | DECIMAL(10,2) | NOT NULL | 支付宝金额 |
| card_amount | DECIMAL(10,2) | NOT NULL | 银行卡金额 |
| member_card_amount | DECIMAL(10,2) | NOT NULL | 会员卡金额 |
| coupon_amount | DECIMAL(10,2) | NOT NULL | 优惠券金额 |
| total_amount | DECIMAL(10,2) | NOT NULL | 总金额 |
| system_amount | DECIMAL(10,2) | NOT NULL | 系统金额 |
| difference | DECIMAL(10,2) | NOT NULL | 差异金额 |
| difference_reason | VARCHAR(255) | NULL | 差异原因 |
| status | VARCHAR(20) | NOT NULL | 状态 |

**索引设计：**
- PRIMARY KEY (id)
- INDEX idx_employee_id (employee_id)
- INDEX idx_shift_date (shift_date)
- INDEX idx_status (status)

---

## 3. 表关系总结

### 3.1 主外键关系

```
users (1) ──────< employees (多)
users (1) ──────< customers (多)
users (1) ──────< members (多)

employees (1) ───< attendances (多)
employees (1) ───< schedules (多)
employees (1) ───< commissions (多)
employees (1) ───< shifts (多)

customers (1) ───< reservations (多)
customers (1) ───< orders (多)
customers (1) ───< members (1)

members (1) ─────< member_cards (多)

services (1) ───< reservations (多)
services (1) ───< order_items (多)

products (1) ───< inventory (多)
products (1) ───< order_items (多)

rooms (1) ──────< reservations (多)

orders (1) ─────< order_items (多)
orders (1) ─────< commissions (多)
```

### 3.2 核心业务流程数据流

**预约到消费流程：**
```
顾客 -> 预约(reservations) -> 订单(orders) -> 订单项(order_items)
                                     │
                                     ▼
                              提成(commissions)
```

**会员消费流程：**
```
顾客 -> 会员(members) -> 会员卡(member_cards)
                           │
                           ▼
                    订单支付(储值余额)
```

---

## 4. 索引优化建议

### 4.1 高频查询优化

| 查询场景 | 优化索引 |
|----------|----------|
| 按员工查询考勤 | idx_employee_id + idx_check_in_time |
| 按日期查询预约 | idx_reservation_date + idx_status |
| 按顾客查询订单 | idx_customer_id + idx_order_date |
| 按状态查询订单 | idx_status + idx_order_date |
| 库存预警查询 | idx_product_id + idx_expiry_date |

### 4.2 联合索引建议

| 索引名 | 包含字段 | 用途 |
|--------|----------|------|
| idx_emp_date | employee_id, schedule_date | 员工排班查询 |
| idx_cust_order | customer_id, order_date | 顾客订单查询 |
| idx_reserve_datetime | reservation_date, status | 预约时间查询 |

---

## 5. 数据库设计规范

### 5.1 命名规范

- 表名：使用小写字母，单数形式，如 `users`, `products`
- 字段名：使用小写字母，下划线分隔，如 `created_at`, `order_id`
- 索引名：`idx_` + 表名 + 字段名，如 `idx_users_username`
- 外键名：`fk_` + 子表名 + 父表名，如 `fk_employees_user_id`

### 5.2 字段设计规范

- 所有表必须有 `id` 主键，使用 BIGINT AUTO_INCREMENT
- 必须有 `created_at` 和 `updated_at` 字段
- 状态字段使用 VARCHAR(20)
- 金额字段使用 DECIMAL(10,2)
- 时间字段根据精度选择 DATETIME 或 DATE

### 5.3 约束设计

- 必须设置适当的外键约束，保持数据完整性
- 关键字段设置 UNIQUE 约束
- 定期清理不再使用的外键约束和索引
