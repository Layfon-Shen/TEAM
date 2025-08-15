package com.ryanshiun.seniorscare.member.rowmapper.member;

import com.ryanshiun.seniorscare.member.model.member.Member;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;

public class MemberRowMapper implements RowMapper<Member> {
    @Override
    public Member mapRow(ResultSet rs, int rowNum) throws SQLException {
        Member member = new Member();

        member.setMemberId(rs.getInt("member_id"));
        member.setMemberName(rs.getString("member_name"));
        member.setMainPhone(rs.getString("main_phone"));
        member.setGender(rs.getBoolean("gender"));
        member.setBirthday(rs.getDate("birthday"));
        member.setActive(rs.getBoolean("active"));
        member.setBanAt(rs.getDate("ban_at"));
        member.setBanReason(rs.getString("ban_reason"));
        member.setCaregiverName(rs.getString("caregiver_name"));
        member.setCaregiverPhone(rs.getString("caregiver_phone"));
        member.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        member.setLoginAt(rs.getTimestamp("login_at").toLocalDateTime());
        return member;
    }
}
