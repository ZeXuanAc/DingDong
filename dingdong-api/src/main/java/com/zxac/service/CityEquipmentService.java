package com.zxac.service;

import com.zxac.model.Building;
import com.zxac.model.City;
import com.zxac.model.Equipment;
import com.zxac.model.Storey;

import java.util.List;

public interface CityEquipmentService {

    /**
     * 得到所有城市列表
     * @return
     */
    List<City> getAllCity();


    /**
     * 得到该城市下的building
     * @param cityId
     * @param location 经纬度, 纬度在前, 经度在后, 用逗号相隔, 如 30.1123,23232
     * @return
     */
    List<Building> getBuildingList(Integer cityId, String location);


    /**
     * 得到该building下的storey
     * @param buildingId
     * @return
     */
    List<Storey> getStoreyList(Integer buildingId);


    /**
     * 得到该楼层下的所有设备
     * @param storeyId
     * @return
     */
    List<Equipment> getEquipmentListByStoreyId(Integer storeyId);


    /**
     * 得到该building下的所有设备
     * @param buildingId
     * @return
     */
    List<Equipment> getEquipmentListByBuildingId(Integer buildingId);
}
