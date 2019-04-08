package com.zxac.controller;


import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class AppController {


    @GetMapping(value = "/")
    public Object hello () {
        return "app接口服务端(dingdong-consumer)启动完成";
    }


}
