package com.zxac.service;

import com.zxac.model.Result;

import java.util.List;
import java.util.Map;

public interface StoreyOccupancyRateService {


    /**
     * 处理占有率数据
     * @return
     */
    Result doInsertOccupancyRate(List<Map<String, String>> redisValueList);


    /**
     * 得到该building下的storey的占有率
     * @param buildingId
     * @param latestTime
     * @return
     */
    Result getStoreyOccupancyRate(Integer buildingId, String latestTime);
}
