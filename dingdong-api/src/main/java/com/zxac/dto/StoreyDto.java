package com.zxac.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.zxac.model.Storey;
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
public class StoreyDto implements Serializable {

    private Integer id;

    private String name;

    private Integer buildingId; // 所属buildingId

    private String buildingName; // 所属buildingName

    private String floor; // 所在楼层

    private String gender; // 所属性别类型

    private String longitude; // 经度

    private String latitude; // 纬度

    private Integer eqNum; // 设备数

    private Integer priority; // 优先级，在app首页展示building的时候使用

    private Integer adminId; // 所属adminId

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date createTime;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date updateTime;


    public static StoreyDto accept (Storey model){
        if (model == null) {
            return new StoreyDto();
        }
        StoreyDto dto = new StoreyDto();
        BeanUtils.copyProperties(model, dto);
        return dto;
    }

    public static List<StoreyDto> acceptList (List<Storey> modelList){
        if (modelList == null || modelList.isEmpty()) {
            return new ArrayList<>();
        }
        return modelList.stream().map(StoreyDto::accept).collect(Collectors.toList());
    }

}
