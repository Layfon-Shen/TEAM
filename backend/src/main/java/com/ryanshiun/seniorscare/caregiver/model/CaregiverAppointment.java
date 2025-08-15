package com.ryanshiun.seniorscare.caregiver.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CaregiverAppointment {
    private Integer id;
    private Integer memberId;
    private Integer caregiverId;
    private LocalDateTime scheduledAt;
    private LocalDateTime endTime;
    private String status;
    private Boolean isBlocked; //虛擬訂單
    private Integer serviceTypeId;
    private String serviceLocation;
    private BigDecimal totalAmount;
    private String notes;
    private String blockType;

    // 建立者資訊
    private String createdByType;
    private Integer createdByMemberId;
    private Integer createdByEmployeeId;

    // 評分資訊
    private Integer ratingScore;
    private String ratingComment;
    private LocalDateTime ratedAt;
    private Boolean isRated;
    private LocalDateTime createdAt;
    private LocalDateTime cancelledAt;
}


