package com.zxac.task;

import com.zxac.config.UrlConfig;
import com.zxac.constant.Common;
import com.zxac.model.EquipmentStatusDto;
import com.zxac.model.Result;
import com.zxac.utils.JsonUtil;
import com.zxac.utils.ObjectUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.stream.IntStream;

@Component
@Slf4j
public class PracticeDataTask {

    @Autowired
    public UrlConfig urlConfig;

    public void createData(Integer eqNum) {
        int[] randomArr = new int[eqNum];
        int[] statusArr = new int[eqNum];
        ScheduledExecutorService executorService = Executors.newScheduledThreadPool(eqNum); // 模拟多个设备同时在发消息
        IntStream.range(0, eqNum).forEach(
                i -> executorService.scheduleAtFixedRate(() -> {
                    randomArr[i]--;
                    if (randomArr[i] <= 0) {
                        randomArr[i] = (int)(Math.random() * 5) + 1;
                        if (statusArr[i] == 1) {
                            statusArr[i] = 0;
                        } else {
                            statusArr[i] = (int) (Math.random() * 2);
                            if (statusArr[i] == 1) {
                                randomArr[i] = (int)(Math.random() * 7) + 3;
                            }
                        }
                    }

                    // 生成数据
                    EquipmentStatusDto dto = EquipmentStatusDto.builder().cityId(1).buildingId(1).storeyId(1).status(String.valueOf(statusArr[i]))
                            .eqId(i + 1).eqName("设备【" + (i + 1) + "】号").createTime(LocalDateTime.now().toString()).build();
                    log.info(dto.toString());
                    // 发起http请求更新数据
                    RestTemplate restTemplate = new RestTemplate();
                    Map<String, Object> param = ObjectUtil.toMap(dto, "eqName");
                    ResponseEntity<String> entity = null;
                    try {
                        entity = restTemplate.getForEntity(urlConfig.redisSetUrl, String.class, param);
                    } catch (RestClientException e) {
                        log.error("访问 redis set 接口失败: ", e.getMessage());
                    }
                    if (!Common.SUCCESS_CODE.equals(JsonUtil.toBean(entity.getBody(), Result.class).getCode())) {
                        log.error("访问 redis set 接口失败: {}", JsonUtil.toBean(entity.getBody(), Result.class).getMsg());
                    }
                }, 0, 1, TimeUnit.SECONDS)
        );
    }


}