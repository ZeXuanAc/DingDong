package com.zxac.service;

import com.alibaba.dubbo.config.annotation.Service;
import com.zxac.dao.BuildingMapper;
import com.zxac.dto.BuildingDto;
import com.zxac.model.Building;
import com.zxac.utils.DistanceUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Comparator;
import java.util.List;


@Service(interfaceClass = BuildingService.class)
@Component
@Slf4j
public class BuildingServiceImpl implements BuildingService {

    @Autowired
    private BuildingMapper buildingMapper;

    /**
     * 得到排序后的building列表
     * @param citycode
     * @param location 经纬度, 纬度在前, 经度在后, 用逗号相隔, 如 30.1123,23232
     * @return
     */
    @Override
    public List<BuildingDto> getBuildingList(String citycode, String location) {
        List<Building> buildingList = buildingMapper.getListByCitycode(citycode);
        List<BuildingDto> dtoList = BuildingDto.acceptList(buildingList);
        if (location != null && !location.equals("")) {
            String[] locations = location.split(",");
            if (locations.length == 2) {
                dtoList.forEach(dto -> {
                    Double distance = DistanceUtil.GetDistance(locations[0], locations[1], dto.getLatitude(), dto.getLongitude());
                    dto.setDistance(distance);
                    dto.setDistanceStr(DistanceUtil.format2decimal(distance));
                });
                dtoList.sort(Comparator.comparing(BuildingDto::getDistance));
            }
        }
        return dtoList;
    }

}
