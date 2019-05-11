package com.zxac.controller;

import com.alibaba.dubbo.config.annotation.Reference;
import com.zxac.dto.BuildingDto;
import com.zxac.exception.BusinessException;
import com.zxac.exception.FailureCode;
import com.zxac.model.Result;
import com.zxac.service.BuildingService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@Slf4j
public class BuildingController {

    @Reference(application = "${dubbo.application.id}", url = "dubbo://localhost:12345")
    private BuildingService buildingService;

    // 得到该citycode下的building
    @GetMapping(value = "building")
    public Result getBuilding(String citycode , String location){
        if (citycode == null) {
            return Result.failure("citycode参数是必传的");
        }
        List<BuildingDto> buildingList = buildingService.getBuildingList(citycode, location);
        return Result.success(buildingList);
    }

    // 得到该adminId下的building信息
    @GetMapping(value = "admin/building")
    public Result getBuildingList(@RequestParam(defaultValue = "1") int pageNum,
                                  @RequestParam(defaultValue = "10") int pageSize,
                                  BuildingDto dto){
        try {
            return buildingService.getBuildingList(pageNum, pageSize, dto);
        } catch (Exception e) {
            log.error("building getBuildingListByAdminId : ", e);
            throw new BusinessException(FailureCode.CODE866);
        }
    }

    // 得到该building下的storey信息
    @GetMapping(value = "admin/building/storeyInfo")
    public Result getBuildingStoreyList(Integer id){
        try {
            return buildingService.getBuildingStoreyList(id);
        } catch (Exception e) {
            log.error("building 得到该building下的storey信息 : ", e);
            throw new BusinessException(FailureCode.CODE866);
        }
    }

    // 新增一条building信息
    @GetMapping(value = "admin/building/insert")
    public Result insert(BuildingDto dto) {
        try {
            return buildingService.insert(dto);
        } catch (Exception e) {
            log.error("building insert : ", e);
            throw new BusinessException(FailureCode.CODE852);
        }
    }

    // 删除一条building信息
    @GetMapping(value = "admin/building/delete")
    public Result delete(Integer id) {
        try {
            return buildingService.delete(id);
        } catch (Exception e) {
            log.error("building delete : ", e);
            if (e instanceof BusinessException) {
                throw e;
            }
            throw new BusinessException(FailureCode.CODE861);
        }
    }

    // 更新一条building信息
    @GetMapping(value = "admin/building/update")
    public Result update(BuildingDto dto) {
        try {
            return buildingService.update(dto);
        } catch (Exception e) {
            log.error("building update : ", e);
            throw new BusinessException(FailureCode.CODE865);
        }
    }

}
