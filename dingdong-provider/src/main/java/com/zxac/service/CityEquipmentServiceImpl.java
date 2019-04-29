package com.zxac.service;


import com.alibaba.dubbo.config.annotation.Service;
import com.zxac.dao.BuildingMapper;
import com.zxac.dao.CityMapper;
import com.zxac.dao.EquipmentMapper;
import com.zxac.dao.StoreyMapper;
import com.zxac.dto.BuildingDto;
import com.zxac.dto.EquipmentStatusDto;
import com.zxac.model.Building;
import com.zxac.model.City;
import com.zxac.model.Equipment;
import com.zxac.model.Storey;
import com.zxac.utils.DistanceUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
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


    @Override
    public Integer checkCityCode(String citycode) {
        return cityMapper.citycodeNum(citycode);
    }

    /**
     * 得到排序后的building列表
     * @param citycode
     * @param location 经纬度, 纬度在前, 经度在后, 用逗号相隔, 如 30.1123,23232
     * @return
     */
    @Override
    public List<BuildingDto> getBuildingList(String citycode, String location) {
        List<Building> buildingList = buildingMapper.getListByCitycode(citycode);
        List<BuildingDto> dtoList = BuildingDto.acceptList(buildingList);
        if (location != null && !location.equals("")) {
            String[] locations = location.split(",");
            if (locations.length == 2) {
                dtoList.forEach(dto -> {
                    Double distance = DistanceUtil.GetDistance(locations[0], locations[1], dto.getLatitude(), dto.getLongitude());
                    dto.setDistance(distance);
                    dto.setDistanceStr(DistanceUtil.format2decimal(distance));
                });
                dtoList.sort(Comparator.comparing(BuildingDto::getDistance));
            }
        }
        return dtoList;
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
     * 得到所有设备
     * @return
     */
    @Override
    public List<Equipment> getAllEquipment() {
        return equipmentMapper.getAll();
    }


    /**
     * 带参数citycode的查询结果缺失所在楼层信息
     */
    @Override
    public List<EquipmentStatusDto> getAllEquipment(String citycode) {
        List<EquipmentStatusDto> dtoList = new ArrayList<>();
        if (citycode != null && !citycode.equals("")){
            List<BuildingDto> buildingList = getBuildingList(citycode, null);
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
