package com.zxac.controller;


import com.alibaba.dubbo.config.annotation.Reference;
import com.zxac.model.Result;
import com.zxac.model.User;
import com.zxac.service.UserService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class UserController {


    @Reference(application = "${dubbo.application.id}", url = "dubbo://localhost:12345")
    private UserService userService;


    @GetMapping(value = "getAllUser")
    public Result getAllUser () {
        List<User> userList = userService.getAllUser();
        return Result.success("", userList);
    }

    @GetMapping(value = "getAllUserByMysql")
    public Result getAllUserByMysql () {
        List<User> userList = userService.getAllUserByMysql();
        return Result.success("", userList);
    }

}
