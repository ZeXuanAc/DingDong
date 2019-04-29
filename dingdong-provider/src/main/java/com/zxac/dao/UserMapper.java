package com.zxac.dao;

import com.zxac.model.User;

public interface UserMapper {

    int insertSelective(User record);

    User selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(User record);

}
