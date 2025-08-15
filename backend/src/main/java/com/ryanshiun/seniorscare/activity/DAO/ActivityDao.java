package com.ryanshiun.seniorscare.activity.DAO;

import com.ryanshiun.seniorscare.activity.dto.ActivityQueryParams;
import com.ryanshiun.seniorscare.activity.model.Activity;

import java.util.List;

public interface ActivityDao {

    Activity getActivityById(Integer id);

    List<Activity> getAllActivities();

    void addActivity(Activity activity);

    void updateActivity(Integer id, Activity activity);

    void deleteActivityById(Integer id);
    
    List<Activity> getActivities(ActivityQueryParams activityqueryParams);

}