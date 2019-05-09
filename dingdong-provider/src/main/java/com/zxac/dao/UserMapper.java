package com.zxac.dao;

import com.zxac.model.User;
import org.apache.ibatis.annotations.Param;

public interface UserMapper {

    int insertSelective(User record);

    User selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(User record);

    int getAllCount();

    int selectCountByPhone(@Param("phone") String phone);

    User selectByPhonePassword(@Param("phone") String phone, @Param("password") String password);

}
