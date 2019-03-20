package com.zxac.controller;


import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class StartController {


    @GetMapping(value = "/")
    public Object hello () {
        return "原始数据提供者（original-provider）启动完成";
    }


}
