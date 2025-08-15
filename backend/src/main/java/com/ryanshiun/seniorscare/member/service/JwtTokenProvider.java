package com.ryanshiun.seniorscare.member.service;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import java.security.Key;
import java.time.Instant;
import java.util.*;
import java.util.stream.Collectors;

@Component
public class JwtTokenProvider {

    /** 從 application.properties 讀取 Base64 格式的金鑰 */
    @Value("${app.jwt.secret}")
    private String base64Secret;

    /** 從 application.properties 讀取的過期毫秒 */
    @Value("${app.jwt.expiration-in-ms}")
    private long jwtExpirationInMs;

    /** 解碼後的 HMAC-SHA 金鑰 */
    private Key secretKey;

    @PostConstruct
    public void init() {
        // Base64 解碼並產生金鑰
        byte[] keyBytes = Base64.getDecoder().decode(base64Secret);
        this.secretKey = Keys.hmacShaKeyFor(keyBytes);
    }

    /**
     * 1. 產生 JWT：
     *    - 子載荷 subject: 使用者帳號
     *    - 自訂 claims: roles
     *    - 簽章演算法: HS256 (預設)
     */
    public String generateToken(Authentication authentication) {
        String username = authentication.getName();

        // 將 authorities 轉成 String list
        List<String> roles = authentication.getAuthorities()
                .stream()
                .map(GrantedAuthority::getAuthority)
                .collect(Collectors.toList());

        Instant now = Instant.now();
        Date issuedAt = Date.from(now);
        Date expiryDate = Date.from(now.plusMillis(jwtExpirationInMs));

        return Jwts.builder()
                .subject(username)
                .claim("roles", roles)
                .issuedAt(issuedAt)
                .expiration(expiryDate)
                .signWith(secretKey)
                .compact();
    }

    /**
     * 2. 驗證 JWT 是否有效
     */
    public boolean validateToken(String token) {
        try {
            Jwts.parser()
                    .setSigningKey(secretKey)
                    .build()
                    .parseClaimsJws(token);
            return true;
        } catch (JwtException | IllegalArgumentException ex) {
            // JwtException 包含過期、簽章錯誤等
            return false;
        }
    }

    /**
     * 3. 從 JWT 取得 user name
     */
    public String getUsernameFromToken(String token) {
        Claims claims = parseClaims(token);
        return claims.getSubject();
    }

    /**
     * 4. 解析 claims
     */
    private Claims parseClaims(String token) {
        return Jwts.parser()
                .setSigningKey(secretKey)
                .build()
                .parseClaimsJws(token)
                .getBody();
    }

    /**
     * 5. 從 JWT 建立 Spring Authentication
     */
    @SuppressWarnings("unchecked")
    public Authentication getAuthentication(String token) {
        Claims claims = parseClaims(token);
        String username = claims.getSubject();

        // 取出自訂 roles
        List<String> roles = claims.get("roles", List.class);
        List<SimpleGrantedAuthority> authorities = roles.stream()
                .map(SimpleGrantedAuthority::new)
                .collect(Collectors.toList());

        // 因前端只需驗證，不需密碼，比對時傳空密碼即可
        UserDetails userDetails = User.builder()
                .username(username)
                .password("")  // 密碼不在此使用
                .authorities(authorities)
                .build();

        return new UsernamePasswordAuthenticationToken(userDetails, token, authorities);
    }
}