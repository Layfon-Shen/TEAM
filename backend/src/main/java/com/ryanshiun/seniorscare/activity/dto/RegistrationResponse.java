package com.ryanshiun.seniorscare.activity.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class RegistrationResponse {
    private Long memberId;
    private Integer num;
    private LocalDateTime scheduledAt;
    private String status;
}
