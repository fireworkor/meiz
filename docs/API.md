# 美妆店智慧管理系统 - API接口文档

## 1. 接口概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| Base URL | `http://localhost:8080/api` |
| 数据格式 | JSON |
| 字符编码 | UTF-8 |
| 认证方式 | Bearer Token |

### 1.2 通用请求头

```
Content-Type: application/json
Authorization: Bearer <token>
```

### 1.3 通用响应格式

**成功响应：**
```json
{
  "success": true,
  "message": "操作成功",
  "data": { }
}
```

**错误响应：**
```json
{
  "success": false,
  "message": "错误信息"
}
```

---

## 2. 用户模块 (User)

### 2.1 用户登录

**接口路径：** `POST /users/login`

**请求参数：**
```json
{
  "username": "admin",
  "password": "admin123",
  "role": "admin"
}
```

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| username | String | 是 | 用户名 |
| password | String | 是 | 密码 |
| role | String | 是 | 角色：admin/staff/customer |

**响应示例：**
```json
{
  "success": true,
  "message": "登录成功",
  "token": "mock-token",
  "role": "admin",
  "username": "admin",
  "userId": 1
}
```

---

### 2.2 用户注册

**接口路径：** `POST /users/register`

**请求参数：**
```json
{
  "username": "test",
  "password": "123456",
  "role": "customer",
  "name": "测试用户",
  "phone": "13800138000"
}
```

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| username | String | 是 | 用户名 |
| password | String | 是 | 密码 |
| role | String | 是 | 角色 |
| name | String | 是 | 姓名 |
| phone | String | 是 | 手机号 |

**响应示例：**
```json
{
  "success": true,
  "message": "注册成功",
  "data": {
    "id": 1,
    "username": "test",
    "role": "customer",
    "name": "测试用户",
    "phone": "13800138000"
  }
}
```

---

## 3. 员工模块 (Employee)

### 3.1 获取员工列表

**接口路径：** `GET /employees`

**查询参数：**
| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| status | String | 否 | 员工状态：在职/离职/休假 |

**响应示例：**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "张美容师",
      "phone": "13800138001",
      "position": "高级美容师",
      "employeeId": "EMP001",
      "entryDate": "2024-01-01",
      "status": "active",
      "skillTags": "面部护理,身体SPA"
    }
  ]
}
```

---

### 3.2 获取员工详情

**接口路径：** `GET /employees/{id}`

**路径参数：**
| 参数名 | 类型 | 说明 |
|--------|------|------|
| id | Long | 员工ID |

**响应示例：**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "userId": 1,
    "name": "张美容师",
    "phone": "13800138001",
    "position": "高级美容师",
    "employeeId": "EMP001",
    "idCard": "110101199001011234",
    "emergencyContact": "张明",
    "emergencyPhone": "13900139001",
    "entryDate": "2024-01-01",
    "status": "active",
    "skillTags": "面部护理,身体SPA"
  }
}
```

---

### 3.3 添加员工

**接口路径：** `POST /employees`

**请求参数：**
```json
{
  "name": "李美容师",
  "phone": "13800138002",
  "position": "美容师",
  "employeeId": "EMP002",
  "idCard": "110101199002022345",
  "emergencyContact": "李华",
  "emergencyPhone": "13900139002",
  "entryDate": "2024-02-01",
  "skillTags": "美甲,纹绣"
}
```

**响应示例：**
```json
{
  "success": true,
  "message": "员工添加成功",
  "data": {
    "id": 2,
    "employeeId": "EMP002"
  }
}
```

---

### 3.4 更新员工信息

**接口路径：** `PUT /employees/{id}`

**请求参数：**
```json
{
  "name": "李美容师",
  "phone": "13800138002",
  "position": "高级美容师",
  "skillTags": "美甲,纹绣,面部护理"
}
```

**响应示例：**
```json
{
  "success": true,
  "message": "员工信息更新成功"
}
```

---

### 3.5 删除员工

**接口路径：** `DELETE /employees/{id}`

**响应示例：**
```json
{
  "success": true,
  "message": "员工删除成功"
}
```

---

## 4. 顾客模块 (Customer)

### 4.1 获取顾客列表

**接口路径：** `GET /customers`

**查询参数：**
| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| sourceChannel | String | 否 | 来源渠道 |
| tags | String | 否 | 顾客标签 |

**响应示例：**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "王女士",
      "phone": "13900139001",
      "gender": "女",
      "birthday": "1990-05-20",
      "wechat": "wang_nvshi",
      "memberLevel": "VIP",
      "points": 5000,
      "tags": "高消费,活跃用户"
    }
  ]
}
```

---

### 4.2 获取顾客详情

**接口路径：** `GET /customers/{id}`

**路径参数：**
| 参数名 | 类型 | 说明 |
|--------|------|------|
| id | Long | 顾客ID |

**响应示例：**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "王女士",
    "phone": "13900139001",
    "gender": "女",
    "birthday": "1990-05-20",
    "wechat": "wang_nvshi",
    "occupation": "企业高管",
    "sourceChannel": "朋友推荐",
    "skinType": "混合性",
    "allergyHistory": "无",
    "skinProblems": "T区油光",
    "preferredItems": "面部护理,身体SPA",
    "preferredEmployee": "张美容师",
    "preferredTime": "周末下午",
    "averageSpending": 500.00,
    "memberLevel": "VIP",
    "points": 5000,
    "tags": "高消费,活跃用户"
  }
}
```

---

### 4.3 添加顾客

**接口路径：** `POST /customers`

**请求参数：**
```json
{
  "name": "赵女士",
  "phone": "13900139002",
  "gender": "女",
  "birthday": "1995-08-15",
  "wechat": "zhao_nvshi",
  "occupation": "教师",
  "sourceChannel": "线上推广",
  "skinType": "干性",
  "tags": "新客户"
}
```

**响应示例：**
```json
{
  "success": true,
  "message": "顾客添加成功",
  "data": {
    "id": 2
  }
}
```

---

### 4.4 更新顾客信息

**接口路径：** `PUT /customers/{id}`

**请求参数：**
```json
{
  "name": "赵女士",
  "phone": "13900139002",
  "skinType": "干性",
  "preferredItems": "面部护理",
  "tags": "新客户,潜在VIP"
}
```

**响应示例：**
```json
{
  "success": true,
  "message": "顾客信息更新成功"
}
```

---

### 4.5 删除顾客

**接口路径：** `DELETE /customers/{id}`

**响应示例：**
```json
{
  "success": true,
  "message": "顾客删除成功"
}
```

---

## 5. 预约模块 (Reservation)

### 5.1 获取预约列表

**接口路径：** `GET /reservations`

**查询参数：**
| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| date | String | 否 | 预约日期（格式：yyyy-MM-dd） |
| status | String | 否 | 预约状态 |
| employeeId | Long | 否 | 员工ID |

**响应示例：**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "customerName": "王女士",
      "employeeName": "张美容师",
      "serviceName": "面部护理",
      "roomName": "VIP房1",
      "reservationDate": "2024-04-22 14:00:00",
      "status": "confirmed",
      "source": "顾客自助预约"
    }
  ]
}
```

---

### 5.2 获取预约详情

**接口路径：** `GET /reservations/{id}`

**路径参数：**
| 参数名 | 类型 | 说明 |
|--------|------|------|
| id | Long | 预约ID |

**响应示例：**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "customerId": 1,
    "customerName": "王女士",
    "employeeId": 1,
    "employeeName": "张美容师",
    "serviceId": 1,
    "serviceName": "面部护理",
    "roomId": 1,
    "roomName": "VIP房1",
    "reservationDate": "2024-04-22 14:00:00",
    "status": "confirmed",
    "source": "顾客自助预约"
  }
}
```

---

### 5.3 创建预约

**接口路径：** `POST /reservations`

**请求参数：**
```json
{
  "customerId": 1,
  "employeeId": 1,
  "serviceId": 1,
  "roomId": 1,
  "reservationDate": "2024-04-23 15:00:00",
  "source": "顾客自助预约"
}
```

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| customerId | Long | 是 | 顾客ID |
| employeeId | Long | 是 | 员工ID |
| serviceId | Long | 是 | 服务ID |
| roomId | Long | 是 | 房间ID |
| reservationDate | String | 是 | 预约时间 |
| source | String | 是 | 来源：前台代约/顾客自助预约 |

**响应示例：**
```json
{
  "success": true,
  "message": "预约创建成功",
  "data": {
    "id": 2
  }
}
```

---

### 5.4 更新预约状态

**接口路径：** `PUT /reservations/{id}/status`

**请求参数：**
```
status=completed
```

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| status | String | 是 | 状态：待确认/已确认/已到店/已完成/已取消/爽约 |

**响应示例：**
```json
{
  "success": true,
  "message": "预约状态更新成功"
}
```

---

### 5.5 取消预约

**接口路径：** `PUT /reservations/{id}/cancel`

**响应示例：**
```json
{
  "success": true,
  "message": "预约取消成功"
}
```

---

## 6. 订单模块 (Order)

### 6.1 获取订单列表

**接口路径：** `GET /orders`

**查询参数：**
| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| date | String | 否 | 订单日期 |
| status | String | 否 | 订单状态 |
| customerId | Long | 否 | 顾客ID |

**响应示例：**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "orderNo": "ORD20240422001",
      "customerName": "王女士",
      "employeeName": "张美容师",
      "orderDate": "2024-04-22 15:30:00",
      "totalAmount": 599.00,
      "paymentMethod": "微信",
      "status": "completed"
    }
  ]
}
```

---

### 6.2 获取订单详情

**接口路径：** `GET /orders/{id}`

**路径参数：**
| 参数名 | 类型 | 说明 |
|--------|------|------|
| id | Long | 订单ID |

**响应示例：**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "orderNo": "ORD20240422001",
    "customerId": 1,
    "customerName": "王女士",
    "employeeId": 1,
    "employeeName": "张美容师",
    "orderDate": "2024-04-22 15:30:00",
    "totalAmount": 599.00,
    "paymentMethod": "微信",
    "status": "completed",
    "items": [
      {
        "id": 1,
        "itemType": "service",
        "itemName": "面部护理",
        "quantity": 1,
        "price": 399.00
      },
      {
        "id": 2,
        "itemType": "product",
        "itemName": "精华液",
        "quantity": 1,
        "price": 200.00
      }
    ]
  }
}
```

---

### 6.3 创建订单

**接口路径：** `POST /orders`

**请求参数：**
```json
{
  "customerId": 1,
  "employeeId": 1,
  "paymentMethod": "微信",
  "items": [
    {
      "itemType": "service",
      "itemId": 1,
      "quantity": 1
    },
    {
      "itemType": "product",
      "itemId": 1,
      "quantity": 1
    }
  ],
  "couponId": 1,
  "usePoints": 100
}
```

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| customerId | Long | 是 | 顾客ID |
| employeeId | Long | 是 | 服务员工ID |
| paymentMethod | String | 是 | 支付方式 |
| items | Array | 是 | 订单项目列表 |
| couponId | Long | 否 | 使用优惠券ID |
| usePoints | Integer | 否 | 使用积分数量 |

**响应示例：**
```json
{
  "success": true,
  "message": "订单创建成功",
  "data": {
    "id": 2,
    "orderNo": "ORD20240422002",
    "totalAmount": 499.00
  }
}
```

---

### 6.4 更新订单状态

**接口路径：** `PUT /orders/{id}/status`

**请求参数：**
```
status=completed
```

**响应示例：**
```json
{
  "success": true,
  "message": "订单状态更新成功"
}
```

---

### 6.5 订单退款

**接口路径：** `PUT /orders/{id}/refund`

**请求参数：**
```
reason=商品不满意
```

**响应示例：**
```json
{
  "success": true,
  "message": "订单退款成功"
}
```

---

## 7. 商品模块 (Product)

### 7.1 获取商品列表

**接口路径：** `GET /products`

**查询参数：**
| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| category | String | 否 | 商品分类 |
| status | String | 否 | 状态 |

**响应示例：**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "精华液",
      "description": "深层补水精华",
      "price": 299.00,
      "costPrice": 150.00,
      "category": "护肤品",
      "stock": 50,
      "status": "active"
    }
  ]
}
```

---

### 7.2 获取商品详情

**接口路径：** `GET /products/{id}`

**响应示例：**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "精华液",
    "description": "深层补水精华",
    "price": 299.00,
    "costPrice": 150.00,
    "category": "护肤品",
    "stock": 50,
    "status": "active"
  }
}
```

---

### 7.3 添加商品

**接口路径：** `POST /products`

**请求参数：**
```json
{
  "name": "面膜",
  "description": "补水面膜",
  "price": 89.00,
  "costPrice": 45.00,
  "category": "护肤品",
  "stock": 100
}
```

**响应示例：**
```json
{
  "success": true,
  "message": "商品添加成功",
  "data": {
    "id": 2
  }
}
```

---

### 7.4 更新商品

**接口路径：** `PUT /products/{id}`

**请求参数：**
```json
{
  "name": "面膜",
  "description": "深层补水面膜",
  "price": 99.00,
  "costPrice": 50.00,
  "category": "护肤品",
  "stock": 80
}
```

**响应示例：**
```json
{
  "success": true,
  "message": "商品更新成功"
}
```

---

### 7.5 删除商品

**接口路径：** `DELETE /products/{id}`

**响应示例：**
```json
{
  "success": true,
  "message": "商品删除成功"
}
```

---

## 8. 库存模块 (Inventory)

### 8.1 获取库存列表

**接口路径：** `GET /inventory`

**查询参数：**
| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| productId | Long | 否 | 商品ID |
| lowStock | Boolean | 否 | 仅显示低库存 |

**响应示例：**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "productId": 1,
      "productName": "精华液",
      "quantity": 50,
      "minStock": 10,
      "batchNumber": "BATCH20240401",
      "supplier": "供应商A",
      "expiryDate": "2025-04-01",
      "location": "A区货架"
    }
  ]
}
```

---

### 8.2 添加库存

**接口路径：** `POST /inventory/add`

**请求参数：**
```json
{
  "productId": 1,
  "quantity": 20,
  "batchNumber": "BATCH20240402",
  "supplier": "供应商B",
  "expiryDate": "2025-04-15"
}
```

**响应示例：**
```json
{
  "success": true,
  "message": "库存添加成功"
}
```

---

### 8.3 库存预警

**接口路径：** `GET /inventory/warning`

**响应示例：**
```json
{
  "success": true,
  "data": [
    {
      "productId": 2,
      "productName": "面膜",
      "currentStock": 5,
      "minStock": 10
    }
  ]
}
```

---

## 9. 会员模块 (Membership Card)

### 9.1 获取会员卡列表

**接口路径：** `GET /membership-cards`

**查询参数：**
| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| customerId | Long | 否 | 顾客ID |
| status | String | 否 | 卡状态 |

**响应示例：**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "memberId": 1,
      "customerName": "王女士",
      "cardType": "储值卡",
      "cardNumber": "MEM202404001",
      "balance": 5000.00,
      "remainingTimes": 0,
      "discountRate": 100,
      "startDate": "2024-01-01",
      "endDate": "2025-12-31",
      "status": "active"
    }
  ]
}
```

---

### 9.2 会员卡充值

**接口路径：** `POST /membership-cards/{id}/recharge`

**请求参数：**
```json
{
  "amount": 1000
}
```

**响应示例：**
```json
{
  "success": true,
  "message": "充值成功",
  "data": {
    "balance": 6000.00
  }
}
```

---

### 9.3 创建会员卡

**接口路径：** `POST /membership-cards`

**请求参数：**
```json
{
  "customerId": 1,
  "cardType": "储值卡",
  "initialBalance": 5000,
  "discountRate": 90
}
```

**响应示例：**
```json
{
  "success": true,
  "message": "会员卡创建成功",
  "data": {
    "id": 2,
    "cardNumber": "MEM202404002"
  }
}
```

---

## 10. 优惠券模块 (Coupon)

### 10.1 获取优惠券列表

**接口路径：** `GET /coupons`

**查询参数：**
| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| status | String | 否 | 状态 |

**响应示例：**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "新客满100减20",
      "type": "满减券",
      "value": 20.00,
      "minAmount": 100.00,
      "totalCount": 100,
      "remainCount": 80,
      "startDate": "2024-04-01",
      "endDate": "2024-04-30",
      "status": "active"
    }
  ]
}
```

---

### 10.2 发放优惠券

**接口路径：** `POST /coupons/{id}/distribute`

**请求参数：**
```json
{
  "customerIds": [1, 2, 3]
}
```

**响应示例：**
```json
{
  "success": true,
  "message": "优惠券发放成功"
}
```

---

### 10.3 创建优惠券

**接口路径：** `POST /coupons`

**请求参数：**
```json
{
  "name": "节日特惠券",
  "type": "满减券",
  "value": 50.00,
  "minAmount": 200.00,
  "totalCount": 200,
  "startDate": "2024-05-01",
  "endDate": "2024-05-07"
}
```

**响应示例：**
```json
{
  "success": true,
  "message": "优惠券创建成功",
  "data": {
    "id": 2
  }
}
```

---

## 11. 考勤模块 (Attendance)

### 11.1 获取考勤记录

**接口路径：** `GET /attendances`

**查询参数：**
| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| employeeId | Long | 否 | 员工ID |
| startDate | String | 否 | 开始日期 |
| endDate | String | 否 | 结束日期 |

**响应示例：**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "employeeId": 1,
      "employeeName": "张美容师",
      "checkInTime": "2024-04-22 09:00:00",
      "checkOutTime": "2024-04-22 18:00:00",
      "checkInLocation": "店铺地址",
      "status": "normal"
    }
  ]
}
```

---

### 11.2 签到

**接口路径：** `POST /attendances/check-in`

**请求参数：**
```json
{
  "employeeId": 1,
  "location": "店铺地址",
  "photo": "base64..."
}
```

**响应示例：**
```json
{
  "success": true,
  "message": "签到成功",
  "data": {
    "attendanceId": 1,
    "checkInTime": "2024-04-22 09:00:00"
  }
}
```

---

### 11.3 签退

**接口路径：** `POST /attendances/check-out`

**请求参数：**
```json
{
  "attendanceId": 1,
  "location": "店铺地址",
  "photo": "base64..."
}
```

**响应示例：**
```json
{
  "success": true,
  "message": "签退成功",
  "data": {
    "checkOutTime": "2024-04-22 18:00:00",
    "status": "normal"
  }
}
```

---

## 12. 排班模块 (Schedule)

### 12.1 获取排班列表

**接口路径：** `GET /schedules`

**查询参数：**
| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| employeeId | Long | 否 | 员工ID |
| startDate | String | 否 | 开始日期 |
| endDate | String | 否 | 结束日期 |

**响应示例：**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "employeeId": 1,
      "employeeName": "张美容师",
      "scheduleDate": "2024-04-22",
      "shiftType": "早班",
      "startTime": "09:00:00",
      "endTime": "17:00:00"
    }
  ]
}
```

---

### 12.2 创建排班

**接口路径：** `POST /schedules`

**请求参数：**
```json
{
  "employeeId": 1,
  "scheduleDate": "2024-04-23",
  "shiftType": "早班",
  "startTime": "09:00:00",
  "endTime": "17:00:00"
}
```

**响应示例：**
```json
{
  "success": true,
  "message": "排班创建成功",
  "data": {
    "id": 2
  }
}
```

---

### 12.3 批量创建排班

**接口路径：** `POST /schedules/batch`

**请求参数：**
```json
{
  "schedules": [
    {
      "employeeId": 1,
      "scheduleDate": "2024-04-23",
      "shiftType": "早班",
      "startTime": "09:00:00",
      "endTime": "17:00:00"
    },
    {
      "employeeId": 2,
      "scheduleDate": "2024-04-23",
      "shiftType": "中班",
      "startTime": "13:00:00",
      "endTime": "21:00:00"
    }
  ]
}
```

**响应示例：**
```json
{
  "success": true,
  "message": "批量排班创建成功"
}
```

---

## 13. 房间模块 (Room)

### 13.1 获取房间列表

**接口路径：** `GET /rooms`

**查询参数：**
| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| type | String | 否 | 房间类型 |
| status | String | 否 | 房间状态 |

**响应示例：**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "VIP房1",
      "type": "VIP房",
      "capacity": 2,
      "status": "available"
    },
    {
      "id": 2,
      "name": "单人间1",
      "type": "单人间",
      "capacity": 1,
      "status": "occupied"
    }
  ]
}
```

---

### 13.2 更新房间状态

**接口路径：** `PUT /rooms/{id}/status`

**请求参数：**
```
status=cleaning
```

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| status | String | 是 | 状态：occupied/available/cleaning |

**响应示例：**
```json
{
  "success": true,
  "message": "房间状态更新成功"
}
```

---

## 14. 数据统计模块 (Dashboard)

### 14.1 获取仪表盘数据

**接口路径：** `GET /dashboard/data`

**响应示例：**
```json
{
  "success": true,
  "data": {
    "todayRevenue": 15000.00,
    "monthRevenue": 450000.00,
    "todayOrders": 25,
    "todayCustomers": 18,
    "pendingReservations": 5,
    "lowStockProducts": 3,
    "employeePerformance": [
      {
        "employeeName": "张美容师",
        "revenue": 8000.00,
        "orders": 12,
        "services": 15
      }
    ],
    "serviceStats": [
      {
        "serviceName": "面部护理",
        "count": 20,
        "revenue": 7980.00
      }
    ],
    "recentOrders": [
      {
        "id": 1,
        "orderNo": "ORD20240422001",
        "customerName": "王女士",
        "totalAmount": 599.00,
        "orderDate": "2024-04-22 15:30:00"
      }
    ]
  }
}
```

---

## 15. 提成模块 (Commission)

### 15.1 获取提成列表

**接口路径：** `GET /commissions`

**查询参数：**
| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| employeeId | Long | 否 | 员工ID |
| startDate | String | 否 | 开始日期 |
| endDate | String | 否 | 结束日期 |
| status | String | 否 | 结算状态 |

**响应示例：**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "employeeId": 1,
      "employeeName": "张美容师",
      "orderId": 1,
      "orderNo": "ORD20240422001",
      "commissionType": "服务提成",
      "amount": 80.00,
      "commissionDate": "2024-04-22",
      "status": "pending"
    }
  ]
}
```

---

### 15.2 结算提成

**接口路径：** `PUT /commissions/{id}/settle`

**响应示例：**
```json
{
  "success": true,
  "message": "提成结算成功"
}
```

---

### 15.3 批量结算提成

**接口路径：** `PUT /commissions/batch-settle`

**请求参数：**
```json
{
  "commissionIds": [1, 2, 3]
}
```

**响应示例：**
```json
{
  "success": true,
  "message": "批量结算成功"
}
```

---

## 16. 错误码说明

| 错误码 | 说明 |
|--------|------|
| 1001 | 参数错误 |
| 1002 | 必填参数为空 |
| 2001 | 数据不存在 |
| 2002 | 数据已存在 |
| 2003 | 数据关联错误 |
| 3001 | 权限不足 |
| 3002 | Token无效 |
| 3003 | Token过期 |
| 4001 | 业务规则错误 |
| 4002 | 余额不足 |
| 4003 | 库存不足 |
| 5001 | 服务器内部错误 |
