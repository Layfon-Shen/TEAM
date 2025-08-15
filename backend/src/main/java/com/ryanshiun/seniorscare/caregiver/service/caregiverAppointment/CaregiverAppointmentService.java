package com.ryanshiun.seniorscare.caregiver.service.caregiverAppointment;

import com.ryanshiun.seniorscare.caregiver.dto.caregiverAppointment.AppointmentRatingDto;
import com.ryanshiun.seniorscare.caregiver.dto.caregiverAppointment.CaregiverAppointmentCreateDto;
import com.ryanshiun.seniorscare.caregiver.dto.caregiverAppointment.CaregiverAppointmentQueryDto;
import com.ryanshiun.seniorscare.caregiver.dto.caregiverAppointment.CaregiverAppointmentUpdateDto;
import com.ryanshiun.seniorscare.caregiver.model.CaregiverAppointment;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;


public interface CaregiverAppointmentService {
    
    // 建立預約
    Integer createAppointment(CaregiverAppointmentCreateDto createDto);
    
    // 取得預約詳情
    CaregiverAppointment getAppointmentById(Integer id);
    
    // 查詢預約列表 (支援分頁)
    Map<String, Object> getAppointments(CaregiverAppointmentQueryDto queryDto);
    
    // 更新預約
    boolean updateAppointment(Integer id, CaregiverAppointmentUpdateDto updateDto);
    
    // 取消預約
    boolean cancelAppointment(Integer id);
    
    // 新增評分
    boolean addRating(Integer id, AppointmentRatingDto ratingDto);
    
    // 檢查時間衝突
    boolean hasTimeConflict(Integer caregiverId, LocalDateTime startTime, LocalDateTime endTime, Integer excludeId);
    
    // 取得照服員行程
    List<CaregiverAppointment> getCaregiverSchedule(Integer caregiverId, LocalDateTime startDate, LocalDateTime endDate);
    
    // 取得會員預約記錄
    List<CaregiverAppointment> getMemberAppointments(Integer memberId, String status);
    
    // 取得待評分預約
    List<CaregiverAppointment> getPendingRatings(Integer memberId);
    
    // 完成預約
    boolean completeAppointment(Integer id);
    
    // 驗證預約資料
    void validateAppointment(CaregiverAppointmentCreateDto createDto);
}
