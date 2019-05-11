package com.zxac.dto;


import com.zxac.model.User;
import lombok.*;
import org.springframework.beans.BeanUtils;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Getter
@Setter
@ToString
@AllArgsConstructor
@NoArgsConstructor
public class UserDto implements Serializable {

    private Integer id;

    private String phone;

    private String name;

    private String password;

    private String gender;

    private String token;

    private String vip;

    private Integer age;

    public static UserDto accept (User model) {
        if (model == null) {
            return new UserDto();
        }
        UserDto dto = new UserDto();
        BeanUtils.copyProperties(model, dto);
        return dto;
    }

    public static List<UserDto> acceptDto (List<User> modelList) {
        if (modelList == null || modelList.isEmpty()) {
            return new ArrayList<>();
        }
        return modelList.stream().map(UserDto::accept).collect(Collectors.toList());
    }
}
