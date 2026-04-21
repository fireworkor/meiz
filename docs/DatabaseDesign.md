# 数据库设计文档

## 数据库概述

- **数据库名称**: beauty_shop
- **字符集**: utf8mb4
- **排序规则**: utf8mb4_unicode_ci

## 数据表设计

### 1. 用户表 (users)

存储系统用户信息，包括管理员、员工和顾客。

| 字段名 | 类型 | 长度 | 允许NULL | 默认值 | 说明 |
|--------|------|------|----------|--------|------|
| id | BIGINT | - | NO | AUTO_INCREMENT | 主键 |
| username | VARCHAR | 50 | NO | - | 用户名 |
| password | VARCHAR | 255 | NO | - | 密码(加密) |
| role | VARCHAR | 20 | NO | - | 角色(admin/staff/customer) |
| name | VARCHAR | 50 | YES | NULL | 姓名 |
| phone | VARCHAR | 20 | YES | NULL | 手机号 |
| avatar | VARCHAR | 255 | YES | NULL | 头像URL |
| created_at | DATETIME | - | NO | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | DATETIME | - | NO | CURRENT_TIMESTAMP ON UPDATE | 更新时间 |

**索引**:
- PRIMARY KEY: id
- UNIQUE KEY: username
- INDEX: phone
- INDEX: role

---

### 2. 员工表 (employees)

存储员工详细信息。

| 字段名 | 类型 | 长度 | 允许NULL | 默认值 | 说明 |
|--------|------|------|----------|--------|------|
| id | BIGINT | - | NO | AUTO_INCREMENT | 主键 |
| user_id | BIGINT | - | NO | - | 关联用户ID |
| name | VARCHAR | 50 | NO | - | 姓名 |
| phone | VARCHAR | 20 | NO | - | 手机号 |
| position | VARCHAR | 50 | YES | NULL | 职位 |
| entry_date | DATE | - | YES | NULL | 入职日期 |
| status | VARCHAR | 20 | NO | active | 状态(active/inactive) |
| base_salary | DECIMAL | 10,2 | YES | 0.00 | 基本工资 |
| created_at | DATETIME | - | NO | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | DATETIME | - | NO | CURRENT_TIMESTAMP ON UPDATE | 更新时间 |

**索引**:
- PRIMARY KEY: id
- UNIQUE KEY: user_id
- INDEX: status
- INDEX: position

---

### 3. 顾客表 (customers)

存储顾客详细信息。

| 字段名 | 类型 | 长度 | 允许NULL | 默认值 | 说明 |
|--------|------|------|----------|--------|------|
| id | BIGINT | - | NO | AUTO_INCREMENT | 主键 |
| user_id | BIGINT | - | NO | - | 关联用户ID |
| name | VARCHAR | 50 | NO | - | 姓名 |
| phone | VARCHAR | 20 | NO | - | 手机号 |
| level | VARCHAR | 20 | NO | normal | 会员等级 |
| points | INT | - | NO | 0 | 积分 |
| birthday | DATE | - | YES | NULL | 生日 |
| address | VARCHAR | 255 | YES | NULL | 地址 |
| notes | TEXT | - | YES | NULL | 备注 |
| created_at | DATETIME | - | NO | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | DATETIME | - | NO | CURRENT_TIMESTAMP ON UPDATE | 更新时间 |

**索引**:
- PRIMARY KEY: id
- UNIQUE KEY: user_id
- INDEX: phone
- INDEX: level

---

### 4. 商品表 (products)

存储商品信息。

| 字段名 | 类型 | 长度 | 允许NULL | 默认值 | 说明 |
|--------|------|------|----------|--------|------|
| id | BIGINT | - | NO | AUTO_INCREMENT | 主键 |
| name | VARCHAR | 100 | NO | - | 商品名称 |
| category | VARCHAR | 50 | NO | - | 分类 |
| price | DECIMAL | 10,2 | NO | 0.00 | 价格 |
| description | TEXT | - | YES | NULL | 描述 |
| image | VARCHAR | 255 | YES | NULL | 图片URL |
| status | VARCHAR | 20 | NO | active | 状态(active/inactive) |
| created_at | DATETIME | - | NO | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | DATETIME | - | NO | CURRENT_TIMESTAMP ON UPDATE | 更新时间 |

**索引**:
- PRIMARY KEY: id
- INDEX: category
- INDEX: status
- INDEX: name

---

### 5. 服务表 (services)

存储服务项目信息。

| 字段名 | 类型 | 长度 | 允许NULL | 默认值 | 说明 |
|--------|------|------|----------|--------|------|
| id | BIGINT | - | NO | AUTO_INCREMENT | 主键 |
| name | VARCHAR | 100 | NO | - | 服务名称 |
| category | VARCHAR | 50 | NO | - | 分类 |
| price | DECIMAL | 10,2 | NO | 0.00 | 价格 |
| duration | INT | - | NO | 60 | 服务时长(分钟) |
| description | TEXT | - | YES | NULL | 描述 |
| image | VARCHAR | 255 | YES | NULL | 图片URL |
| commission_rate | DECIMAL | 5,2 | YES | 10.00 | 提成比例(%) |
| status | VARCHAR | 20 | NO | active | 状态(active/inactive) |
| created_at | DATETIME | - | NO | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | DATETIME | - | NO | CURRENT_TIMESTAMP ON UPDATE | 更新时间 |

**索引**:
- PRIMARY KEY: id
- INDEX: category
- INDEX: status
- INDEX: name

---

### 6. 订单表 (orders)

存储订单信息。

| 字段名 | 类型 | 长度 | 允许NULL | 默认值 | 说明 |
|--------|------|------|----------|--------|------|
| id | BIGINT | - | NO | AUTO_INCREMENT | 主键 |
| order_no | VARCHAR | 50 | NO | - | 订单号 |
| customer_id | BIGINT | - | YES | NULL | 顾客ID |
| employee_id | BIGINT | - | YES | NULL | 服务员工ID |
| total_amount | DECIMAL | 10,2 | NO | 0.00 | 总金额 |
| discount_amount | DECIMAL | 10,2 | YES | 0.00 | 优惠金额 |
| actual_amount | DECIMAL | 10,2 | NO | 0.00 | 实际金额 |
| payment_method | VARCHAR | 20 | YES | NULL | 支付方式 |
| status | VARCHAR | 20 | NO | pending | 状态 |
| notes | TEXT | - | YES | NULL | 备注 |
| created_at | DATETIME | - | NO | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | DATETIME | - | NO | CURRENT_TIMESTAMP ON UPDATE | 更新时间 |

**索引**:
- PRIMARY KEY: id
- UNIQUE KEY: order_no
- INDEX: customer_id
- INDEX: employee_id
- INDEX: status
- INDEX: created_at

---

### 7. 订单详情表 (order_items)

存储订单的商品和服务明细。

| 字段名 | 类型 | 长度 | 允许NULL | 默认值 | 说明 |
|--------|------|------|----------|--------|------|
| id | BIGINT | - | NO | AUTO_INCREMENT | 主键 |
| order_id | BIGINT | - | NO | - | 订单ID |
| type | VARCHAR | 20 | NO | - | 类型(product/service) |
| item_id | BIGINT | - | NO | - | 商品/服务ID |
| name | VARCHAR | 100 | NO | - | 名称 |
| price | DECIMAL | 10,2 | NO | 0.00 | 单价 |
| quantity | INT | - | NO | 1 | 数量 |
| subtotal | DECIMAL | 10,2 | NO | 0.00 | 小计 |
| employee_id | BIGINT | - | YES | NULL | 服务员工ID(服务项目) |
| created_at | DATETIME | - | NO | CURRENT_TIMESTAMP | 创建时间 |

**索引**:
- PRIMARY KEY: id
- INDEX: order_id
- INDEX: type
- INDEX: item_id

---

### 8. 预约表 (reservations)

存储预约信息。

| 字段名 | 类型 | 长度 | 允许NULL | 默认值 | 说明 |
|--------|------|------|----------|--------|------|
| id | BIGINT | - | NO | AUTO_INCREMENT | 主键 |
| reservation_no | VARCHAR | 50 | NO | - | 预约号 |
| customer_id | BIGINT | - | NO | - | 顾客ID |
| employee_id | BIGINT | - | YES | NULL | 员工ID |
| service_id | BIGINT | - | NO | - | 服务ID |
| room_id | BIGINT | - | YES | NULL | 房间ID |
| reservation_date | DATE | - | NO | - | 预约日期 |
| reservation_time | TIME | - | NO | - | 预约时间 |
| status | VARCHAR | 20 | NO | pending | 状态 |
| notes | TEXT | - | YES | NULL | 备注 |
| created_at | DATETIME | - | NO | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | DATETIME | - | NO | CURRENT_TIMESTAMP ON UPDATE | 更新时间 |

**索引**:
- PRIMARY KEY: id
- UNIQUE KEY: reservation_no
- INDEX: customer_id
- INDEX: employee_id
- INDEX: service_id
- INDEX: reservation_date
- INDEX: status

---

### 9. 考勤表 (attendances)

存储员工考勤记录。

| 字段名 | 类型 | 长度 | 允许NULL | 默认值 | 说明 |
|--------|------|------|----------|--------|------|
| id | BIGINT | - | NO | AUTO_INCREMENT | 主键 |
| employee_id | BIGINT | - | NO | - | 员工ID |
| attendance_date | DATE | - | NO | - | 考勤日期 |
| check_in_time | DATETIME | - | YES | NULL | 签到时间 |
| check_out_time | DATETIME | - | YES | NULL | 签退时间 |
| work_hours | DECIMAL | 4,1 | YES | 0.0 | 工作时长(小时) |
| status | VARCHAR | 20 | NO | normal | 状态 |
| notes | TEXT | - | YES | NULL | 备注 |
| created_at | DATETIME | - | NO | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | DATETIME | - | NO | CURRENT_TIMESTAMP ON UPDATE | 更新时间 |

**索引**:
- PRIMARY KEY: id
- INDEX: employee_id
- INDEX: attendance_date
- UNIQUE KEY: employee_id, attendance_date
- INDEX: status

---

### 10. 提成表 (commissions)

存储员工提成记录。

| 字段名 | 类型 | 长度 | 允许NULL | 默认值 | 说明 |
|--------|------|------|----------|--------|------|
| id | BIGINT | - | NO | AUTO_INCREMENT | 主键 |
| employee_id | BIGINT | - | NO | - | 员工ID |
| order_id | BIGINT | - | NO | - | 订单ID |
| order_item_id | BIGINT | - | NO | - | 订单项ID |
| amount | DECIMAL | 10,2 | NO | 0.00 | 提成金额 |
| rate | DECIMAL | 5,2 | NO | 10.00 | 提成比例(%) |
| status | VARCHAR | 20 | NO | unpaid | 状态(unpaid/paid) |
| created_at | DATETIME | - | NO | CURRENT_TIMESTAMP | 创建时间 |
| paid_at | DATETIME | - | YES | NULL | 发放时间 |

**索引**:
- PRIMARY KEY: id
- INDEX: employee_id
- INDEX: order_id
- INDEX: status

---

### 11. 排班表 (schedules)

存储员工排班信息。

| 字段名 | 类型 | 长度 | 允许NULL | 默认值 | 说明 |
|--------|------|------|----------|--------|------|
| id | BIGINT | - | NO | AUTO_INCREMENT | 主键 |
| employee_id | BIGINT | - | NO | - | 员工ID |
| shift_id | BIGINT | - | NO | - | 班次ID |
| schedule_date | DATE | - | NO | - | 排班日期 |
| notes | TEXT | - | YES | NULL | 备注 |
| created_at | DATETIME | - | NO | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | DATETIME | - | NO | CURRENT_TIMESTAMP ON UPDATE | 更新时间 |

**索引**:
- PRIMARY KEY: id
- INDEX: employee_id
- INDEX: shift_id
- INDEX: schedule_date
- UNIQUE KEY: employee_id, schedule_date

---

### 12. 班次表 (shifts)

存储班次信息。

| 字段名 | 类型 | 长度 | 允许NULL | 默认值 | 说明 |
|--------|------|------|----------|--------|------|
| id | BIGINT | - | NO | AUTO_INCREMENT | 主键 |
| name | VARCHAR | 50 | NO | - | 班次名称 |
| start_time | TIME | - | NO | - | 开始时间 |
| end_time | TIME | - | NO | - | 结束时间 |
| description | VARCHAR | 255 | YES | NULL | 描述 |
| created_at | DATETIME | - | NO | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | DATETIME | - | NO | CURRENT_TIMESTAMP ON UPDATE | 更新时间 |

**索引**:
- PRIMARY KEY: id

---

### 13. 库存表 (inventory)

存储商品库存信息。

| 字段名 | 类型 | 长度 | 允许NULL | 默认值 | 说明 |
|--------|------|------|----------|--------|------|
| id | BIGINT | - | NO | AUTO_INCREMENT | 主键 |
| product_id | BIGINT | - | NO | - | 商品ID |
| quantity | INT | - | NO | 0 | 库存数量 |
| min_stock | INT | - | NO | 10 | 最低库存预警 |
| location | VARCHAR | 100 | YES | NULL | 存放位置 |
| created_at | DATETIME | - | NO | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | DATETIME | - | NO | CURRENT_TIMESTAMP ON UPDATE | 更新时间 |

**索引**:
- PRIMARY KEY: id
- UNIQUE KEY: product_id

---

### 14. 房间表 (rooms)

存储服务房间信息。

| 字段名 | 类型 | 长度 | 允许NULL | 默认值 | 说明 |
|--------|------|------|----------|--------|------|
| id | BIGINT | - | NO | AUTO_INCREMENT | 主键 |
| name | VARCHAR | 50 | NO | - | 房间名称 |
| floor | VARCHAR | 20 | YES | NULL | 楼层 |
| capacity | INT | - | YES | 1 | 容纳人数 |
| status | VARCHAR | 20 | NO | available | 状态 |
| description | TEXT | - | YES | NULL | 描述 |
| created_at | DATETIME | - | NO | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | DATETIME | - | NO | CURRENT_TIMESTAMP ON UPDATE | 更新时间 |

**索引**:
- PRIMARY KEY: id
- INDEX: status

---

### 15. 会员卡表 (membership_cards)

存储会员卡信息。

| 字段名 | 类型 | 长度 | 允许NULL | 默认值 | 说明 |
|--------|------|------|----------|--------|------|
| id | BIGINT | - | NO | AUTO_INCREMENT | 主键 |
| card_no | VARCHAR | 50 | NO | - | 卡号 |
| customer_id | BIGINT | - | NO | - | 顾客ID |
| card_type_id | BIGINT | - | NO | - | 卡类型ID |
| balance | DECIMAL | 10,2 | NO | 0.00 | 余额 |
| points | INT | - | NO | 0 | 积分 |
| status | VARCHAR | 20 | NO | active | 状态(active/inactive) |
| created_at | DATETIME | - | NO | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | DATETIME | - | NO | CURRENT_TIMESTAMP ON UPDATE | 更新时间 |

**索引**:
- PRIMARY KEY: id
- UNIQUE KEY: card_no
- INDEX: customer_id
- INDEX: status

---

### 16. 卡类型表 (card_types)

存储会员卡类型信息。

| 字段名 | 类型 | 长度 | 允许NULL | 默认值 | 说明 |
|--------|------|------|----------|--------|------|
| id | BIGINT | - | NO | AUTO_INCREMENT | 主键 |
| name | VARCHAR | 50 | NO | - | 卡名称 |
| discount | DECIMAL | 5,2 | NO | 100.00 | 折扣(%) |
| points_rate | INT | - | NO | 1 | 积分倍率 |
| price | DECIMAL | 10,2 | NO | 0.00 | 办卡价格 |
| benefits | TEXT | - | YES | NULL | 权益说明 |
| status | VARCHAR | 20 | NO | active | 状态 |
| created_at | DATETIME | - | NO | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | DATETIME | - | NO | CURRENT_TIMESTAMP ON UPDATE | 更新时间 |

**索引**:
- PRIMARY KEY: id
- INDEX: status

---

### 17. 优惠券表 (coupons)

存储优惠券信息。

| 字段名 | 类型 | 长度 | 允许NULL | 默认值 | 说明 |
|--------|------|------|----------|--------|------|
| id | BIGINT | - | NO | AUTO_INCREMENT | 主键 |
| coupon_no | VARCHAR | 50 | NO | - | 券号 |
| customer_id | BIGINT | - | YES | NULL | 顾客ID(已领取) |
| name | VARCHAR | 100 | NO | - | 优惠券名称 |
| type | VARCHAR | 20 | NO | - | 类型(discount/fixed) |
| value | DECIMAL | 10,2 | NO | 0.00 | 优惠值 |
| min_amount | DECIMAL | 10,2 | YES | 0.00 | 最低使用金额 |
| start_date | DATE | - | YES | NULL | 开始日期 |
| end_date | DATE | - | YES | NULL | 结束日期 |
| status | VARCHAR | 20 | NO | unused | 状态(unused/used/expired) |
| used_at | DATETIME | - | YES | NULL | 使用时间 |
| created_at | DATETIME | - | NO | CURRENT_TIMESTAMP | 创建时间 |

**索引**:
- PRIMARY KEY: id
- UNIQUE KEY: coupon_no
- INDEX: customer_id
- INDEX: status
- INDEX: end_date

---

### 18. 营销活动表 (marketing_activities)

存储营销活动信息。

| 字段名 | 类型 | 长度 | 允许NULL | 默认值 | 说明 |
|--------|------|------|----------|--------|------|
| id | BIGINT | - | NO | AUTO_INCREMENT | 主键 |
| name | VARCHAR | 100 | NO | - | 活动名称 |
| description | TEXT | - | YES | NULL | 活动描述 |
| image | VARCHAR | 255 | YES | NULL | 活动图片 |
| start_date | DATE | - | YES | NULL | 开始日期 |
| end_date | DATE | - | YES | NULL | 结束日期 |
| status | VARCHAR | 20 | NO | draft | 状态(draft/active/ended) |
| created_at | DATETIME | - | NO | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | DATETIME | - | NO | CURRENT_TIMESTAMP ON UPDATE | 更新时间 |

**索引**:
- PRIMARY KEY: id
- INDEX: status
- INDEX: start_date
- INDEX: end_date

---

### 19. 薪酬表 (salaries)

存储员工薪酬记录。

| 字段名 | 类型 | 长度 | 允许NULL | 默认值 | 说明 |
|--------|------|------|----------|--------|------|
| id | BIGINT | - | NO | AUTO_INCREMENT | 主键 |
| employee_id | BIGINT | - | NO | - | 员工ID |
| year | INT | - | NO | - | 年份 |
| month | INT | - | NO | - | 月份 |
| base_salary | DECIMAL | 10,2 | NO | 0.00 | 基本工资 |
| commission | DECIMAL | 10,2 | NO | 0.00 | 提成奖金 |
| bonus | DECIMAL | 10,2 | NO | 0.00 | 其他奖金 |
| full_attendance_bonus | DECIMAL | 10,2 | NO | 0.00 | 全勤奖 |
| social_security | DECIMAL | 10,2 | NO | 0.00 | 社保扣款 |
| tax | DECIMAL | 10,2 | NO | 0.00 | 个税 |
| other_deduction | DECIMAL | 10,2 | NO | 0.00 | 其他扣款 |
| net_salary | DECIMAL | 10,2 | NO | 0.00 | 实发工资 |
| status | VARCHAR | 20 | NO | unpaid | 状态(unpaid/paid) |
| paid_at | DATETIME | - | YES | NULL | 发放时间 |
| created_at | DATETIME | - | NO | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | DATETIME | - | NO | CURRENT_TIMESTAMP ON UPDATE | 更新时间 |

**索引**:
- PRIMARY KEY: id
- INDEX: employee_id
- INDEX: year, month
- INDEX: status
- UNIQUE KEY: employee_id, year, month

---

## 关系说明

- **users** 是系统核心表，与 **employees** 和 **customers** 是一对一关系
- **orders** 与 **order_items** 是一对多关系
- **orders** 与 **commissions** 是一对多关系
- **customers** 与 **reservations** 是一对多关系
- **employees** 与 **attendances**、**schedules**、**commissions**、**salaries** 是一对多关系
- **products** 与 **inventory** 是一对一关系

---

## 初始化数据

### 管理员账号

- 用户名: admin
- 密码: admin123

### 员工账号

- 用户名: staff
- 密码: staff123

### 顾客账号

- 用户名: customer
- 密码: customer123
