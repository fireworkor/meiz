-- 美容店管理系统 - 数据库注释脚本
-- 为所有表和字段添加中文注释

USE beauty_shop;

-- ============================================
-- 1. 用户表
-- ============================================
ALTER TABLE users COMMENT '用户表';
ALTER TABLE users MODIFY COLUMN id BIGINT NOT NULL AUTO_INCREMENT COMMENT '用户ID';
ALTER TABLE users MODIFY COLUMN username VARCHAR(50) NOT NULL COMMENT '用户名';
ALTER TABLE users MODIFY COLUMN password VARCHAR(100) NOT NULL COMMENT '密码';
ALTER TABLE users MODIFY COLUMN role VARCHAR(20) NOT NULL COMMENT '角色';
ALTER TABLE users MODIFY COLUMN name VARCHAR(50) COMMENT '姓名';
ALTER TABLE users MODIFY COLUMN phone VARCHAR(20) COMMENT '电话';
ALTER TABLE users MODIFY COLUMN avatar VARCHAR(255) COMMENT '头像';
ALTER TABLE users MODIFY COLUMN created_at DATETIME COMMENT '创建时间';
ALTER TABLE users MODIFY COLUMN updated_at DATETIME COMMENT '更新时间';

-- ============================================
-- 2. 客户表
-- ============================================
ALTER TABLE customers COMMENT '客户表';
ALTER TABLE customers MODIFY COLUMN id BIGINT NOT NULL AUTO_INCREMENT COMMENT '客户ID';
ALTER TABLE customers MODIFY COLUMN user_id BIGINT NOT NULL COMMENT '用户ID';
ALTER TABLE customers MODIFY COLUMN name VARCHAR(50) NOT NULL COMMENT '姓名';
ALTER TABLE customers MODIFY COLUMN phone VARCHAR(20) NOT NULL COMMENT '电话';
ALTER TABLE customers MODIFY COLUMN level VARCHAR(20) COMMENT '会员等级';
ALTER TABLE customers MODIFY COLUMN points INT DEFAULT 0 COMMENT '积分';
ALTER TABLE customers MODIFY COLUMN birthday DATE COMMENT '生日';
ALTER TABLE customers MODIFY COLUMN gender VARCHAR(10) COMMENT '性别';
ALTER TABLE customers MODIFY COLUMN skin_type VARCHAR(50) COMMENT '皮肤类型';
ALTER TABLE customers MODIFY COLUMN tags VARCHAR(255) COMMENT '标签';
ALTER TABLE customers MODIFY COLUMN created_at DATETIME COMMENT '创建时间';
ALTER TABLE customers MODIFY COLUMN updated_at DATETIME COMMENT '更新时间';

-- ============================================
-- 3. 员工表
-- ============================================
ALTER TABLE employees COMMENT '员工表';
ALTER TABLE employees MODIFY COLUMN id BIGINT NOT NULL AUTO_INCREMENT COMMENT '员工ID';
ALTER TABLE employees MODIFY COLUMN user_id BIGINT NOT NULL COMMENT '用户ID';
ALTER TABLE employees MODIFY COLUMN name VARCHAR(50) NOT NULL COMMENT '姓名';
ALTER TABLE employees MODIFY COLUMN phone VARCHAR(20) NOT NULL COMMENT '电话';
ALTER TABLE employees MODIFY COLUMN position VARCHAR(50) COMMENT '职位';
ALTER TABLE employees MODIFY COLUMN entry_date DATE COMMENT '入职日期';
ALTER TABLE employees MODIFY COLUMN employee_id VARCHAR(20) COMMENT '员工编号';
ALTER TABLE employees MODIFY COLUMN id_card VARCHAR(20) COMMENT '身份证号';
ALTER TABLE employees MODIFY COLUMN emergency_contact VARCHAR(50) COMMENT '紧急联系人';
ALTER TABLE employees MODIFY COLUMN emergency_phone VARCHAR(20) COMMENT '紧急联系电话';
ALTER TABLE employees MODIFY COLUMN status VARCHAR(20) DEFAULT 'active' COMMENT '状态';
ALTER TABLE employees MODIFY COLUMN skill_tags VARCHAR(255) COMMENT '技能标签';
ALTER TABLE employees MODIFY COLUMN base_salary DECIMAL(10,2) COMMENT '基本工资';
ALTER TABLE employees MODIFY COLUMN created_at DATETIME COMMENT '创建时间';
ALTER TABLE employees MODIFY COLUMN updated_at DATETIME COMMENT '更新时间';

-- ============================================
-- 4. 服务项目表
-- ============================================
ALTER TABLE services COMMENT '服务项目表';
ALTER TABLE services MODIFY COLUMN id BIGINT NOT NULL AUTO_INCREMENT COMMENT '服务ID';
ALTER TABLE services MODIFY COLUMN name VARCHAR(100) NOT NULL COMMENT '服务名称';
ALTER TABLE services MODIFY COLUMN category VARCHAR(50) COMMENT '服务类别';
ALTER TABLE services MODIFY COLUMN price DECIMAL(10,2) DEFAULT 0 COMMENT '价格';
ALTER TABLE services MODIFY COLUMN duration INT DEFAULT 60 COMMENT '时长(分钟)';
ALTER TABLE services MODIFY COLUMN description TEXT COMMENT '描述';
ALTER TABLE services MODIFY COLUMN image VARCHAR(255) COMMENT '图片';
ALTER TABLE services MODIFY COLUMN commission_rate DECIMAL(5,2) DEFAULT 10.00 COMMENT '佣金比例(%)';
ALTER TABLE services MODIFY COLUMN status VARCHAR(20) DEFAULT 'active' COMMENT '状态';
ALTER TABLE services MODIFY COLUMN created_at DATETIME COMMENT '创建时间';
ALTER TABLE services MODIFY COLUMN updated_at DATETIME COMMENT '更新时间';

-- ============================================
-- 5. 房间表
-- ============================================
ALTER TABLE rooms COMMENT '房间表';
ALTER TABLE rooms MODIFY COLUMN id BIGINT NOT NULL AUTO_INCREMENT COMMENT '房间ID';
ALTER TABLE rooms MODIFY COLUMN name VARCHAR(100) NOT NULL COMMENT '房间名称';
ALTER TABLE rooms MODIFY COLUMN type VARCHAR(50) COMMENT '房间类型';
ALTER TABLE rooms MODIFY COLUMN capacity INT DEFAULT 2 COMMENT '容纳人数';
ALTER TABLE rooms MODIFY COLUMN status VARCHAR(20) DEFAULT 'AVAILABLE' COMMENT '状态';
ALTER TABLE rooms ADD COLUMN description VARCHAR(500) COMMENT '房间描述';
ALTER TABLE rooms ADD COLUMN floor INT COMMENT '楼层';
ALTER TABLE rooms ADD COLUMN display_order INT DEFAULT 0 COMMENT '显示顺序';

-- ============================================
-- 6. 预约表
-- ============================================
ALTER TABLE reservations COMMENT '预约表';
ALTER TABLE reservations MODIFY COLUMN id BIGINT NOT NULL AUTO_INCREMENT COMMENT '预约ID';
ALTER TABLE reservations MODIFY COLUMN customer_id BIGINT NOT NULL COMMENT '客户ID';
ALTER TABLE reservations MODIFY COLUMN employee_id BIGINT NOT NULL COMMENT '员工ID';
ALTER TABLE reservations MODIFY COLUMN service_id BIGINT NOT NULL COMMENT '服务ID';
ALTER TABLE reservations MODIFY COLUMN room_id BIGINT NOT NULL COMMENT '房间ID';
ALTER TABLE reservations MODIFY COLUMN reservation_date DATETIME NOT NULL COMMENT '预约日期';
ALTER TABLE reservations MODIFY COLUMN status VARCHAR(20) NOT NULL COMMENT '状态';
ALTER TABLE reservations MODIFY COLUMN source VARCHAR(20) NOT NULL COMMENT '来源';
ALTER TABLE reservations MODIFY COLUMN created_at DATETIME COMMENT '创建时间';
ALTER TABLE reservations MODIFY COLUMN updated_at DATETIME COMMENT '更新时间';

-- ============================================
-- 7. 订单表
-- ============================================
ALTER TABLE orders COMMENT '订单表';
ALTER TABLE orders MODIFY COLUMN id BIGINT NOT NULL AUTO_INCREMENT COMMENT '订单ID';
ALTER TABLE orders MODIFY COLUMN customer_id BIGINT NOT NULL COMMENT '客户ID';
ALTER TABLE orders MODIFY COLUMN employee_id BIGINT NOT NULL COMMENT '员工ID';
ALTER TABLE orders MODIFY COLUMN order_date DATETIME NOT NULL COMMENT '订单日期';
ALTER TABLE orders MODIFY COLUMN total_amount DECIMAL(10,2) DEFAULT 0 COMMENT '总金额';
ALTER TABLE orders MODIFY COLUMN payment_method VARCHAR(20) COMMENT '支付方式';
ALTER TABLE orders MODIFY COLUMN status VARCHAR(20) DEFAULT 'PENDING' COMMENT '状态';
ALTER TABLE orders MODIFY COLUMN created_at DATETIME COMMENT '创建时间';
ALTER TABLE orders MODIFY COLUMN updated_at DATETIME COMMENT '更新时间';

-- ============================================
-- 8. 订单明细表
-- ============================================
ALTER TABLE order_items COMMENT '订单明细表';
ALTER TABLE order_items MODIFY COLUMN id BIGINT NOT NULL AUTO_INCREMENT COMMENT '明细ID';
ALTER TABLE order_items MODIFY COLUMN order_id BIGINT NOT NULL COMMENT '订单ID';
ALTER TABLE order_items MODIFY COLUMN item_type VARCHAR(20) NOT NULL COMMENT '项目类型';
ALTER TABLE order_items MODIFY COLUMN item_id BIGINT NOT NULL COMMENT '项目ID';
ALTER TABLE order_items MODIFY COLUMN quantity INT DEFAULT 1 COMMENT '数量';
ALTER TABLE order_items MODIFY COLUMN price DECIMAL(10,2) DEFAULT 0 COMMENT '价格';

-- ============================================
-- 9. 支付记录表
-- ============================================
ALTER TABLE payment_record COMMENT '支付记录表';
ALTER TABLE payment_record MODIFY COLUMN id BIGINT NOT NULL AUTO_INCREMENT COMMENT '支付记录ID';
ALTER TABLE payment_record MODIFY COLUMN payment_no VARCHAR(50) NOT NULL COMMENT '支付单号';
ALTER TABLE payment_record MODIFY COLUMN order_id BIGINT NOT NULL COMMENT '订单ID';
ALTER TABLE payment_record MODIFY COLUMN order_no VARCHAR(50) COMMENT '订单编号';
ALTER TABLE payment_record MODIFY COLUMN payment_type VARCHAR(20) COMMENT '支付方式';
ALTER TABLE payment_record MODIFY COLUMN total_amount DECIMAL(10,2) DEFAULT 0 COMMENT '总金额';
ALTER TABLE payment_record MODIFY COLUMN payment_status VARCHAR(20) DEFAULT 'PENDING' COMMENT '支付状态';
ALTER TABLE payment_record MODIFY COLUMN create_time DATETIME COMMENT '创建时间';
ALTER TABLE payment_record MODIFY COLUMN update_time DATETIME COMMENT '更新时间';

-- ============================================
-- 10. 考勤表
-- ============================================
ALTER TABLE attendances COMMENT '考勤表';
ALTER TABLE attendances MODIFY COLUMN id BIGINT NOT NULL AUTO_INCREMENT COMMENT '考勤ID';
ALTER TABLE attendances MODIFY COLUMN employee_id BIGINT NOT NULL COMMENT '员工ID';
ALTER TABLE attendances MODIFY COLUMN check_in_time DATETIME COMMENT '上班时间';
ALTER TABLE attendances MODIFY COLUMN check_out_time DATETIME COMMENT '下班时间';
ALTER TABLE attendances MODIFY COLUMN status VARCHAR(20) DEFAULT 'NORMAL' COMMENT '状态';
ALTER TABLE attendances MODIFY COLUMN created_at DATETIME COMMENT '创建时间';
ALTER TABLE attendances MODIFY COLUMN updated_at DATETIME COMMENT '更新时间';

-- ============================================
-- 11. 排班表
-- ============================================
ALTER TABLE schedules COMMENT '排班表';
ALTER TABLE schedules MODIFY COLUMN id BIGINT NOT NULL AUTO_INCREMENT COMMENT '排班ID';
ALTER TABLE schedules MODIFY COLUMN employee_id BIGINT NOT NULL COMMENT '员工ID';
ALTER TABLE schedules MODIFY COLUMN schedule_date DATE NOT NULL COMMENT '排班日期';
ALTER TABLE schedules MODIFY COLUMN shift_type VARCHAR(20) COMMENT '班次类型';
ALTER TABLE schedules MODIFY COLUMN start_time VARCHAR(10) COMMENT '开始时间';
ALTER TABLE schedules MODIFY COLUMN end_time VARCHAR(10) COMMENT '结束时间';
ALTER TABLE schedules MODIFY COLUMN status VARCHAR(20) DEFAULT 'active' COMMENT '状态';

-- ============================================
-- 12. 交接班表
-- ============================================
ALTER TABLE shifts COMMENT '交接班表';
ALTER TABLE shifts MODIFY COLUMN id BIGINT NOT NULL AUTO_INCREMENT COMMENT '交接班ID';
ALTER TABLE shifts MODIFY COLUMN employee_id BIGINT NOT NULL COMMENT '员工ID';
ALTER TABLE shifts MODIFY COLUMN shift_date DATE NOT NULL COMMENT '交接班日期';
ALTER TABLE shifts MODIFY COLUMN cash_amount DECIMAL(10,2) DEFAULT 0 COMMENT '现金金额';
ALTER TABLE shifts MODIFY COLUMN wechat_amount DECIMAL(10,2) DEFAULT 0 COMMENT '微信金额';
ALTER TABLE shifts MODIFY COLUMN alipay_amount DECIMAL(10,2) DEFAULT 0 COMMENT '支付宝金额';
ALTER TABLE shifts MODIFY COLUMN card_amount DECIMAL(10,2) DEFAULT 0 COMMENT '银行卡金额';
ALTER TABLE shifts MODIFY COLUMN member_card_amount DECIMAL(10,2) DEFAULT 0 COMMENT '会员卡金额';
ALTER TABLE shifts MODIFY COLUMN coupon_amount DECIMAL(10,2) DEFAULT 0 COMMENT '优惠券金额';
ALTER TABLE shifts MODIFY COLUMN total_amount DECIMAL(10,2) DEFAULT 0 COMMENT '总金额';
ALTER TABLE shifts MODIFY COLUMN system_amount DECIMAL(10,2) DEFAULT 0 COMMENT '系统金额';
ALTER TABLE shifts MODIFY COLUMN status VARCHAR(20) DEFAULT 'open' COMMENT '状态';

-- ============================================
-- 13. 薪资表
-- ============================================
ALTER TABLE salaries COMMENT '薪资表';
ALTER TABLE salaries MODIFY COLUMN id BIGINT NOT NULL AUTO_INCREMENT COMMENT '薪资ID';
ALTER TABLE salaries MODIFY COLUMN employee_id BIGINT NOT NULL COMMENT '员工ID';
ALTER TABLE salaries MODIFY COLUMN year INT NOT NULL COMMENT '年份';
ALTER TABLE salaries MODIFY COLUMN month INT NOT NULL COMMENT '月份';
ALTER TABLE salaries MODIFY COLUMN base_salary DECIMAL(10,2) DEFAULT 0 COMMENT '基本工资';
ALTER TABLE salaries MODIFY COLUMN commission DECIMAL(10,2) DEFAULT 0 COMMENT '提成';
ALTER TABLE salaries MODIFY COLUMN bonus DECIMAL(10,2) DEFAULT 0 COMMENT '奖金';
ALTER TABLE salaries MODIFY COLUMN net_salary DECIMAL(10,2) DEFAULT 0 COMMENT '实发工资';
ALTER TABLE salaries MODIFY COLUMN status VARCHAR(20) DEFAULT 'unpaid' COMMENT '状态';
ALTER TABLE salaries MODIFY COLUMN created_at DATETIME COMMENT '创建时间';
ALTER TABLE salaries MODIFY COLUMN updated_at DATETIME COMMENT '更新时间';

-- ============================================
-- 14. 提成表
-- ============================================
ALTER TABLE commissions COMMENT '提成表';
ALTER TABLE commissions MODIFY COLUMN id BIGINT NOT NULL AUTO_INCREMENT COMMENT '提成ID';
ALTER TABLE commissions MODIFY COLUMN employee_id BIGINT NOT NULL COMMENT '员工ID';
ALTER TABLE commissions MODIFY COLUMN order_id BIGINT NOT NULL COMMENT '订单ID';
ALTER TABLE commissions MODIFY COLUMN commission_type VARCHAR(20) COMMENT '提成类型';
ALTER TABLE commissions MODIFY COLUMN amount DECIMAL(10,2) DEFAULT 0 COMMENT '提成金额';
ALTER TABLE commissions MODIFY COLUMN commission_date DATE COMMENT '提成日期';
ALTER TABLE commissions MODIFY COLUMN status VARCHAR(20) DEFAULT 'unsettled' COMMENT '状态';

-- ============================================
-- 15. 产品表
-- ============================================
ALTER TABLE products COMMENT '产品表';
ALTER TABLE products MODIFY COLUMN id BIGINT NOT NULL AUTO_INCREMENT COMMENT '产品ID';
ALTER TABLE products MODIFY COLUMN name VARCHAR(100) NOT NULL COMMENT '产品名称';
ALTER TABLE products MODIFY COLUMN description TEXT COMMENT '产品描述';
ALTER TABLE products MODIFY COLUMN price DECIMAL(10,2) DEFAULT 0 COMMENT '价格';
ALTER TABLE products MODIFY COLUMN cost_price DECIMAL(10,2) DEFAULT 0 COMMENT '成本价';
ALTER TABLE products MODIFY COLUMN category VARCHAR(50) COMMENT '产品类别';
ALTER TABLE products MODIFY COLUMN status VARCHAR(20) DEFAULT 'active' COMMENT '状态';

-- ============================================
-- 16. 库存表
-- ============================================
ALTER TABLE inventory COMMENT '库存表';
ALTER TABLE inventory MODIFY COLUMN id BIGINT NOT NULL AUTO_INCREMENT COMMENT '库存ID';
ALTER TABLE inventory MODIFY COLUMN product_id BIGINT NOT NULL COMMENT '产品ID';
ALTER TABLE inventory MODIFY COLUMN quantity INT DEFAULT 0 COMMENT '数量';
ALTER TABLE inventory MODIFY COLUMN supplier VARCHAR(100) COMMENT '供应商';

-- ============================================
-- 17. 卡类型表
-- ============================================
ALTER TABLE card_types COMMENT '卡类型表';
ALTER TABLE card_types MODIFY COLUMN id BIGINT NOT NULL AUTO_INCREMENT COMMENT '卡类型ID';
ALTER TABLE card_types MODIFY COLUMN name VARCHAR(100) NOT NULL COMMENT '卡名称';
ALTER TABLE card_types MODIFY COLUMN description TEXT COMMENT '描述';
ALTER TABLE card_types MODIFY COLUMN initial_amount DECIMAL(10,2) DEFAULT 0 COMMENT '初始金额';
ALTER TABLE card_types MODIFY COLUMN gift_amount DECIMAL(10,2) DEFAULT 0 COMMENT '赠送金额';
ALTER TABLE card_types MODIFY COLUMN discount_rate DECIMAL(5,2) DEFAULT 1.00 COMMENT '折扣率';
ALTER TABLE card_types MODIFY COLUMN points_rate DECIMAL(5,2) DEFAULT 1.00 COMMENT '积分率';
ALTER TABLE card_types MODIFY COLUMN validity_months INT DEFAULT 12 COMMENT '有效期(月)';
ALTER TABLE card_types MODIFY COLUMN status VARCHAR(20) DEFAULT 'active' COMMENT '状态';

-- ============================================
-- 18. 会员卡表
-- ============================================
ALTER TABLE membership_cards COMMENT '会员卡表';
ALTER TABLE membership_cards MODIFY COLUMN id BIGINT NOT NULL AUTO_INCREMENT COMMENT '会员卡ID';
ALTER TABLE membership_cards MODIFY COLUMN customer_id BIGINT NOT NULL COMMENT '客户ID';
ALTER TABLE membership_cards MODIFY COLUMN card_number VARCHAR(50) NOT NULL COMMENT '卡号';
ALTER TABLE membership_cards MODIFY COLUMN card_type VARCHAR(50) COMMENT '卡类型';
ALTER TABLE membership_cards MODIFY COLUMN balance DECIMAL(10,2) DEFAULT 0 COMMENT '余额';
ALTER TABLE membership_cards MODIFY COLUMN total_amount DECIMAL(10,2) DEFAULT 0 COMMENT '总充值金额';
ALTER TABLE membership_cards MODIFY COLUMN discount_rate DECIMAL(5,2) DEFAULT 1.00 COMMENT '折扣率';
ALTER TABLE membership_cards MODIFY COLUMN points INT DEFAULT 0 COMMENT '积分';
ALTER TABLE membership_cards MODIFY COLUMN issue_date DATE COMMENT '发卡日期';
ALTER TABLE membership_cards MODIFY COLUMN status VARCHAR(20) DEFAULT 'active' COMMENT '状态';

-- ============================================
-- 19. 优惠券表
-- ============================================
ALTER TABLE coupons COMMENT '优惠券表';
ALTER TABLE coupons MODIFY COLUMN id BIGINT NOT NULL AUTO_INCREMENT COMMENT '优惠券ID';
ALTER TABLE coupons MODIFY COLUMN customer_id BIGINT NOT NULL COMMENT '客户ID';
ALTER TABLE coupons MODIFY COLUMN coupon_number VARCHAR(50) NOT NULL COMMENT '优惠券编号';
ALTER TABLE coupons MODIFY COLUMN name VARCHAR(100) NOT NULL COMMENT '优惠券名称';
ALTER TABLE coupons MODIFY COLUMN type VARCHAR(20) COMMENT '优惠券类型';
ALTER TABLE coupons MODIFY COLUMN discount_amount DECIMAL(10,2) DEFAULT 0 COMMENT '优惠金额';
ALTER TABLE coupons MODIFY COLUMN min_amount DECIMAL(10,2) DEFAULT 0 COMMENT '最低消费';
ALTER TABLE coupons MODIFY COLUMN issue_date DATE COMMENT '发放日期';
ALTER TABLE coupons MODIFY COLUMN expiry_date DATE COMMENT '过期日期';
ALTER TABLE coupons MODIFY COLUMN status VARCHAR(20) DEFAULT 'unused' COMMENT '状态';

-- ============================================
-- 20. 营销活动表
-- ============================================
ALTER TABLE marketing_activities COMMENT '营销活动表';
ALTER TABLE marketing_activities MODIFY COLUMN id BIGINT NOT NULL AUTO_INCREMENT COMMENT '活动ID';
ALTER TABLE marketing_activities MODIFY COLUMN name VARCHAR(100) NOT NULL COMMENT '活动名称';
ALTER TABLE marketing_activities MODIFY COLUMN type VARCHAR(50) COMMENT '活动类型';
ALTER TABLE marketing_activities MODIFY COLUMN description TEXT COMMENT '活动描述';
ALTER TABLE marketing_activities MODIFY COLUMN start_date DATE COMMENT '开始日期';
ALTER TABLE marketing_activities MODIFY COLUMN end_date DATE COMMENT '结束日期';
ALTER TABLE marketing_activities MODIFY COLUMN discount_amount DECIMAL(10,2) DEFAULT 0 COMMENT '优惠金额';
ALTER TABLE marketing_activities MODIFY COLUMN status VARCHAR(20) DEFAULT 'active' COMMENT '状态';

-- ============================================
-- 21. 团购表
-- ============================================
ALTER TABLE group_purchases COMMENT '团购表';
ALTER TABLE group_purchases MODIFY COLUMN id BIGINT NOT NULL AUTO_INCREMENT COMMENT '团购ID';
ALTER TABLE group_purchases MODIFY COLUMN title VARCHAR(100) NOT NULL COMMENT '团购标题';
ALTER TABLE group_purchases MODIFY COLUMN subtitle VARCHAR(255) COMMENT '副标题';
ALTER TABLE group_purchases MODIFY COLUMN description TEXT COMMENT '描述';
ALTER TABLE group_purchases MODIFY COLUMN original_price DECIMAL(10,2) DEFAULT 0 COMMENT '原价';
ALTER TABLE group_purchases MODIFY COLUMN group_price DECIMAL(10,2) DEFAULT 0 COMMENT '团购价';
ALTER TABLE group_purchases MODIFY COLUMN min_members INT DEFAULT 2 COMMENT '最低人数';
ALTER TABLE group_purchases MODIFY COLUMN max_members INT DEFAULT 10 COMMENT '最高人数';
ALTER TABLE group_purchases MODIFY COLUMN current_members INT DEFAULT 0 COMMENT '当前人数';
ALTER TABLE group_purchases MODIFY COLUMN stock INT DEFAULT 0 COMMENT '库存';
ALTER TABLE group_purchases MODIFY COLUMN sold_count INT DEFAULT 0 COMMENT '已售数量';
ALTER TABLE group_purchases MODIFY COLUMN status VARCHAR(20) DEFAULT 'active' COMMENT '状态';
ALTER TABLE group_purchases MODIFY COLUMN category VARCHAR(50) COMMENT '类别';
ALTER TABLE group_purchases MODIFY COLUMN validity_days INT DEFAULT 30 COMMENT '有效期(天)';
ALTER TABLE group_purchases MODIFY COLUMN created_at DATETIME COMMENT '创建时间';
ALTER TABLE group_purchases MODIFY COLUMN updated_at DATETIME COMMENT '更新时间';

-- ============================================
-- 22. 团购成员表
-- ============================================
ALTER TABLE group_purchase_members COMMENT '团购成员表';
ALTER TABLE group_purchase_members MODIFY COLUMN id BIGINT NOT NULL AUTO_INCREMENT COMMENT '成员ID';
ALTER TABLE group_purchase_members MODIFY COLUMN group_purchase_id BIGINT NOT NULL COMMENT '团购ID';
ALTER TABLE group_purchase_members MODIFY COLUMN group_purchase_title VARCHAR(100) COMMENT '团购标题';
ALTER TABLE group_purchase_members MODIFY COLUMN customer_id BIGINT NOT NULL COMMENT '客户ID';
ALTER TABLE group_purchase_members MODIFY COLUMN customer_name VARCHAR(50) COMMENT '客户姓名';
ALTER TABLE group_purchase_members MODIFY COLUMN customer_phone VARCHAR(20) COMMENT '客户电话';
ALTER TABLE group_purchase_members MODIFY COLUMN status VARCHAR(20) DEFAULT 'pending' COMMENT '状态';
ALTER TABLE group_purchase_members MODIFY COLUMN is_leader BOOLEAN DEFAULT FALSE COMMENT '是否团长';
ALTER TABLE group_purchase_members MODIFY COLUMN joined_at DATETIME COMMENT '加入时间';
ALTER TABLE group_purchase_members MODIFY COLUMN created_at DATETIME COMMENT '创建时间';

-- ============================================
-- 23. 核销记录表
-- ============================================
ALTER TABLE verifications COMMENT '核销记录表';
ALTER TABLE verifications MODIFY COLUMN id BIGINT NOT NULL AUTO_INCREMENT COMMENT '核销记录ID';
ALTER TABLE verifications MODIFY COLUMN verification_code VARCHAR(50) NOT NULL COMMENT '核销码';
ALTER TABLE verifications MODIFY COLUMN customer_id BIGINT NOT NULL COMMENT '客户ID';
ALTER TABLE verifications MODIFY COLUMN customer_name VARCHAR(50) COMMENT '客户姓名';
ALTER TABLE verifications MODIFY COLUMN customer_phone VARCHAR(20) COMMENT '客户电话';
ALTER TABLE verifications MODIFY COLUMN type VARCHAR(20) COMMENT '核销类型';
ALTER TABLE verifications MODIFY COLUMN item_name VARCHAR(100) COMMENT '项目名称';
ALTER TABLE verifications MODIFY COLUMN points INT DEFAULT 0 COMMENT '积分';
ALTER TABLE verifications MODIFY COLUMN amount DECIMAL(10,2) DEFAULT 0 COMMENT '金额';
ALTER TABLE verifications MODIFY COLUMN status VARCHAR(20) DEFAULT 'unused' COMMENT '状态';
ALTER TABLE verifications MODIFY COLUMN created_at DATETIME COMMENT '创建时间';
ALTER TABLE verifications MODIFY COLUMN updated_at DATETIME COMMENT '更新时间';

-- ============================================
-- 完成提示
-- ============================================
SELECT '数据库注释添加成功！' AS status;