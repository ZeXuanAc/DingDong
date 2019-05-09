package com.zxac.service;

import com.zxac.model.Storey;

import java.util.List;

public interface StoreyService {

    /**
     * 得到该building下的storey
     * @param buildingId
     * @return
     */
    List<Storey> getStoreyList(Integer buildingId);


}
