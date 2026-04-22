# 美妆店智慧管理系统

## 项目简介

这是一个完整的美妆店智慧管理系统，包含前端界面和后端服务，支持管理员、员工和顾客三种角色登录。

## 项目结构

```
project1/
├── java-backend/          # Java后端项目
├── uniapp-frontend/       # Vue前端项目
├── database.sql           # 数据库脚本
└── docs/                  # 文档目录
```

## 技术栈

### 后端技术栈
- **Java 1.8**
- **Spring Boot 2.7.15**
- **Spring Data JPA**
- **MySQL 8.0**
- **Spring Security**

### 前端技术栈
- **Vue 2.x**
- **Vue Router 3.x**
- **uni-app**
- **HTML5/CSS3**

## 功能模块

### 管理员端功能
- 员工管理：添加、编辑、删除员工
- 顾客管理：添加、编辑、删除顾客
- 预约管理：查看、添加预约
- 排班管理：员工排班、班次管理
- 考勤管理：考勤记录查看、修改
- 薪酬管理：薪酬计算、发放
- 订单管理：查看订单、订单结算
- 库存管理：商品库存、库存预警
- 会员体系：会员卡类型、会员充值
- 优惠券管理：优惠券创建、发放
- 营销活动管理：活动策划、活动推广
- 核销管理：优惠券/积分/商品核销
- 本地生活团购：团购活动管理
- 支付管理：支付记录查看
- 数据统计：营业数据、员工业绩

### 员工端功能
- 考勤打卡：签到、签退
- 今日预约：查看和处理当日预约
- 开单（加钟）：服务项目加钟
- 扫码核销：优惠券/积分/商品扫码核销
- 我的业绩：个人业绩和提成统计
- 全员营销：营销活动推广
- 申请调班：调班申请管理
- 消息通知：系统消息查看
- 营销推广：活动分享、客户引流
- 订单结算：订单处理、收款
- 调班申请：班次调整、请假申请
- 消息通知：系统消息、工作通知

### 顾客端功能
- 个人资料：个人信息查看和修改
- 消费记录：历史消费查看
- 预约服务：服务预约、预约管理
- 评价系统：服务评价、商品评价
- 在线商城：商品浏览、购物车
- 积分商城：积分查看、积分兑换
- 本地生活团购：团购活动参与
- 营销活动：活动参与、优惠券领取
- 我的核销码：优惠券/积分核销码管理
- 推广员功能：推广码、佣金统计
- 消息通知：预约提醒、活动通知

## 快速开始

### 1. 环境准备

确保您的开发环境已安装以下软件：
- Java JDK 1.8+
- Node.js 14+
- MySQL 8.0+
- Maven 3.6+

### 2. 数据库配置

```bash
# 创建数据库
mysql -u root -p
CREATE DATABASE beauty_shop CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

# 导入数据库脚本
mysql -u root -p beauty_shop < database.sql
```

### 3. 后端启动

```bash
cd java-backend

# 修改数据库配置
# 编辑 src/main/resources/application.properties
# 修改数据库用户名和密码

# 使用Maven构建项目
mvn clean package

# 运行应用
java -jar target/beauty-shop-management-1.0.0.jar
```

后端服务将在 `http://localhost:8080` 启动。

### 4. 前端启动

```bash
cd uniapp-frontend

# 安装依赖
npm install

# 启动开发服务器
npm run dev
```

前端服务将在 `http://localhost:8081` 启动。

## 登录凭据

### 管理员
- 用户名：`admin`
- 密码：`admin123`

### 员工
- 用户名：`staff`
- 密码：`staff123`

### 顾客
- 用户名：`customer`
- 密码：`customer123`

## 数据库设计

### 核心数据表
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
- `shifts` - 班次表
- `inventory` - 库存表
- `rooms` - 房间表

## API文档

### 用户相关API
- `POST /api/users/login` - 用户登录
- `POST /api/users/register` - 用户注册

### 员工相关API
- `GET /api/employees` - 获取员工列表
- `POST /api/employees` - 添加员工
- `PUT /api/employees/{id}` - 更新员工信息
- `DELETE /api/employees/{id}` - 删除员工

### 顾客相关API
- `GET /api/customers` - 获取顾客列表
- `POST /api/customers` - 添加顾客
- `PUT /api/customers/{id}` - 更新顾客信息
- `DELETE /api/customers/{id}` - 删除顾客

### 其他API
完整的API文档请参见后端代码中的 `controller` 包。

## 开发规范

### 代码风格
- 后端遵循阿里巴巴Java开发规范
- 前端遵循ESLint规范
- 使用清晰的变量和函数命名
- 添加必要的代码注释

### Git提交规范
- `feat:` 新功能
- `fix:` 修复bug
- `docs:` 文档更新
- `style:` 代码格式调整
- `refactor:` 重构
- `test:` 测试相关
- `chore:` 构建/工具相关

## 常见问题

### 1. 后端启动失败
- 检查MySQL服务是否启动
- 检查数据库连接配置是否正确
- 检查端口8080是否被占用

### 2. 前端启动失败
- 检查Node.js版本是否符合要求
- 删除node_modules重新安装依赖
- 检查端口8081是否被占用

### 3. 登录失败
- 确认使用正确的登录凭据
- 检查后端服务是否正常运行
- 清除浏览器缓存重试

## 项目维护

### 版本更新
定期更新依赖版本以修复安全漏洞：
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

## 联系方式

如有问题或建议，请联系项目维护者。

## 许可证

本项目遵循MIT许可证。
