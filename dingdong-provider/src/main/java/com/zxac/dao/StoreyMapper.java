package com.zxac.dao;


import com.zxac.dto.StoreyDto;
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

    List<Storey> getListByBuildingId(@Param("buildingId") Integer buildingId);

    // 通过 admin_id 或 其他条件 得到符合的building
    List<StoreyDto> getListByDto(StoreyDto dto);

}
