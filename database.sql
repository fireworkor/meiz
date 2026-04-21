-- 创建数据库
CREATE DATABASE IF NOT EXISTS beauty_shop CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE beauty_shop;

-- 用户表
CREATE TABLE IF NOT EXISTS users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL, -- admin, staff, customer
    name VARCHAR(50) NOT NULL,
    phone VARCHAR(20) UNIQUE NOT NULL,
    avatar VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 员工表
CREATE TABLE IF NOT EXISTS employees (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    position VARCHAR(50) NOT NULL,
    entry_date DATE NOT NULL,
    employee_id VARCHAR(20) UNIQUE NOT NULL,
    id_card VARCHAR(20) NOT NULL,
    emergency_contact VARCHAR(50) NOT NULL,
    emergency_phone VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL, -- 在职/离职/休假
    skill_tags VARCHAR(255), -- 擅长项目，逗号分隔
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 员工提成比例表
CREATE TABLE IF NOT EXISTS commission_rates (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    employee_id BIGINT NOT NULL,
    service_id BIGINT NOT NULL,
    rate DECIMAL(5,2) NOT NULL, -- 提成比例
    FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE
);

-- 考勤表
CREATE TABLE IF NOT EXISTS attendances (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    employee_id BIGINT NOT NULL,
    check_in_time DATETIME NOT NULL,
    check_out_time DATETIME,
    check_in_location VARCHAR(255),
    check_out_location VARCHAR(255),
    check_in_photo VARCHAR(255),
    check_out_photo VARCHAR(255),
    status VARCHAR(20) NOT NULL, -- 正常/迟到/旷工
    FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE
);

-- 顾客表
CREATE TABLE IF NOT EXISTS customers (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    birthday DATE,
    gender VARCHAR(10),
    wechat VARCHAR(50),
    occupation VARCHAR(50),
    source_channel VARCHAR(50), -- 来源渠道
    skin_type VARCHAR(50), -- 肤质类型
    allergy_history VARCHAR(255), -- 过敏史
    skin_problems VARCHAR(255), -- 皮肤问题
    preferred_items VARCHAR(255), -- 偏好项目
    preferred_employee VARCHAR(50), -- 偏好美容师
    preferred_time VARCHAR(50), -- 偏好时间段
    average_spending DECIMAL(10,2), -- 客单价
    tags VARCHAR(255), -- 标签，逗号分隔
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 服务记录表
CREATE TABLE IF NOT EXISTS service_records (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    employee_id BIGINT NOT NULL,
    service_id BIGINT NOT NULL,
    order_id BIGINT NOT NULL,
    service_date DATETIME NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    notes VARCHAR(255),
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
    FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE
);

-- 互动记录表
CREATE TABLE IF NOT EXISTS interaction_records (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    type VARCHAR(50) NOT NULL, -- 投诉/回访/生日问候/活动参与
    content VARCHAR(255) NOT NULL,
    record_date DATETIME NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
);

-- 服务表
CREATE TABLE IF NOT EXISTS services (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(255),
    price DECIMAL(10,2) NOT NULL,
    duration INT NOT NULL, -- 服务时长（分钟）
    status VARCHAR(20) NOT NULL -- 启用/禁用
);

-- 产品表
CREATE TABLE IF NOT EXISTS products (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(255),
    price DECIMAL(10,2) NOT NULL,
    cost_price DECIMAL(10,2) NOT NULL,
    category VARCHAR(50) NOT NULL,
    status VARCHAR(20) NOT NULL -- 启用/禁用
);

-- 库存表
CREATE TABLE IF NOT EXISTS inventory (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    product_id BIGINT NOT NULL,
    quantity INT NOT NULL,
    batch_number VARCHAR(50),
    supplier VARCHAR(50),
    expiry_date DATE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- 订单表
CREATE TABLE IF NOT EXISTS orders (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    employee_id BIGINT NOT NULL,
    order_date DATETIME NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(50) NOT NULL, -- 现金/微信/支付宝/银行卡/储值余额
    status VARCHAR(20) NOT NULL, -- 待支付/已支付/已完成/已退款
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
    FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE
);

-- 订单项表
CREATE TABLE IF NOT EXISTS order_items (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_id BIGINT NOT NULL,
    item_type VARCHAR(20) NOT NULL, -- service/product
    item_id BIGINT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);

-- 预约表
CREATE TABLE IF NOT EXISTS reservations (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    employee_id BIGINT NOT NULL,
    service_id BIGINT NOT NULL,
    room_id BIGINT NOT NULL,
    reservation_date DATETIME NOT NULL,
    status VARCHAR(20) NOT NULL, -- 待确认/已确认/已到店/已完成/已取消/爽约
    source VARCHAR(20) NOT NULL, -- 前台代约/顾客自助预约
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
    FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE
);

-- 排班表
CREATE TABLE IF NOT EXISTS schedules (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    employee_id BIGINT NOT NULL,
    schedule_date DATE NOT NULL,
    shift_type VARCHAR(20) NOT NULL, -- 早班/中班/晚班/休息
    start_time TIME,
    end_time TIME,
    FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE
);

-- 房间表
CREATE TABLE IF NOT EXISTS rooms (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    type VARCHAR(20) NOT NULL, -- VIP房/双人间/单人间
    capacity INT NOT NULL, -- 容量
    status VARCHAR(20) NOT NULL -- 占用/空闲/清洁中
);

-- 会员表
CREATE TABLE IF NOT EXISTS members (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    member_level VARCHAR(20) NOT NULL,
    points INT DEFAULT 0,
    join_date DATETIME NOT NULL,
    expiry_date DATETIME,
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
);

-- 会员卡表
CREATE TABLE IF NOT EXISTS member_cards (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    member_id BIGINT NOT NULL,
    card_type VARCHAR(20) NOT NULL, -- 储值卡/疗程卡/折扣卡/时段卡/组合卡
    card_number VARCHAR(50) UNIQUE NOT NULL,
    balance DECIMAL(10,2) DEFAULT 0,
    remaining_times INT DEFAULT 0, -- 剩余次数（疗程卡）
    discount_rate DECIMAL(5,2) DEFAULT 100, -- 折扣率（折扣卡）
    start_date DATETIME NOT NULL,
    end_date DATETIME,
    status VARCHAR(20) NOT NULL, -- 激活/未激活/已过期
    FOREIGN KEY (member_id) REFERENCES members(id) ON DELETE CASCADE
);

-- 提成表
CREATE TABLE IF NOT EXISTS commissions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    employee_id BIGINT NOT NULL,
    order_id BIGINT NOT NULL,
    commission_type VARCHAR(20) NOT NULL, -- 服务提成/销售产品提成/办卡提成/耗卡提成/全员营销佣金
    amount DECIMAL(10,2) NOT NULL,
    commission_date DATETIME NOT NULL,
    status VARCHAR(20) NOT NULL, -- 待结算/已结算
    FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);

-- 营销任务表
CREATE TABLE IF NOT EXISTS marketing_tasks (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    start_date DATETIME NOT NULL,
    end_date DATETIME NOT NULL,
    status VARCHAR(20) NOT NULL -- 进行中/已完成/已取消
);

-- 员工营销任务表
CREATE TABLE IF NOT EXISTS employee_marketing_tasks (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    employee_id BIGINT NOT NULL,
    task_id BIGINT NOT NULL,
    completion_status VARCHAR(20) NOT NULL, -- 未开始/进行中/已完成
    completion_date DATETIME,
    FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE,
    FOREIGN KEY (task_id) REFERENCES marketing_tasks(id) ON DELETE CASCADE
);

-- 推广记录表
CREATE TABLE IF NOT EXISTS promotion_records (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    employee_id BIGINT NOT NULL,
    customer_id BIGINT NOT NULL,
    promotion_date DATETIME NOT NULL,
    channel VARCHAR(50) NOT NULL, -- 朋友圈/微信群/私聊
    commission DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
);

-- 交班表
CREATE TABLE IF NOT EXISTS shifts (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    employee_id BIGINT NOT NULL,
    shift_date DATETIME NOT NULL,
    cash_amount DECIMAL(10,2) NOT NULL,
    wechat_amount DECIMAL(10,2) NOT NULL,
    alipay_amount DECIMAL(10,2) NOT NULL,
    card_amount DECIMAL(10,2) NOT NULL,
    member_card_amount DECIMAL(10,2) NOT NULL,
    coupon_amount DECIMAL(10,2) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    system_amount DECIMAL(10,2) NOT NULL,
    difference DECIMAL(10,2) NOT NULL,
    difference_reason VARCHAR(255),
    status VARCHAR(20) NOT NULL, -- 待确认/已确认
    FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE
);

-- 初始化管理员用户
INSERT INTO users (username, password, role, name, phone) VALUES 
('admin', '$2a$10$e6T9F9qBZ0iY7rF3c9Y6Ae7v8w9x1y2z3a4b5c6d7e8f9g10h11i12j13k14l15m16n', 'admin', '管理员', '13800138000');

-- 初始化员工用户
INSERT INTO users (username, password, role, name, phone) VALUES 
('staff1', '$2a$10$e6T9F9qBZ0iY7rF3c9Y6Ae7v8w9x1y2z3a4b5c6d7e8f9g10h11i12j13k14l15m16n', 'staff', '员工1', '13800138001');

-- 初始化顾客用户
INSERT INTO users (username, password, role, name, phone) VALUES 
('customer1', '$2a$10$e6T9F9qBZ0iY7rF3c9Y6Ae7v8w9x1y2z3a4b5c6d7e8f9g10h11i12j13k14l15m16n', 'customer', '顾客1', '13800138002');