package com.zxac.controller;

import com.alibaba.dubbo.config.annotation.Reference;
import com.zxac.dto.EquipmentDto;
import com.zxac.dto.EquipmentInitDto;
import com.zxac.exception.BusinessException;
import com.zxac.exception.FailureCode;
import com.zxac.model.Equipment;
import com.zxac.model.Result;
import com.zxac.permission.Module;
import com.zxac.permission.PermissionModule;
import com.zxac.service.EquipmentService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
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

    // 得到该adminId下的equipment信息
    @GetMapping(value = "admin/equipmentDto")
    public Result getEquipmentList(@RequestParam(defaultValue = "1") int pageNum,
                                @RequestParam(defaultValue = "10") int pageSize,
                                EquipmentDto dto){
        try {
            return equipmentService.getEquipmentListByAdminIdDto(pageNum, pageSize, dto);
        } catch (Exception e) {
            log.warn("equipment getEquipmentList : ", e);
            if (e instanceof BusinessException) {
                throw e;
            }
            throw new BusinessException(FailureCode.CODE913);
        }
    }

    // 新增一条equipment信息
    @GetMapping(value = "admin/equipment/insert")
    public Result insert(EquipmentDto dto) {
        try {
            return equipmentService.insert(dto);
        } catch (Exception e) {
            log.warn("equipment insert : ", e);
            if (e instanceof BusinessException) {
                throw e;
            }
            throw new BusinessException(FailureCode.CODE914);
        }
    }

    // 删除一条equipment信息
    @GetMapping(value = "admin/equipment/delete")
    public Result delete(Integer eqId) {
        try {
            return equipmentService.delete(eqId);
        } catch (Exception e) {
            log.warn("equipment delete : ", e);
            if (e instanceof BusinessException) {
                throw e;
            }
            throw new BusinessException(FailureCode.CODE915);
        }
    }

    // 更新一条equipment信息
    @GetMapping(value = "admin/equipment/update")
    public Result update(EquipmentDto dto) {
        try {
            return equipmentService.update(dto);
        } catch (Exception e) {
            log.warn("equipment update : ", e);
            if (e instanceof BusinessException) {
                throw e;
            }
            throw new BusinessException(FailureCode.CODE916);
        }
    }


    // 初始化设备信息接口
    @PermissionModule(belong = Module.ADMIN)
    @PostMapping(value = "admin/equipment/init")
    public Result init(EquipmentInitDto dto) {
        try {
            return equipmentService.init(dto);
        } catch (Exception e) {
            log.warn("equipment init : ", e);
            if (e instanceof BusinessException) {
                throw e;
            }
            throw new BusinessException(FailureCode.CODE925);
        }
    }


}
