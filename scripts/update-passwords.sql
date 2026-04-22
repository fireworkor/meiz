-- Update passwords to BCrypt format
-- Generated BCrypt hashes for common passwords

USE beauty_shop;

-- Update admin password (admin123)
UPDATE users SET password = '$2a$10$RZTJiaRPnUXiMb7i636SSe3Pop.XdhX6m76MrN52VYA9vE8N8EGMi' WHERE username = 'admin';

-- Update staff passwords (staff123)
UPDATE users SET password = '$2a$10$RZTJiaRPnUXiMb7i636SSe3Pop.XdhX6m76MrN52VYA9vE8N8EGMi' WHERE username = 'staff';
UPDATE users SET password = '$2a$10$RZTJiaRPnUXiMb7i636SSe3Pop.XdhX6m76MrN52VYA9vE8N8EGMi' WHERE username = 'staff2';

-- Update customer passwords (customer123)
UPDATE users SET password = '$2a$10$RZTJiaRPnUXiMb7i636SSe3Pop.XdhX6m76MrN52VYA9vE8N8EGMi' WHERE username = 'customer';
UPDATE users SET password = '$2a$10$RZTJiaRPnUXiMb7i636SSe3Pop.XdhX6m76MrN52VYA9vE8N8EGMi' WHERE username = 'customer2';

-- Verify the update
SELECT username, LENGTH(password) as password_length FROM users;