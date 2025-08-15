package com.ryanshiun.seniorscare.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.List;

@Configuration
@EnableMethodSecurity
public class SecurityConfig {

    @Autowired
    private JwtAuthenticationFilter jwtFilter;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        return http
                .csrf(AbstractHttpConfigurer::disable)
                .sessionManagement((session) -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class)
                .httpBasic(AbstractHttpConfigurer::disable)
                .formLogin(AbstractHttpConfigurer::disable)
                .cors(cors -> cors
                        .configurationSource(corsConfigurationSource()))
                .authorizeHttpRequests(request -> request
                        // 所有人都能訪問的 API
                        .requestMatchers("/api/pwdReset/**").permitAll()
                        .requestMatchers("/api/auth/**").permitAll()
                        .requestMatchers("/images/**").permitAll()
                        // EMPLOYEE 權限 - 登入即可使用
                        .requestMatchers(HttpMethod.PUT, "/api/employees/reset/{empId}").authenticated()
                        .requestMatchers(HttpMethod.PUT, "/api/employees/{empId}").authenticated()
                        .requestMatchers(HttpMethod.GET, "/api/employees").authenticated()
                        .requestMatchers(HttpMethod.GET, "/api/employees/{empId}/roles").authenticated()
                        .requestMatchers(HttpMethod.GET, "/api/employees/{empId}").authenticated()
                        .requestMatchers(HttpMethod.GET, "/api/employees/roles").authenticated()

                        // MANAGER 權限
                        .requestMatchers(HttpMethod.PUT, "/api/employees/{empId}/roles").hasRole("MANAGER")

                        // ADMIN 權限
                        .requestMatchers(HttpMethod.PUT, "/api/employees/{empId}/status").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.POST, "/api/employees").hasRole("ADMIN")
                        // 組員 api 預設都為登入即可使用
                        .anyRequest().authenticated()
                )
                .build();
    }

    private CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration config = new CorsConfiguration();
        // 所有來源都可以請求
        config.setAllowedOrigins(List.of("*"));
//        config.setAllowedOrigins(List.of("http://localhost:5173"));
        config.setAllowedHeaders(List.of("*"));
        // 允許所有方法
        config.setAllowedMethods(List.of("*"));
        // 允許帶上 cookie
//        config.setAllowCredentials(true);
        // PreFlight 請求結果可以被瀏覽器 cache 幾秒
        config.setMaxAge(3600L);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", config);

        return source;
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }
}
