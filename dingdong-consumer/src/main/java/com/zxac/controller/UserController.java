package com.zxac.controller;

import com.alibaba.dubbo.config.annotation.Reference;
import com.zxac.dto.UserDto;
import com.zxac.exception.BusinessException;
import com.zxac.exception.FailureCode;
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

    @GetMapping(value = "autoLogin")
    public Result autoLogin(String token){
        try {
            return userService.autoLogin(token);
        } catch (Exception e) {
            throw new BusinessException(FailureCode.CODE706);
        }
    }

    @GetMapping(value = "login")
    public Result autoLogin(String phone, String password){
        try {
            return userService.login(phone, password);
        } catch (Exception e) {
            throw new BusinessException(FailureCode.CODE700);
        }
    }

    @GetMapping(value = "signUp")
    public Result signUp(UserDto dto) {
        try {
            return userService.signUp(dto);
        } catch (Exception e) {
            throw new BusinessException(FailureCode.CODE705);
        }

    }
}
