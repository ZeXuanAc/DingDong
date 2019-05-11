package com.zxac.controller;

import com.alibaba.dubbo.config.annotation.Reference;
import com.zxac.dto.CityDto;
import com.zxac.exception.BusinessException;
import com.zxac.exception.FailureCode;
import com.zxac.model.Result;
import com.zxac.permission.Module;
import com.zxac.permission.PermissionModule;
import com.zxac.service.CityService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Slf4j
public class CityController {

    @Reference(application = "${dubbo.application.id}", url = "dubbo://localhost:12345")
    private CityService cityService;


    @PermissionModule(belong = Module.ADMIN)
    @GetMapping(value = "admin/city/insert")
    public Result insert(CityDto dto) {
        try {
            return cityService.insert(dto);
        } catch (Exception e) {
            log.error("city insert : ", e);
            throw new BusinessException(FailureCode.CODE810);
        }
    }

    @PermissionModule(belong = Module.ADMIN)
    @GetMapping(value = "admin/city/delete")
    public Result delete(String citycode) {
        try {
            return cityService.delete(citycode);
        } catch (Exception e) {
            log.error("city delete : ", e);
            throw new BusinessException(FailureCode.CODE820);
        }
    }

    @PermissionModule(belong = Module.ADMIN)
    @GetMapping(value = "admin/getCityList")
    public Result getCityList(@RequestParam(defaultValue = "1") int pageNum,
                              @RequestParam(defaultValue = "10") int pageSize,
                              CityDto dto){
        try {
            return cityService.getCityListByDto(pageNum, pageSize, dto);
        } catch (Exception e) {
            log.error("getCityList : ", e);
            throw new BusinessException(FailureCode.CODE800);
        }
    }

    @PermissionModule(belong = Module.ADMIN)
    @GetMapping(value = "admin/city/update")
    public Result update(CityDto dto) {
        try {
            return cityService.update(dto);
        } catch (Exception e) {
            log.error("city update : ", e);
            throw new BusinessException(FailureCode.CODE830);
        }
    }

    @GetMapping(value = "allCity")
    public Result getAllCity(){
        return cityService.getAll();
    }

    @GetMapping(value = "citycode/get")
    public Result checkCitycode(String citycode){
        if (citycode == null) {
            return Result.failure("citycode参数是必传的");
        }
        Integer cityList = cityService.checkCityCode(citycode);
        return Result.success(cityList);
    }



}
