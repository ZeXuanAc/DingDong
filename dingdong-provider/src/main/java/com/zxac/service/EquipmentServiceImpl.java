package com.zxac.service;

import com.alibaba.dubbo.config.annotation.Service;
import com.zxac.dao.BuildingMapper;
import com.zxac.dao.EquipmentMapper;
import com.zxac.dto.BuildingDto;
import com.zxac.dto.EquipmentStatusDto;
import com.zxac.model.Equipment;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;


@Service(interfaceClass = EquipmentService.class)
@Component
@Slf4j
public class EquipmentServiceImpl implements EquipmentService{

    @Autowired
    private BuildingMapper buildingMapper;

    @Autowired
    private EquipmentMapper equipmentMapper;

    /**
     * 得到所有设备
     * @return
     */
    @Override
    public List<Equipment> getAllEquipment() {
        return equipmentMapper.getAll();
    }


    /**
     * 得到根据优先级排序后设备列表
     * @param storeyId
     * @return
     */
    @Override
    public List<Equipment> getEquipmentListByStoreyId(Integer storeyId) {
        List<Equipment> equipmentList = equipmentMapper.getListByStoreyId(storeyId);
        equipmentList.sort(Comparator.comparing(Equipment::getPriority));
        return equipmentList;
    }

    /**
     * 得到根据优先级排序后设备列表
     * @param buildingId
     * @return
     */
    @Override
    public List<Equipment> getEquipmentListByBuildingId(Integer buildingId) {
        List<Equipment> equipmentList = equipmentMapper.getListByBuildingId(buildingId);
        equipmentList.sort(Comparator.comparing(Equipment::getPriority));
        return equipmentList;
    }

    /**
     * 带参数citycode的查询结果缺失所在楼层信息
     */
    @Override
    public List<EquipmentStatusDto> getAllEquipmentDto(String citycode) {
        List<EquipmentStatusDto> dtoList = new ArrayList<>();
        if (citycode != null && !citycode.equals("")){
            List<BuildingDto> buildingList = BuildingDto.acceptList(buildingMapper.getListByCitycode(citycode));
            for (BuildingDto b : buildingList) {
                List<Equipment> eqList = getEquipmentListByBuildingId(b.getId());
                dtoList.addAll(EquipmentStatusDto.acceptList(eqList));
                dtoList.forEach(dto -> {
                    dto.setBuildingId(b.getId());
                    dto.setCitycode(citycode);
                });
            }
        } else {
            dtoList = equipmentMapper.getEqDtoList(citycode);
        }
        return dtoList;
    }
}
