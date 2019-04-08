package com.zxac.controller;


import com.zxac.task.PracticeDataTask;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class StartController {

    @Autowired
    public PracticeDataTask practiceDataTask;

    @GetMapping(value = "/")
    public Object hello () {
        practiceDataTask.createData(5);
        return "原始数据提供者（dingdong-original-provider）启动完成";
    }


}
