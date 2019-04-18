package com.zxac.task;

import com.alibaba.dubbo.config.annotation.Reference;
import com.zxac.config.UrlConfig;
import com.zxac.constant.Common;
import com.zxac.model.EquipmentStatusDto;
import com.zxac.model.Result;
import com.zxac.service.CityEquipmentService;
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

    @Value("${eqNum}")
    public Integer eqNumConfig;

    private int[] randomArr = new int[200];
    private int[] statusArr = new int[200];

    @Reference(application = "${dubbo.application.id}", url = "dubbo://localhost:12345")
    private CityEquipmentService cityEquipmentService;

    @Override
    public void doTask() {
        List<EquipmentStatusDto> equipmentStatusDtoList = cityEquipmentService.getAllEquipment("");
        final List<EquipmentStatusDto> eqList = equipmentStatusDtoList.stream().filter(equipment -> equipment.getCondition().equals("1")).collect(Collectors.toList());
        int eqNum = eqList.size();
        if (eqNum > 0) {
            IntStream.range(0, eqNum).forEach(i -> {
                randomArr[i]--;
                if (randomArr[i] <= 0) {
                    randomArr[i] = (int) (Math.random() * 10) + 20;
                    if (statusArr[i] == 1) {
                        statusArr[i] = 0;
                    } else {
                        statusArr[i] = (int) (Math.random() * 2);
                        if (statusArr[i] == 1) {
                            randomArr[i] = (int) (Math.random() * 20) + 50;
                        }
                    }
                }

                // 生成数据
                EquipmentStatusDto dto = eqList.get(i);
                dto.setStatus(String.valueOf(statusArr[i]));
                dto.setCreateTimeStr(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
                log.info(dto.toString());
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
        }
        System.out.println();
    }



}