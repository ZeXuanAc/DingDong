package com.zxac.controller;

import com.alibaba.dubbo.config.annotation.Reference;
import com.zxac.dto.BuildingDto;
import com.zxac.model.Result;
import com.zxac.service.BuildingService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@Slf4j
public class BuildingController {

    @Reference(application = "${dubbo.application.id}", url = "dubbo://localhost:12345")
    private BuildingService buildingService;


    @GetMapping(value = "building")
    public Result getBuilding(String citycode , String location){
        if (citycode == null) {
            return Result.failure("citycode参数是必传的");
        }
        List<BuildingDto> buildingList = buildingService.getBuildingList(citycode, location);
        return Result.success(buildingList);
    }

}
