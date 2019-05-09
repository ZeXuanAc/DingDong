package com.zxac.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.zxac.model.City;
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
public class CityDto implements Serializable {

    private Integer id;

    private String citycode;

    private String name;

    private String province;

    private Integer priority;

    @JsonFormat(timezone = "GMT+8", pattern = "yyyy-MM-dd HH:mm:ss")
    private Date createTime;

    @JsonFormat(timezone = "GMT+8", pattern = "yyyy-MM-dd HH:mm:ss")
    private Date updateTime;

    public static CityDto accept (City model){
        if (model == null) {
            return null;
        }
        CityDto dto = new CityDto();
        BeanUtils.copyProperties(model, dto);
        return dto;
    }

    public static List<CityDto> acceptList (List<City> modelList){
        if (modelList == null || modelList.isEmpty()) {
            return null;
        }
        return modelList.stream().map(CityDto::accept).collect(Collectors.toList());
    }
}
