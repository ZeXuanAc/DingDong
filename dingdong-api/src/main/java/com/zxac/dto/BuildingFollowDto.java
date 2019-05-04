package com.zxac.dto;

import lombok.*;

import java.io.Serializable;
import java.util.Date;


@ToString
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class BuildingFollowDto implements Serializable {

    private Integer uid;

    private String phone;

    private Integer buildingId;

    private String buildingName;

    private String citycode;

    private String cityName;

    private String longitude;

    private String latitude;

    private Double distance; // 单位为M

    private String distanceStr;

    private Date createTime;

    private Date updateTime;
}
