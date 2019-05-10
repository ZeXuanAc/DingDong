package com.zxac.service;

import com.alibaba.dubbo.config.annotation.Service;
import com.zxac.dao.StoreyMapper;
import com.zxac.model.Result;
import com.zxac.model.Storey;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Comparator;
import java.util.List;

@Service(interfaceClass = StoreyService.class)
@Component
@Slf4j
public class StoreyServiceImpl implements StoreyService {

    @Autowired
    private StoreyMapper storeyMapper;

    /**
     * 得到排序后的楼层列表
     * @param buildingId
     * @return
     */
    @Override
    public Result getStoreyList(Integer buildingId) {
        List<Storey> storeyList = storeyMapper.getListByBuildingId(buildingId);
        storeyList.sort(Comparator.comparing(Storey::getPriority));
        return Result.success(storeyList);
    }


}
