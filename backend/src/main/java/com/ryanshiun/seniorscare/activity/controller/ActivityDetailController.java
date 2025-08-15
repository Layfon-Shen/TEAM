package com.ryanshiun.seniorscare.activity.controller;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.ryanshiun.seniorscare.activity.dto.RegistrationResponse;
import com.ryanshiun.seniorscare.activity.dto.PhotoRequest;
import com.ryanshiun.seniorscare.activity.dto.OrganizerRequest;
import com.ryanshiun.seniorscare.activity.model.ActivityRegistration;
import com.ryanshiun.seniorscare.activity.model.ActivityOrganizer;
import com.ryanshiun.seniorscare.activity.model.ActivityPhoto;
import com.ryanshiun.seniorscare.activity.service.ActivityDetailService;

@RestController
@RequestMapping("/activities/{activityId}")
@CrossOrigin
public class ActivityDetailController {

    @Autowired private ActivityDetailService svc;

    // 1. 查詢預約人清單
    @GetMapping("/registrations")
    public List<RegistrationResponse> getRegistrations(@PathVariable Integer activityId) {
        return svc.getRegistrations(activityId)
                  .stream()
                  .map(r -> {
                      var dto = new RegistrationResponse();
                      dto.setMemberId(r.getMemberId());
                      dto.setNum(r.getNum());
                      dto.setScheduledAt(r.getScheduledAt());
                      dto.setStatus(r.getStatus());
                      return dto;
                  })
                  .toList();
    }

    // 2. 新增活動照片
    @PostMapping("/photos")
    public ResponseEntity<Map<String,Integer>> addPhoto(
            @PathVariable Integer activityId,
            @RequestBody PhotoRequest req) {
        int id = svc.addPhoto(activityId, req.getPhotoUrl());
        return ResponseEntity.status(201).body(Map.of("id", id));
    }

    // 3. 查詢主辦方更新
    @GetMapping("/organizer-updates")
    public List<ActivityOrganizer> getOrganizerUpdates(@PathVariable Integer activityId) {
        return svc.getOrganizerUpdates(activityId);
    }

    // 4. 新增主辦方留言／更新
    @PostMapping("/organizer-updates")
    public ResponseEntity<Map<String,Integer>> addOrganizerUpdate(
            @PathVariable Integer activityId,
            @RequestBody OrganizerRequest req) {
        int id = svc.addOrganizerUpdate(activityId, req.getTitle(), req.getContent());
        return ResponseEntity.status(201).body(Map.of("id", id));
    }
    // 取得照片清單
    @GetMapping("/photos")
    public List<ActivityPhoto> getPhotos(@PathVariable Integer activityId) {
        return svc.getPhotos(activityId);
    }
}
