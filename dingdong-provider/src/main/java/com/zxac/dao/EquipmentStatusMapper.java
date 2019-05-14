package com.zxac.dao;

import com.zxac.model.EquipmentStatus;

import java.util.List;

public interface EquipmentStatusMapper {
    int deleteByPrimaryKey(Integer id);

    EquipmentStatus selectByPrimaryKey(Integer id);

    int insertBatch(List<EquipmentStatus> statusList);

    String getOldestStartTime();
}
