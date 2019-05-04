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

    @GetMapping(value = "user/editInfo")
    public Result editInfo(UserDto dto) {
        try {
            return userService.editInfo(dto);
        } catch (Exception e) {
            throw new BusinessException(FailureCode.CODE750);
        }
    }

    @GetMapping(value = "user/followBuildingCount")
    public Result followBuildingCount(Integer uid, Integer buildingId) {
        try {
            return userService.followBuildingCount(uid, buildingId);
        } catch (Exception e) {
            throw new BusinessException(FailureCode.CODE780);
        }
    }


    @GetMapping(value = "user/followBuilding")
    public Result followBuilding(Integer uid, String phone, Integer buildingId) {
        try {
            return userService.followBuilding(uid, phone, buildingId);
        } catch (Exception e) {
            throw new BusinessException(FailureCode.CODE773);
        }
    }

    @GetMapping(value = "user/unFollowBuilding")
    public Result unFollowBuilding(Integer uid, Integer buildingId) {
        try {
            return userService.unFollowBuilding(uid, buildingId);
        } catch (Exception e) {
            throw new BusinessException(FailureCode.CODE778);
        }
    }

    @GetMapping(value = "user/allFollowBuilding")
    public Result allFollowBuilding(Integer uid, String location) {
        try {
            return userService.allFollowBuilding(uid, location);
        } catch (Exception e) {
            throw new BusinessException(FailureCode.CODE785);
        }
    }

}
