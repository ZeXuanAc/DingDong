package com.zxac.dao;

import com.zxac.model.User;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface UserMapper {

    User selectByPrimaryKey(Integer id);

    List<User> selectAll();
}