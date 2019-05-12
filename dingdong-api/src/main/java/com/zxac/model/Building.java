package com.zxac.model;

import com.zxac.dto.BuildingDto;
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
public class Building implements Serializable {
    private Integer id;

    private String name;

    private String citycode;

    private String cityName;

    private Integer eqNum;

    private String longitude;

    private String latitude;

    private Integer priority;

    private Date createTime;

    private Date updateTime;


    public static Building accept (BuildingDto dto) {
        if (dto == null) {
            return new Building();
        }
        Building model = new Building();
        BeanUtils.copyProperties(dto, model);
        return model;
    }

    public static List<Building> acceptDto (List<BuildingDto> dtoList) {
        if (dtoList == null || dtoList.isEmpty()) {
            return new ArrayList<>();
        }
        return dtoList.stream().map(Building::accept).collect(Collectors.toList());
    }
}
