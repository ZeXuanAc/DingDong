package com.zxac.service;

import com.zxac.model.Result;

public interface StoreyService {

    /**
     * 得到该building下的storey
     * @param buildingId
     * @return
     */
    Result getStoreyList(Integer buildingId);


}
