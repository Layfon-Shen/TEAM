package com.ryanshiun.seniorscare.activity.service.Impl;

import com.ryanshiun.seniorscare.activity.DAO.ActivityDao;
import com.ryanshiun.seniorscare.activity.dto.ActivityRequest;
import com.ryanshiun.seniorscare.activity.model.Activity;
import com.ryanshiun.seniorscare.activity.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ActivityServiceImpl implements ActivityService {

    @Autowired
    private ActivityDao activityDao;

    @Override
    public Activity getActivityById(Integer id) {
        return activityDao.getActivityById(id);
    }

    @Override
    public List<Activity> getAllActivities() {
        return activityDao.getAllActivities();
    }

    @Override
    public void addActivity(ActivityRequest activityrequest) {
        Activity activity = new Activity();
        activity.setName(activityrequest.getName());
        activity.setCategory(activityrequest.getCategory());
        activity.setLimit(activityrequest.getLimit());
        activity.setCurrent(activityrequest.getCurrent());
        activity.setDate(activityrequest.getDate());
        activity.setEnd(activityrequest.getEnd());
        activity.setTime(activityrequest.getTime());
        activity.setRegistrationStart(activityrequest.getRegistrationStart());
        activity.setRegistrationEnd(activityrequest.getRegistrationEnd());
        activity.setLocation(activityrequest.getLocation());
        activity.setLatitude(activityrequest.getLatitude());
        activity.setLongitude(activityrequest.getLongitude());
        activity.setInstructor(activityrequest.getInstructor());
        activity.setStatus(activityrequest.getStatus());
        activity.setDescription(activityrequest.getDescription());
        activity.setImage(activityrequest.getImage());

        activityDao.addActivity(activity);
    }

    @Override
    public void updateActivity(Integer id, Activity activity) {
        activityDao.updateActivity(id, activity);
    }


    @Override
    public void deleteActivityById(Integer id) {
        activityDao.deleteActivityById(id);
    }
}
