package com.ryanshiun.seniorscare.member.dto.member;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.util.Date;

@Data
public class MemberProfileDto {
    @NotBlank @Size(min = 2, max = 50)
    private String memberName;
    @NotBlank
    private String mainPhone;
    @NotNull
    private Boolean gender;
    @NotNull
    private Date birthday;
    @Size(min=2, max=50)
    private String caregiverName;
    private String caregiverPhone;
}
