package com.zxac.task;

import com.alibaba.dubbo.config.annotation.Reference;
import com.zxac.config.UrlConfig;
import com.zxac.constant.Common;
import com.zxac.dto.EquipmentStatusDto;
import com.zxac.model.EquipmentStatus;
import com.zxac.model.Result;
import com.zxac.service.EquipmentService;
import com.zxac.utils.JsonUtil;
import com.zxac.utils.ObjectUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

@Component
@Slf4j
@PropertySource(value = "classpath:config/constant.properties")
public class PracticeDataTask extends DynamicScheduledTask{

    @Autowired
    public UrlConfig urlConfig;

    @Value("${eq_num}")
    public Integer eqNumConfig;
    @Value("${free_base}")
    public Integer free_base;
    @Value("${free_addition}")
    public Integer free_addition;
    @Value("${use_base}")
    public Integer use_base;
    @Value("${use_addition}")
    public Integer use_addition;

    private int[] randomArr = new int[300]; // 记录每一个equipment当前还剩的时间
    private int[] statusArr = new int[300]; // 记录每一个equipment当前的状态

    @Reference(application = "${dubbo.application.id}", url = "dubbo://localhost:12345")
    private EquipmentService equipmentService;

    @Override
    public void doTask() {
        List<EquipmentStatusDto> equipmentStatusDtoList = equipmentService.getAllEquipmentDto("");
        final List<EquipmentStatusDto> eqList = equipmentStatusDtoList.stream().filter(equipment -> equipment.getCondition().equals("1")).collect(Collectors.toList());
        List<EquipmentStatus> equipmentStatusList;
        int eqNum = eqList.size();
        if (eqNum > 0) {
            equipmentStatusList = new ArrayList<>();
            IntStream.range(0, eqNum).forEach(i -> {
                // 每秒减1
                randomArr[i]--;
                EquipmentStatusDto dto = eqList.get(i);
                // 当random剩余的时间小于0时重新生成状态， 上一个状态为1（占用）的时间结束后自动转为0（空闲），上一个状态为0（空闲）的则随机生成状态
                // 每次随机生成状态和时间的时候保存时间到数据库
                if (randomArr[i] <= 0) {
                    EquipmentStatus equipmentStatus = getEquipmentStatus(dto);
                    randomArr[i] = (int) (Math.random() * free_base) + free_addition;
                    if (statusArr[i] == 1) {
                        statusArr[i] = 0;
                    } else {
                        statusArr[i] = (int) (Math.random() * 2);
                        if (statusArr[i] == 1) {
                            randomArr[i] = (int) (Math.random() * use_base) + use_addition;
                        }
                    }
                    equipmentStatus.setStatus(String.valueOf(statusArr[i]));
                    equipmentStatus.setStartTime(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
                    equipmentStatus.setEndTime(LocalDateTime.now().plusSeconds(randomArr[i]).format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
                    equipmentStatusList.add(equipmentStatus);
                }

                // 生成数据
                dto.setStatus(String.valueOf(statusArr[i]));
                dto.setCreateTimeStr(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
//                log.info(dto.toString());
                // 发起http请求更新数据
                RestTemplate restTemplate = new RestTemplate();
                Map<String, Object> param = ObjectUtil.toMap(dto, Object.class);
                ResponseEntity<String> entity = null;
                try {
                    entity = restTemplate.getForEntity(urlConfig.redisSetUrl, String.class, param);
                } catch (RestClientException e) {
                    log.error("访问 redis set 接口失败: ", e.getCause().getMessage());
                }
                if (entity != null && !Common.SUCCESS_CODE.equals(JsonUtil.toBean(entity.getBody(), Result.class).getCode())) {
                    log.error("访问 redis set 接口失败: {}", JsonUtil.toBean(entity.getBody(), Result.class).getMsg());
                }
            });

            // 将数据持久化
            if (!equipmentStatusList.isEmpty()) {
                equipmentService.insertStatusDto(equipmentStatusList);
            }
        }
    }


    private EquipmentStatus getEquipmentStatus(EquipmentStatusDto dto) {
        if (dto == null) {
            return null;
        }
        EquipmentStatus equipmentStatus = new EquipmentStatus();
        equipmentStatus.setBuildingId(dto.getBuildingId());
        equipmentStatus.setEqId(dto.getEqId());
        equipmentStatus.setEqName(dto.getEqName());
        equipmentStatus.setStoreyId(dto.getStoreyId());
        equipmentStatus.setCitycode(dto.getCitycode());
        return equipmentStatus;
    }


}
