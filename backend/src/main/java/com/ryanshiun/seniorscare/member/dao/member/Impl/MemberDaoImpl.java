package com.ryanshiun.seniorscare.member.dao.member.Impl;

import com.ryanshiun.seniorscare.member.dao.member.MemberDao;
import com.ryanshiun.seniorscare.member.dto.member.MemberProfileDto;
import com.ryanshiun.seniorscare.member.model.member.Member;
import com.ryanshiun.seniorscare.member.rowmapper.member.MemberRowMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

@Component
public class MemberDaoImpl implements MemberDao {

    @Autowired
    private NamedParameterJdbcTemplate namedParameterJdbcTemplate;

    // 檢查手機是否存在
    @Override
    public Boolean existsByMainPhone(String phone) {
        final String sql = "SELECT COUNT(*) FROM member WHERE main_phone = :mainPhone";
        Map<String,Object> map = new HashMap<>();
        map.put("mainPhone",phone);
        return namedParameterJdbcTemplate.queryForObject(sql,map,Integer.class)>0;
    }

    // 搜尋會員 By mainPhone
    @Override
    public Member findByMainPhone(String phone) {
        final String sql = "SELECT * FROM member WHERE main_phone = :mainPhone";
        Map<String,Object> map = new HashMap<>();
        map.put("mainPhone", phone);
        return namedParameterJdbcTemplate.queryForObject(sql, map, new MemberRowMapper());
    }

    // 搜尋會員 By memberId
    @Override
    public Member findById(Integer id, boolean forUpdate) {
        final String sql = "select * from member where member_id = :memberId";
        Map<String,Object> map = new HashMap<>();
        map.put("memberId", id);
        return namedParameterJdbcTemplate.queryForObject(sql, map, new MemberRowMapper());
    }

    // 註冊會員
    @Override
    public Integer register(Member member) {
        final String sql = "INSERT INTO member (member_name, main_phone, gender, birthday, caregiver_name, caregiver_phone)" +
                "VALUES (:memberName, :mainPhone, :gender, :birthday, :caregiverName, :caregiverPhone)";
        Map<String, Object> map = new HashMap<>();
        map.put("memberName", member.getMemberName());
        map.put("mainPhone", member.getMainPhone());
        map.put("gender", member.getGender());
        map.put("birthday", member.getBirthday());
        map.put("caregiverName", member.getCaregiverName());
        map.put("caregiverPhone", member.getCaregiverPhone());

        KeyHolder keyHolder = new GeneratedKeyHolder();
        namedParameterJdbcTemplate.update(sql, new MapSqlParameterSource(map), keyHolder);
        return Objects.requireNonNull(keyHolder.getKey()).intValue();
    }

    // 更新登入時間
    @Override
    public Integer updateLogin(Integer memberId, String loginTime) {
        final String sql = "UPDATE member SET login_at = :loginAt WHERE member_id = :memberId";
        Map<String, Object> map = new HashMap<>();
        map.put("memberId", memberId);
        LocalDateTime now = LocalDateTime.now();
        map.put("loginAt", now);
        return namedParameterJdbcTemplate.update(sql, map);
    }

    // 編輯個人資料
    @Override
    public Integer updateProfile(Integer memberId, MemberProfileDto dto) {
        final String sql = "UPDATE member SET member_name = :memberName, main_phone = :mainPhone," +
                " gender = :gender, birthday = :birthday, caregiver_name = :caregiverName, caregiver_phone = :caregiverPhone" +
                " WHERE member_id = :memberId";
        Map<String, Object> map = new HashMap<>();
        map.put("memberName", dto.getMemberName());
        map.put("mainPhone", dto.getMainPhone());
        map.put("gender", dto.getGender());
        map.put("birthday", dto.getBirthday());
        map.put("caregiverName", dto.getCaregiverName());
        map.put("caregiverPhone", dto.getCaregiverPhone());
        return namedParameterJdbcTemplate.update(sql, map);
    }

    // 開通代理人手機
    @Override
    public Integer bindCaregiverPhone(Integer memberId, String caregiverPhone) {
        final String sql = "UPDATE member SET caregiver_phone = :caregiverPhone WHERE member_id = :memberId";
        Map<String, Object> map = new HashMap<>();
        map.put("memberId", memberId);
        map.put("caregiverPhone", caregiverPhone);
        return namedParameterJdbcTemplate.update(sql, map);
    }

    // 解除綁定代理人手機
    @Override
    public Integer unbindCaregiverPhone(Integer memberId) {
        // 刪除代理人手機號碼
        final String sql = "UPDATE member SET caregiver_phone = NULL WHERE member_id = :memberId";
        Map<String, Object> map = new HashMap<>();
        map.put("memberId", memberId);
        return namedParameterJdbcTemplate.update(sql, map);
    }

    // 停權會員 (永久停權)
    @Override
    public Integer banMember(Integer memberId, String reason, LocalDateTime banAt) {
        final String sql = "UPDATE member SET is_active = 0, ban_reason = :reason, ban_at = :banAt " +
                " WHERE member_id = :memberId";
        Map<String, Object> map = new HashMap<>();
        map.put("memberId", memberId);
        map.put("reason", reason);
        map.put("banAt", banAt);
        return namedParameterJdbcTemplate.update(sql, map);
    }
}
