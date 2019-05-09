package com.zxac.service;

import com.zxac.dto.BuildingDto;

import java.util.List;

public interface BuildingService {

    /**
     * 得到该城市下的building
     * @param citycode
     * @param location 经纬度, 纬度在前, 经度在后, 用逗号相隔, 如 30.1123,23232
     * @return
     */
    List<BuildingDto> getBuildingList(String citycode, String location);



}
