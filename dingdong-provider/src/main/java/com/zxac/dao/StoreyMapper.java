package com.zxac.dao;


import com.zxac.model.Storey;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface StoreyMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(Storey record);

    int insertSelective(Storey record);

    Storey selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Storey record);

    int updateByPrimaryKey(Storey record);

    // todo
    List<Storey> getListByBuildingId(@Param("buildingId") Integer buildingId);


}