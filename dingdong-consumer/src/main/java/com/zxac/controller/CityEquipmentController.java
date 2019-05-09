package com.zxac.controller;

import com.alibaba.dubbo.config.annotation.Reference;
import com.zxac.service.CityEquipmentService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.RestController;


@RestController
@Slf4j
public class CityEquipmentController {

    @Reference(application = "${dubbo.application.id}", url = "dubbo://localhost:12345")
    private CityEquipmentService cityEquipmentService;

//    @GetMapping(value = "allCity")
//    public Result getAllCity(){
//        List<City> cityList = cityEquipmentService.getAllCity();
//        return Result.success(cityList);
//    }
//
//    @GetMapping(value = "citycode/get")
//    public Result checkCitycode(String citycode){
//        if (citycode == null) {
//            return Result.failure("citycode参数是必传的");
//        }
//        Integer cityList = cityEquipmentService.checkCityCode(citycode);
//        return Result.success(cityList);
//    }

//    @GetMapping(value = "building")
//    public Result getBuilding(String citycode , String location){
//        if (citycode == null) {
//            return Result.failure("citycode参数是必传的");
//        }
//        List<BuildingDto> buildingList = cityEquipmentService.getBuildingList(citycode, location);
//        return Result.success(buildingList);
//    }

//    @GetMapping(value = "storey")
//    public Result getStorey(Integer buildingId){
//        List<Storey> storeyList = cityEquipmentService.getStoreyList(buildingId);
//        return Result.success(storeyList);
//    }


//    @GetMapping(value = "equipment/all")
//    public Result getAllEquipment(){
//        List<Equipment> equipmentList = cityEquipmentService.getAllEquipment();
//        return Result.success(equipmentList);
//    }
//
//    @GetMapping(value = "equipment/building")
//    public Result getEquipmentByBuildingId(Integer buildingId){
//        List<Equipment> equipmentList = cityEquipmentService.getEquipmentListByBuildingId(buildingId);
//        return Result.success(equipmentList);
//    }
//
//    @GetMapping(value = "equipment/storey")
//    public Result getEquipmentByStoreyId(Integer storeyId){
//        List<Equipment> equipmentList = cityEquipmentService.getEquipmentListByStoreyId(storeyId);
//        return Result.success(equipmentList);
//    }

}

