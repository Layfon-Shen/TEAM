package com.ryanshiun.seniorscare.caregiver.service.caregiverAppointment;

import com.ryanshiun.seniorscare.caregiver.dao.caregiverAppointment.CaregiverAppointmentDao;
import com.ryanshiun.seniorscare.caregiver.dto.caregiverAppointment.AppointmentRatingDto;
import com.ryanshiun.seniorscare.caregiver.dto.caregiverAppointment.CaregiverAppointmentCreateDto;
import com.ryanshiun.seniorscare.caregiver.dto.caregiverAppointment.CaregiverAppointmentQueryDto;
import com.ryanshiun.seniorscare.caregiver.dto.caregiverAppointment.CaregiverAppointmentUpdateDto;
import com.ryanshiun.seniorscare.caregiver.model.CaregiverAppointment;
import com.ryanshiun.seniorscare.caregiver.service.caregiverAppointment.CaregiverAppointmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class CaregiverAppointmentServiceImpl implements CaregiverAppointmentService {

    @Autowired
    private CaregiverAppointmentDao appointmentDao;

    @Override
    @Transactional
    public Integer createAppointment(CaregiverAppointmentCreateDto createDto) {
        // 驗證預約資料
        validateAppointment(createDto);

        // 檢查時間衝突
        if (hasTimeConflict(createDto.getCaregiverId(), createDto.getScheduledAt(),
                createDto.getEndTime(), null)) {
            throw new RuntimeException("預約時間衝突，該照服員在此時間已有其他預約");
        }

        return appointmentDao.createAppointment(createDto);
    }

    @Override
    public CaregiverAppointment getAppointmentById(Integer id) {
        if (id == null || id <= 0) {
            throw new IllegalArgumentException("預約ID不能為空或小於等於0");
        }

        CaregiverAppointment appointment = appointmentDao.getAppointmentById(id);
        if (appointment == null) {
            throw new RuntimeException("找不到指定的預約記錄：" + id);
        }

        return appointment;
    }

    @Override
    public Map<String, Object> getAppointments(CaregiverAppointmentQueryDto queryDto) {
        if (queryDto == null) {
            queryDto = new CaregiverAppointmentQueryDto();
        }

        List<CaregiverAppointment> appointments = appointmentDao.getAppointments(queryDto);
        Integer totalCount = appointmentDao.getAppointmentCount(queryDto);

        Map<String, Object> result = new HashMap<>();
        result.put("appointments", appointments);
        result.put("totalCount", totalCount);
        result.put("currentPage", (queryDto.getOffset() / queryDto.getLimit()) + 1);
        result.put("totalPages", (int) Math.ceil((double) totalCount / queryDto.getLimit()));

        return result;
    }

    @Override
    @Transactional
    public boolean updateAppointment(Integer id, CaregiverAppointmentUpdateDto updateDto) {
        if (id == null || id <= 0) {
            throw new IllegalArgumentException("預約ID不能為空或小於等於0");
        }

        if (updateDto == null) {
            throw new IllegalArgumentException("更新資料不能為空");
        }

        // 檢查預約是否存在
        CaregiverAppointment existingAppointment = getAppointmentById(id);

        // 如果更新時間，需要檢查衝突
        if (updateDto.getScheduledAt() != null || updateDto.getEndTime() != null) {
            LocalDateTime startTime = updateDto.getScheduledAt() != null ?
                    updateDto.getScheduledAt() : existingAppointment.getScheduledAt();
            LocalDateTime endTime = updateDto.getEndTime() != null ?
                    updateDto.getEndTime() : existingAppointment.getEndTime();

            if (hasTimeConflict(existingAppointment.getCaregiverId(), startTime, endTime, id)) {
                throw new RuntimeException("更新失敗：預約時間衝突");
            }
        }

        Integer result = appointmentDao.updateAppointment(id, updateDto);
        return result > 0;
    }

    @Override
    @Transactional
    public boolean cancelAppointment(Integer id) {
        if (id == null || id <= 0) {
            throw new IllegalArgumentException("預約ID不能為空或小於等於0");
        }

        CaregiverAppointment appointment = getAppointmentById(id);

        if ("cancelled".equals(appointment.getStatus())) {
            throw new RuntimeException("預約已經被取消");
        }

        if ("completed".equals(appointment.getStatus())) {
            throw new RuntimeException("已完成的預約無法取消");
        }

        Integer result = appointmentDao.cancelAppointment(id);
        return result > 0;
    }

    @Override
    @Transactional
    public boolean addRating(Integer id, AppointmentRatingDto ratingDto) {
        if (id == null || id <= 0) {
            throw new IllegalArgumentException("預約ID不能為空或小於等於0");
        }

        if (ratingDto == null || ratingDto.getRatingScore() == null) {
            throw new IllegalArgumentException("評分資料不完整");
        }

        if (ratingDto.getRatingScore() < 1 || ratingDto.getRatingScore() > 5) {
            throw new IllegalArgumentException("評分必須在1-5分之間");
        }

        CaregiverAppointment appointment = getAppointmentById(id);

        if (!"completed".equals(appointment.getStatus())) {
            throw new RuntimeException("只能對已完成的預約進行評分");
        }

        if (Boolean.TRUE.equals(appointment.getIsRated())) {
            throw new RuntimeException("此預約已經評分過了");
        }

        Integer result = appointmentDao.addRating(id, ratingDto);
        return result > 0;
    }

    @Override
    public boolean hasTimeConflict(Integer caregiverId, LocalDateTime startTime, LocalDateTime endTime, Integer excludeId) {
        if (caregiverId == null || startTime == null || endTime == null) {
            return false;
        }

        if (startTime.isAfter(endTime) || startTime.isEqual(endTime)) {
            throw new IllegalArgumentException("開始時間必須早於結束時間");
        }

        List<CaregiverAppointment> conflicts = appointmentDao.checkTimeConflict(
                caregiverId, startTime, endTime, excludeId);

        return !conflicts.isEmpty();
    }

    @Override
    public List<CaregiverAppointment> getCaregiverSchedule(Integer caregiverId, LocalDateTime startDate, LocalDateTime endDate) {
        if (caregiverId == null || caregiverId <= 0) {
            throw new IllegalArgumentException("照服員ID不能為空或小於等於0");
        }

        if (startDate == null || endDate == null) {
            throw new IllegalArgumentException("查詢時間範圍不能為空");
        }

        if (startDate.isAfter(endDate)) {
            throw new IllegalArgumentException("開始時間不能晚於結束時間");
        }

        return appointmentDao.getCaregiverAppointments(caregiverId, startDate, endDate);
    }

    @Override
    public List<CaregiverAppointment> getMemberAppointments(Integer memberId, String status) {
        if (memberId == null || memberId <= 0) {
            throw new IllegalArgumentException("會員ID不能為空或小於等於0");
        }

        return appointmentDao.getMemberAppointments(memberId, status);
    }

    @Override
    public List<CaregiverAppointment> getPendingRatings(Integer memberId) {
        if (memberId == null || memberId <= 0) {
            throw new IllegalArgumentException("會員ID不能為空或小於等於0");
        }

        return appointmentDao.getUnratedCompletedAppointments(memberId);
    }

    @Override
    @Transactional
    public boolean completeAppointment(Integer id) {
        if (id == null || id <= 0) {
            throw new IllegalArgumentException("預約ID不能為空或小於等於0");
        }

        CaregiverAppointment appointment = getAppointmentById(id);

        if ("completed".equals(appointment.getStatus())) {
            throw new RuntimeException("預約已經完成");
        }

        if ("cancelled".equals(appointment.getStatus())) {
            throw new RuntimeException("已取消的預約無法標記為完成");
        }

        Integer result = appointmentDao.updateAppointmentStatus(id, "completed");
        return result > 0;
    }

    @Override
    public void validateAppointment(CaregiverAppointmentCreateDto createDto) {
        if (createDto == null) {
            throw new IllegalArgumentException("預約資料不能為空");
        }

        if (createDto.getCaregiverId() == null || createDto.getCaregiverId() <= 0) {
            throw new IllegalArgumentException("照服員ID不能為空或無效");
        }

        if (createDto.getScheduledAt() == null) {
            throw new IllegalArgumentException("預約開始時間不能為空");
        }

        if (createDto.getEndTime() == null) {
            throw new IllegalArgumentException("預約結束時間不能為空");
        }

        if (createDto.getScheduledAt().isAfter(createDto.getEndTime()) ||
                createDto.getScheduledAt().isEqual(createDto.getEndTime())) {
            throw new IllegalArgumentException("開始時間必須早於結束時間");
        }

        if (createDto.getScheduledAt().isBefore(LocalDateTime.now())) {
            throw new IllegalArgumentException("預約時間不能早於現在時間");
        }

        // 檢查虛擬預約邏輯
        if (Boolean.TRUE.equals(createDto.getIsBlocked()) && createDto.getBlockType() == null) {
            throw new IllegalArgumentException("虛擬預約必須指定類型");
        }

        if (Boolean.FALSE.equals(createDto.getIsBlocked()) && createDto.getMemberId() == null) {
            throw new IllegalArgumentException("真實預約必須指定會員ID");
        }
    }
}