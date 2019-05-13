package com.zxac.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.zxac.model.StoreyOccupancyRate;
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
public class StoreyOccupancyRateDto implements Serializable {
    private Integer id;

    private Integer buildingId;

    private Integer storeyId;

    private String storeyName;

    private Integer totalEqNum;

    private Integer useEqNum;

    private String occupancyRate;

    private Integer freeEqNum;

    private Integer abnormalEqNum;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date createTime;

    public static StoreyOccupancyRateDto accept (StoreyOccupancyRate model) {
        if (model == null) {
            return new StoreyOccupancyRateDto();
        }
        StoreyOccupancyRateDto dto = new StoreyOccupancyRateDto();
        BeanUtils.copyProperties(model, dto);
        return dto;
    }

    public static List<StoreyOccupancyRateDto> acceptDto (List<StoreyOccupancyRate> modelList) {
        if (modelList == null || modelList.isEmpty()) {
            return new ArrayList<>();
        }
        return modelList.stream().map(StoreyOccupancyRateDto::accept).collect(Collectors.toList());
    }

}
