package com.zxac.service;

import com.zxac.model.User;

import java.util.List;

public interface UserService {

    List<User> getAllUser ();

    List<User> getAllUserByMysql ();

}
