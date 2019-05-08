package com.zxac.service;

import com.zxac.model.Result;

public interface AdminService {

    /**
     * 登陆
     * @param name
     * @param password
     * @return
     */
    Result login(String name, String password);


    /**
     * 获取用户信息
     * @param uid
     * @return
     */
    Result userInfo(Integer uid);
}
