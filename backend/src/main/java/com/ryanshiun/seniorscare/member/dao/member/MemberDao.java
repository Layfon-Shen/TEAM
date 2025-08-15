package com.ryanshiun.seniorscare.member.dao.member;

import com.ryanshiun.seniorscare.member.dto.member.MemberProfileDto;
import com.ryanshiun.seniorscare.member.model.member.Member;

import java.time.LocalDateTime;
import java.util.List;

public interface MemberDao {
    // 註冊前檢查手機是否存在
    Boolean existsByMainPhone(String phone);

    // 讀取會員資料 By mainPhone
    Member findByMainPhone(String phone);

    // 讀取會員資料 By memberId
    Member findById(Integer id, boolean forUpdate);

    // 註冊會員資料
    Integer register(Member member);

    // 登入成功更新 login
    Integer updateLogin(Integer memberId, String loginTime);

    // 編輯個人資料
    Integer updateProfile(Integer memberId, MemberProfileDto dto);

    // 開通第二支手機
    Integer bindCaregiverPhone(Integer memberId, String caregiverPhone);

    // 移除代理人電話
    Integer unbindCaregiverPhone(Integer memberId);

    // 停權會員
    Integer banMember(Integer memberId, String reason, LocalDateTime banAt);
}
