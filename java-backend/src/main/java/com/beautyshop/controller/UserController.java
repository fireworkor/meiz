package com.beautyshop.controller;

import com.beautyshop.dto.LoginRequest;
import com.beautyshop.dto.LoginResponse;
import com.beautyshop.entity.User;
import com.beautyshop.service.UserService;
import com.beautyshop.utils.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.Optional;

@RestController
@RequestMapping("/api/users")
public class UserController {
    @Autowired
    private UserService userService;

    @PostMapping("/login")
    public LoginResponse login(@RequestBody LoginRequest request) {
        LoginResponse response = new LoginResponse();
        System.out.println("Login request: " + request.getUsername() + ", role: " + request.getRole());
        Optional<User> userOptional = userService.findByUsername(request.getUsername());
        
        if (userOptional.isPresent()) {
            User user = userOptional.get();
            System.out.println("Found user: " + user.getUsername() + ", role: " + user.getRole());
            System.out.println("Password validation: " + userService.validatePassword(request.getPassword(), user.getPassword()));
            if (userService.validatePassword(request.getPassword(), user.getPassword())) {
                if (user.getRole().equals(request.getRole())) {
                    response.setSuccess(true);
                    response.setMessage("登录成功");
                    response.setToken(JwtUtil.generateToken(user.getUsername(), user.getRole())); // 生成真实的JWT token
                    response.setRole(user.getRole());
                    response.setUsername(user.getUsername());
                    System.out.println("Login success");
                } else {
                    response.setSuccess(false);
                    response.setMessage("角色不匹配");
                    System.out.println("Role mismatch: expected " + user.getRole() + ", got " + request.getRole());
                }
            } else {
                response.setSuccess(false);
                response.setMessage("密码错误");
                System.out.println("Password validation failed");
            }
        } else {
            response.setSuccess(false);
            response.setMessage("用户不存在");
            System.out.println("User not found: " + request.getUsername());
        }
        
        return response;
    }

    @PostMapping("/register")
    public User register(@RequestBody User user) {
        return userService.save(user);
    }
}