package com.ryanshiun.seniorscare.activity.service.Impl;

import java.time.LocalDateTime;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ryanshiun.seniorscare.activity.DAO.ActivityRegistrationDao;
import com.ryanshiun.seniorscare.activity.DAO.ActivityPhotoDao;
import com.ryanshiun.seniorscare.activity.DAO.ActivityOrganizerDao;
import com.ryanshiun.seniorscare.activity.model.ActivityRegistration;
import com.ryanshiun.seniorscare.activity.model.ActivityPhoto;
import com.ryanshiun.seniorscare.activity.model.ActivityOrganizer;
import com.ryanshiun.seniorscare.activity.service.ActivityDetailService;

@Service
public class ActivityDetailServiceImpl implements ActivityDetailService {
    @Autowired private ActivityRegistrationDao regDao;
    @Autowired private ActivityPhotoDao photoDao;
    @Autowired private ActivityOrganizerDao orgDao;

    @Override
    public List<ActivityRegistration> getRegistrations(Integer activityId) {
        return regDao.findByActivityId(activityId);
    }

    @Override
    public Integer addPhoto(Integer activityId, String photoUrl) {
        ActivityPhoto p = new ActivityPhoto();
        p.setActivityId(activityId);
        p.setPhotoUrl(photoUrl);
        p.setUploaded(LocalDateTime.now());
        return photoDao.insert(p);
    }
    
    @Override
    public List<ActivityPhoto> getPhotos(Integer activityId) {
        return photoDao.findByActivityId(activityId);
    }

    @Override
    public Integer addOrganizerUpdate(Integer activityId, String title, String content) {
        ActivityOrganizer o = new ActivityOrganizer();
        o.setActivityId(activityId);
        o.setTitle(title);
        o.setContent(content);
        o.setPublishedAt(LocalDateTime.now());
        return orgDao.insert(o);
    }

    @Override
    public List<ActivityOrganizer> getOrganizerUpdates(Integer activityId) {
        return orgDao.findByActivityId(activityId);
    }
}
