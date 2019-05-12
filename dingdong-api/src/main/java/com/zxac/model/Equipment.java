package com.zxac.model;

import com.zxac.dto.EquipmentDto;
import org.springframework.beans.BeanUtils;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

public class Equipment implements Serializable {
    private Integer id;

    private String name;

    private Integer storeyId;

    private String address;

    private String condition;

    private String latitude;

    private String longitude;

    private Integer priority;

    private Date createTime;

    private Date updateTime;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name == null ? null : name.trim();
    }

    public Integer getStoreyId() {
        return storeyId;
    }

    public void setStoreyId(Integer storeyId) {
        this.storeyId = storeyId;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address == null ? null : address.trim();
    }

    public String getCondition() {
        return condition;
    }

    public void setCondition(String condition) {
        this.condition = condition;
    }

    public String getLatitude() {
        return latitude;
    }

    public void setLatitude(String latitude) {
        this.latitude = latitude == null ? null : latitude.trim();
    }

    public String getLongitude() {
        return longitude;
    }

    public void setLongitude(String longitude) {
        this.longitude = longitude == null ? null : longitude.trim();
    }

    public Integer getPriority() {
        return priority;
    }

    public void setPriority(Integer priority) {
        this.priority = priority;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

    public static Equipment accept (EquipmentDto dto) {
        if (dto == null) {
            return new Equipment();
        }
        Equipment model = new Equipment();
        BeanUtils.copyProperties(dto, model);
        model.setName(dto.getEqName());
        model.setId(dto.getEqId());
        return model;
    }

    public static List<Equipment> acceptDto (List<EquipmentDto> dtoList) {
        if (dtoList == null || dtoList.isEmpty()) {
            return new ArrayList<>();
        }
        return dtoList.stream().map(Equipment::accept).collect(Collectors.toList());
    }

}
