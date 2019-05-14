package com.zxac.service;

import com.alibaba.dubbo.config.annotation.Service;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.zxac.constant.Common;
import com.zxac.dao.*;
import com.zxac.dto.*;
import com.zxac.exception.BusinessException;
import com.zxac.exception.FailureCode;
import com.zxac.model.*;
import com.zxac.utils.RedisUtil;
import lombok.Builder;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.ArrayUtils;
import org.apache.commons.lang3.StringUtils;
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
    private AdminMapper adminMapper;
    @Autowired
    private AdminBuildingMapper adminBuildingMapper;
    @Autowired
    private CityMapper cityMapper;
    @Autowired
    private BuildingMapper buildingMapper;
    @Autowired
    private StoreyMapper storeyMapper;
    @Autowired
    private EquipmentMapper equipmentMapper;
    @Autowired
    private EquipmentStatusMapper equipmentStatusMapper;


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

    /**
     * 判断该数据是否属于存在的city，不属于则新增city、building、storey、equipment信息
     * @param dto
     * @return
     */
    @Override
    @Transactional
    public Result init(EquipmentInitDto dto) {
        // 判断是否属于已有的city
        if(StringUtils.isBlank(dto.getCitycode()) || StringUtils.isBlank(dto.getCityName()) || StringUtils.isBlank(dto.getProvince())) {
            return Result.failure(FailureCode.CODE926);
        }
        if(StringUtils.isBlank(dto.getBuildingName())) {
            return Result.failure(FailureCode.CODE927);
        }
        if(StringUtils.isBlank(dto.getStoreyName()) || StringUtils.isBlank(dto.getFloor()) || StringUtils.isBlank(dto.getStoreyGender())
                || StringUtils.isBlank(dto.getLatitude()) || StringUtils.isBlank(dto.getLongitude())) {
            return Result.failure(FailureCode.CODE929);
        }
        if(StringUtils.isBlank(dto.getEqName())) {
            return Result.failure(FailureCode.CODE930);
        }
        List<City> cityList = cityMapper.getCityListByDto(CityDto.builder().citycode(dto.getCitycode()).build());
        if(cityList == null || cityList.size() != 1) {
            City city = City.builder().citycode(dto.getCitycode()).name(dto.getCityName()).province(dto.getProvince()).build();
            cityMapper.insertSelective(city);
        }
        log.info("equipment init city success..");

        try {
            List<Building> buildingList = buildingMapper.selectListByCitycodeName(dto.getBuildingName(), dto.getCitycode());
            Building building;
            if (buildingList != null && buildingList.size() == 1) {
                building = buildingList.get(0);
            } else {
                if (dto.getAdminId() == null) {
                    throw new BusinessException(FailureCode.CODE928);
                }
                building = Building.builder().name(dto.getBuildingName()).citycode(dto.getCitycode())
                        .cityName(dto.getCityName()).eqNum(1).build();
                buildingMapper.insertSelective(building);
                AdminBuilding adminBuilding = new AdminBuilding();
                adminBuilding.setAdminId(dto.getAdminId());
                adminBuilding.setBuildingId(building.getId());
                adminBuildingMapper.insertSelective(adminBuilding);
            }
            dto.setBuildingId(building.getId());
            log.info("equipment init building success..");

            List<Storey> storeyList = storeyMapper.selectByNameFloorGender(dto.getStoreyName(), dto.getFloor(), dto.getBuildingName(), dto.getCitycode(), dto.getStoreyGender());
            Storey storey;
            if (storeyList != null && storeyList.size() == 1) {
                storey = storeyList.get(0);
            } else {
                storey = Storey.builder().name(dto.getStoreyName()).buildingId(dto.getBuildingId()).floor(dto.getFloor())
                        .gender(dto.getStoreyGender()).latitude(dto.getLatitude()).longitude(dto.getLongitude()).eqNum(1).build();
                storeyMapper.insertSelective(storey);
            }
            dto.setStoreyId(storey.getId());
            log.info("equipment init storey success..");

            Equipment equipment = new Equipment();
            equipment.setName(dto.getEqName());
            equipment.setStoreyId(dto.getStoreyId());
            equipmentMapper.insertSelective(equipment);
            log.info("equipment init equipment success..");
        } catch (Exception e) {
            log.warn("equipment init: ", e);
            throw new BusinessException(FailureCode.CODE650);
        }
        return Result.success("设备初始化成功");
    }

    @Override
    public Result insertStatusDto(List<EquipmentStatus> statusList) {
        if (statusList == null || statusList.isEmpty()) {
            return Result.success("待处理数据为空，直接返回");
        }
        int count = equipmentStatusMapper.insertBatch(statusList);
        if (!(count > 0)) {
            return Result.failure("插入失败---> 待插入数：" + statusList.size() + ", 插入数： " + count);
        }
        return Result.success("equipmentStatus 持久化完成");
    }
}
