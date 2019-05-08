package com.zxac.service;


import com.alibaba.dubbo.config.annotation.Service;
import com.zxac.dao.AdminMapper;
import com.zxac.exception.FailureCode;
import com.zxac.model.Admin;
import com.zxac.model.Result;
import com.zxac.utils.UuidUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

@Service(interfaceClass = AdminService.class)
@Component
@Slf4j
public class AdminServiceImpl implements AdminService {

    @Autowired
    private AdminMapper adminMapper;


    /**
     * 登陆，查询数据库是否存在此用户，不存在则返回注册，存在则存token到session
     * @param name
     * @param password
     * @return
     */
    @Override
    public Result login(String name, String password) {
        if (name == null || password == null) {
            return Result.failure(FailureCode.CODE791);
        }
        List<Admin> adminList = adminMapper.selectByNamePassword(name, password);
        if (adminList != null && adminList.size() == 1) {
            String token = UuidUtil.getUUID();
            return Result.success(token, adminList.get(0).getId());
        } else {
            return Result.failure(FailureCode.CODE703);
        }
    }


    @Override
    public Result userInfo(Integer uid) {
        if (uid == null) {
            return Result.failure(FailureCode.CODE795);
        }
        Admin admin = adminMapper.selectByPrimaryKey(uid);
        if (admin == null) {
            return Result.failure(FailureCode.CODE796);
        }
        return Result.success(admin);
    }
}
