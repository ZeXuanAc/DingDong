package com.zxac.dao;

import com.zxac.dto.BuildingFollowDto;
import com.zxac.model.BuildingFollow;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface BuildingFollowMapper {
    int deleteByPrimaryKey(Integer id);

    int insertSelective(BuildingFollow record);

    BuildingFollow selectByPrimaryKey(Integer id);

    int selectCountByUidBuildingId(@Param("uid") Integer uid, @Param("buildingId") Integer buildingId);

    int deleteByUidBuildingId(@Param("uid") Integer uid, @Param("buildingId") Integer buildingId);

    List<BuildingFollowDto> allFollowBuilding(@Param("uid") Integer uid);
}
