package com.zxac.controller;

import com.alibaba.dubbo.config.annotation.Reference;
import com.zxac.model.Equipment;
import com.zxac.model.Result;
import com.zxac.permission.Module;
import com.zxac.permission.PermissionModule;
import com.zxac.service.EquipmentService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@Slf4j
public class EquipmentController {

    @Reference(application = "${dubbo.application.id}", url = "dubbo://localhost:12345")
    private EquipmentService equipmentService;


    @PermissionModule(belong = Module.NORMAL)
    @GetMapping(value = "admin/equipment/all")
    public Result getAllEquipment(){
        List<Equipment> equipmentList = equipmentService.getAllEquipment();
        return Result.success(equipmentList);
    }

    @GetMapping(value = "equipment/building")
    public Result getEquipmentByBuildingId(Integer buildingId){
        List<Equipment> equipmentList = equipmentService.getEquipmentListByBuildingId(buildingId);
        return Result.success(equipmentList);
    }

    @GetMapping(value = "equipment/storey")
    public Result getEquipmentByStoreyId(Integer storeyId){
        List<Equipment> equipmentList = equipmentService.getEquipmentListByStoreyId(storeyId);
        return Result.success(equipmentList);
    }
}
