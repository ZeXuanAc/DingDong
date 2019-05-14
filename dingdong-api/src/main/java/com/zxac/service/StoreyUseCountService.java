package com.zxac.service;

import com.zxac.model.Result;

public interface StoreyUseCountService {

    /**
     * 执行任务
     * @return
     */
    void doTask();

    /**
     * 得到数据
     * @return
     */
    Result getStoreyUseCountList(Integer buildingId, String endTime);


}
