package com.zxac.dto;

import lombok.*;

import java.io.Serializable;

/**
 * equipment初始化专用dto
 */
@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class EquipmentInitDto implements Serializable {

    private Integer adminId;

    private String buildingName; // buildingName

    private String citycode; // 城市代码

    private String cityName; // 城市名称

    private Integer eqNum; // 设备数量，如果不存在building，则eqNum为1

    private String province; // 所属省份

    private String storeyName; // 楼层名称

    private Integer buildingId;

    private String floor; // 所属楼层

    private String storeyGender; // storey性别

    private String latitude; // 纬度（storey）导航用

    private String longitude; // 经度（storey）导航用

    private String eqName; // 设备名称

    private Integer storeyId;

}
