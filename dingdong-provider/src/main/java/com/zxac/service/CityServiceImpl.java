package com.zxac.service;

import com.alibaba.dubbo.config.annotation.Service;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.zxac.constant.Common;
import com.zxac.dao.BuildingMapper;
import com.zxac.dao.CityMapper;
import com.zxac.dto.CityDto;
import com.zxac.exception.BusinessException;
import com.zxac.exception.FailureCode;
import com.zxac.model.Building;
import com.zxac.model.City;
import com.zxac.model.Result;
import com.zxac.utils.RedisUtil;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.ArrayUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Service(interfaceClass = CityService.class)
@Component
@Slf4j
public class CityServiceImpl implements CityService {

    @Autowired
    private CityMapper cityMapper;

    @Autowired
    private BuildingMapper buildingMapper;


    @Override
    @Transactional
    public Result insert(CityDto dto) {
        if (dto.getCitycode() == null || dto.getName() == null) {
            return Result.failure(FailureCode.CODE812);
        }
        int citycodeCount = checkCityCode(dto.getCitycode());
        if (citycodeCount > 0) {
            return Result.failure(FailureCode.CODE813);
        }
        int result = cityMapper.insertSelective(City.accept(dto));
        if (result != 1) {
            throw new BusinessException(FailureCode.CODE650);
        }
        return Result.success("新增city信息成功");
    }

    @Override
    @Transactional
    public Result delete(String citycode) {
        if (citycode == null || citycode.equals("")) {
            return Result.failure(FailureCode.CODE822);
        }
        int result;
        try {
            result = cityMapper.deleteByCitycode(citycode);
        } catch (Exception e) {
            log.warn("city delete: ", e);
            throw new BusinessException(FailureCode.CODE651);
        }
        if (result == 1) {
            try {
                RedisUtil.delKeys(Common.REDIS_KEY_CITY + citycode + "*");
                return Result.success("删除city信息成功");
            } catch (Exception e) {
                throw new BusinessException(FailureCode.CODE603);
            }
        } else {
            // result == 0
            return Result.failure(FailureCode.CODE823);
        }
    }

    @Override
    public Result getCityListByDto(int pageNum, int pageSize, CityDto dto) {
        Page<Object> page = PageHelper.startPage(pageNum, pageSize);
        List<City> cityList = cityMapper.getCityListByDto(dto);
        List<CityDto> dtoList = CityDto.acceptList(cityList);
        PageInfo pageInfo = new PageInfo(dtoList);
        pageInfo.setPageNum(pageNum);
        pageInfo.setTotal(page.getTotal());
        return Result.success(pageInfo);
    }

    @Override
    @Transactional
    public Result update(CityDto dto) {
        if (dto.getId() == null) {
            return Result.failure(FailureCode.CODE832);
        }
        if (dto.getCitycode() == null) {
            return Result.failure(FailureCode.CODE833);
        }
        int result;
        try {
            result = cityMapper.updateByPrimaryKeySelective(City.accept(dto));
        } catch (Exception e) {
            log.warn("city update: ", e);
            throw new BusinessException(FailureCode.CODE652);
        }
        // 这里的result值指的是查询到的数据条数（mysql执行返回的是Affected rows），也就是数据没更新result返回值也是1。
        if (result == 1) {
            try {
                RedisUtil.delKeys(Common.REDIS_KEY_CITY + dto.getCitycode() + "*");
            } catch (Exception e) {
                throw new BusinessException(FailureCode.CODE603);
            }
        }
        return Result.success("更新city信息成功");
    }

    @Override
    public Integer checkCityCode(String citycode) {
        return cityMapper.citycodeNum(citycode);
    }

    @Override
    public Result getAll() {
        List<City> cityList = cityMapper.getCityListByDto(new CityDto());
        cityList.sort(Comparator.comparing(City::getPriority).reversed());
        List<String> citycodeList = buildingMapper.getCitycodeList();
        // 去除没有下属没有building的city
        cityList = cityList.stream().filter(city -> ArrayUtils.contains(citycodeList.toArray(), city.getCitycode())).collect(Collectors.toList());
        return Result.success(cityList);
    }


}
