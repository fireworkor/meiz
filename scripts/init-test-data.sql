-- Beauty Shop Management System - Test Data Script
-- Complete test data matching actual table names

USE beauty_shop;

-- ============================================
-- 1. Clean existing data (reverse dependency order)
-- ============================================
SET FOREIGN_KEY_CHECKS = 0;

DELETE FROM verifications;
DELETE FROM group_purchase_members;
DELETE FROM group_purchases;
DELETE FROM salaries;
DELETE FROM commissions;
DELETE FROM shifts;
DELETE FROM schedules;
DELETE FROM attendances;
DELETE FROM payment_record;
DELETE FROM order_items;
DELETE FROM orders;
DELETE FROM membership_cards;
DELETE FROM coupons;
DELETE FROM marketing_activities;
DELETE FROM card_types;
DELETE FROM inventory;
DELETE FROM products;
DELETE FROM services;
DELETE FROM rooms;
DELETE FROM reservations;
DELETE FROM customers;
DELETE FROM employees;
DELETE FROM users;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================
-- 2. User Data
-- ============================================
INSERT INTO users (username, password, role, name, phone, created_at, updated_at) VALUES
('admin', '$2a$10$RZTJiaRPnUXiMb7i636SSe3Pop.XdhX6m76MrN52VYA9vE8N8EGMi', 'admin', 'Administrator', '13800000000', NOW(), NOW()),
('staff', '$2a$10$RZTJiaRPnUXiMb7i636SSe3Pop.XdhX6m76MrN52VYA9vE8N8EGMi', 'staff', 'Zhang Xiaomei', '13800001001', NOW(), NOW()),
('staff2', '$2a$10$RZTJiaRPnUXiMb7i636SSe3Pop.XdhX6m76MrN52VYA9vE8N8EGMi', 'staff', 'Li Xiaoli', '13800001002', NOW(), NOW()),
('customer', '$2a$10$RZTJiaRPnUXiMb7i636SSe3Pop.XdhX6m76MrN52VYA9vE8N8EGMi', 'customer', 'Ms. Zhang', '13900001001', NOW(), NOW()),
('customer2', '$2a$10$RZTJiaRPnUXiMb7i636SSe3Pop.XdhX6m76MrN52VYA9vE8N8EGMi', 'customer', 'Mr. Li', '13900001002', NOW(), NOW());

-- ============================================
-- 3. Employee Data
-- ============================================
INSERT INTO employees (user_id, name, phone, position, entry_date, employee_id, id_card, emergency_contact, emergency_phone, status, skill_tags, base_salary, created_at, updated_at) VALUES
((SELECT id FROM users WHERE username = 'staff'), 'Zhang Xiaomei', '13800001001', 'Beautician', '2022-01-15', 'EMP001', '110101199001011234', 'Emergency Contact 1', '13812345678', 'active', 'Facial Care,Hydration', 8000.00, NOW(), NOW()),
((SELECT id FROM users WHERE username = 'staff2'), 'Li Xiaoli', '13800001002', 'Senior Beautician', '2021-06-20', 'EMP002', '110101198501011234', 'Emergency Contact 2', '13887654321', 'active', 'SPA,Anti-aging', 12000.00, NOW(), NOW());

-- ============================================
-- 4. Customer Data
-- ============================================
INSERT INTO customers (user_id, name, phone, level, points, birthday, gender, skin_type, tags, created_at, updated_at) VALUES
((SELECT id FROM users WHERE username = 'customer'), 'Ms. Zhang', '13900001001', 'GOLD', 2500, '1990-05-20', 'FEMALE', 'Dry', 'VIP,Regular', NOW(), NOW()),
((SELECT id FROM users WHERE username = 'customer2'), 'Mr. Li', '13900001002', 'SILVER', 1200, '1985-08-15', 'MALE', 'Combination', 'New Customer', NOW(), NOW());

-- ============================================
-- 5. Room Data
-- ============================================
INSERT INTO rooms (name, type, capacity, status) VALUES
('Beauty Room 1', 'BEAUTY', 2, 'AVAILABLE'),
('Beauty Room 2', 'BEAUTY', 2, 'AVAILABLE'),
('SPA Room', 'SPA', 1, 'AVAILABLE');

-- ============================================
-- 6. Service Data
-- ============================================
INSERT INTO services (name, category, price, duration, description, status, created_at, updated_at) VALUES
('Deep Facial Clean', 'BEAUTY', 198.00, 60, 'Gentle exfoliation, deep pore cleaning', 'active', NOW(), NOW()),
('Hydration Care', 'BEAUTY', 268.00, 90, 'Hyaluronic acid infusion, hydration lock', 'active', NOW(), NOW()),
('Full Body SPA', 'SPA', 398.00, 90, 'Essential oil massage, relaxation', 'active', NOW(), NOW());

-- ============================================
-- 7. Product Data
-- ============================================
INSERT INTO products (name, description, price, cost_price, category, status) VALUES
('Hydrating Mask', 'Deep hydrating facial mask', 88.00, 40.00, 'SKINCARE', 'active'),
('Sunscreen', 'SPF50+ sunscreen', 168.00, 80.00, 'SKINCARE', 'active'),
('Essential Oil', 'Lavender essential oil', 228.00, 100.00, 'SPA', 'active');

-- ============================================
-- 8. Inventory Data
-- ============================================
INSERT INTO inventory (product_id, quantity, supplier) VALUES
((SELECT id FROM products WHERE name = 'Hydrating Mask'), 100, 'Beauty Supplier A'),
((SELECT id FROM products WHERE name = 'Sunscreen'), 50, 'Beauty Supplier A'),
((SELECT id FROM products WHERE name = 'Essential Oil'), 30, 'Beauty Supplier B');

-- ============================================
-- 9. Card Type Data
-- ============================================
INSERT INTO card_types (name, description, initial_amount, gift_amount, discount_rate, points_rate, validity_months, status) VALUES
('Normal Member', 'Basic membership benefits', 0.00, 0.00, 1.00, 1, 12, 'active'),
('Silver Member', '95% discount', 99.00, 10.00, 0.95, 1.5, 12, 'active'),
('Gold Member', '90% discount', 299.00, 50.00, 0.90, 2, 12, 'active'),
('Platinum Member', '85% discount', 499.00, 100.00, 0.85, 3, 12, 'active'),
('Diamond Member', '80% discount', 999.00, 200.00, 0.80, 4, 12, 'active');

-- ============================================
-- 10. Membership Card Data
-- ============================================
INSERT INTO membership_cards (customer_id, card_number, card_type, balance, total_amount, discount_rate, points, issue_date, status) VALUES
((SELECT id FROM customers WHERE name = 'Ms. Zhang'), 'MC001', 'Gold Member', 1000.00, 1000.00, 0.90, 500, CURDATE(), 'active'),
((SELECT id FROM customers WHERE name = 'Ms. Zhang'), 'MC002', 'Platinum Member', 2000.00, 2500.00, 0.85, 1200, DATE_SUB(CURDATE(), INTERVAL 3 MONTH), 'active'),
((SELECT id FROM customers WHERE name = 'Mr. Li'), 'MC003', 'Silver Member', 500.00, 500.00, 0.95, 200, CURDATE(), 'active'),
((SELECT id FROM customers WHERE name = 'Mr. Li'), 'MC004', 'Normal Member', 0.00, 0.00, 1.00, 50, DATE_SUB(CURDATE(), INTERVAL 6 MONTH), 'active');

-- ============================================
-- 11. Coupon Data
-- ============================================
INSERT INTO coupons (customer_id, coupon_number, name, type, discount_amount, min_amount, issue_date, expiry_date, status) VALUES
((SELECT id FROM customers WHERE name = 'Ms. Zhang'), 'CPN001', 'New Customer 20% Off', 'DISCOUNT', 0.00, 100.00, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 30 DAY), 'unused'),
((SELECT id FROM customers WHERE name = 'Ms. Zhang'), 'CPN002', '50 Off Over 200', 'CASH', 50.00, 200.00, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 30 DAY), 'unused'),
((SELECT id FROM customers WHERE name = 'Ms. Zhang'), 'CPN003', 'Member Day 15% Off', 'DISCOUNT', 0.00, 150.00, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 15 DAY), 'unused'),
((SELECT id FROM customers WHERE name = 'Ms. Zhang'), 'CPN004', 'Birthday 100 Off', 'CASH', 100.00, 300.00, DATE_SUB(CURDATE(), INTERVAL 5 DAY), DATE_ADD(CURDATE(), INTERVAL 25 DAY), 'used'),
((SELECT id FROM customers WHERE name = 'Mr. Li'), 'CPN005', 'New Customer 20% Off', 'DISCOUNT', 0.00, 100.00, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 30 DAY), 'unused'),
((SELECT id FROM customers WHERE name = 'Mr. Li'), 'CPN006', 'First Visit 30 Off', 'CASH', 30.00, 150.00, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 45 DAY), 'unused'),
((SELECT id FROM customers WHERE name = 'Mr. Li'), 'CPN007', 'Seasonal 10% Off', 'DISCOUNT', 0.00, 200.00, DATE_SUB(CURDATE(), INTERVAL 40 DAY), DATE_SUB(CURDATE(), INTERVAL 10 DAY), 'expired');

-- ============================================
-- 12. Marketing Activity Data
-- ============================================
INSERT INTO marketing_activities (name, type, description, start_date, end_date, discount_amount, status) VALUES
('Spring Skincare Season', 'CAMPAIGN', 'Spring skincare products 20% off', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 30 DAY), 20.00, 'active'),
('Member Day', 'EVENT', 'Monthly member day, 12% off all services', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 365 DAY), 12.00, 'active');

-- ============================================
-- 13. Reservation Data
-- ============================================
INSERT INTO reservations (customer_id, employee_id, service_id, room_id, reservation_date, status, source, created_at, updated_at) VALUES
((SELECT id FROM customers WHERE name = 'Ms. Zhang'), (SELECT id FROM employees WHERE name = 'Zhang Xiaomei'), (SELECT id FROM services WHERE name = 'Deep Facial Clean'), (SELECT id FROM rooms WHERE name = 'Beauty Room 1'), CURDATE(), 'confirmed', 'online', NOW(), NOW()),
((SELECT id FROM customers WHERE name = 'Ms. Zhang'), (SELECT id FROM employees WHERE name = 'Li Xiaoli'), (SELECT id FROM services WHERE name = 'Hydration Care'), (SELECT id FROM rooms WHERE name = 'Beauty Room 1'), DATE_ADD(CURDATE(), INTERVAL 1 DAY), 'pending', 'online', NOW(), NOW()),
((SELECT id FROM customers WHERE name = 'Mr. Li'), (SELECT id FROM employees WHERE name = 'Zhang Xiaomei'), (SELECT id FROM services WHERE name = 'Full Body SPA'), (SELECT id FROM rooms WHERE name = 'SPA Room'), DATE_ADD(CURDATE(), INTERVAL 2 DAY), 'confirmed', 'walk_in', NOW(), NOW());

-- ============================================
-- 14. Order Data
-- ============================================
INSERT INTO orders (customer_id, employee_id, order_date, total_amount, payment_method, status, created_at, updated_at) VALUES
((SELECT id FROM customers WHERE name = 'Ms. Zhang'), (SELECT id FROM employees WHERE name = 'Zhang Xiaomei'), NOW(), 466.00, 'WXPAY', 'PAID', NOW(), NOW()),
((SELECT id FROM customers WHERE name = 'Mr. Li'), (SELECT id FROM employees WHERE name = 'Li Xiaoli'), NOW(), 398.00, 'ALIPAY', 'PAID', NOW(), NOW()),
((SELECT id FROM customers WHERE name = 'Ms. Zhang'), (SELECT id FROM employees WHERE name = 'Zhang Xiaomei'), DATE_SUB(NOW(), INTERVAL 1 DAY), 68.00, 'MEMBERCARD', 'COMPLETED', DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY));

-- ============================================
-- 15. Order Item Data
-- ============================================
INSERT INTO order_items (order_id, item_type, item_id, quantity, price) VALUES
((SELECT id FROM orders WHERE total_amount = 466.00 ORDER BY created_at DESC LIMIT 1), 'service', (SELECT id FROM services WHERE name = 'Deep Facial Clean'), 1, 198.00),
((SELECT id FROM orders WHERE total_amount = 466.00 ORDER BY created_at DESC LIMIT 1), 'service', (SELECT id FROM services WHERE name = 'Hydration Care'), 1, 268.00),
((SELECT id FROM orders WHERE total_amount = 398.00 ORDER BY created_at DESC LIMIT 1), 'service', (SELECT id FROM services WHERE name = 'Full Body SPA'), 1, 398.00),
((SELECT id FROM orders WHERE total_amount = 68.00 ORDER BY created_at DESC LIMIT 1), 'service', (SELECT id FROM services WHERE name = 'Deep Facial Clean'), 1, 68.00);

-- ============================================
-- 16. Payment Record Data
-- ============================================
INSERT INTO payment_record (payment_no, order_id, order_no, payment_type, total_amount, payment_status, create_time, update_time) VALUES
('PAY202404220001', (SELECT id FROM orders WHERE total_amount = 466.00 ORDER BY created_at DESC LIMIT 1), 'ORD001', 'WXPAY', 466.00, 'SUCCESS', NOW(), NOW()),
('PAY202404220002', (SELECT id FROM orders WHERE total_amount = 398.00 ORDER BY created_at DESC LIMIT 1), 'ORD002', 'ALIPAY', 398.00, 'SUCCESS', NOW(), NOW()),
('PAY202404210001', (SELECT id FROM orders WHERE total_amount = 68.00 ORDER BY created_at DESC LIMIT 1), 'ORD003', 'MEMBERCARD', 68.00, 'SUCCESS', NOW(), NOW());

-- ============================================
-- 17. Attendance Data
-- ============================================
INSERT INTO attendances (employee_id, check_in_time, check_out_time, status, created_at, updated_at) VALUES
((SELECT id FROM employees WHERE name = 'Zhang Xiaomei'), CONCAT(CURDATE(), ' 09:00:00'), CONCAT(CURDATE(), ' 18:05:00'), 'NORMAL', NOW(), NOW()),
((SELECT id FROM employees WHERE name = 'Li Xiaoli'), CONCAT(CURDATE(), ' 09:30:00'), CONCAT(CURDATE(), ' 18:30:00'), 'LATE', NOW(), NOW());

-- ============================================
-- 18. Schedule Data
-- ============================================
INSERT INTO schedules (employee_id, schedule_date, shift_type, start_time, end_time, status) VALUES
((SELECT id FROM employees WHERE name = 'Zhang Xiaomei'), CURDATE(), 'DAY', '09:00', '18:00', 'active'),
((SELECT id FROM employees WHERE name = 'Li Xiaoli'), CURDATE(), 'DAY', '09:00', '18:00', 'active');

-- ============================================
-- 19. Shift Data
-- ============================================
INSERT INTO shifts (employee_id, shift_date, cash_amount, wechat_amount, alipay_amount, card_amount, member_card_amount, coupon_amount, total_amount, system_amount, status) VALUES
((SELECT id FROM employees WHERE name = 'Zhang Xiaomei'), CURDATE(), 0.00, 466.00, 0.00, 0.00, 0.00, 0.00, 466.00, 466.00, 'closed');

-- ============================================
-- 20. Commission Data
-- ============================================
INSERT INTO commissions (employee_id, order_id, commission_type, amount, commission_date, status) VALUES
((SELECT id FROM employees WHERE name = 'Zhang Xiaomei'), (SELECT id FROM orders WHERE total_amount = 466.00 ORDER BY created_at DESC LIMIT 1), 'SERVICE', 39.60, CURDATE(), 'unsettled'),
((SELECT id FROM employees WHERE name = 'Li Xiaoli'), (SELECT id FROM orders WHERE total_amount = 398.00 ORDER BY created_at DESC LIMIT 1), 'SERVICE', 79.60, CURDATE(), 'unsettled'),
((SELECT id FROM employees WHERE name = 'Zhang Xiaomei'), (SELECT id FROM orders WHERE total_amount = 68.00 ORDER BY created_at DESC LIMIT 1), 'SERVICE', 13.60, DATE_SUB(CURDATE(), INTERVAL 1 DAY), 'settled'),
((SELECT id FROM employees WHERE name = 'Zhang Xiaomei'), (SELECT id FROM orders WHERE total_amount = 466.00 ORDER BY created_at DESC LIMIT 1), 'PRODUCT', 15.00, CURDATE(), 'unsettled'),
((SELECT id FROM employees WHERE name = 'Li Xiaoli'), (SELECT id FROM orders WHERE total_amount = 398.00 ORDER BY created_at DESC LIMIT 1), 'MEMBERSHIP', 50.00, CURDATE(), 'unsettled'),
((SELECT id FROM employees WHERE name = 'Zhang Xiaomei'), (SELECT id FROM orders WHERE total_amount = 68.00 ORDER BY created_at DESC LIMIT 1), 'SERVICE', 13.60, DATE_SUB(CURDATE(), INTERVAL 2 DAY), 'settled');


-- ============================================
-- 21. Salary Data
-- ============================================
INSERT INTO salaries (employee_id, year, month, base_salary, commission, bonus, full_attendance_bonus, social_security, tax, other_deduction, net_salary, status, created_at, updated_at) VALUES
((SELECT id FROM employees WHERE name = 'Zhang Xiaomei'), 2024, 2, 8000.00, 1500.00, 300.00, 200.00, 800.00, 150.00, 0.00, 9050.00, 'paid', NOW(), NOW()),
((SELECT id FROM employees WHERE name = 'Zhang Xiaomei'), 2024, 3, 8000.00, 1800.00, 400.00, 200.00, 800.00, 180.00, 50.00, 9370.00, 'paid', NOW(), NOW()),
((SELECT id FROM employees WHERE name = 'Zhang Xiaomei'), 2024, 4, 8000.00, 2000.00, 500.00, 200.00, 800.00, 200.00, 0.00, 9700.00, 'paid', NOW(), NOW()),
((SELECT id FROM employees WHERE name = 'Li Xiaoli'), 2024, 2, 12000.00, 2800.00, 600.00, 300.00, 1200.00, 300.00, 0.00, 14200.00, 'paid', NOW(), NOW()),
((SELECT id FROM employees WHERE name = 'Li Xiaoli'), 2024, 3, 12000.00, 3200.00, 700.00, 300.00, 1200.00, 350.00, 100.00, 14550.00, 'paid', NOW(), NOW()),
((SELECT id FROM employees WHERE name = 'Li Xiaoli'), 2024, 4, 12000.00, 3500.00, 800.00, 300.00, 1200.00, 400.00, 0.00, 15000.00, 'paid', NOW(), NOW());

-- ============================================
-- 22. Group Purchase Data
-- ============================================
INSERT INTO group_purchases (title, subtitle, description, original_price, group_price, min_members, max_members, current_members, stock, sold_count, status, category, validity_days, created_at, updated_at) VALUES
('Facial Care Package', 'Deep Clean + Hydration', 'Complete facial care experience', 466.00, 299.00, 2, 5, 3, 50, 128, 'active', 'BEAUTY', 30, NOW(), NOW()),
('Full Body SPA Package', '60-min Full Body Massage', 'Relaxing full body SPA experience', 398.00, 268.00, 3, 8, 5, 30, 86, 'active', 'SPA', 30, NOW(), NOW());

-- ============================================
-- 23. Group Purchase Member Data
-- ============================================
INSERT INTO group_purchase_members (group_purchase_id, group_purchase_title, customer_id, customer_name, customer_phone, status, is_leader, joined_at, created_at) VALUES
((SELECT id FROM group_purchases WHERE title = 'Facial Care Package' LIMIT 1), 'Facial Care Package', (SELECT id FROM customers WHERE name = 'Ms. Zhang'), 'Ms. Zhang', '13900001001', 'success', TRUE, NOW(), NOW()),
((SELECT id FROM group_purchases WHERE title = 'Facial Care Package' LIMIT 1), 'Facial Care Package', (SELECT id FROM customers WHERE name = 'Mr. Li'), 'Mr. Li', '13900001002', 'pending', FALSE, NOW(), NOW());

-- ============================================
-- 24. Verification Data
-- ============================================
INSERT INTO verifications (verification_code, customer_id, customer_name, customer_phone, type, item_name, points, amount, status, created_at, updated_at) VALUES
('VER001', (SELECT id FROM customers WHERE name = 'Ms. Zhang'), 'Ms. Zhang', '13900001001', 'COUPON', '50 Off Over 200', 0, 50.00, 'unused', NOW(), NOW()),
('VER002', (SELECT id FROM customers WHERE name = 'Mr. Li'), 'Mr. Li', '13900001002', 'POINTS', 'Points Redemption', 500, 0, 'used', NOW(), NOW());

-- ============================================
-- Completion Notice
-- ============================================
SELECT 'Test data imported successfully!' AS status;
SELECT COUNT(*) as user_count FROM users;
SELECT COUNT(*) as employee_count FROM employees;
SELECT COUNT(*) as customer_count FROM customers;
SELECT COUNT(*) as order_count FROM orders;
SELECT COUNT(*) as service_count FROM services;
