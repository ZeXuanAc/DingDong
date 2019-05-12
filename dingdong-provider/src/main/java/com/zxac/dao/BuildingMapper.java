package com.zxac.dao;


import com.zxac.dto.BuildingDto;
import com.zxac.model.Building;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface BuildingMapper {
    int deleteByPrimaryKey(Integer id);

    int insertSelective(Building record);

    Building selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Building record);

    // 通过 citycode 得到符合的建筑
    List<Building> getListByCitycode(@Param("citycode") String citycode);

    // 通过 admin_id 或 其他条件 得到符合的building
    List<Building> getListByAdminIdAndDto(BuildingDto dto);

    List<String> getCitycodeList();

    List<Building> selectListByCitycodeName(@Param("name") String name, @Param("citycode") String citycode);

}
