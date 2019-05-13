package com.zxac.service;


import com.alibaba.dubbo.config.annotation.Service;
import com.zxac.dao.StoreyOccupancyRateMapper;
import com.zxac.dto.StoreyOccupancyRateDto;
import com.zxac.exception.BusinessException;
import com.zxac.exception.FailureCode;
import com.zxac.model.Result;
import com.zxac.model.StoreyOccupancyRate;
import com.zxac.utils.DistanceUtil;
import com.zxac.utils.ObjectUtil;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Service(interfaceClass = StoreyOccupancyRateService.class)
@Component
@Slf4j
public class StoreyOccupancyRateServiceImpl implements StoreyOccupancyRateService {

    @Autowired
    private StoreyOccupancyRateMapper storeyOccupancyRateMapper;

    @Override
    @Transactional
    public Result doInsertOccupancyRate(List<Map<String, String>> redisValueList) {
        List<StoreyOccupancyRate> rateList = new ArrayList<>();
        if (redisValueList == null || redisValueList.isEmpty()) {
            return Result.failure(FailureCode.CODE940);
        }
        // 按照storeyId分组得到的map
        Map<String, List<Map<String, String>>> allStoreyRedisValueMap = redisValueList.stream().collect(Collectors.groupingBy(map -> map.get("storeyId")));
        for (Map.Entry<String, List<Map<String, String>>> entry: allStoreyRedisValueMap.entrySet()) {
            StoreyOccupancyRate rate = new StoreyOccupancyRate();
            // 当前storeyId下的数据
            List<Map<String, String>> storeyIdMapList = allStoreyRedisValueMap.get(entry.getKey());
            // 得到condition = 1即状况正常的数据
            List<Map<String, String>> storeyIdConditionList = storeyIdMapList.stream().filter(map1 -> map1.get("condition").equals("1")).collect(Collectors.toList());
            // 当前storeyId下状况正常的数据根据status分组
            Map<String, List<Map<String, String>>> eqStatusListMap = storeyIdConditionList.stream().collect(Collectors.groupingBy(storeyIdMap -> storeyIdMap.get("status")));
            try {
                rate.setBuildingId(Integer.valueOf(entry.getValue().get(0).get("buildingId")));
                rate.setStoreyId(Integer.valueOf(entry.getValue().get(0).get("storeyId")));
                rate.setTotalEqNum(storeyIdMapList.size());
                rate.setAbnormalEqNum(storeyIdMapList.size() - storeyIdConditionList.size());
                if (eqStatusListMap.get("1") == null || eqStatusListMap.get("1").isEmpty()) {
                    rate.setUseEqNum(0);
                } else {
                    rate.setUseEqNum(eqStatusListMap.get("1").size());
                }
                if (eqStatusListMap.get("0") == null || eqStatusListMap.get("0").isEmpty()) {
                    rate.setFreeEqNum(0);
                } else {
                    rate.setFreeEqNum(eqStatusListMap.get("0").size());
                }
            } catch (Exception e) {
                continue;
            }
            rateList.add(rate);
        }
        try {
            boolean isSuccess = storeyOccupancyRateMapper.insertBatch(rateList) > 0;
            if (isSuccess) {
                return Result.success("占有率数据处理成功");
            }
            return Result.failure(FailureCode.CODE941);
        } catch (Exception e) {
            log.warn("storey占有率统计--批量插入异常: ", e);
            throw new BusinessException(FailureCode.CODE650);
        }
    }


    @Override
    public Result getStoreyOccupancyRate(Integer buildingId, String latestTime) {
        if(buildingId == null || StringUtils.isBlank(latestTime)) {
            return Result.failure(FailureCode.CODE942);
        }
        List<StoreyOccupancyRateDto> rateList = storeyOccupancyRateMapper.selectByBuildingIdCreateTime(buildingId, latestTime);
        String resultLatestTime = "";
        Map<String, List<StoreyOccupancyRateDto>> rateListMap = new HashMap<>();
        if (rateList != null && !rateList.isEmpty()) {
            rateList.forEach(dto -> dto.setOccupancyRate(DistanceUtil.calcPercent(dto.getUseEqNum(), dto.getTotalEqNum())));
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            resultLatestTime = sdf.format(rateList.get(rateList.size() - 1).getCreateTime());
            rateListMap = rateList.stream().collect(Collectors.groupingBy(StoreyOccupancyRateDto::getStoreyName));
        }
        List<Map<String, Object>> seriesDataList = new ArrayList<>();
        List<String> dateList = new ArrayList<>();
        if (!rateListMap.isEmpty()) {
            for (Map.Entry<String, List<StoreyOccupancyRateDto>> entry: rateListMap.entrySet()) {
                List<StoreyOccupancyRateDto> rateDtoList = entry.getValue();
                Map<String, Object> seriesDataMap = new HashMap<>();
                seriesDataMap.put("name", entry.getKey());
                List<String> rateStrList = rateDtoList.stream().map(StoreyOccupancyRateDto::getOccupancyRate).collect(Collectors.toList());
                seriesDataMap.put("data", rateStrList);
                if (dateList.isEmpty()) {
                    dateList = rateDtoList.stream().map(map -> new SimpleDateFormat("HH:mm:ss").format(map.getCreateTime()) ).collect(Collectors.toList());
                    dateList.sort(String::compareTo);
                }
                seriesDataList.add(seriesDataMap);
            }
        }
        Map<String, Object> map = new HashMap<>();
        map.put("list", seriesDataList);
        map.put("xAxisData", dateList);
        map.put("latestTime", resultLatestTime);
        return Result.success(map);
    }
}
