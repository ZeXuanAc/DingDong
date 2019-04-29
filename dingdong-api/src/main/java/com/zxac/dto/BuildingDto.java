package com.zxac.dto;

import com.zxac.model.Building;
import lombok.*;
import org.springframework.beans.BeanUtils;

import java.io.Serializable;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;


@Getter
@Setter
@ToString
@AllArgsConstructor
@NoArgsConstructor
public class BuildingDto implements Serializable {

    private Integer id;

    private String name;

    private String citycode;

    private String cityName;

    private Integer eqNum;

    private String longitude;

    private String latitude;

    private Integer priority;

    private Double distance; // 单位为M

    private String distanceStr;

    private Date createTime;

    private Date updateTime;


    public static BuildingDto accept (Building model){
        BuildingDto dto = new BuildingDto();
        BeanUtils.copyProperties(model, dto);
        return dto;
    }

    public static List<BuildingDto> acceptList (List<Building> modelList){
        return modelList.stream().map(BuildingDto::accept).collect(Collectors.toList());
    }

}
