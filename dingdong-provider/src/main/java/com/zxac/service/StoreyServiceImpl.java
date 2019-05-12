package com.zxac.service;

import com.alibaba.dubbo.config.annotation.Service;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.zxac.constant.Common;
import com.zxac.dao.AdminMapper;
import com.zxac.dao.BuildingMapper;
import com.zxac.dao.EquipmentMapper;
import com.zxac.dao.StoreyMapper;
import com.zxac.dto.BuildingDto;
import com.zxac.dto.StoreyDto;
import com.zxac.exception.BusinessException;
import com.zxac.exception.FailureCode;
import com.zxac.model.Admin;
import com.zxac.model.Building;
import com.zxac.model.Result;
import com.zxac.model.Storey;
import com.zxac.utils.RedisUtil;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.ArrayUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service(interfaceClass = StoreyService.class)
@Component
@Slf4j
public class StoreyServiceImpl implements StoreyService {

    @Autowired
    private StoreyMapper storeyMapper;

    @Autowired
    private BuildingMapper buildingMapper;

    @Autowired
    private AdminMapper adminMapper;

    @Autowired
    private EquipmentMapper equipmentMapper;

    /**
     * @param buildingId
     * @return
     */
    @Override
    public Result getStoreyList(Integer buildingId) {
        List<Storey> storeyList = storeyMapper.getListByBuildingId(buildingId);
        return Result.success(storeyList);
    }


    /**
     * 得到storey信息，后台管理
     * @param pageNum
     * @param pageSize
     * @param dto
     * @return
     */
    @Override
    public Result getStoreyList(int pageNum, int pageSize, StoreyDto dto) {
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
        List<StoreyDto> dtoList = storeyMapper.getListByDto(dto);
        PageInfo pageInfo = new PageInfo(dtoList);
        pageInfo.setPageNum(pageNum);
        pageInfo.setTotal(page.getTotal());
        return Result.success(pageInfo);
    }

    @Override
    @Transactional
    public Result insert(StoreyDto dto) {
        if (dto.getName() == null || dto.getBuildingId() == null
                || dto.getFloor() == null) {
            return Result.failure(FailureCode.CODE901);
        }
        Storey storey = Storey.accept(dto);
        int result = storeyMapper.insertSelective(storey);
        if (result != 1) {
            throw new BusinessException(FailureCode.CODE650);
        }
        return Result.success("新增storey成功");
    }

    @Override
    @Transactional
    public Result delete(Integer storeyId) {
        if (storeyId == null) {
            return Result.failure(FailureCode.CODE902);
        }
        int equipmentCount = equipmentMapper.getListByStoreyId(storeyId).size();
        if (equipmentCount > 0) {
            throw new BusinessException(FailureCode.CODE860);
        }
        try {
            int result = storeyMapper.deleteByPrimaryKey(storeyId);
            if (result != 1) {
                throw new BusinessException(FailureCode.CODE651);
            }
        } catch (Exception e) {
            log.warn("storey delete: ", e);
            throw new BusinessException(FailureCode.CODE651);
        }
        try {
            RedisUtil.delKeys("*" + Common.REDIS_KEY_STOREY + storeyId + "*");
        } catch (Exception e) {
            throw new BusinessException(FailureCode.CODE603);
        }
        return Result.success("删除storey成功");
    }

    @Override
    public Result update(StoreyDto dto) {
        if (dto.getId() == null) {
            return Result.failure(FailureCode.CODE902);
        }
        int result;
        try {
            result = storeyMapper.updateByPrimaryKeySelective(Storey.accept(dto));
        } catch (Exception e) {
            log.warn("storey update: ", e);
            throw new BusinessException(FailureCode.CODE652);
        }
        if (result == 1) {
            try {
                RedisUtil.delKeys("*" + Common.REDIS_KEY_STOREY + dto.getId() + "*");
            } catch (Exception e) {
                throw new BusinessException(FailureCode.CODE603);
            }
        }
        return Result.success("更新storey信息成功");
    }

}
