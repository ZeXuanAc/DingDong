package com.zxac.service.impl;


import com.alibaba.dubbo.config.annotation.Service;
import com.zxac.dao.UserMapper;
import com.zxac.model.User;
import com.zxac.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

@Service(interfaceClass = UserService.class)
@Component
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Override
    public List<User> getAllUser() {
        return Arrays.asList(new User(1, "1", 1),
                new User(2, "2", 2),
                new User(3, "3", 3));
    }

    @Override
    public List<User> getAllUserByMysql() {
        return userMapper.selectAll();
    }


}
