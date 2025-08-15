package com.ryanshiun.seniorscare.activity.service;

import com.ryanshiun.seniorscare.activity.dto.ActivityRequest;
import com.ryanshiun.seniorscare.activity.model.Activity;

import java.util.List;

public interface ActivityService {

    Activity getActivityById(Integer id);

    List<Activity> getAllActivities();

    void addActivity(ActivityRequest activityrequest);

    void updateActivity(Integer id, Activity activity);

    void deleteActivityById(Integer id);
}
