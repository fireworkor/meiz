package com.beautyshop.utils;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class PasswordGenerator {
    public static void main(String[] args) {
        if (args.length != 1) {
            System.out.println("Usage: java PasswordGenerator <password>");
            return;
        }
        
        String password = args[0];
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        String encodedPassword = encoder.encode(password);
        
        System.out.println("Original password: " + password);
        System.out.println("Encoded password: " + encodedPassword);
    }
}