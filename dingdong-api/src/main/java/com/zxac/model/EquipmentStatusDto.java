package com.zxac.model;


import lombok.*;

/**
 * 数据传输数据包格式
 */
@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class EquipmentStatusDto {

    private Integer eqId; // 设备id

    private String eqName; // 设备名称

    private Integer storeyId; // 楼层id

    private Integer buildingId; // 建筑名称id

    private Integer cityId; // 城市id

    private String status; // 状态

    private String createTime; // 数据包生成时间
}
