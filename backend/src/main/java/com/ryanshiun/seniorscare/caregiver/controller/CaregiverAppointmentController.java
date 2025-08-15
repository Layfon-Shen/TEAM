package com.ryanshiun.seniorscare.caregiver.controller;

import com.ryanshiun.seniorscare.caregiver.dto.caregiverAppointment.AppointmentRatingDto;
import com.ryanshiun.seniorscare.caregiver.dto.caregiverAppointment.CaregiverAppointmentCreateDto;
import com.ryanshiun.seniorscare.caregiver.dto.caregiverAppointment.CaregiverAppointmentQueryDto;
import com.ryanshiun.seniorscare.caregiver.dto.caregiverAppointment.CaregiverAppointmentUpdateDto;
import com.ryanshiun.seniorscare.caregiver.model.CaregiverAppointment;
import com.ryanshiun.seniorscare.caregiver.service.caregiverAppointment.CaregiverAppointmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/appointments")
public class CaregiverAppointmentController {

    @Autowired
    private CaregiverAppointmentService appointmentService;

    // 建立預約
    @PostMapping
    public ResponseEntity<Map<String, Object>> createAppointment(@RequestBody CaregiverAppointmentCreateDto createDto) {
        Map<String, Object> response = new HashMap<>();

        try {
            Integer appointmentId = appointmentService.createAppointment(createDto);
            response.put("success", true);
            response.put("message", "預約建立成功");
            response.put("appointmentId", appointmentId);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    // 取得預約詳情
    @GetMapping("/{id}")
    public ResponseEntity<Map<String, Object>> getAppointment(@PathVariable Integer id) {
        Map<String, Object> response = new HashMap<>();

        try {
            CaregiverAppointment appointment = appointmentService.getAppointmentById(id);
            response.put("success", true);
            response.put("appointment", appointment);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    // 查詢預約列表
    @GetMapping
    public ResponseEntity<Map<String, Object>> getAppointments(
            @RequestParam(required = false) Integer memberId,
            @RequestParam(required = false) Integer caregiverId,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) Boolean isBlocked,
            @RequestParam(required = false) LocalDateTime startDate,
            @RequestParam(required = false) LocalDateTime endDate,
            @RequestParam(required = false) String createdByType,
            @RequestParam(required = false) Boolean isRated,
            @RequestParam(defaultValue = "20") Integer limit,
            @RequestParam(defaultValue = "0") Integer offset) {

        Map<String, Object> response = new HashMap<>();

        try {
            CaregiverAppointmentQueryDto queryDto = new CaregiverAppointmentQueryDto();
            queryDto.setMemberId(memberId);
            queryDto.setCaregiverId(caregiverId);
            queryDto.setStatus(status);
            queryDto.setIsBlocked(isBlocked);
            queryDto.setStartDate(startDate);
            queryDto.setEndDate(endDate);
            queryDto.setCreatedByType(createdByType);
            queryDto.setIsRated(isRated);
            queryDto.setLimit(limit);
            queryDto.setOffset(offset);

            Map<String, Object> result = appointmentService.getAppointments(queryDto);
            response.put("success", true);
            response.putAll(result);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    // 更新預約
    @PutMapping("/{id}")
    public ResponseEntity<Map<String, Object>> updateAppointment(
            @PathVariable Integer id,
            @RequestBody CaregiverAppointmentUpdateDto updateDto) {

        Map<String, Object> response = new HashMap<>();

        try {
            boolean updated = appointmentService.updateAppointment(id, updateDto);
            response.put("success", updated);
            response.put("message", updated ? "預約更新成功" : "預約更新失敗");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    // 取消預約
    @PostMapping("/{id}/cancel")
    public ResponseEntity<Map<String, Object>> cancelAppointment(@PathVariable Integer id) {
        Map<String, Object> response = new HashMap<>();

        try {
            boolean cancelled = appointmentService.cancelAppointment(id);
            response.put("success", cancelled);
            response.put("message", cancelled ? "預約取消成功" : "預約取消失敗");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    // 完成預約
    @PostMapping("/{id}/complete")
    public ResponseEntity<Map<String, Object>> completeAppointment(@PathVariable Integer id) {
        Map<String, Object> response = new HashMap<>();

        try {
            boolean completed = appointmentService.completeAppointment(id);
            response.put("success", completed);
            response.put("message", completed ? "預約完成" : "預約完成失敗");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    // 新增評分
    @PostMapping("/{id}/rating")
    public ResponseEntity<Map<String, Object>> addRating(
            @PathVariable Integer id,
            @RequestBody AppointmentRatingDto ratingDto) {

        Map<String, Object> response = new HashMap<>();

        try {
            boolean rated = appointmentService.addRating(id, ratingDto);
            response.put("success", rated);
            response.put("message", rated ? "評分成功" : "評分失敗");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    // 取得照服員行程
    @GetMapping("/caregiver/{caregiverId}/schedule")
    public ResponseEntity<Map<String, Object>> getCaregiverSchedule(
            @PathVariable Integer caregiverId,
            @RequestParam LocalDateTime startDate,
            @RequestParam LocalDateTime endDate) {

        Map<String, Object> response = new HashMap<>();

        try {
            List<CaregiverAppointment> schedule = appointmentService.getCaregiverSchedule(
                    caregiverId, startDate, endDate);
            response.put("success", true);
            response.put("schedule", schedule);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    // 取得會員預約記錄
    @GetMapping("/member/{memberId}")
    public ResponseEntity<Map<String, Object>> getMemberAppointments(
            @PathVariable Integer memberId,
            @RequestParam(required = false) String status) {

        Map<String, Object> response = new HashMap<>();

        try {
            List<CaregiverAppointment> appointments = appointmentService.getMemberAppointments(memberId, status);
            response.put("success", true);
            response.put("appointments", appointments);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    // 取得待評分預約
    @GetMapping("/member/{memberId}/pending-ratings")
    public ResponseEntity<Map<String, Object>> getPendingRatings(@PathVariable Integer memberId) {
        Map<String, Object> response = new HashMap<>();

        try {
            List<CaregiverAppointment> pendingRatings = appointmentService.getPendingRatings(memberId);
            response.put("success", true);
            response.put("pendingRatings", pendingRatings);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    // 檢查時間衝突
    @GetMapping("/check-conflict")
    public ResponseEntity<Map<String, Object>> checkTimeConflict(
            @RequestParam Integer caregiverId,
            @RequestParam LocalDateTime startTime,
            @RequestParam LocalDateTime endTime,
            @RequestParam(required = false) Integer excludeId) {

        Map<String, Object> response = new HashMap<>();

        try {
            boolean hasConflict = appointmentService.hasTimeConflict(caregiverId, startTime, endTime, excludeId);
            response.put("success", true);
            response.put("hasConflict", hasConflict);
            response.put("message", hasConflict ? "時間衝突" : "時間可用");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
}