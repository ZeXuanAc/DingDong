package com.zxac.controller;

import com.alibaba.dubbo.config.annotation.Reference;
import com.zxac.dto.StoreyDto;
import com.zxac.exception.BusinessException;
import com.zxac.exception.FailureCode;
import com.zxac.model.Result;
import com.zxac.service.StoreyService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
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

    // 得到该adminId下的storey信息
    @GetMapping(value = "admin/storeyDto")
    public Result getStoreyList(@RequestParam(defaultValue = "1") int pageNum,
                                  @RequestParam(defaultValue = "10") int pageSize,
                                  StoreyDto dto){
        try {
            return storeyService.getStoreyList(pageNum, pageSize, dto);
        } catch (Exception e) {
            log.error("storey getStoreyDtoList : ", e);
            throw new BusinessException(FailureCode.CODE904);
        }
    }

    // 新增一条storey信息
    @GetMapping(value = "admin/storey/insert")
    public Result insert(StoreyDto dto) {
        try {
            return storeyService.insert(dto);
        } catch (Exception e) {
            log.error("storey insert : ", e);
            throw new BusinessException(FailureCode.CODE906);
        }
    }

    // 删除一条storey信息
    @GetMapping(value = "admin/storey/delete")
    public Result delete(Integer id) {
        try {
            return storeyService.delete(id);
        } catch (Exception e) {
            log.error("storey delete : ", e);
            if (e instanceof BusinessException) {
                throw e;
            }
            throw new BusinessException(FailureCode.CODE907);
        }
    }

    // 更新一条storey信息
    @GetMapping(value = "admin/storey/update")
    public Result update(StoreyDto dto) {
        try {
            return storeyService.update(dto);
        } catch (Exception e) {
            log.error("StoreyDto update : ", e);
            throw new BusinessException(FailureCode.CODE908);
        }
    }
}
