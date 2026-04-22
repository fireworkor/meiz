-- 美妆店管理系统 - 简化版测试数据脚本
-- 使用说明：先运行此脚本导入基础测试数据

USE beauty_shop;

-- ============================================
-- 1. 清理现有数据（按依赖关系逆序）
-- ============================================
SET FOREIGN_KEY_CHECKS = 0;
DELETE FROM order_item;
DELETE FROM orders;
DELETE FROM customer;
DELETE FROM employee;
DELETE FROM users;
SET FOREIGN_KEY_CHECKS = 1;

-- ============================================
-- 2. 用户数据
-- ============================================
INSERT INTO users (username, password, role, name, phone, created_at, updated_at) VALUES
('admin', 'admin123', 'admin', '管理员', '13800000000', NOW(), NOW()),
('staff', 'staff123', 'staff', '张小美', '13800001001', NOW(), NOW()),
('customer', 'customer123', 'customer', '张女士', '13900001001', NOW(), NOW());

-- ============================================
-- 3. 员工数据
-- ============================================
INSERT INTO employee (name, phone, position, hire_date, salary, status, created_at, updated_at) VALUES
('张小美', '13800001001', '美容师', '2022-01-15', 8000.00, 'ACTIVE', NOW(), NOW()),
('李晓丽', '13800001002', '高级美容师', '2021-06-20', 12000.00, 'ACTIVE', NOW(), NOW());

-- ============================================
-- 4. 顾客数据
-- ============================================
INSERT INTO customer (name, phone, email, gender, birthday, member_level, points, total_consumption, status, created_at, updated_at) VALUES
('张女士', '13900001001', 'zhangnvshi@email.com', 'FEMALE', '1990-05-20', 'GOLD', 2500, 15800.00, 'ACTIVE', NOW(), NOW()),
('李先生', '13900001002', 'lixiansheng@email.com', 'MALE', '1985-08-15', 'SILVER', 1200, 8600.00, 'ACTIVE', NOW(), NOW());

-- ============================================
-- 5. 订单数据（简化版）
-- ============================================
INSERT INTO orders (order_date, total_amount, payment_method, status, created_at, updated_at) VALUES
(NOW(), 298.00, 'WXPAY', 'PAID', NOW(), NOW()),
(NOW(), 398.00, 'ALIPAY', 'PAID', NOW(), NOW());

-- ============================================
-- 完成提示
-- ============================================
SELECT '测试数据导入完成！' AS status;
SELECT COUNT(*) as user_count FROM users;
SELECT COUNT(*) as employee_count FROM employee;
SELECT COUNT(*) as customer_count FROM customer;
SELECT COUNT(*) as order_count FROM orders;
