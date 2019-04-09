package com.zxac.model;


import lombok.*;
import org.springframework.beans.BeanUtils;

import java.io.Serializable;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 数据传输数据包格式
 */
@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class EquipmentStatusDto implements Serializable {

    private Integer eqId; // 设备id

    private String eqName; // 设备名称

    private Integer storeyId; // 楼层id

    private Integer buildingId; // 建筑名称id

    private Integer cityId; // 城市id

    private String storeyName; // 楼层名称

    private String cityName; // 城市名称

    private String buildingName; // buildingName

    private String condition; // 设备状况（1为正常， 0 为维护中）

    private String status; // 使用情况（1为使用中， 0 为空闲）

    private String address; // 详细地址(设备)

    private String latitude; // 经度（building）

    private String longitude; // 纬度（building）

    private Integer priority; // 优先级, 设备

    private String createTimeStr; // 数据包生成时间

    public static EquipmentStatusDto accept (Equipment model, Integer buildingId, Integer cityId, String status, String createTime){
        EquipmentStatusDto dto = new EquipmentStatusDto();
        BeanUtils.copyProperties(model, dto);
        dto.setBuildingId(buildingId);
        dto.setCityId(cityId);
        dto.setStatus(status);
        dto.setCreateTimeStr(createTime);
        return dto;
    }

    public static EquipmentStatusDto accept (Equipment model){
        EquipmentStatusDto dto = new EquipmentStatusDto();
        BeanUtils.copyProperties(model, dto);
        return dto;
    }

    public static List<EquipmentStatusDto> acceptList (List<Equipment> modelList){
        return modelList.stream().map(EquipmentStatusDto::accept).collect(Collectors.toList());
    }
}