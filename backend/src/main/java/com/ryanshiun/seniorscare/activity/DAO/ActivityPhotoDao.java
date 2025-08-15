package com.ryanshiun.seniorscare.activity.DAO;

import java.util.List;

import com.ryanshiun.seniorscare.activity.model.ActivityPhoto;

public interface ActivityPhotoDao {
    Integer insert(ActivityPhoto photo);
    List<ActivityPhoto> findByActivityId(Integer activityId);  // ← 新增
}

