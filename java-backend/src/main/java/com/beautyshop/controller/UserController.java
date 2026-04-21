package com.beautyshop.controller;

import com.beautyshop.dto.LoginRequest;
import com.beautyshop.dto.LoginResponse;
import com.beautyshop.entity.User;
import com.beautyshop.service.UserService;
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
        Optional<User> userOptional = userService.findByUsername(request.getUsername());
        
        if (userOptional.isPresent()) {
            User user = userOptional.get();
            if (userService.validatePassword(request.getPassword(), user.getPassword())) {
                if (user.getRole().equals(request.getRole())) {
                    response.setSuccess(true);
                    response.setMessage("登录成功");
                    response.setToken("mock-token"); // 实际项目中应生成真实的JWT token
                    response.setRole(user.getRole());
                    response.setUsername(user.getUsername());
                } else {
                    response.setSuccess(false);
                    response.setMessage("角色不匹配");
                }
            } else {
                response.setSuccess(false);
                response.setMessage("密码错误");
            }
        } else {
            response.setSuccess(false);
            response.setMessage("用户不存在");
        }
        
        return response;
    }

    @PostMapping("/register")
    public User register(@RequestBody User user) {
        return userService.save(user);
    }
}