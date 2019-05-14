package com.zxac.service;


import com.alibaba.dubbo.config.annotation.Service;
import com.zxac.dao.EquipmentStatusMapper;
import com.zxac.dao.StoreyOccupancyRateMapper;
import com.zxac.dao.StoreyUseCountMapper;
import com.zxac.dto.StoreyOccupancyRateDto;
import com.zxac.exception.BusinessException;
import com.zxac.exception.FailureCode;
import com.zxac.model.EquipmentStatus;
import com.zxac.model.Result;
import com.zxac.model.StoreyOccupancyRate;
import com.zxac.model.StoreyUseCount;
import com.zxac.utils.DistanceUtil;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service(interfaceClass = StoreyUseCountService.class)
@Component
@Slf4j
public class StoreyUseCountServiceImpl implements StoreyUseCountService {

    @Autowired
    private StoreyUseCountMapper storeyUseCountMapper;
    @Autowired
    private EquipmentStatusMapper equipmentStatusMapper;

    @Override
    public Result getStoreyUseCountList(Integer buildingId, String endTime) {
        if(buildingId == null || StringUtils.isBlank(endTime)) {
            return Result.failure(FailureCode.CODE953);
        }
        DateTimeFormatter df = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        LocalDateTime localDateTime = LocalDateTime.parse(endTime, df);
        String startTime = LocalDateTime.of(localDateTime.getYear(), localDateTime.getMonthValue(), localDateTime.getDayOfMonth(), 0, 0, 0).format(df);
        List<StoreyUseCount> allUseCountList = storeyUseCountMapper.selectByNowTime(buildingId, startTime, endTime);
        List<Map<String, Object>> seriesDataList = new ArrayList<>();
        List<String> storeyNameList = new ArrayList<>();
        List<String> xAxisDataList = new ArrayList<>();
        if (!allUseCountList.isEmpty()) {
            Map<String, List<StoreyUseCount>> useCountListMap = allUseCountList.stream().collect(Collectors.groupingBy(StoreyUseCount::getStoreyName));
            for (Map.Entry<String, List<StoreyUseCount>> entry: useCountListMap.entrySet()) {
                List<StoreyUseCount> partUseCountList = entry.getValue();
                Map<String, Object> seriesDataMap = new HashMap<>();
                seriesDataMap.put("name", entry.getKey());
                seriesDataMap.put("data", partUseCountList.stream().map(StoreyUseCount::getUseCount).collect(Collectors.toList()));
                seriesDataMap.put("stack", "storey");
                storeyNameList.add(entry.getKey());
                if (xAxisDataList.isEmpty()) {
                    xAxisDataList = partUseCountList.stream().map(StoreyUseCount::getStartTime).collect(Collectors.toList());
                }
                seriesDataList.add(seriesDataMap);
            }
            Map<String, Object> buildingMap = new HashMap<>();
            buildingMap.put("name", "ALL");
            List<Integer> buildingData = new ArrayList<>();
            Map<String, List<StoreyUseCount>> startTimeListMap = allUseCountList.stream().collect(Collectors.groupingBy(StoreyUseCount::getStartTime));
            startTimeListMap.forEach((key, value) -> {

            });
            storeyNameList.add("ALL");
        }
        return null;
    }

    @Override
    @Transactional
    public void doTask() {
        DateTimeFormatter df = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String latestStartTime = getLatestStartTime();
        if (latestStartTime == null) {
            log.error("获取最新的时间失败");
            throw new BusinessException(FailureCode.CODE951);
        }
        log.info("latestStartTime : {}", latestStartTime);
        LocalDateTime tempLocalDateTime = LocalDateTime.parse(latestStartTime, df);
        LocalDateTime localDateTime = LocalDateTime.of(tempLocalDateTime.getYear(),
                tempLocalDateTime.getMonthValue(), tempLocalDateTime.getDayOfMonth(), tempLocalDateTime.getHour(), 0, 0);
        int taskSize = 0;
        while (true) {
            List<StoreyUseCount> storeyUseCountList = getEquipmentStatusList(localDateTime);
            if (storeyUseCountList == null || storeyUseCountList.isEmpty()) {
                break;
            }
            insertBatch(storeyUseCountList, localDateTime.format(df));
            log.info("get storeyUseCountList {} 条", storeyUseCountList.size());
            localDateTime = localDateTime.plusHours(1);
            taskSize += storeyUseCountList.size();
        }
        log.info("此次任务共插入数据 {} 条。", taskSize);
    }


    private String getLatestStartTime() {
        String latestStartTime = storeyUseCountMapper.getLatestStartTime();
        // 如果storey_use_count数据库为空，则获取equipment_status最早的时间
        if (latestStartTime == null) {
            latestStartTime = equipmentStatusMapper.getOldestStartTime();
        }
        return latestStartTime;
    }

    // 得到nowTime后一个小时内的数据，如nowTime为2019-05-14 19:00:00，则返回2019-05-14 19:00:00 ~ 2019-05-14 20:00:00的数据
    private List<StoreyUseCount> getEquipmentStatusList(LocalDateTime nowTime) {
        DateTimeFormatter df = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        LocalDateTime endLocalDateTime = nowTime.plusHours(1);
        String startTime = nowTime.format(df);
        String endTime = endLocalDateTime.format(df);
        List<StoreyUseCount> userCountList = null;
        try {
            userCountList = storeyUseCountMapper.getStoreyUseCountFromEquipmentStatus(startTime, endTime);
        } catch (Exception e) {
            log.error("storeyUseCount getEquipmentStatusList 异常：", e);
        }
        return userCountList;
    }

    @Transactional
    public void insertBatch(List<StoreyUseCount> useCountList, String startTime) {
        if (useCountList == null || useCountList.isEmpty()) {
            return;
        }
        useCountList.forEach(storeyUseCount -> storeyUseCount.setStartTime(startTime));
        try {
            storeyUseCountMapper.insertBatch(useCountList);
        } catch (Exception e) {
            log.error("storeyUseCountMapper insertBatch error: ", e);
            throw new BusinessException(FailureCode.CODE950);
        }
    }


}
