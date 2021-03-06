package com.zxac.dao;

import com.zxac.dto.EquipmentDto;
import com.zxac.model.Equipment;
import com.zxac.dto.EquipmentStatusDto;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface EquipmentMapper {
    int deleteByPrimaryKey(Integer id);

    int insertSelective(Equipment record);

    Equipment selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Equipment record);

    List<Equipment> getAll();

    // 通过 storeyId 得到当前层的设备
    List<Equipment> getListByStoreyId(@Param("storeyId") Integer storeyId);

    // 通过 buildingId 得到当前层的设备
    List<Equipment> getListByBuildingId(@Param("buildingId") Integer buildingId);

    // 通过citycode得到该设备的所有信息
    List<EquipmentStatusDto> getEqDtoList(@Param("citycode") String citycode);

    // 通过adminId和dto信息得到equipment
    List<EquipmentDto> getEquipmentListByAdminIdDto(EquipmentDto dto);
}
