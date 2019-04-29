package com.zxac.controller;

import com.alibaba.dubbo.config.annotation.Reference;
import com.zxac.model.Result;
import com.zxac.service.UserService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Slf4j
public class UserController {

    @Reference(application = "${dubbo.application.id}", url = "dubbo://localhost:12345")
    private UserService userService;

    @GetMapping(value = "login")
    public Result getAllCity(String phone, String password){
        return userService.login(phone, password);
    }
}
