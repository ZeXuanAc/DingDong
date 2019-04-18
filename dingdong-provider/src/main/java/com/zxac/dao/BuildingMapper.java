package com.zxac.dao;


import com.zxac.model.Building;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface BuildingMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(Building record);

    int insertSelective(Building record);

    Building selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Building record);

    int updateByPrimaryKey(Building record);

    // 通过 citycode 得到符合的建筑
    List<Building> getListByCitycode(@Param("citycode") String citycode);

}