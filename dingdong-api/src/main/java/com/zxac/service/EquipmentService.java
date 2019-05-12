package com.zxac.service;

import com.zxac.dto.EquipmentDto;
import com.zxac.dto.EquipmentInitDto;
import com.zxac.dto.EquipmentStatusDto;
import com.zxac.model.Equipment;
import com.zxac.model.Result;

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


    /**
     * 得到adminId下的equipment信息，当admin的role为admin的时候获取全部信息
     * @param dto
     * @return
     */
    Result getEquipmentListByAdminIdDto(int pageNum, int pageSize, EquipmentDto dto);


    /**
     * 新增数据
     * @param dto
     * @return
     */
    Result insert(EquipmentDto dto);

    /**
     * 删除equipment
     * @param eqId
     * @return
     */
    Result delete(Integer eqId);

    /**
     * 更新数据
     * @param dto
     * @return
     */
    Result update(EquipmentDto dto);


    /**
     * 初始化设备
     * @param dto
     * @return
     */
    Result init(EquipmentInitDto dto);
}
