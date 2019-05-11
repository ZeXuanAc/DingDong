package com.zxac.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.zxac.model.Building;
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
@AllArgsConstructor
@NoArgsConstructor
public class BuildingDto implements Serializable {

    private Integer id;

    private String name;

    private String citycode; // 所在城市的citycode

    private String cityName; // 所在城市的名称

    private Integer eqNum; // 设备数

    private Integer storeyNum; // 楼层数

    private Integer followUserNum; // 关注的用户数

    private String longitude; // building 经度（暂无使用）

    private String latitude; // building 纬度（暂无使用）

    private Integer priority; // 优先级，在app展示building的时候用到

    private Double distance; // 单位为M

    private String distanceStr;

    private Integer adminId; // 相关联的adminId

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date createTime;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date updateTime;


    public static BuildingDto accept (Building model){
        if (model == null) {
            return new BuildingDto();
        }
        BuildingDto dto = new BuildingDto();
        BeanUtils.copyProperties(model, dto);
        return dto;
    }

    public static List<BuildingDto> acceptList (List<Building> modelList){
        if (modelList == null || modelList.isEmpty()) {
            return new ArrayList<>();
        }
        return modelList.stream().map(BuildingDto::accept).collect(Collectors.toList());
    }

}
