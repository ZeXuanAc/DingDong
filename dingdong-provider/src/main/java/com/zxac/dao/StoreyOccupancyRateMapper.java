package com.zxac.dao;

import com.zxac.dto.StoreyOccupancyRateDto;
import com.zxac.model.StoreyOccupancyRate;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface StoreyOccupancyRateMapper {

    int insertSelective(StoreyOccupancyRate record);

    StoreyOccupancyRate selectByPrimaryKey(Integer id);

    int insertBatch(List<StoreyOccupancyRate> storeyOccupancyRateList);

    // 得到>=createTime 和BuildingId的数据
    List<StoreyOccupancyRateDto> selectByBuildingIdCreateTime(@Param("buildingId") Integer buildingId,
                                                              @Param("createTime") String createTime,
                                                              @Param("endTime") String endTime);

}
