package com.zxac.controller;

import com.alibaba.dubbo.config.annotation.Reference;
import com.zxac.model.*;
import com.zxac.service.CityEquipmentService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;


@RestController
@Slf4j
public class CityEquipmentController {

    @Reference(application = "${dubbo.application.id}", url = "dubbo://localhost:12345")
    private CityEquipmentService cityEquipmentService;

    @GetMapping(value = "allCity")
    public Result getAllCity(){
        List<City> cityList = cityEquipmentService.getAllCity();
        return Result.success(cityList);
    }

    @GetMapping(value = "building")
    public Result getBuilding(Integer cityId, String location){
        List<Building> buildingList = cityEquipmentService.getBuildingList(cityId, location);
        return Result.success(buildingList);
    }

    @GetMapping(value = "storey")
    public Result getStorey(Integer buildingId){
        List<Storey> storeyList = cityEquipmentService.getStoreyList(buildingId);
        return Result.success(storeyList);
    }

    @GetMapping(value = "equipment/building")
    public Result getEquipmentByBuildingId(Integer buildingId){
        List<Equipment> storeyList = cityEquipmentService.getEquipmentListByBuildingId(buildingId);
        return Result.success(storeyList);
    }

    @GetMapping(value = "equipment/storey")
    public Result getEquipmentByStoreyId(Integer storeyId){
        List<Equipment> equipmentList = cityEquipmentService.getEquipmentListByStoreyId(storeyId);
        return Result.success(equipmentList);
    }

}

