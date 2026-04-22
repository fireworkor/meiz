package com.beautyshop.service;

import com.beautyshop.entity.User;
import com.beautyshop.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import java.util.Optional;

@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public Optional<User> findByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    public User save(User user) {
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        return userRepository.save(user);
    }

    public boolean validatePassword(String rawPassword, String encodedPassword) {
        // For testing purposes, support both plain text and encoded passwords
        if (encodedPassword.length() < 60) {
            return rawPassword.equals(encodedPassword);
        }
        return passwordEncoder.matches(rawPassword, encodedPassword);
    }
}