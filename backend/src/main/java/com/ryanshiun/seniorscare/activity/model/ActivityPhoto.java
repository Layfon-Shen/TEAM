package com.ryanshiun.seniorscare.activity.model;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class ActivityPhoto {
    private Integer id;
    private Integer activityId;
    private String  photoUrl;
    private LocalDateTime uploaded;
}
