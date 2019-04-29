package com.zxac.service;

import com.zxac.dto.BuildingDto;
import com.zxac.dto.EquipmentStatusDto;
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
     * 检查是否存在此citycode
     * @return
     */
    Integer checkCityCode(String citycode);

    /**
     * 得到该城市下的building
     * @param citycode
     * @param location 经纬度, 纬度在前, 经度在后, 用逗号相隔, 如 30.1123,23232
     * @return
     */
    List<BuildingDto> getBuildingList(String citycode, String location);


    /**
     * 得到该building下的storey
     * @param buildingId
     * @return
     */
    List<Storey> getStoreyList(Integer buildingId);


    /**
     * 得到所有equipment, 直接查询equipment表
     * @return
     */
    List<Equipment> getAllEquipment();


    /**
     * 得到该城市下的所有equipment, 当citycode为""时查询所有
     * @param citycode
     * @return
     */
    List<EquipmentStatusDto> getAllEquipment(String citycode);

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
