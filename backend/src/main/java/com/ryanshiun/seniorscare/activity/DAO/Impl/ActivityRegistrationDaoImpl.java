package com.ryanshiun.seniorscare.activity.DAO.Impl;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Repository;
import com.ryanshiun.seniorscare.activity.DAO.ActivityRegistrationDao;
import com.ryanshiun.seniorscare.activity.model.ActivityRegistration;

@Repository
public class ActivityRegistrationDaoImpl implements ActivityRegistrationDao {
    @Autowired
    private NamedParameterJdbcTemplate jdbc;

    @Override
    public List<ActivityRegistration> findByActivityId(Integer activityId) {
        String sql = "SELECT * FROM activity_registration WHERE activity_id = :aid";
        return jdbc.query(sql,
            Map.of("aid", activityId),
            new BeanPropertyRowMapper<>(ActivityRegistration.class));
    }
}
