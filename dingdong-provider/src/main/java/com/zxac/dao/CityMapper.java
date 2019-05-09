package com.zxac.dao;


import com.zxac.dto.CityDto;
import com.zxac.model.City;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface CityMapper {
    int deleteByCitycode(@Param("citycode") String citycode);

    int insertSelective(City record);

    City selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(City record);

    List<City> getCityListByDto(CityDto dto);

    Integer citycodeNum(@Param("citycode") String citycode);
}
