package com.ryanshiun.seniorscare.bus.model;


import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * "預約表"，
 * 一個純資料物件（Plain Old Java Object，POJO），與 rehabus 資料表對應的一筆車輛資料
 * 用來封裝資料，可以是資料庫的一筆記錄，也可以是前端送來的請求參數
 */

@Data
@NoArgsConstructor
public class Reservation {

	@JsonProperty("ID")
	private Long id;                     //預約單號
	
	@JsonProperty("MEMBER_ID")
	private Long memberId;               //會員標號
	
	@JsonProperty("BUS_ID")
	private int busId;                   //巴士編號
	
	@JsonProperty("START_ZONE_ID")
	private int startZone;               //出發位置
	
	@JsonProperty("END_ZONE_ID")
	private int endZone;                 //到達位置
	
	@JsonProperty("CREATED_AT")
	private LocalDateTime createAt;      //訂單建立時間
	
	@JsonProperty("SCHEDULED_AT")
	private LocalDateTime scheduledAt;   //預約搭車時間 
	
	@JsonProperty("COMPLETED_AT")
	private LocalDateTime completedAt;   //訂單完乘時間
	
	@JsonProperty("PRICE")
	private int price;                   //車費
	
	@JsonProperty("RESERVATION_STATUS")
	private String reservationStatus;    //訂單狀態
	
	@JsonProperty("NOTE")
	private String note;                 //訂單備註
	
}
