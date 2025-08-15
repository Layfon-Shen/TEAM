package com.ryanshiun.seniorscare.activity.controller;

import com.ryanshiun.seniorscare.activity.dto.ActivityRequest;
import com.ryanshiun.seniorscare.activity.model.Activity;
import com.ryanshiun.seniorscare.activity.service.ActivityService;

import jakarta.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/activities")
@CrossOrigin
public class ActivityController {

    @Autowired
    private ActivityService activityService;

    // 查詢所有活動
    @GetMapping
    public List<Activity> getAllActivities() {
        return activityService.getAllActivities();
    }

    // 查詢單筆活動
    @GetMapping("/{id}")
    public ResponseEntity<Activity> getActivityById(@PathVariable Integer id) {
        Activity activity = activityService.getActivityById(id);
        if (activity != null) {
            return ResponseEntity.ok(activity);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    // 新增活動
    @PostMapping
    public ResponseEntity<Void> addActivity(@RequestBody ActivityRequest activityrequest) {
        activityService.addActivity(activityrequest);
        return ResponseEntity.status(HttpStatus.CREATED).build();
    }


 // 更新活動
    @PutMapping("/{id}")
    public ResponseEntity<String> updateActivity(@PathVariable Integer id,
                                                 @Valid @RequestBody ActivityRequest activityrequest) {
        Activity existing = activityService.getActivityById(id);
        if (existing != null) {
            Activity updated = new Activity();
            updated.setId(id); // 保留原 ID

            updated.setName(activityrequest.getName());
            updated.setCategory(activityrequest.getCategory());
            updated.setLimit(activityrequest.getLimit());
            updated.setCurrent(activityrequest.getCurrent());
            updated.setDate(activityrequest.getDate());
            updated.setEnd(activityrequest.getEnd());
            updated.setTime(activityrequest.getTime());
            updated.setRegistrationStart(activityrequest.getRegistrationStart());
            updated.setRegistrationEnd(activityrequest.getRegistrationEnd());
            updated.setLocation(activityrequest.getLocation());
            updated.setLatitude(activityrequest.getLatitude());
            updated.setLongitude(activityrequest.getLongitude());
            updated.setInstructor(activityrequest.getInstructor());
            updated.setStatus(activityrequest.getStatus());
            updated.setDescription(activityrequest.getDescription());
            updated.setImage(activityrequest.getImage());

            activityService.updateActivity(id, updated);
            return ResponseEntity.ok("更新成功");
        } else {
            return ResponseEntity.notFound().build();
        }
    }



    // 刪除活動
    @DeleteMapping("/{id}")
    public ResponseEntity<String> deleteActivity(@PathVariable Integer id) {
        Activity existing = activityService.getActivityById(id);
        if (existing != null) {
            activityService.deleteActivityById(id);
            return ResponseEntity.ok("刪除成功");
        } else {
            return ResponseEntity.notFound().build();
        }
    }
}
