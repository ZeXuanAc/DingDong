package com.zxac.task;

import com.alibaba.dubbo.config.annotation.Reference;
import com.zxac.service.StoreyUseCountService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.scheduling.config.ScheduledTaskRegistrar;
import org.springframework.scheduling.support.CronTrigger;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * 统计storey在某个时间段内的数量
 */

@Component
@Slf4j
@PropertySource(value = "classpath:config/constant.properties")
public class StoreyUseCountTask extends DynamicScheduledTask{

    @Value("${storey_use_count_interval_cron}")
    private String cron;

    @Reference(application = "${dubbo.application.id}", url = "dubbo://localhost:12345")
    private StoreyUseCountService storeyUseCountService;

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
        log.info("开始-->执行storey使用数量统计任务: {} ", LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));

        try {
            storeyUseCountService.doTask();
            log.info("结束-->执行storey使用数量统计任务: {} ", LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
        } catch (Exception e) {
            log.error("执行storey使用数量统计任务 失败！", e);
        }


    }
}
