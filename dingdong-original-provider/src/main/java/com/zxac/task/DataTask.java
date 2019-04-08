package com.zxac.task;

import com.zxac.config.UrlConfig;
import com.zxac.model.EquipmentStatusDto;
import com.zxac.utils.ObjectUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDateTime;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.stream.IntStream;

@Component
@Slf4j
public class DataTask {

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
//                        log.info("设备【{}】号当前状态为{}, 时间为{}", i + 1, statusArr[i], randomArr[i]);
                    }

                    // 生成数据
                    EquipmentStatusDto dto = EquipmentStatusDto.builder().cityId(1).buildingId(1).storeyId(1).status(String.valueOf(statusArr[i]))
                            .eqId(i + 1).eqName("设备【" + (i + 1) + "】号").createTime(LocalDateTime.now().toString()).build();
                    log.info(dto.toString());
                    // 发起http请求更新数据
                    RestTemplate restTemplate = new RestTemplate();
                    ResponseEntity<String> entity = restTemplate.getForEntity(urlConfig.redisSetUrl, String.class, ObjectUtil.toMap(dto, "eqName"));
                    if (entity.getStatusCodeValue() != HttpStatus.OK.value()) {
                        log.error("访问 redis set 接口失败");
                    }
                }, 0, 1, TimeUnit.SECONDS)
        );
    }


}