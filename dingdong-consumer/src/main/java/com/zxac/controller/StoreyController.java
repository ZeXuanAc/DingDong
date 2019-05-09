package com.zxac.controller;

import com.alibaba.dubbo.config.annotation.Reference;
import com.zxac.model.Result;
import com.zxac.model.Storey;
import com.zxac.service.StoreyService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@Slf4j
public class StoreyController {

    @Reference(application = "${dubbo.application.id}", url = "dubbo://localhost:12345")
    private StoreyService storeyService;


    @GetMapping(value = "storey")
    public Result getStorey(Integer buildingId){
        List<Storey> storeyList = storeyService.getStoreyList(buildingId);
        return Result.success(storeyList);
    }
}
