package com.zxac.service;


import com.alibaba.dubbo.config.annotation.Service;
import com.zxac.dao.UserMapper;
import com.zxac.dto.UserDto;
import com.zxac.model.Result;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Service(interfaceClass = CityEquipmentService.class)
@Component
@Slf4j
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Override
    public Result<UserDto> login(String phone, String password) {
        return null;
    }
}
