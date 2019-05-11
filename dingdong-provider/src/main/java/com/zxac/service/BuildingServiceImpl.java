package com.zxac.service;

import com.alibaba.dubbo.config.annotation.Service;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.zxac.constant.Common;
import com.zxac.dao.AdminBuildingMapper;
import com.zxac.dao.AdminMapper;
import com.zxac.dao.BuildingMapper;
import com.zxac.dao.StoreyMapper;
import com.zxac.dto.BuildingDto;
import com.zxac.dto.CityDto;
import com.zxac.dto.StoreyDto;
import com.zxac.exception.BusinessException;
import com.zxac.exception.FailureCode;
import com.zxac.model.*;
import com.zxac.utils.DistanceUtil;
import com.zxac.utils.RedisUtil;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.ArrayUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.Comparator;
import java.util.List;


@Service(interfaceClass = BuildingService.class)
@Component
@Slf4j
public class BuildingServiceImpl implements BuildingService {

    @Autowired
    private AdminMapper adminMapper;

    @Autowired
    private BuildingMapper buildingMapper;

    @Autowired
    private StoreyMapper storeyMapper;

    @Autowired
    private AdminBuildingMapper adminBuildingMapper;

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


    @Override
    public Result getBuildingList(int pageNum, int pageSize, BuildingDto dto) {
        Integer adminId = dto.getAdminId();
        if (adminId == null || adminId == 0) {
            return Result.failure(FailureCode.CODE850);
        }
        // 查询该id下的权限，如果是admin则让adminId = 0得到所有的building
        Admin admin = adminMapper.selectByPrimaryKey(adminId);
        if (ArrayUtils.contains(admin.getRoles().split(","), "admin")) {
            adminId = 0;
        }
        dto.setAdminId(adminId);
        Page<Object> page = PageHelper.startPage(pageNum, pageSize);
        List<Building> buildingList = buildingMapper.getListByAdminIdAndDto(dto);
        List<BuildingDto> dtoList = BuildingDto.acceptList(buildingList);
        PageInfo pageInfo = new PageInfo(dtoList);
        pageInfo.setPageNum(pageNum);
        pageInfo.setTotal(page.getTotal());
        return Result.success(pageInfo);
    }

    @Override
    public Result getBuildingStoreyList(Integer buildingId) {
        if (buildingId == null) {
            return Result.failure(FailureCode.CODE858);
        }
        List<Storey> storeyList = storeyMapper.getListByBuildingId(buildingId);
        List<StoreyDto> dtoList = StoreyDto.acceptList(storeyList);
        return Result.success(dtoList);
    }

    @Override
    @Transactional
    public Result insert(BuildingDto dto) {
        if (dto.getName() == null || dto.getCitycode() == null || dto.getCityName() == null) {
            return Result.failure(FailureCode.CODE851);
        }
        Building building = Building.accept(dto);
        int result = buildingMapper.insertSelective(building);
        if (result != 1) {
            throw new BusinessException(FailureCode.CODE650);
        }
        log.info("1----> building insert success");
        if (dto.getAdminId() != null && building.getId() != null) {
            AdminBuilding adminBuilding = new AdminBuilding();
            adminBuilding.setAdminId(dto.getAdminId());
            adminBuilding.setBuildingId(building.getId());
            int i = adminBuildingMapper.insertSelective(adminBuilding);
            if (i != 1) {
                throw new BusinessException(FailureCode.CODE853);
            }
            log.info("2----> admin-building insert success");
        }
        return Result.success("新增building成功");
    }

    /**
     * 1、查询storey结果，如果无相关storey数据则删除building数据，再删除redis数据，有storey相关数据则返回失败结果
     * @param buildingId
     * @return
     */
    @Override
    @Transactional
    public Result delete(Integer buildingId) {
        if (buildingId == null) {
            return Result.failure(FailureCode.CODE858);
        }
        int storeyCount = storeyMapper.getListByBuildingId(buildingId).size();
        if (storeyCount > 0) {
            throw new BusinessException(FailureCode.CODE860);
        }
        try {
            int result = buildingMapper.deleteByPrimaryKey(buildingId);
            int adminBuildingResult = adminBuildingMapper.deleteByBuildingId(buildingId);
            if (result != 1 || adminBuildingResult != 1) {
                throw new BusinessException(FailureCode.CODE651);
            }
        } catch (Exception e) {
            log.warn("building delete: ", e);
            throw new BusinessException(FailureCode.CODE651);
        }
        try {
            RedisUtil.delKeys("*" + Common.REDIS_KEY_BUILDING + buildingId + "*");
        } catch (Exception e) {
            throw new BusinessException(FailureCode.CODE603);
        }
        return Result.success("删除building成功");
    }

    @Override
    @Transactional
    public Result update(BuildingDto dto) {
        if (dto.getId() == null) {
            return Result.failure(FailureCode.CODE858);
        }
        int result;
        try {
            result = buildingMapper.updateByPrimaryKeySelective(Building.accept(dto));
        } catch (Exception e) {
            log.warn("building update: ", e);
            throw new BusinessException(FailureCode.CODE652);
        }
        if (result == 1) {
            try {
                RedisUtil.delKeys("*" + Common.REDIS_KEY_BUILDING + dto.getId() + "*");
            } catch (Exception e) {
                throw new BusinessException(FailureCode.CODE603);
            }
        }
        return Result.success("更新building信息成功");
    }
}
