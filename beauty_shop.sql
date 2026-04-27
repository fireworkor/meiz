

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for attendances
-- ----------------------------
DROP TABLE IF EXISTS `attendances`;
CREATE TABLE `attendances`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `employee_id` bigint NULL DEFAULT NULL,
  `check_in_time` timestamp NULL DEFAULT NULL,
  `check_out_time` timestamp NULL DEFAULT NULL,
  `check_in_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `check_out_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `check_in_photo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `check_out_photo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_employee_id`(`employee_id` ASC) USING BTREE,
  CONSTRAINT `FK2mia0pcnmy2nddwedvfrt0w08` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of attendances
-- ----------------------------
INSERT INTO `attendances` VALUES (1, 1, '2026-04-22 09:00:00', '2026-04-22 18:05:00', NULL, NULL, NULL, NULL, 'NORMAL', '2026-04-22 22:27:26', '2026-04-22 22:27:26');
INSERT INTO `attendances` VALUES (2, 2, '2026-04-22 09:30:00', '2026-04-22 18:30:00', NULL, NULL, NULL, NULL, 'LATE', '2026-04-22 22:27:26', '2026-04-22 22:27:26');

-- ----------------------------
-- Table structure for card_types
-- ----------------------------
DROP TABLE IF EXISTS `card_types`;
CREATE TABLE `card_types`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `initial_amount` decimal(10, 2) NOT NULL,
  `gift_amount` decimal(10, 2) NULL DEFAULT NULL,
  `discount_rate` decimal(5, 2) NOT NULL,
  `points_rate` int NULL DEFAULT NULL,
  `validity_months` int NULL DEFAULT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of card_types
-- ----------------------------
INSERT INTO `card_types` VALUES (1, 'Normal Member', 'Basic membership benefits', 0.00, 0.00, 1.00, 1, 12, 'active');
INSERT INTO `card_types` VALUES (2, 'Silver Member', '95% discount', 99.00, 10.00, 0.95, 2, 12, 'active');
INSERT INTO `card_types` VALUES (3, 'Gold Member', '90% discount', 299.00, 50.00, 0.90, 2, 12, 'active');

-- ----------------------------
-- Table structure for commissions
-- ----------------------------
DROP TABLE IF EXISTS `commissions`;
CREATE TABLE `commissions`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `employee_id` bigint NOT NULL,
  `order_id` bigint NOT NULL,
  `commission_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` decimal(10, 2) NOT NULL,
  `commission_date` date NOT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_employee_id`(`employee_id` ASC) USING BTREE,
  INDEX `idx_order_id`(`order_id` ASC) USING BTREE,
  CONSTRAINT `FK5vtjsbyho5u0wxb5wsl5gwj76` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK8lrww534wk9n7try26jied988` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of commissions
-- ----------------------------
INSERT INTO `commissions` VALUES (1, 1, 1, 'SERVICE', 39.60, '2026-04-22', 'unsettled');
INSERT INTO `commissions` VALUES (2, 2, 2, 'SERVICE', 79.60, '2026-04-22', 'unsettled');

-- ----------------------------
-- Table structure for coupons
-- ----------------------------
DROP TABLE IF EXISTS `coupons`;
CREATE TABLE `coupons`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `customer_id` bigint NULL DEFAULT NULL,
  `coupon_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `discount_amount` decimal(10, 2) NULL DEFAULT NULL,
  `min_amount` decimal(10, 2) NULL DEFAULT NULL,
  `discount_rate` decimal(5, 2) NULL DEFAULT NULL,
  `issue_date` date NOT NULL,
  `expiry_date` date NOT NULL,
  `used_date` date NULL DEFAULT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_customer_id`(`customer_id` ASC) USING BTREE,
  CONSTRAINT `FKiab9o5omyiakkiyg3k7b987xf` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of coupons
-- ----------------------------
INSERT INTO `coupons` VALUES (1, 1, 'CPN001', 'New Customer 20% Off', 'DISCOUNT', 0.00, 100.00, NULL, '2026-04-22', '2026-05-22', NULL, 'unused');
INSERT INTO `coupons` VALUES (2, 1, 'CPN002', '50 Off Over 200', 'CASH', 50.00, 200.00, NULL, '2026-04-22', '2026-05-22', NULL, 'unused');
INSERT INTO `coupons` VALUES (3, 2, 'CPN003', 'New Customer 20% Off', 'DISCOUNT', 0.00, 100.00, NULL, '2026-04-22', '2026-05-22', NULL, 'unused');

-- ----------------------------
-- Table structure for customers
-- ----------------------------
DROP TABLE IF EXISTS `customers`;
CREATE TABLE `customers`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NULL DEFAULT NULL,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `level` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `points` int NULL DEFAULT 0,
  `birthday` date NULL DEFAULT NULL,
  `gender` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `wechat` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `occupation` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `source_channel` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `skin_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `allergy_history` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `skin_problems` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `preferred_items` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `preferred_employee` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `preferred_time` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `average_spending` double NULL DEFAULT NULL,
  `tags` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `FKrh1g1a20omjmn6kurd35o3eit` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of customers
-- ----------------------------
INSERT INTO `customers` VALUES (1, 4, 'Ms. Zhang', '13900001001', 'GOLD', 2500, '1990-05-20', '男', NULL, NULL, NULL, 'Dry', NULL, NULL, NULL, NULL, NULL, NULL, 'VIP,Regular', '2026-04-22 22:27:26', '2026-04-23 19:43:18');
INSERT INTO `customers` VALUES (2, 5, 'Mr. Li', '13900001002', 'SILVER', 1200, '1985-08-15', 'MALE', NULL, NULL, NULL, 'Combination', NULL, NULL, NULL, NULL, NULL, NULL, 'New Customer', '2026-04-22 22:27:26', '2026-04-22 22:27:26');

-- ----------------------------
-- Table structure for employees
-- ----------------------------
DROP TABLE IF EXISTS `employees`;
CREATE TABLE `employees`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NULL DEFAULT NULL,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `position` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `entry_date` date NULL DEFAULT NULL,
  `employee_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `id_card` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `emergency_contact` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `emergency_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `skill_tags` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `base_salary` decimal(10, 2) NULL DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `FK69x3vjuy1t5p18a5llb8h2fjx` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of employees
-- ----------------------------
INSERT INTO `employees` VALUES (1, 2, 'Zhang Xiaomei', '13800001001', 'Beautician', '2022-01-15', 'EMP001', '110101199001011234', 'Emergency Contact 1', '13812345678', 'active', 'Facial Care,Hydration', 8000.00, '2026-04-22 22:27:26', '2026-04-22 22:27:26');
INSERT INTO `employees` VALUES (2, 3, 'Li Xiaoli', '13800001002', 'Senior Beautician', '2021-06-20', 'EMP002', '110101198501011234', 'Emergency Contact 2', '13887654321', 'active', 'SPA,Anti-aging', 12000.00, '2026-04-22 22:27:26', '2026-04-22 22:27:26');
INSERT INTO `employees` VALUES (3, 9, '123', '1', '前台', '2026-04-22', '5', '1', '1', '1', '在职', '', 0.00, '2026-04-22 22:54:21', '2026-04-22 22:55:38');

-- ----------------------------
-- Table structure for group_purchase_members
-- ----------------------------
DROP TABLE IF EXISTS `group_purchase_members`;
CREATE TABLE `group_purchase_members`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_purchase_id` bigint NULL DEFAULT NULL,
  `group_purchase_title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `customer_id` bigint NULL DEFAULT NULL,
  `customer_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `customer_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'pending',
  `is_leader` tinyint(1) NULL DEFAULT 0,
  `joined_at` timestamp NULL DEFAULT NULL,
  `success_at` timestamp NULL DEFAULT NULL,
  `failed_at` timestamp NULL DEFAULT NULL,
  `failure_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_group_purchase_id`(`group_purchase_id` ASC) USING BTREE,
  INDEX `FKpecyqr1vd5nedxcw4h2g9mfpn`(`customer_id` ASC) USING BTREE,
  CONSTRAINT `FKkuo01opuh2qt0q7f18b4ma08x` FOREIGN KEY (`group_purchase_id`) REFERENCES `group_purchases` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FKpecyqr1vd5nedxcw4h2g9mfpn` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of group_purchase_members
-- ----------------------------
INSERT INTO `group_purchase_members` VALUES (1, 1, 'Facial Care Package', 1, 'Ms. Zhang', '13900001001', 'success', 1, '2026-04-22 22:27:26', NULL, NULL, NULL, '2026-04-22 22:27:26');
INSERT INTO `group_purchase_members` VALUES (2, 1, 'Facial Care Package', 2, 'Mr. Li', '13900001002', 'pending', 0, '2026-04-22 22:27:26', NULL, NULL, NULL, '2026-04-22 22:27:26');

-- ----------------------------
-- Table structure for group_purchases
-- ----------------------------
DROP TABLE IF EXISTS `group_purchases`;
CREATE TABLE `group_purchases`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `subtitle` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `original_price` decimal(10, 2) NULL DEFAULT 0.00,
  `group_price` decimal(10, 2) NULL DEFAULT 0.00,
  `min_members` int NULL DEFAULT 2,
  `max_members` int NULL DEFAULT 10,
  `current_members` int NULL DEFAULT 0,
  `stock` int NULL DEFAULT 100,
  `sold_count` int NULL DEFAULT 0,
  `start_date` date NULL DEFAULT NULL,
  `end_date` date NULL DEFAULT NULL,
  `group_deadline` timestamp NULL DEFAULT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'pending',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `validity_days` int NULL DEFAULT 30,
  `details` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `notes` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of group_purchases
-- ----------------------------
INSERT INTO `group_purchases` VALUES (1, 'Facial Care Package', 'Deep Clean + Hydration', NULL, NULL, 466.00, 299.00, 1, 5, 0, 50, 0, NULL, NULL, NULL, 'pending', 'BEAUTY', NULL, 30, '', NULL, NULL, '2026-04-22 23:51:08');
INSERT INTO `group_purchases` VALUES (2, 'Full Body SPA Package', '60-min Full Body Massage', 'Relaxing full body SPA experience', NULL, 398.00, 268.00, 3, 8, 5, 30, 86, NULL, NULL, NULL, 'active', 'SPA', NULL, 30, NULL, NULL, '2026-04-22 22:27:26', '2026-04-22 22:27:26');
INSERT INTO `group_purchases` VALUES (3, '1', '1', NULL, NULL, 111.00, 110.00, 2, 10, 0, 100, 0, NULL, NULL, NULL, 'active', 'beauty', NULL, 30, '', NULL, '2026-04-22 23:51:44', '2026-04-22 23:51:44');

-- ----------------------------
-- Table structure for inventory
-- ----------------------------
DROP TABLE IF EXISTS `inventory`;
CREATE TABLE `inventory`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `product_id` bigint NOT NULL,
  `quantity` int NOT NULL,
  `batch_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `supplier` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `expiry_date` date NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_product_id`(`product_id` ASC) USING BTREE,
  CONSTRAINT `FKq2yge7ebtfuvwufr6lwfwqy9l` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of inventory
-- ----------------------------
INSERT INTO `inventory` VALUES (1, 1, 100, '213131', 'Beauty Supplier A', '2026-04-24');
INSERT INTO `inventory` VALUES (2, 2, 50, NULL, 'Beauty Supplier A', NULL);
INSERT INTO `inventory` VALUES (3, 3, 30, NULL, 'Beauty Supplier B', NULL);
INSERT INTO `inventory` VALUES (4, 1, 1, '1', '1', '2026-04-23');
INSERT INTO `inventory` VALUES (5, 3, 1122, '11122', '1122', '2026-04-30');

-- ----------------------------
-- Table structure for marketing_activities
-- ----------------------------
DROP TABLE IF EXISTS `marketing_activities`;
CREATE TABLE `marketing_activities`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `discount_amount` decimal(10, 2) NULL DEFAULT NULL,
  `discount_rate` decimal(5, 2) NULL DEFAULT NULL,
  `min_amount` decimal(10, 2) NULL DEFAULT NULL,
  `target_count` int NULL DEFAULT NULL,
  `participation_count` int NULL DEFAULT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of marketing_activities
-- ----------------------------
INSERT INTO `marketing_activities` VALUES (1, 'Spring Skincare Season', 'CAMPAIGN', 'Spring skincare products 20% off', '2026-04-22', '2026-05-22', 20.00, NULL, NULL, NULL, NULL, 'active');
INSERT INTO `marketing_activities` VALUES (2, 'Member Day', 'EVENT', 'Monthly member day, 12% off all services', '2026-04-22', '2027-04-22', 12.00, NULL, NULL, NULL, NULL, 'active');

-- ----------------------------
-- Table structure for membership_cards
-- ----------------------------
DROP TABLE IF EXISTS `membership_cards`;
CREATE TABLE `membership_cards`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `customer_id` bigint NOT NULL,
  `card_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `card_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `balance` decimal(10, 2) NOT NULL,
  `total_amount` decimal(10, 2) NOT NULL,
  `discount_rate` decimal(5, 2) NULL DEFAULT NULL,
  `points` int NOT NULL,
  `issue_date` date NOT NULL,
  `expiry_date` date NULL DEFAULT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_customer_id`(`customer_id` ASC) USING BTREE,
  CONSTRAINT `FKdxdlbvny08xpxff3wqnfmi3sk` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of membership_cards
-- ----------------------------
INSERT INTO `membership_cards` VALUES (1, 1, 'MC001', 'Gold Member', 1000.00, 1000.00, 0.90, 500, '2026-04-22', NULL, 'active');
INSERT INTO `membership_cards` VALUES (2, 2, 'MC002', 'Silver Member', 680.00, 700.00, 0.95, 200, '2026-04-22', NULL, 'active');

-- ----------------------------
-- Table structure for order_items
-- ----------------------------
DROP TABLE IF EXISTS `order_items`;
CREATE TABLE `order_items`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint NOT NULL,
  `item_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `item_id` bigint NULL DEFAULT NULL,
  `quantity` int NULL DEFAULT NULL,
  `price` double NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_order_id`(`order_id` ASC) USING BTREE,
  CONSTRAINT `FKbioxgbv59vetrxe0ejfubep1w` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order_items
-- ----------------------------
INSERT INTO `order_items` VALUES (1, 1, 'service', 1, 1, 198);
INSERT INTO `order_items` VALUES (2, 1, 'service', 2, 1, 268);
INSERT INTO `order_items` VALUES (3, 2, 'service', 3, 1, 398);
INSERT INTO `order_items` VALUES (4, 3, 'service', 1, 1, 68);
INSERT INTO `order_items` VALUES (5, 4, NULL, NULL, 1, 200);
INSERT INTO `order_items` VALUES (6, 5, NULL, NULL, 1, 200);
INSERT INTO `order_items` VALUES (7, 6, NULL, NULL, 1, 300);
INSERT INTO `order_items` VALUES (8, 7, NULL, NULL, 1, 200);
INSERT INTO `order_items` VALUES (9, 8, NULL, NULL, 1, 200);
INSERT INTO `order_items` VALUES (10, 9, NULL, NULL, 1, 198);

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `customer_id` bigint NULL DEFAULT NULL,
  `employee_id` bigint NULL DEFAULT NULL,
  `order_date` datetime NULL DEFAULT NULL,
  `total_amount` double NULL DEFAULT NULL,
  `payment_method` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_customer_id`(`customer_id` ASC) USING BTREE,
  INDEX `FKfhl8bv0xn3sj33q2f3scf1bq6`(`employee_id` ASC) USING BTREE,
  CONSTRAINT `FKfhl8bv0xn3sj33q2f3scf1bq6` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FKpxtb8awmi0dk6smoh2vp1litg` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of orders
-- ----------------------------
INSERT INTO `orders` VALUES (1, 1, 1, '2026-04-22 22:27:26', 466, 'WXPAY', 'PAID', '2026-04-22 22:27:26', '2026-04-22 22:27:26');
INSERT INTO `orders` VALUES (2, 2, 2, '2026-04-22 22:27:26', 398, 'ALIPAY', 'PAID', '2026-04-22 22:27:26', '2026-04-22 22:27:26');
INSERT INTO `orders` VALUES (3, 1, 1, '2026-04-21 22:27:26', 68, 'MEMBERCARD', 'COMPLETED', '2026-04-21 22:27:26', '2026-04-21 22:27:26');
INSERT INTO `orders` VALUES (4, 1, 1, '2026-04-22 22:28:39', 200, 'cash', '待支付', '2026-04-22 22:28:39', '2026-04-22 22:28:39');
INSERT INTO `orders` VALUES (5, 1, 1, '2026-04-22 22:28:55', 200, 'cash', '待支付', '2026-04-22 22:28:55', '2026-04-22 22:28:55');
INSERT INTO `orders` VALUES (6, 2, 2, '2026-04-22 22:32:47', 300, 'cash', '待支付', '2026-04-22 22:32:47', '2026-04-22 22:32:47');
INSERT INTO `orders` VALUES (7, 1, 1, '2026-04-22 22:37:34', 200, 'cash', '待支付', '2026-04-22 22:37:34', '2026-04-22 22:37:34');
INSERT INTO `orders` VALUES (8, 1, 1, '2026-04-22 22:37:43', 200, 'wechat', '待支付', '2026-04-22 22:37:43', '2026-04-22 22:37:43');
INSERT INTO `orders` VALUES (9, 1, 2, '2026-04-22 23:31:22', 198, 'cash', '待支付', '2026-04-22 23:31:22', '2026-04-22 23:31:22');

-- ----------------------------
-- Table structure for payment_record
-- ----------------------------
DROP TABLE IF EXISTS `payment_record`;
CREATE TABLE `payment_record`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `payment_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `order_id` bigint NOT NULL,
  `order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `payment_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_amount` decimal(10, 2) NOT NULL,
  `payment_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'UNPAID',
  `transaction_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `pay_time` timestamp NULL DEFAULT NULL,
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_payment_no`(`payment_no` ASC) USING BTREE,
  INDEX `idx_order_id`(`order_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of payment_record
-- ----------------------------
INSERT INTO `payment_record` VALUES (1, 'PAY202404220001', 1, 'ORD001', 'WXPAY', 466.00, 'SUCCESS', NULL, NULL, '2026-04-22 22:27:26', '2026-04-22 22:27:26');
INSERT INTO `payment_record` VALUES (2, 'PAY202404220002', 2, 'ORD002', 'ALIPAY', 398.00, 'SUCCESS', NULL, NULL, '2026-04-22 22:27:26', '2026-04-22 22:27:26');
INSERT INTO `payment_record` VALUES (3, 'PAY202404210001', 3, 'ORD003', 'MEMBERCARD', 68.00, 'SUCCESS', NULL, NULL, '2026-04-22 22:27:26', '2026-04-22 22:27:26');

-- ----------------------------
-- Table structure for products
-- ----------------------------
DROP TABLE IF EXISTS `products`;
CREATE TABLE `products`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `price` decimal(10, 2) NOT NULL,
  `cost_price` decimal(10, 2) NOT NULL,
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of products
-- ----------------------------
INSERT INTO `products` VALUES (1, 'Hydrating Mask', 'Deep hydrating facial mask', 88.00, 40.00, 'SKINCARE', 'active');
INSERT INTO `products` VALUES (2, 'Sunscreen', 'SPF50+ sunscreen', 168.00, 80.00, 'SKINCARE', 'active');
INSERT INTO `products` VALUES (3, 'Essential Oil', 'Lavender essential oil', 228.00, 100.00, 'SPA', 'active');

-- ----------------------------
-- Table structure for reservations
-- ----------------------------
DROP TABLE IF EXISTS `reservations`;
CREATE TABLE `reservations`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `customer_id` bigint NULL DEFAULT NULL,
  `employee_id` bigint NULL DEFAULT NULL,
  `service_id` bigint NULL DEFAULT NULL,
  `room_id` bigint NULL DEFAULT NULL,
  `reservation_date` date NULL DEFAULT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `source` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_customer_id`(`customer_id` ASC) USING BTREE,
  INDEX `idx_employee_id`(`employee_id` ASC) USING BTREE,
  INDEX `FKljt6q1tp205b0h26eiegc5mx6`(`room_id` ASC) USING BTREE,
  INDEX `FK3ww618ll729ubr3pb5krt9d3h`(`service_id` ASC) USING BTREE,
  CONSTRAINT `FK26cya250clfqgfl59s9vi9e8x` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK3ww618ll729ubr3pb5krt9d3h` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK8eccffekcj27jkdiyw2e9r8ks` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FKljt6q1tp205b0h26eiegc5mx6` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of reservations
-- ----------------------------
INSERT INTO `reservations` VALUES (1, 1, 1, 1, 1, '2026-04-22', 'confirmed', 'online', '2026-04-22 22:27:26', '2026-04-22 22:27:26');
INSERT INTO `reservations` VALUES (2, 1, 2, 2, 1, '2026-04-23', '爽约', 'online', '2026-04-22 22:27:26', '2026-04-23 19:05:30');
INSERT INTO `reservations` VALUES (3, 2, 1, 3, 3, '2026-04-24', 'confirmed', 'walk_in', '2026-04-22 22:27:26', '2026-04-22 22:27:26');
INSERT INTO `reservations` VALUES (4, 1, 1, 1, 1, '2026-04-22', '待确认', '顾客自助预约', '2026-04-22 22:37:15', '2026-04-22 22:37:15');

-- ----------------------------
-- Table structure for rooms
-- ----------------------------
DROP TABLE IF EXISTS `rooms`;
CREATE TABLE `rooms`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `capacity` int NOT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `display_order` int NULL DEFAULT NULL,
  `floor` int NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of rooms
-- ----------------------------
INSERT INTO `rooms` VALUES (1, 'Beauty Room 1', 'BEAUTY', 2, 'AVAILABLE', NULL, NULL, NULL);
INSERT INTO `rooms` VALUES (2, 'Beauty Room 2', 'BEAUTY', 2, 'AVAILABLE', NULL, NULL, NULL);
INSERT INTO `rooms` VALUES (3, 'SPA Room', 'SPA', 1, 'AVAILABLE', NULL, NULL, NULL);

-- ----------------------------
-- Table structure for salaries
-- ----------------------------
DROP TABLE IF EXISTS `salaries`;
CREATE TABLE `salaries`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `employee_id` bigint NOT NULL,
  `year` int NOT NULL,
  `month` int NOT NULL,
  `base_salary` decimal(10, 2) NULL DEFAULT 0.00,
  `commission` decimal(10, 2) NULL DEFAULT 0.00,
  `bonus` decimal(10, 2) NULL DEFAULT 0.00,
  `full_attendance_bonus` decimal(10, 2) NULL DEFAULT 0.00,
  `social_security` decimal(10, 2) NULL DEFAULT 0.00,
  `tax` decimal(10, 2) NULL DEFAULT 0.00,
  `other_deduction` decimal(10, 2) NULL DEFAULT 0.00,
  `net_salary` decimal(10, 2) NULL DEFAULT 0.00,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'unpaid',
  `paid_at` timestamp NULL DEFAULT NULL,
  `notes` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_employee_id`(`employee_id` ASC) USING BTREE,
  CONSTRAINT `FK1utmvufusgyktdtbmo4xfas10` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of salaries
-- ----------------------------
INSERT INTO `salaries` VALUES (1, 1, 2024, 4, 8000.00, 2000.00, 500.00, 0.00, 0.00, 0.00, 0.00, 10500.00, 'paid', NULL, NULL, '2026-04-22 22:27:26', '2026-04-22 22:27:26');
INSERT INTO `salaries` VALUES (2, 2, 2024, 4, 12000.00, 3500.00, 800.00, 0.00, 0.00, 0.00, 0.00, 16300.00, 'paid', NULL, NULL, '2026-04-22 22:27:26', '2026-04-22 22:27:26');

-- ----------------------------
-- Table structure for schedules
-- ----------------------------
DROP TABLE IF EXISTS `schedules`;
CREATE TABLE `schedules`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `employee_id` bigint NOT NULL,
  `schedule_date` date NOT NULL,
  `shift_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `start_time` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `end_time` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `notes` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_employee_id`(`employee_id` ASC) USING BTREE,
  CONSTRAINT `FKk1xoduufw1mu7ywao2xg90g3f` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of schedules
-- ----------------------------
INSERT INTO `schedules` VALUES (1, 1, '2026-04-22', 'DAY', '09:00', '18:00', 'active', NULL);
INSERT INTO `schedules` VALUES (2, 2, '2026-04-22', 'DAY', '09:00', '18:00', 'active', NULL);
INSERT INTO `schedules` VALUES (3, 1, '2026-04-01', '早班', '', '', '正常', '');
INSERT INTO `schedules` VALUES (4, 1, '2026-04-01', '早班', '09:38', '18:52', '正常', '');
INSERT INTO `schedules` VALUES (5, 1, '2026-04-22', '早班', '22:39', '22:40', '正常', '');

-- ----------------------------
-- Table structure for services
-- ----------------------------
DROP TABLE IF EXISTS `services`;
CREATE TABLE `services`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `price` decimal(10, 2) NULL DEFAULT 0.00,
  `duration` int NULL DEFAULT 60,
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `commission_rate` decimal(5, 2) NULL DEFAULT 10.00,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of services
-- ----------------------------
INSERT INTO `services` VALUES (1, 'Deep Facial Clean', 'BEAUTY', 198.00, 60, 'Gentle exfoliation, deep pore cleaning', NULL, 10.00, 'active', '2026-04-22 22:27:26', '2026-04-22 22:27:26');
INSERT INTO `services` VALUES (2, 'Hydration Care', 'BEAUTY', 268.00, 90, 'Hyaluronic acid infusion, hydration lock', NULL, 10.00, 'active', '2026-04-22 22:27:26', '2026-04-22 22:27:26');
INSERT INTO `services` VALUES (3, 'Full Body SPA', 'SPA', 398.00, 90, 'Essential oil massage, relaxation', NULL, 10.00, 'active', '2026-04-22 22:27:26', '2026-04-22 22:27:26');

-- ----------------------------
-- Table structure for shifts
-- ----------------------------
DROP TABLE IF EXISTS `shifts`;
CREATE TABLE `shifts`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `employee_id` bigint NOT NULL,
  `shift_date` date NOT NULL,
  `cash_amount` decimal(10, 2) NOT NULL,
  `wechat_amount` decimal(10, 2) NOT NULL,
  `alipay_amount` decimal(10, 2) NOT NULL,
  `card_amount` decimal(10, 2) NOT NULL,
  `member_card_amount` decimal(10, 2) NOT NULL,
  `coupon_amount` decimal(10, 2) NOT NULL,
  `total_amount` decimal(10, 2) NOT NULL,
  `system_amount` decimal(10, 2) NOT NULL,
  `difference` decimal(10, 2) NULL DEFAULT NULL,
  `difference_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `next_employee_id` bigint NULL DEFAULT NULL,
  `notes` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_employee_id`(`employee_id` ASC) USING BTREE,
  CONSTRAINT `FKtbsbc3nmr4b1vlwtnd944q9u7` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of shifts
-- ----------------------------
INSERT INTO `shifts` VALUES (1, 1, '2026-04-22', 0.00, 466.00, 0.00, 0.00, 0.00, 0.00, 466.00, 466.00, NULL, NULL, 'closed', NULL, NULL);

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, 'admin', '$2a$10$RZTJiaRPnUXiMb7i636SSe3Pop.XdhX6m76MrN52VYA9vE8N8EGMi', 'admin', 'Administrator', '13800000000', NULL, '2026-04-22 22:27:26', '2026-04-22 22:28:06');
INSERT INTO `users` VALUES (2, 'staff', '$2a$10$RZTJiaRPnUXiMb7i636SSe3Pop.XdhX6m76MrN52VYA9vE8N8EGMi', 'staff', 'Zhang Xiaomei', '13800001001', NULL, '2026-04-22 22:27:26', '2026-04-22 22:28:06');
INSERT INTO `users` VALUES (3, 'staff2', '$2a$10$RZTJiaRPnUXiMb7i636SSe3Pop.XdhX6m76MrN52VYA9vE8N8EGMi', 'staff', 'Li Xiaoli', '13800001002', NULL, '2026-04-22 22:27:26', '2026-04-22 22:28:06');
INSERT INTO `users` VALUES (4, 'customer', '$2a$10$RZTJiaRPnUXiMb7i636SSe3Pop.XdhX6m76MrN52VYA9vE8N8EGMi', 'customer', 'Ms. Zhang', '13900001001', NULL, '2026-04-22 22:27:26', '2026-04-22 22:28:06');
INSERT INTO `users` VALUES (5, 'customer2', '$2a$10$RZTJiaRPnUXiMb7i636SSe3Pop.XdhX6m76MrN52VYA9vE8N8EGMi', 'customer', 'Mr. Li', '13900001002', NULL, '2026-04-22 22:27:26', '2026-04-22 22:28:06');
INSERT INTO `users` VALUES (6, 'test1', 'admin123', 'staff', '1', '1', NULL, '2026-04-22 22:40:55', '2026-04-22 22:40:55');
INSERT INTO `users` VALUES (7, 'test2', 'admin123', 'staff', 'test2', '1', NULL, '2026-04-22 22:43:36', '2026-04-22 22:43:36');
INSERT INTO `users` VALUES (8, 'test3', 'admin123', 'staff', 'test3', '1', NULL, '2026-04-22 22:48:30', '2026-04-22 22:48:30');
INSERT INTO `users` VALUES (9, 'test4', 'admin123', 'staff', '123', '1', NULL, '2026-04-22 22:54:21', '2026-04-22 22:54:21');

-- ----------------------------
-- Table structure for verifications
-- ----------------------------
DROP TABLE IF EXISTS `verifications`;
CREATE TABLE `verifications`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `verification_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `customer_id` bigint NULL DEFAULT NULL,
  `customer_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `customer_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `related_id` bigint NULL DEFAULT NULL,
  `item_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `quantity` int NULL DEFAULT 1,
  `points` int NULL DEFAULT 0,
  `amount` double NULL DEFAULT 0,
  `employee_id` bigint NULL DEFAULT NULL,
  `employee_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'unused',
  `used_at` timestamp NULL DEFAULT NULL,
  `notes` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_verification_code`(`verification_code` ASC) USING BTREE,
  INDEX `idx_customer_id`(`customer_id` ASC) USING BTREE,
  INDEX `FK1230jls6i1undvnjjpbxttgo5`(`employee_id` ASC) USING BTREE,
  CONSTRAINT `FK1230jls6i1undvnjjpbxttgo5` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK3mp01240kkv0btv8otq1h0hm8` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of verifications
-- ----------------------------
INSERT INTO `verifications` VALUES (1, 'VER001', 1, 'Ms. Zhang', '13900001001', 'COUPON', NULL, '50 Off Over 200', 1, 0, 50, NULL, NULL, 'unused', NULL, NULL, '2026-04-22 22:27:26', '2026-04-22 22:27:26');
INSERT INTO `verifications` VALUES (2, 'VER002', 2, 'Mr. Li', '13900001002', 'POINTS', NULL, 'Points Redemption', 1, 500, 0, NULL, NULL, 'used', NULL, NULL, '2026-04-22 22:27:26', '2026-04-22 22:27:26');

SET FOREIGN_KEY_CHECKS = 1;
