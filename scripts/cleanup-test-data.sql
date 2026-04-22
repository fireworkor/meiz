-- Beauty Shop Management System - Clean Test Data Script
-- Cleans all test data while preserving table structure

USE beauty_shop;

-- ============================================
-- Clean data in reverse dependency order
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
-- Completion Notice
-- ============================================
SELECT 'Test data cleaned successfully!' AS status;
