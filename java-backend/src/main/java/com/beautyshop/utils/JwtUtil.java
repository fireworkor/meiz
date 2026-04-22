package com.beautyshop.utils;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class JwtUtil {
    private static final String SECRET_KEY = "beauty_shop_secret_key_2024";
    private static final long EXPIRE_TIME = 24 * 60 * 60 * 1000; // 24小时

    /**
     * 生成token
     */
    public static String generateToken(String username, String role) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("username", username);
        claims.put("role", role);
        
        return Jwts.builder()
                .setClaims(claims)
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + EXPIRE_TIME))
                .signWith(SignatureAlgorithm.HS256, SECRET_KEY)
                .compact();
    }

    /**
     * 解析token
     */
    public static Claims parseToken(String token) {
        return Jwts.parser()
                .setSigningKey(SECRET_KEY)
                .parseClaimsJws(token)
                .getBody();
    }

    /**
     * 验证token
     */
    public static boolean validateToken(String token) {
        try {
            Jwts.parser().setSigningKey(SECRET_KEY).parseClaimsJws(token);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * 从token中获取用户名
     */
    public static String getUsernameFromToken(String token) {
        return parseToken(token).get("username", String.class);
    }

    /**
     * 从token中获取角色
     */
    public static String getRoleFromToken(String token) {
        return parseToken(token).get("role", String.class);
    }
}