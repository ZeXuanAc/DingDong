package com.zxac.dao;

import com.zxac.model.StoreyUseCount;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface StoreyUseCountMapper {

    String getLatestStartTime();

    int insertBatch(List<StoreyUseCount> storeyUseCountList);

    List<StoreyUseCount> getStoreyUseCountFromEquipmentStatus(@Param("startTime") String startTime,
                                           @Param("endTime") String endTime);

    List<StoreyUseCount> selectByNowTime(@Param("buildingId") Integer buildingId,
                                         @Param("startTime") String startTime,
                                         @Param("endTime") String endTime);

    int deleteStartTimeData(@Param("startTime") String startTime);

}
