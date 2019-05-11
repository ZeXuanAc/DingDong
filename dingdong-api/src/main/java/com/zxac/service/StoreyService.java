package com.zxac.service;

import com.zxac.dto.StoreyDto;
import com.zxac.model.Result;

public interface StoreyService {

    /**
     * 得到该building下的storey
     * @param buildingId
     * @return
     */
    Result getStoreyList(Integer buildingId);


    /**
     * 得到adminId下的storey信息，当admin的role为admin的时候获取全部信息
     * @param dto
     * @return
     */
    Result getStoreyList(int pageNum, int pageSize, StoreyDto dto);


    /**
     * 新增数据
     * @param dto
     * @return
     */
    Result insert(StoreyDto dto);

    /**
     * 删除storey
     * @param storeyId
     * @return
     */
    Result delete(Integer storeyId);

    /**
     * 更新数据
     * @param dto
     * @return
     */
    Result update(StoreyDto dto);

}
