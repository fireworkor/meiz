package com.beautyshop;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class PasswordEncoderTool {
    public static void main(String[] args) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        
        // 生成加密密码
        String adminPassword = encoder.encode("admin123");
        String staffPassword = encoder.encode("staff123");
        String customerPassword = encoder.encode("customer123");
        
        System.out.println("Admin password: " + adminPassword);
        System.out.println("Staff password: " + staffPassword);
        System.out.println("Customer password: " + customerPassword);
        
        // 生成SQL更新语句
        System.out.println("\nSQL Update Statements:");
        System.out.println("UPDATE users SET password = '" + adminPassword + "' WHERE username = 'admin';");
        System.out.println("UPDATE users SET password = '" + staffPassword + "' WHERE username = 'staff';");
        System.out.println("UPDATE users SET password = '" + staffPassword + "' WHERE username = 'staff2';");
        System.out.println("UPDATE users SET password = '" + customerPassword + "' WHERE username = 'customer';");
        System.out.println("UPDATE users SET password = '" + customerPassword + "' WHERE username = 'customer2';");
    }
}