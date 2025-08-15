package com.ryanshiun.seniorscare.roomType.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class RoomType {
    private int id;
    private String name;
    private int price;
    private int capacity;
    private String description;
    @JsonProperty("image_path")
    private String imagePath;
    @JsonProperty("is_available")
    private boolean isAvailable;
    private String adminNote;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}