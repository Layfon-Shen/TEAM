package com.ryanshiun.seniorscare.activity.dto;

import com.fasterxml.jackson.annotation.JsonFormat;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class ActivityRequest {

	@NotNull
    private String name;
    private String category;
    
    @NotNull
    private Integer limit;
    private Integer current;

    @NotNull
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate date;

    @NotNull
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate end;

    private String time;

    @NotNull
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate registrationStart;

    @NotNull
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate registrationEnd;

    private String location;
    private BigDecimal latitude;
    private BigDecimal longitude;
    private String instructor;
    private Boolean status;
    private String description;
    private String image;
}
