package com.zxac.dto;


import com.fasterxml.jackson.annotation.JsonFormat;
import com.zxac.model.Equipment;
import lombok.*;
import org.springframework.beans.BeanUtils;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

/**
 * equipmentDto
 */
@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class EquipmentDto implements Serializable {

    private Integer eqId; // 设备id

    private String eqName; // 设备名称

    private Integer storeyId; // 楼层id

    private Integer buildingId; // 建筑名称id

    private String storeyName; // 楼层名称

    private String buildingName; // buildingName

    private String condition; // 设备状况（1为正常， 0 为维护中）

    private String floor; // 楼层，如“F1”（地上一层）,“B1”（地下一层）

    private String storeyGender; // 性别（storey）

    private Integer priority; // 优先级, 设备

    private Integer adminId; // 管理员id

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date updateTime;


    public static EquipmentDto accept (Equipment model){
        if (model == null) {
            return new EquipmentDto();
        }
        EquipmentDto dto = new EquipmentDto();
        BeanUtils.copyProperties(model, dto);
        dto.setEqName(model.getName());
        dto.setEqId(model.getId());
        return dto;
    }

    public static List<EquipmentDto> acceptList (List<Equipment> modelList){
        if (modelList == null || modelList.isEmpty()) {
            return new ArrayList<>();
        }
        return modelList.stream().map(EquipmentDto::accept).collect(Collectors.toList());
    }

}
