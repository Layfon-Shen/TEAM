package com.ryanshiun.seniorscare.activity.model;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class ActivityRegistration {
    private Integer id;
    private Integer activityId;
    private Long    memberId;
    private Integer num;
    private LocalDateTime scheduledAt;
    private String  status;
}
