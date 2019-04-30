package com.zxac.service;

import com.zxac.dto.UserDto;
import com.zxac.model.Result;

public interface UserService {


    /**
     * 自动登陆，验证token是否存在，存在则登陆
     * @param token
     * @return
     */
    Result autoLogin(String token);


    /**
     * 登陆
     * @param phone
     * @param password
     * @return
     */
    Result login(String phone, String password);


    /**
     * 注册
     * @param dto
     * @return
     */
    Result signUp(UserDto dto);


    /**
     * 修改个人信息
     * @param dto
     * @return
     */
    Result editInfo(UserDto dto);

}
