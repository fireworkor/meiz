# 美妆店智慧管理系统

## 项目简介

这是一个面向美容美发行业的智慧管理系统，提供员工管理、顾客管理、预约管理、订单管理、会员管理、库存管理、营销活动管理等核心功能。系统支持管理员、员工、顾客三种角色，满足店铺日常运营管理的需求。

## 项目结构

```
project1/
├── java-backend/          # Java后端项目 (Spring Boot)
├── uniapp-frontend/       # Vue前端项目 (uni-app)
├── database.sql           # 数据库脚本
└── docs/                  # 详细文档目录
```

## 文档体系

本项目的完整文档位于 `docs/` 目录下，包括：

| 文档 | 说明 |
|------|------|
| [README.md](README.md) | 项目概述、快速开始 |
| [ARCHITECTURE.md](ARCHITECTURE.md) | 系统架构设计 |
| [DATABASE.md](DATABASE.md) | 数据库设计文档 |
| [API.md](API.md) | API接口文档 |
| [MODULES.md](MODULES.md) | 模块详细设计 |
| [DEPLOYMENT.md](DEPLOYMENT.md) | 部署指南 |
| [DEVELOPER.md](DEVELOPER.md) | 开发指南 |

## 技术栈

### 后端技术栈
- **Java 1.8** - 编程语言
- **Spring Boot 2.7.15** - Web应用框架
- **Spring Data JPA** - 数据访问
- **Spring Security** - 安全框架
- **MySQL 8.0** - 关系型数据库

### 前端技术栈
- **Vue 2.x** - 前端框架
- **uni-app** - 跨平台框架
- **Vite** - 构建工具

## 快速开始

### 1. 环境准备

确保开发环境已安装：
- Java JDK 1.8+
- Node.js 14+
- MySQL 8.0+
- Maven 3.6+

### 2. 数据库配置

```bash
# 创建数据库
mysql -u root -p
CREATE DATABASE beauty_shop CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
EXIT;

# 导入数据
mysql -u root -p beauty_shop < database.sql
```

### 3. 后端启动

```bash
cd java-backend

# 修改数据库配置
# 编辑 src/main/resources/application.properties
# 修改数据库用户名和密码

# 使用Maven构建
mvn clean package

# 运行应用
java -jar target/beautyshop-1.0.0.jar
```

后端服务地址：`http://localhost:8080`

### 4. 前端启动

```bash
cd uniapp-frontend

# 安装依赖
npm install

# 启动开发服务器
npm run dev
```

前端服务地址：`http://localhost:8081`

## 默认登录账号

| 角色 | 用户名 | 密码 |
|------|--------|------|
| 管理员 | admin | admin123 |
| 员工 | staff1 | （需在数据库中设置） |
| 顾客 | customer1 | （需在数据库中设置） |

## 功能模块

### 管理员端
- 员工管理、顾客管理
- 预约管理、订单管理
- 会员管理、优惠券管理
- 库存管理、营销活动
- 排班管理、考勤管理
- 数据统计

### 员工端
- 考勤打卡、业绩查询
- 预约查看、订单结算
- 营销推广、调班申请
- 消息通知

### 顾客端
- 个人信息、预约服务
- 在线商城、积分兑换
- 营销活动、评价系统
- 消息通知、推广功能

## 数据库设计

核心数据表：
- `users` - 用户表（管理员、员工、顾客）
- `employees` - 员工表
- `customers` - 顾客表
- `products` - 商品表
- `services` - 服务项目表
- `orders` - 订单表
- `reservations` - 预约表
- `membership_cards` - 会员卡表
- `coupons` - 优惠券表
- `marketing_activities` - 营销活动表
- `attendances` - 考勤表
- `commissions` - 提成表
- `schedules` - 排班表
- `shifts` - 交班表
- `inventory` - 库存表
- `rooms` - 房间表

详细数据库设计请参见 [DATABASE.md](docs/DATABASE.md)

## 开发规范

### 后端规范
- 遵循阿里巴巴Java开发规范
- 使用Spring Boot标准项目结构
- RESTful API设计原则
- 分层架构：Controller → Service → Repository

### 前端规范
- Vue组件规范
- 统一的API调用封装
- 响应式数据管理
- 页面路由基于角色控制

## 常见问题

### 1. 后端启动失败
- 检查MySQL服务是否启动
- 检查数据库连接配置
- 检查端口8080是否被占用

### 2. 前端启动失败
- 检查Node.js版本
- 删除node_modules重新安装
- 检查端口8081是否被占用

### 3. 登录失败
- 确认使用正确的登录凭据
- 检查后端服务是否运行
- 清除浏览器缓存重试

## 项目维护

### 依赖更新
```bash
# Maven依赖更新
mvn versions:display-dependency-updates

# npm依赖更新
npm update
```

### 备份策略
- 定期备份数据库
- 使用Git进行代码版本控制
- 重要数据进行多地点备份

## 许可证

本项目遵循MIT许可证。
