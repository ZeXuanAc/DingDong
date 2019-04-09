package com.zxac.controller;


import com.zxac.constant.Common;
import com.zxac.model.EquipmentStatusDto;
import com.zxac.model.RedisValue;
import com.zxac.model.Result;
import com.zxac.utils.JsonUtil;
import com.zxac.utils.RedisUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import redis.clients.jedis.Jedis;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;


@RestController
@Slf4j
public class RedisController {


    @GetMapping(value = "redis/get")
    public Result getRedisData(@RequestParam(value = "cityId") Integer cityId,
                               @RequestParam(value = "buildingId") Integer buildingId,
                               @RequestParam(value = "storeyId", required = false) Integer storeyId){
        String redisKeyPattern = Common.REDIS_KEY_CITY + cityId + Common.UNDERLINE + Common.REDIS_KEY_BUILDING + buildingId;
        if (storeyId != null && !storeyId.equals(0)) {
            redisKeyPattern += Common.UNDERLINE  + Common.REDIS_KEY_STOREY + storeyId;
        }
        redisKeyPattern += "*";
        Jedis jedis = null;
        List<EquipmentStatusDto> dtoList = null;
        try {
            jedis = RedisUtil.getJedis();
            if (jedis != null) {
                Set<String> keys = jedis.keys(redisKeyPattern);
                if (keys.size() > 0) {
                    String[] keysArray = keys.toArray(new String[0]);
                    List<String> valueList = jedis.mget(keysArray);
                    dtoList = valueList.stream().map(s -> {
                        RedisValue redisValue = JsonUtil.toBean(s, RedisValue.class);
                        return EquipmentStatusDto.builder().createTimeStr(redisValue.getCreateTimeStr())
                                .status(redisValue.getStatus()).cityId(cityId).buildingId(buildingId).build();
                    }).collect(Collectors.toList());
                    for (int i = 0; i < keysArray.length; i++) {
                        dtoList.get(i).setStoreyId(Integer.valueOf(keysArray[i].split(Common.UNDERLINE)[2].substring(Common.REDIS_KEY_STOREY.length())));
                        dtoList.get(i).setEqId(Integer.valueOf(keysArray[i].split(Common.UNDERLINE)[3].substring(Common.REDIS_KEY_EQ.length())));
                    }
                }
            } else {
                log.warn("jedis is null");
                return Result.failure(Common.FAILURE_CODE_600, "jedis is null");
            }
        } catch (Exception e) {
            log.error("redis 查询数据错误, redisKeyPattern: {}, {}", redisKeyPattern, e.getMessage());
            return Result.failure(Common.FAILURE_CODE_602, "redis 查询数据错误, redisKeyPattern: " + redisKeyPattern + ", " + e.getMessage());
        } finally {
            RedisUtil.close(jedis);
        }
        return Result.success(dtoList);
    }


    @GetMapping(value = "redis/set")
    public Result setRedisData (EquipmentStatusDto dto){
        String redisKey = Common.REDIS_KEY_CITY + dto.getCityId() + Common.UNDERLINE +
                Common.REDIS_KEY_BUILDING + dto.getBuildingId() + Common.UNDERLINE  +
                Common.REDIS_KEY_STOREY + dto.getStoreyId()+ Common.UNDERLINE  + Common.REDIS_KEY_EQ + dto.getEqId();
        Jedis jedis = null;
        RedisValue redisValue;
        try {
            jedis = RedisUtil.getJedis();
            if (jedis != null) {
                if (jedis.exists(redisKey)){
                    String value = jedis.get(redisKey);
                    redisValue = JsonUtil.toBean(value, RedisValue.class);
                    if (redisValue.getStatus().equals(dto.getStatus())) {
                        if (dto.getStatus().equals("0")) {
                            redisValue.setCreateTimeStr(dto.getCreateTimeStr());
                        }
                    } else {
                        redisValue.setStatus(dto.getStatus());
                        if (dto.getStatus().equals("0")) {
                            redisValue.setCreateTimeStr(dto.getCreateTimeStr());
                        }
                    }
                } else {
                    redisValue = RedisValue.builder().createTimeStr(dto.getCreateTimeStr()).status(dto.getStatus()).build();
                }
                jedis.set(redisKey, JsonUtil.toJson(redisValue));
            } else {
                log.warn("jedis is null");
                return Result.failure(Common.FAILURE_CODE_600, "jedis is null");
            }
        } catch (Exception e) {
            log.error("redis 数据更新存储错误, redisKey: {}, {}", redisKey, e.getMessage());
            return Result.failure(Common.FAILURE_CODE_601, "redis 数据更新存储错误, redisKey: " + redisKey + "----" + e.getMessage());
        } finally {
            RedisUtil.close(jedis);
        }
        return Result.success();
    }
}
