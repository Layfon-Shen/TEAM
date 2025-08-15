package com.ryanshiun.seniorscare.member.model.member;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.Date;

@Data
public class Member {
    @JsonProperty("member_id")
    private int memberId;

    @JsonProperty("member_name")
    private String memberName;

    @JsonProperty("main_phone")
    private String mainPhone;

    private Boolean gender;
    private Date birthday;

    @JsonProperty("is_active")
    private Boolean active;

    @JsonProperty("ban_at")
    private Date banAt;

    @JsonProperty("ban_reason")
    private String banReason;

    @JsonProperty("caregiver_name")
    private String caregiverName;

    @JsonProperty("caregiver_phone")
    private String caregiverPhone;

    @JsonProperty("created_at")
    private LocalDateTime createdAt;

    @JsonProperty("login_at")
    private LocalDateTime loginAt;
}
