package com.ryanshiun.seniorscare.member.controller.login;

// --- AuthController.java ---

import com.ryanshiun.seniorscare.member.dto.employee.AuthResponse;
import com.ryanshiun.seniorscare.member.dto.employee.EmployeeProfileDto;
import com.ryanshiun.seniorscare.member.dto.employee.LoginDto;
import com.ryanshiun.seniorscare.member.service.JwtTokenProvider;
import com.ryanshiun.seniorscare.member.service.employee.EmployeeService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthenticationManager authManager;
    private final JwtTokenProvider jwtProvider;
    private final EmployeeService employeeService;

    public AuthController(
            AuthenticationManager authManager,
            JwtTokenProvider jwtProvider,
            EmployeeService employeeService
    ) {
        this.authManager = authManager;
        this.jwtProvider = jwtProvider;
        this.employeeService = employeeService;
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginDto dto) {
        try {
            // 1. 認證帳密
            Authentication auth = authManager.authenticate(
                    new UsernamePasswordAuthenticationToken(dto.getEmail(), dto.getPassword())
            );
            SecurityContextHolder.getContext().setAuthentication(auth);

            // 2. 產生 JWT
            String token = jwtProvider.generateToken(auth);

            // 3. 撈使用者基本資料
            EmployeeProfileDto me = employeeService.passEmpInfo(dto.getEmail());

            // 4. 回傳
            AuthResponse response = new AuthResponse(token, me);
            return ResponseEntity.ok(response);
        } catch (BadCredentialsException e) {
            // 1) 密碼錯誤 → 401
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        } catch (DisabledException e) {
            // 2) 帳號已停用 → 403
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }
}

