package com.ryanshiun.seniorscare.bus.service.Impl;

import java.time.LocalDateTime;
import com.ryanshiun.seniorscare.bus.utils.GoogleMapsClient;

import java.util.List;

import org.springframework.http.HttpStatus;
import com.ryanshiun.seniorscare.bus.fare.FareCalculator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ResponseStatusException;

import com.ryanshiun.seniorscare.bus.dao.ReservationDAO;
import com.ryanshiun.seniorscare.bus.dto.ResCreateRequest;
import com.ryanshiun.seniorscare.bus.dto.ResQueryParams;
import com.ryanshiun.seniorscare.bus.dto.ResRequest;
import com.ryanshiun.seniorscare.bus.model.Reservation;
import com.ryanshiun.seniorscare.bus.service.ResService;
import com.ryanshiun.seniorscare.bus.utils.TimeUtils;

@Component
public class ResServiceImpl implements ResService {

	@Autowired
	private ReservationDAO reservationDAO;
	@Autowired
	private GoogleMapsClient googleMapsClient;

	// 新增預約表單
	@Override
	public Integer insertRes(ResCreateRequest resCreateRequest) {

		// 基本檢查：起訖地址必填
		if (resCreateRequest.getStartAddress() == null || resCreateRequest.getStartAddress().isBlank()
				|| resCreateRequest.getEndAddress() == null || resCreateRequest.getEndAddress().isBlank()) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "請提供有效的起點與終點地址");
		}

		// 計算距離（呼叫 Google Maps API）
		Integer distanceMeters = googleMapsClient.getDrivingDistanceMeters(resCreateRequest.getStartAddress(),
				resCreateRequest.getEndAddress());

		if (distanceMeters == null) {
			throw new IllegalStateException("無法計算距離，請檢查地址是否正確");
		}

		// 計算價格
		int taxiFare = FareCalculator.calcTaxiFareByTYMeters(distanceMeters);
		int price = FareCalculator.calcRehabusFareFormTaxi(taxiFare);

		LocalDateTime createdAt = TimeUtils.taipeiNowMinute();
		LocalDateTime scheduledAt = TimeUtils.truncateToMinute(resCreateRequest.getScheduledAt());
		String reservationStatus = "Active";

		return reservationDAO.insertRes(resCreateRequest, createdAt, scheduledAt, reservationStatus, distanceMeters,
				price);

	}

	// 刪除預約表單
	@Override
	public Integer deleteRes(int id) {
		return reservationDAO.deleteRes(id);
	}

	// 修改預約表單
	@Override
	public Reservation updateRes(ResRequest resRequest) {

		// 先取舊資料用來比對是否真的改地址
		Reservation old = reservationDAO.findById(resRequest.getId());
		if (old == null) {
			throw new ResponseStatusException(HttpStatus.NOT_FOUND, "找不到要更新的預約單");
		}

		boolean startChanged = resRequest.getStartAddress() != null && !resRequest.getStartAddress().isBlank()
				&& !resRequest.getStartAddress().equals(old.getStartAddress());

		boolean endChanged = resRequest.getEndAddress() != null && !resRequest.getEndAddress().isBlank()
				&& !resRequest.getEndAddress().equals(old.getEndAddress());

		boolean addressChanged = startChanged || endChanged;

		Integer distanceMetersForUpdate = null;
		Integer priceForUpdate = null;

		if (addressChanged) {
			// 用本次要更新的「最終起訖」來算距離（沒帶的新地址就沿用舊值）
			String origin = startChanged ? resRequest.getStartAddress() : old.getStartAddress();
			String destination = endChanged ? resRequest.getEndAddress() : old.getEndAddress();

			Integer dist = googleMapsClient.getDrivingDistanceMeters(origin, destination);
			if (dist == null) {
				throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "無法計算距離，請確認新地址是否正確");
			}
			distanceMetersForUpdate = dist;
			
			int taxiFare = FareCalculator.calcTaxiFareByTYMeters(dist);
			priceForUpdate = FareCalculator.calcRehabusFareFormTaxi(taxiFare);
			
		}

		return reservationDAO.updateRes(resRequest, distanceMetersForUpdate, priceForUpdate);
	}

	// 查詢所有預約表單
	@Override
	public List<Reservation> findAllRes() {
		return reservationDAO.findAllRes();
	}

	// 查詢預約表單(根據ID)
	@Override
	public Reservation findById(int id) {
		return reservationDAO.findById(id);
	}

	// 查詢預約表單(根據指定地點、預約時間、會員ID)
	@Override
	public List<Reservation> findByFilter(ResQueryParams resQueryParams) {

		Integer memberId = resQueryParams.getMemberId();
		String startAddress = resQueryParams.getStartAddress();
		String endAddress = resQueryParams.getEndAddress();

		// 這兩個是方法內的「區域變數」，不是 DTO 欄位
		LocalDateTime from = null;
		LocalDateTime to = null;

		if (resQueryParams.getScheduledAtTime() != null) {
			from = TimeUtils.truncateToMinute(resQueryParams.getScheduledAtTime());
			to = from.plusMinutes(1);
		} else if (resQueryParams.getScheduledAt() != null) {
			from = resQueryParams.getScheduledAt().atStartOfDay();
			to = resQueryParams.getScheduledAt().plusDays(1).atStartOfDay();
		}

		return reservationDAO.findByFilter(memberId, startAddress, endAddress, from, to);
	}

	// 已完乘，自動放入時間
	@Override
	public void markCompleted(int id) {

		LocalDateTime now = LocalDateTime.now();
		int rows = reservationDAO.markCompleted(id, now);

		if (rows == 0) {
			throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Reservation not found: id=" + id);
		}
	}

}
