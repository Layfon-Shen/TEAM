package com.ryanshiun.seniorscare.activity.model;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class ActivityOrganizer {
    private Integer id;
    private Integer activityId;
    private String  title;
    private String  content;
    private LocalDateTime publishedAt;
}
