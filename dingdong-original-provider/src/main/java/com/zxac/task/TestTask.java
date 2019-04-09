package com.zxac.task;


import lombok.extern.slf4j.Slf4j;

import java.time.LocalDateTime;

@Slf4j
//@Component
//@Service
public class TestTask extends DynamicScheduledTask {
    @Override
    public void doTask() {
        log.info(LocalDateTime.now().toString());
    }
}
