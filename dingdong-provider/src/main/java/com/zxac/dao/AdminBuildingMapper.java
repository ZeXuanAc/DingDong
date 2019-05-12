package com.zxac.dao;

import com.zxac.model.AdminBuilding;
import org.apache.ibatis.annotations.Param;

public interface AdminBuildingMapper {
    int deleteByPrimaryKey(Integer id);

    int insertSelective(AdminBuilding record);

    AdminBuilding selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(AdminBuilding record);

    int deleteByBuildingId(@Param("buildingId") Integer buildingId);
}
