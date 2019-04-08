package com.zxac.service;


import com.alibaba.dubbo.config.annotation.Service;
import com.zxac.dao.*;
import com.zxac.model.*;
import com.zxac.utils.DistanceUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import sun.rmi.runtime.Log;

import java.util.Arrays;
import java.util.Comparator;
import java.util.List;

@Service(interfaceClass = CityEquipmentService.class)
@Component
@Slf4j
public class CityEquipmentServiceImpl implements CityEquipmentService {

    @Autowired
    private CityMapper cityMapper;

    @Autowired
    private BuildingMapper buildingMapper;

    @Autowired
    private StoreyMapper storeyMapper;

    @Autowired
    private EquipmentMapper equipmentMapper;


    /**
     * 得到所有城市
     * @return
     */
    @Override
    public List<City> getAllCity() {
        return cityMapper.getAll();
    }


    /**
     * 得到排序后的building列表
     * @param cityId
     * @param location 经纬度, 纬度在前, 经度在后, 用逗号相隔, 如 30.1123,23232
     * @return
     */
    @Override
    public List<Building> getBuildingList(Integer cityId, String location) {
        List<Building> buildingList = buildingMapper.getListByCityId(cityId);
        String[] locations = location.split(",");
        buildingList.sort(Comparator.comparing((Building b) -> DistanceUtil.GetDistance(locations[0], locations[1], b.getLongitude(), b.getLatitude())));
        return buildingList;
    }


    /**
     * 得到排序后的楼层列表
     * @param buildingId
     * @return
     */
    @Override
    public List<Storey> getStoreyList(Integer buildingId) {
        List<Storey> storeyList = storeyMapper.getListByBuildingId(buildingId);
        storeyList.sort(Comparator.comparing(Storey::getName));
        return storeyList;
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
}
