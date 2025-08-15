package com.ryanshiun.seniorscare.roomType.service.Impl;

import java.time.LocalDate;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ryanshiun.seniorscare.roomType.dao.ReservationDao;
import com.ryanshiun.seniorscare.roomType.dto.ReservationDetail;
import com.ryanshiun.seniorscare.roomType.dto.ReservationStats;
import com.ryanshiun.seniorscare.roomType.dto.RoomTypeRanking;
import com.ryanshiun.seniorscare.roomType.model.Reservation;
import com.ryanshiun.seniorscare.roomType.service.ReservationService;

@Service
@Transactional
public class ReservationServiceImpl implements ReservationService {

    private final ReservationDao dao;

    public ReservationServiceImpl(ReservationDao dao) {
        this.dao = dao;
    }

    // ===== CRUD =====
    @Override
    public int addReservation(Reservation r) {
        return dao.addReservation(r);
    }

    @Override
    public boolean updateReservation(Reservation r) {
        return dao.updateReservation(r);
    }

    @Override
    public boolean deleteReservation(int reservationId) {
        return dao.deleteReservation(reservationId);
    }

    @Override
    public Reservation getReservationById(int reservationId) {
        return dao.getReservationById(reservationId);
    }

    @Override
    public List<Reservation> getAllReservations() {
        return dao.getAllReservations();
    }

    // ===== 查詢 =====
    @Override
    public List<Reservation> getByMember(Integer memberId) {
        return dao.getByMember(memberId);
    }

    @Override
    public List<Reservation> getByRoomType(Integer roomTypeId) {
        return dao.getByRoomType(roomTypeId);
    }

    @Override
    public List<Reservation> getByPreferredDate(LocalDate date) {
        return dao.getByPreferredDate(date);
    }

    @Override
    public List<Reservation> getByDateRange(LocalDate from, LocalDate to) {
        return dao.getByDateRange(from, to);
    }

    @Override
    public List<Reservation> getByStatus(int status) {
        return dao.getByStatus(status);
    }

    // ===== 統計 =====
    @Override
    public long countOnDate(LocalDate date) {
        return dao.countOnDate(date);
    }

    @Override
    public long countByRoomType(Integer roomTypeId) {
        return dao.countByRoomType(roomTypeId);
    }

    // ===== 趨勢 =====
    @Override
    public List<ReservationStats> getDailyTrend(int days) {
        return dao.getDailyTrend(days);
    }

    @Override
    public List<ReservationStats> getMonthlyTrend(int months) {
        return dao.getMonthlyTrend(months);
    }

    // ===== 房型排行 =====
    @Override
    public List<RoomTypeRanking> getRoomTypeRanking(int topN) {
        return dao.getRoomTypeRanking(topN);
    }
    
    @Override
    @Transactional(readOnly = true)
    public ReservationDetail getDetailById(int reservationId) {
        return dao.getDetailById(reservationId);
    }
}
