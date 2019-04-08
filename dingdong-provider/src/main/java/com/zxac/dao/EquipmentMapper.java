package com.zxac.dao;

import com.zxac.model.Equipment;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface EquipmentMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(Equipment record);

    int insertSelective(Equipment record);

    Equipment selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Equipment record);

    int updateByPrimaryKey(Equipment record);

    // 通过 storeyId 得到当前层的设备
    List<Equipment> getListByStoreyId(@Param("storeyId") Integer storeyId);

    // 通过 buildingId 得到当前层的设备
    List<Equipment> getListByBuildingId(@Param("buildingId") Integer buildingId);
}