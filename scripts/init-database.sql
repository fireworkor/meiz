-- Beauty Shop Management System - Database Initialization Script
-- Create database and all table structures matching JPA entities

-- ============================================
-- Create Database
-- ============================================
CREATE DATABASE IF NOT EXISTS beauty_shop
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE beauty_shop;

-- ============================================
-- 1. Users Table
-- ============================================
CREATE TABLE IF NOT EXISTS `users` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `username` VARCHAR(50) NOT NULL,
    `password` VARCHAR(100) NOT NULL,
    `role` VARCHAR(20),
    `name` VARCHAR(50),
    `phone` VARCHAR(20),
    `avatar` VARCHAR(255),
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- 2. Employees Table
-- ============================================
CREATE TABLE IF NOT EXISTS `employees` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT,
    `name` VARCHAR(50) NOT NULL,
    `phone` VARCHAR(20),
    `position` VARCHAR(50),
    `entry_date` DATE,
    `employee_id` VARCHAR(50),
    `id_card` VARCHAR(50),
    `emergency_contact` VARCHAR(50),
    `emergency_phone` VARCHAR(20),
    `status` VARCHAR(20),
    `skill_tags` VARCHAR(255),
    `base_salary` DECIMAL(10,2) DEFAULT 0,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- 3. Customers Table
-- ============================================
CREATE TABLE IF NOT EXISTS `customers` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT,
    `name` VARCHAR(50) NOT NULL,
    `phone` VARCHAR(20),
    `level` VARCHAR(20),
    `points` INT DEFAULT 0,
    `birthday` DATE,
    `gender` VARCHAR(10),
    `wechat` VARCHAR(50),
    `occupation` VARCHAR(100),
    `source_channel` VARCHAR(50),
    `skin_type` VARCHAR(50),
    `allergy_history` VARCHAR(255),
    `skin_problems` VARCHAR(255),
    `preferred_items` VARCHAR(255),
    `preferred_employee` VARCHAR(50),
    `preferred_time` VARCHAR(50),
    `average_spending` DOUBLE,
    `tags` VARCHAR(255),
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- 4. Rooms Table
-- ============================================
CREATE TABLE IF NOT EXISTS `rooms` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    `type` VARCHAR(20) NOT NULL,
    `capacity` INT NOT NULL,
    `status` VARCHAR(20) NOT NULL,
    `description` VARCHAR(500),
    `floor` INT,
    `display_order` INT DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- 5. Services Table (not beauty_service)
-- ============================================
CREATE TABLE IF NOT EXISTS `services` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    `category` VARCHAR(50),
    `price` DECIMAL(10,2) DEFAULT 0,
    `duration` INT DEFAULT 60,
    `description` VARCHAR(500),
    `image` VARCHAR(255),
    `commission_rate` DECIMAL(5,2) DEFAULT 10.00,
    `status` VARCHAR(20) DEFAULT 'active',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- 6. Products Table
-- ============================================
CREATE TABLE IF NOT EXISTS `products` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    `description` VARCHAR(500),
    `price` DECIMAL(10,2) NOT NULL,
    `cost_price` DECIMAL(10,2) NOT NULL,
    `category` VARCHAR(50) NOT NULL,
    `status` VARCHAR(20) NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- 7. Inventory Table
-- ============================================
CREATE TABLE IF NOT EXISTS `inventory` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `product_id` BIGINT NOT NULL,
    `quantity` INT NOT NULL,
    `batch_number` VARCHAR(50),
    `supplier` VARCHAR(100),
    `expiry_date` DATE,
    PRIMARY KEY (`id`),
    KEY `idx_product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- 8. Card Types Table
-- ============================================
CREATE TABLE IF NOT EXISTS `card_types` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    `description` VARCHAR(500),
    `initial_amount` DECIMAL(10,2) NOT NULL,
    `gift_amount` DECIMAL(10,2),
    `discount_rate` DECIMAL(5,2) NOT NULL,
    `points_rate` INT,
    `validity_months` INT,
    `status` VARCHAR(20) NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- 9. Membership Cards Table
-- ============================================
CREATE TABLE IF NOT EXISTS `membership_cards` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `customer_id` BIGINT NOT NULL,
    `card_number` VARCHAR(50) NOT NULL,
    `card_type` VARCHAR(50) NOT NULL,
    `balance` DECIMAL(10,2) NOT NULL,
    `total_amount` DECIMAL(10,2) NOT NULL,
    `discount_rate` DECIMAL(5,2),
    `points` INT NOT NULL,
    `issue_date` DATE NOT NULL,
    `expiry_date` DATE,
    `status` VARCHAR(20) NOT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_customer_id` (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- 10. Coupons Table
-- ============================================
CREATE TABLE IF NOT EXISTS `coupons` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `customer_id` BIGINT,
    `coupon_number` VARCHAR(50) NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    `type` VARCHAR(20) NOT NULL,
    `discount_amount` DECIMAL(10,2),
    `min_amount` DECIMAL(10,2),
    `discount_rate` DECIMAL(5,2),
    `issue_date` DATE NOT NULL,
    `expiry_date` DATE NOT NULL,
    `used_date` DATE,
    `status` VARCHAR(20) NOT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_customer_id` (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- 11. Marketing Activities Table
-- ============================================
CREATE TABLE IF NOT EXISTS `marketing_activities` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    `type` VARCHAR(20) NOT NULL,
    `description` VARCHAR(500),
    `start_date` DATE NOT NULL,
    `end_date` DATE NOT NULL,
    `discount_amount` DECIMAL(10,2),
    `discount_rate` DECIMAL(5,2),
    `min_amount` DECIMAL(10,2),
    `target_count` INT,
    `participation_count` INT,
    `status` VARCHAR(20) NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- 12. Reservations Table
-- ============================================
CREATE TABLE IF NOT EXISTS `reservations` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `customer_id` BIGINT,
    `employee_id` BIGINT,
    `service_id` BIGINT,
    `room_id` BIGINT,
    `reservation_date` DATE,
    `status` VARCHAR(20),
    `source` VARCHAR(20),
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_customer_id` (`customer_id`),
    KEY `idx_employee_id` (`employee_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- 13. Orders Table
-- ============================================
CREATE TABLE IF NOT EXISTS `orders` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `customer_id` BIGINT,
    `employee_id` BIGINT,
    `order_date` DATETIME,
    `total_amount` DOUBLE,
    `payment_method` VARCHAR(20),
    `status` VARCHAR(20),
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_customer_id` (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- 14. Order Items Table
-- ============================================
CREATE TABLE IF NOT EXISTS `order_items` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `order_id` BIGINT NOT NULL,
    `item_type` VARCHAR(20),
    `item_id` BIGINT,
    `quantity` INT,
    `price` DOUBLE,
    PRIMARY KEY (`id`),
    KEY `idx_order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- 15. Payment Record Table (singular)
-- ============================================
CREATE TABLE IF NOT EXISTS `payment_record` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `payment_no` VARCHAR(32) NOT NULL,
    `order_id` BIGINT NOT NULL,
    `order_no` VARCHAR(32) NOT NULL,
    `payment_type` VARCHAR(20) NOT NULL,
    `total_amount` DECIMAL(10,2) NOT NULL,
    `payment_status` VARCHAR(20) NOT NULL DEFAULT 'UNPAID',
    `transaction_id` VARCHAR(64),
    `pay_time` TIMESTAMP NULL,
    `create_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `update_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_payment_no` (`payment_no`),
    KEY `idx_order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- 16. Attendances Table
-- ============================================
CREATE TABLE IF NOT EXISTS `attendances` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `employee_id` BIGINT,
    `check_in_time` TIMESTAMP NULL,
    `check_out_time` TIMESTAMP NULL,
    `check_in_location` VARCHAR(255),
    `check_out_location` VARCHAR(255),
    `check_in_photo` VARCHAR(255),
    `check_out_photo` VARCHAR(255),
    `status` VARCHAR(20),
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_employee_id` (`employee_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- 17. Schedules Table
-- ============================================
CREATE TABLE IF NOT EXISTS `schedules` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `employee_id` BIGINT NOT NULL,
    `schedule_date` DATE NOT NULL,
    `shift_type` VARCHAR(20) NOT NULL,
    `start_time` VARCHAR(10),
    `end_time` VARCHAR(10),
    `status` VARCHAR(20),
    `notes` VARCHAR(500),
    PRIMARY KEY (`id`),
    KEY `idx_employee_id` (`employee_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- 18. Shifts Table
-- ============================================
CREATE TABLE IF NOT EXISTS `shifts` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `employee_id` BIGINT NOT NULL,
    `shift_date` DATE NOT NULL,
    `cash_amount` DECIMAL(10,2) NOT NULL,
    `wechat_amount` DECIMAL(10,2) NOT NULL,
    `alipay_amount` DECIMAL(10,2) NOT NULL,
    `card_amount` DECIMAL(10,2) NOT NULL,
    `member_card_amount` DECIMAL(10,2) NOT NULL,
    `coupon_amount` DECIMAL(10,2) NOT NULL,
    `total_amount` DECIMAL(10,2) NOT NULL,
    `system_amount` DECIMAL(10,2) NOT NULL,
    `difference` DECIMAL(10,2),
    `difference_reason` VARCHAR(500),
    `status` VARCHAR(20) NOT NULL,
    `next_employee_id` BIGINT,
    `notes` VARCHAR(500),
    PRIMARY KEY (`id`),
    KEY `idx_employee_id` (`employee_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- 19. Commissions Table
-- ============================================
CREATE TABLE IF NOT EXISTS `commissions` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `employee_id` BIGINT NOT NULL,
    `order_id` BIGINT NOT NULL,
    `commission_type` VARCHAR(20) NOT NULL,
    `amount` DECIMAL(10,2) NOT NULL,
    `commission_date` DATE NOT NULL,
    `status` VARCHAR(20) NOT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_employee_id` (`employee_id`),
    KEY `idx_order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- 20. Salaries Table (plural)
-- ============================================
CREATE TABLE IF NOT EXISTS `salaries` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `employee_id` BIGINT NOT NULL,
    `year` INT NOT NULL,
    `month` INT NOT NULL,
    `base_salary` DECIMAL(10,2) DEFAULT 0,
    `commission` DECIMAL(10,2) DEFAULT 0,
    `bonus` DECIMAL(10,2) DEFAULT 0,
    `full_attendance_bonus` DECIMAL(10,2) DEFAULT 0,
    `social_security` DECIMAL(10,2) DEFAULT 0,
    `tax` DECIMAL(10,2) DEFAULT 0,
    `other_deduction` DECIMAL(10,2) DEFAULT 0,
    `net_salary` DECIMAL(10,2) DEFAULT 0,
    `status` VARCHAR(20) DEFAULT 'unpaid',
    `paid_at` TIMESTAMP NULL,
    `notes` VARCHAR(500),
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_employee_id` (`employee_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- 21. Group Purchases Table
-- ============================================
CREATE TABLE IF NOT EXISTS `group_purchases` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `title` VARCHAR(100) NOT NULL,
    `subtitle` VARCHAR(200),
    `description` VARCHAR(500),
    `image` VARCHAR(255),
    `original_price` DECIMAL(10,2) DEFAULT 0,
    `group_price` DECIMAL(10,2) DEFAULT 0,
    `min_members` INT DEFAULT 2,
    `max_members` INT DEFAULT 10,
    `current_members` INT DEFAULT 0,
    `stock` INT DEFAULT 100,
    `sold_count` INT DEFAULT 0,
    `start_date` DATE,
    `end_date` DATE,
    `group_deadline` TIMESTAMP NULL,
    `status` VARCHAR(20) DEFAULT 'pending',
    `category` VARCHAR(50),
    `location` VARCHAR(255),
    `validity_days` INT DEFAULT 30,
    `details` TEXT,
    `notes` VARCHAR(500),
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- 22. Group Purchase Members Table
-- ============================================
CREATE TABLE IF NOT EXISTS `group_purchase_members` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `group_purchase_id` BIGINT,
    `group_purchase_title` VARCHAR(100),
    `customer_id` BIGINT,
    `customer_name` VARCHAR(50),
    `customer_phone` VARCHAR(20),
    `status` VARCHAR(20) DEFAULT 'pending',
    `is_leader` BOOLEAN DEFAULT FALSE,
    `joined_at` TIMESTAMP NULL,
    `success_at` TIMESTAMP NULL,
    `failed_at` TIMESTAMP NULL,
    `failure_reason` VARCHAR(500),
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_group_purchase_id` (`group_purchase_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- 23. Verifications Table
-- ============================================
CREATE TABLE IF NOT EXISTS `verifications` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `verification_code` VARCHAR(50),
    `customer_id` BIGINT,
    `customer_name` VARCHAR(50),
    `customer_phone` VARCHAR(20),
    `type` VARCHAR(20),
    `related_id` BIGINT,
    `item_name` VARCHAR(100),
    `quantity` INT DEFAULT 1,
    `points` INT DEFAULT 0,
    `amount` DOUBLE DEFAULT 0,
    `employee_id` BIGINT,
    `employee_name` VARCHAR(50),
    `status` VARCHAR(20) DEFAULT 'unused',
    `used_at` TIMESTAMP NULL,
    `notes` VARCHAR(500),
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_verification_code` (`verification_code`),
    KEY `idx_customer_id` (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- Completion Notice
-- ============================================
SELECT 'Database initialization complete!' AS status;
SHOW TABLES;
