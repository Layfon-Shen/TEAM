package com.ryanshiun.seniorscare.activity.DAO;

import java.util.List;
import com.ryanshiun.seniorscare.activity.model.ActivityRegistration;

public interface ActivityRegistrationDao {
    List<ActivityRegistration> findByActivityId(Integer activityId);
}
