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
import com.zxac.dto.EquipmentDto;
import com.zxac.dto.EquipmentStatusDto;
import com.zxac.exception.BusinessException;
import com.zxac.exception.FailureCode;
import com.zxac.model.*;
import com.zxac.utils.RedisUtil;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.ArrayUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;


@Service(interfaceClass = EquipmentService.class)
@Component
@Slf4j
public class EquipmentServiceImpl implements EquipmentService{

    @Autowired
    private BuildingMapper buildingMapper;

    @Autowired
    private EquipmentMapper equipmentMapper;

    @Autowired
    private AdminMapper adminMapper;

    @Autowired
    private StoreyMapper storeyMapper;

    /**
     * 得到所有设备
     * @return
     */
    @Override
    public List<Equipment> getAllEquipment() {
        return equipmentMapper.getAll();
    }


    /**
     * 得到根据优先级排序后设备列表
     * @param storeyId
     * @return
     */
    @Override
    public List<Equipment> getEquipmentListByStoreyId(Integer storeyId) {
        List<Equipment> equipmentList = equipmentMapper.getListByStoreyId(storeyId);
        equipmentList.sort(Comparator.comparing(Equipment::getPriority));
        return equipmentList;
    }

    /**
     * 得到根据优先级排序后设备列表
     * @param buildingId
     * @return
     */
    @Override
    public List<Equipment> getEquipmentListByBuildingId(Integer buildingId) {
        List<Equipment> equipmentList = equipmentMapper.getListByBuildingId(buildingId);
        equipmentList.sort(Comparator.comparing(Equipment::getPriority));
        return equipmentList;
    }

    /**
     * 带参数citycode的查询结果缺失所在楼层信息
     */
    @Override
    public List<EquipmentStatusDto> getAllEquipmentDto(String citycode) {
        List<EquipmentStatusDto> dtoList = new ArrayList<>();
        if (citycode != null && !citycode.equals("")){
            List<BuildingDto> buildingList = BuildingDto.acceptList(buildingMapper.getListByCitycode(citycode));
            for (BuildingDto b : buildingList) {
                List<Equipment> eqList = getEquipmentListByBuildingId(b.getId());
                dtoList.addAll(EquipmentStatusDto.acceptList(eqList));
                dtoList.forEach(dto -> {
                    dto.setBuildingId(b.getId());
                    dto.setCitycode(citycode);
                });
            }
        } else {
            dtoList = equipmentMapper.getEqDtoList(citycode);
        }
        return dtoList;
    }

    @Override
    public Result getEquipmentListByAdminIdDto(int pageNum, int pageSize, EquipmentDto dto) {
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
        List<EquipmentDto> dtoList = equipmentMapper.getEquipmentListByAdminIdDto(dto);
        PageInfo pageInfo = new PageInfo(dtoList);
        pageInfo.setPageNum(pageNum);
        pageInfo.setTotal(page.getTotal());
        return Result.success(pageInfo);
    }

    /**
     * 新增设备，插入equipment表后再更新building表和storey表的eq_num数量
     * @param dto
     * @return
     */
    @Override
    @Transactional
    public Result insert(EquipmentDto dto) {
        if (dto.getEqName() == null || dto.getStoreyId() == null) {
            return Result.failure(FailureCode.CODE911);
        }
        Equipment equipment = Equipment.accept(dto);
        int result = equipmentMapper.insertSelective(equipment);
        if (result != 1) {
            throw new BusinessException(FailureCode.CODE650);
        }
        updateEqNum(dto.getStoreyId(), 1);
        return Result.success("新增equipment成功");
    }

    @Override
    @Transactional
    public Result delete(Integer eqId) {
        if (eqId == null) {
            return Result.failure(FailureCode.CODE912);
        }
        Equipment equipment = equipmentMapper.selectByPrimaryKey(eqId);
        try {
            int result = equipmentMapper.deleteByPrimaryKey(eqId);
            if (result != 1) {
                throw new BusinessException(FailureCode.CODE651);
            }
        } catch (Exception e) {
            log.warn("equipment delete: ", e);
            throw new BusinessException(FailureCode.CODE651);
        }
        try {
            RedisUtil.delKeys("*" + Common.REDIS_KEY_EQ + eqId + "*");
        } catch (Exception e) {
            throw new BusinessException(FailureCode.CODE603);
        }
        updateEqNum(equipment.getStoreyId(), -1);
        return Result.success("删除equipment成功");
    }

    @Override
    @Transactional
    public Result update(EquipmentDto dto) {
        if (dto.getEqId() == null) {
            return Result.failure(FailureCode.CODE912);
        }
        int result;
        try {
            result = equipmentMapper.updateByPrimaryKeySelective(Equipment.accept(dto));
        } catch (Exception e) {
            log.warn("equipment update: ", e);
            throw new BusinessException(FailureCode.CODE652);
        }
        if (result == 1) {
            try {
                RedisUtil.delKeys("*" + Common.REDIS_KEY_EQ + dto.getEqId() + "*");
            } catch (Exception e) {
                throw new BusinessException(FailureCode.CODE603);
            }
        }
        return Result.success("更新equipment信息成功");
    }

    @Transactional
    protected void updateEqNum(Integer storeyId, Integer num) {
        try {
            Storey storey = storeyMapper.selectByPrimaryKey(storeyId);
            storey.setEqNum(storey.getEqNum() + num);
            storeyMapper.updateByPrimaryKeySelective(storey);
            Building building = buildingMapper.selectByPrimaryKey(storey.getBuildingId());
            building.setEqNum(building.getEqNum() + num);
            buildingMapper.updateByPrimaryKeySelective(building);
        } catch (Exception e) {
            throw new BusinessException(FailureCode.CODE917);
        }
    }
}
