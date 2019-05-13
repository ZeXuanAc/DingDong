package com.zxac.model;

import com.zxac.dto.StoreyOccupancyRateDto;
import org.springframework.beans.BeanUtils;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

public class StoreyOccupancyRate {
    private Integer id;

    private Integer buildingId;

    private Integer storeyId;

    private Integer totalEqNum;

    private Integer useEqNum;

    private Integer freeEqNum;

    private Integer abnormalEqNum;

    private Date createTime;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getBuildingId() {
        return buildingId;
    }

    public void setBuildingId(Integer buildingId) {
        this.buildingId = buildingId;
    }

    public Integer getStoreyId() {
        return storeyId;
    }

    public void setStoreyId(Integer storeyId) {
        this.storeyId = storeyId;
    }

    public Integer getTotalEqNum() {
        return totalEqNum;
    }

    public void setTotalEqNum(Integer totalEqNum) {
        this.totalEqNum = totalEqNum;
    }

    public Integer getUseEqNum() {
        return useEqNum;
    }

    public void setUseEqNum(Integer useEqNum) {
        this.useEqNum = useEqNum;
    }

    public Integer getFreeEqNum() {
        return freeEqNum;
    }

    public void setFreeEqNum(Integer freeEqNum) {
        this.freeEqNum = freeEqNum;
    }

    public Integer getAbnormalEqNum() {
        return abnormalEqNum;
    }

    public void setAbnormalEqNum(Integer abnormalEqNum) {
        this.abnormalEqNum = abnormalEqNum;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public static StoreyOccupancyRate accept (StoreyOccupancyRateDto dto) {
        if (dto == null) {
            return new StoreyOccupancyRate();
        }
        StoreyOccupancyRate model = new StoreyOccupancyRate();
        BeanUtils.copyProperties(dto, model);
        return model;
    }

    public static List<StoreyOccupancyRate> acceptDto (List<StoreyOccupancyRateDto> dtoList) {
        if (dtoList == null || dtoList.isEmpty()) {
            return new ArrayList<>();
        }
        return dtoList.stream().map(StoreyOccupancyRate::accept).collect(Collectors.toList());
    }


}
