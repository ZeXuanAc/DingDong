package com.zxac.controller;

import com.alibaba.dubbo.config.annotation.Reference;
import com.zxac.exception.BusinessException;
import com.zxac.exception.FailureCode;
import com.zxac.model.Result;
import com.zxac.service.StoreyService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Slf4j
public class StoreyController {

    @Reference(application = "${dubbo.application.id}", url = "dubbo://localhost:12345")
    private StoreyService storeyService;


    @GetMapping(value = "admin/storey")
    public Result getStorey(Integer buildingId){
        try {
            return storeyService.getStoreyList(buildingId);
        } catch (Exception e) {
            log.error("storey getStorey : ", e);
            throw new BusinessException(FailureCode.CODE900);
        }
    }
}
