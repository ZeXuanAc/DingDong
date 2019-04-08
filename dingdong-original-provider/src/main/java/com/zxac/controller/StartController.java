package com.zxac.controller;


import com.zxac.task.DataTask;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class StartController {

    @Autowired
    public DataTask dataTask;

    @GetMapping(value = "/")
    public Object hello () {
        dataTask.createData(3);
        return "原始数据提供者（dingdong-original-provider）启动完成";
    }


}
