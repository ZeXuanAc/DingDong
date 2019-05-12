package com.zxac.model;

import com.zxac.dto.StoreyDto;
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
public class Storey implements Serializable {
    private Integer id;

    private String name;

    private Integer buildingId;

    private String floor;

    private String gender;

    private String longitude;

    private String latitude;

    private Integer eqNum;

    private Integer priority;

    private Date createTime;

    private Date updateTime;


    public static Storey accept (StoreyDto dto) {
        if (dto == null) {
            return new Storey();
        }
        Storey model = new Storey();
        BeanUtils.copyProperties(dto, model);
        return model;
    }

    public static List<Storey> acceptDto (List<StoreyDto> dtoList) {
        if (dtoList == null || dtoList.isEmpty()) {
            return new ArrayList<>();
        }
        return dtoList.stream().map(Storey::accept).collect(Collectors.toList());
    }

}
