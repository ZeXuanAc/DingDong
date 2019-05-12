package com.zxac.model;

import com.zxac.dto.CityDto;
import lombok.*;
import org.springframework.beans.BeanUtils;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class City implements Serializable {
    private Integer id;

    private String citycode;

    private String name;

    private String province;

    private Integer priority;

    private Date createTime;

    private Date updateTime;

    public static City accept (CityDto dto) {
        if (dto == null) {
            return new City();
        }
        City model = new City();
        BeanUtils.copyProperties(dto, model);
        return model;
    }

    public static List<City> acceptDto (List<CityDto> dtoList) {
        if (dtoList == null || dtoList.isEmpty()) {
            return new ArrayList<>();
        }
        return dtoList.stream().map(City::accept).collect(Collectors.toList());
    }
}
