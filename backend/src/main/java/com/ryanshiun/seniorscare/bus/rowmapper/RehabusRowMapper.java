package com.ryanshiun.seniorscare.bus.rowmapper;

import java.sql.ResultSet;



import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.ryanshiun.seniorscare.bus.model.Rehabus;


/**
 * 用來把「資料庫查詢結果的每一列」轉成 Java 的 Rehabus 物件
 */


public class RehabusRowMapper implements RowMapper<Rehabus> {

	@Override
	public Rehabus mapRow(ResultSet rSet, int rowNum) throws SQLException{
		Rehabus rehabus = new Rehabus();
		rehabus.setBusId(rSet.getInt("bus_id"));
		rehabus.setCarDealership(rSet.getString("car_dealership"));
		rehabus.setBusBrand(rSet.getString("bus_brand"));
		rehabus.setBusModel(rSet.getString("bus_model"));
		rehabus.setSeatCapacity(rSet.getInt("seat_capacity"));
		rehabus.setWheelchairCapacity(rSet.getInt("wheelchair_capacity"));
		rehabus.setLicensePlate(rSet.getString("license_plate"));
		rehabus.setStatus(rSet.getString("status"));
		return rehabus;
		
	}
}
