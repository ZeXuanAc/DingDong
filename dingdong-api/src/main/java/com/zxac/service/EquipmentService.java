package com.zxac.service;

import com.zxac.dto.EquipmentStatusDto;
import com.zxac.model.Equipment;

import java.util.List;

public interface EquipmentService {


    /**
     * 得到所有equipment, 直接查询equipment表
     * @return
     */
    List<Equipment> getAllEquipment();


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


    /**
     * 得到该城市下的所有equipment, 当citycode为""时查询所有
     * @param citycode
     * @return
     */
    List<EquipmentStatusDto> getAllEquipmentDto(String citycode);

}
