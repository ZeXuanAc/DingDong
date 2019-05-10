package com.zxac.service;

import com.zxac.dto.CityDto;
import com.zxac.model.Result;

public interface CityService {

    /**
     * 新增数据
     * @param dto
     * @return
     */
    Result insert(CityDto dto);

    /**
     * 删除city
     * @param citycode
     * @return
     */
    Result delete(String citycode);

    /**
     * 筛选得到城市列表
     * @return
     */
    Result getCityListByDto(int pageNum, int pageSize, CityDto dto);


    /**
     * 更新数据
     * @param dto
     * @return
     */
    Result update(CityDto dto);

    /**
     * 检查是否存在此citycode
     * @return
     */
    Integer checkCityCode(String citycode);

    /**
     * 得到所有city信息
     * @return
     */
    Result getAll();

}
