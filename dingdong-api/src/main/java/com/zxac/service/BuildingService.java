package com.zxac.service;

import com.zxac.dto.BuildingDto;
import com.zxac.model.Result;

import java.util.List;

public interface BuildingService {

    /**
     * 得到该城市下的building
     * @param citycode
     * @param location 经纬度, 纬度在前, 经度在后, 用逗号相隔, 如 30.1123,23232
     * @return
     */
    List<BuildingDto> getBuildingList(String citycode, String location);

    /**
     * 得到adminId下的building信息，当admin的role为admin的时候获取全部信息
     * @param adminId
     * @return
     */
    Result getBuildingList(int pageNum, int pageSize, Integer adminId);

    /**
     * 新增数据
     * @param dto
     * @return
     */
    Result insert(BuildingDto dto);

    /**
     * 删除city
     * @param buildingId
     * @return
     */
    Result delete(Integer buildingId);

    /**
     * 更新数据
     * @param dto
     * @return
     */
    Result update(BuildingDto dto);

}
