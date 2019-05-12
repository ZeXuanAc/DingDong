package com.zxac.dao;


import com.zxac.dto.StoreyDto;
import com.zxac.model.Storey;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface StoreyMapper {
    int deleteByPrimaryKey(Integer id);

    int insertSelective(Storey record);

    Storey selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Storey record);

    List<Storey> getListByBuildingId(@Param("buildingId") Integer buildingId);

    // 通过 admin_id 或 其他条件 得到符合的building
    List<StoreyDto> getListByDto(StoreyDto dto);

    // 通过 name、floor、gender查询
    List<Storey> selectByNameFloorGender(@Param("storeyName") String storeyName,
                                         @Param("floor") String floor,
                                         @Param("buildingName") String buildingName,
                                         @Param("citycode") String citycode,
                                         @Param("storeyGender") String storeyGender);

}
