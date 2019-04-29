package com.zxac.service;

import com.zxac.dto.UserDto;
import com.zxac.model.Result;

public interface UserService {


    /**
     * 登陆或者注册，用户名不存在的时候就注册，存在就登陆
     * @param phone
     * @param password
     * @return
     */
    Result<UserDto> login(String phone, String password);




}
