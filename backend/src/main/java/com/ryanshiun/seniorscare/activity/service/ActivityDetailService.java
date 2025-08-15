package com.ryanshiun.seniorscare.activity.service;

import java.util.List;
import com.ryanshiun.seniorscare.activity.model.ActivityRegistration;
import com.ryanshiun.seniorscare.activity.model.ActivityPhoto;
import com.ryanshiun.seniorscare.activity.model.ActivityOrganizer;

public interface ActivityDetailService {
	
    List<ActivityRegistration> getRegistrations(Integer activityId);
    
    Integer addPhoto(Integer activityId, String photoUrl);
    
    List<ActivityPhoto> getPhotos(Integer activityId);
    
    Integer addOrganizerUpdate(Integer activityId, String title, String content);
    
    List<ActivityOrganizer> getOrganizerUpdates(Integer activityId);
    
}
