package com.zxac.model;

import com.zxac.dto.UserDto;
import org.springframework.beans.BeanUtils;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

public class User {
    private Integer id;

    private String phone;

    private String name;

    private String password;

    private String gender;

    private String vip;

    private Integer age;

    private Date createTime;

    private Date updateTime;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone == null ? null : phone.trim();
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name == null ? null : name.trim();
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password == null ? null : password.trim();
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getVip() {
        return vip;
    }

    public void setVip(String vip) {
        this.vip = vip == null ? null : vip.trim();
    }

    public Integer getAge() {
        return age;
    }

    public void setAge(Integer age) {
        this.age = age;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }


    public static User accept (UserDto dto) {
        if (dto == null) {
            return new User();
        }
        User model = new User();
        BeanUtils.copyProperties(dto, model);
        return model;
    }

    public static List<User> acceptDto (List<UserDto> dtoList) {
        if (dtoList == null || dtoList.isEmpty()) {
            return new ArrayList<>();
        }
        return dtoList.stream().map(User::accept).collect(Collectors.toList());
    }

}
