package com.zxac.task;

import com.alibaba.dubbo.config.annotation.Reference;
import com.zxac.constant.Common;
import com.zxac.model.Result;
import com.zxac.service.StoreyOccupancyRateService;
import com.zxac.utils.RedisUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.scheduling.config.ScheduledTaskRegistrar;
import org.springframework.scheduling.support.CronTrigger;
import org.springframework.stereotype.Component;
import redis.clients.jedis.Response;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 计算实时占有率
 */

@Component
@Slf4j
@PropertySource(value = "classpath:config/constant.properties")
public class OccupancyRateTask extends DynamicScheduledTask{

    @Value("${occupancy_rate_time_interval_cron}")
    private String cron;

    @Reference(application = "${dubbo.application.id}", url = "dubbo://localhost:12345")
    private StoreyOccupancyRateService storeyOccupancyRateService;

    @Override
    public void configureTasks(ScheduledTaskRegistrar scheduledTaskRegistrar) {
        scheduledTaskRegistrar.addTriggerTask(this::doTask, triggerContext -> {
            // 定时任务触发，可修改定时任务的执行周期
            CronTrigger trigger = new CronTrigger(this.cron);
            return trigger.nextExecutionTime(triggerContext);
        });
    }

    @Override
    public void doTask() {
        log.info("执行占有率定时任务: {} ", LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
        // 获取所有redis-key(*B*_S*)
        String redisPattern = "*" + Common.REDIS_KEY_BUILDING + "*" + Common.UNDERLINE + Common.REDIS_KEY_STOREY + "*";
        Map<String, Response<Map<String, String>>> redisKeyMap = RedisUtil.getKeys(redisPattern);
        List<Map<String, String>> redisValueList = new ArrayList<>();
        redisKeyMap.forEach((key, value) -> redisValueList.add(value.get()));

        // 交给StoreyOccupancyRateService处理数据
        try {
            Result result = storeyOccupancyRateService.doInsertOccupancyRate(redisValueList);
            if (result.isSuccess()) {
                log.info(result.getMsg());
            } else {
                log.warn("占有率数据处理错误, code: {}, msg: {}", result.getCode(), result.getMsg());
            }
        } catch (Exception e) {
            log.warn("占有率数据处理错误: ", e);
        }

    }
}
