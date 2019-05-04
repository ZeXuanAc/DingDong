package com.zxac.controller;


import com.zxac.constant.Common;
import com.zxac.dto.EquipmentStatusDto;
import com.zxac.exception.FailureCode;
import com.zxac.model.Result;
import com.zxac.utils.ObjectUtil;
import com.zxac.utils.RedisUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import redis.clients.jedis.Jedis;

import java.util.*;
import java.util.stream.Collectors;


@RestController
@Slf4j
public class RedisController {

    @GetMapping(value = "redis/get")
    public Result getRedisDataV2(@RequestParam(value = "citycode") String citycode,
                               @RequestParam(value = "buildingId") Integer buildingId,
                               @RequestParam(value = "storeyId", required = false) Integer storeyId,
                               @RequestParam(value = "gender", required = false) String gender){
        String redisKeyPattern = Common.REDIS_KEY_CITY + citycode + Common.UNDERLINE + Common.REDIS_KEY_BUILDING + buildingId;
        if (gender != null) {
            redisKeyPattern += Common.UNDERLINE + "[A," + getStoreyGenderCode(gender) + "]";
        } else {
            redisKeyPattern += "*";
        }
        if (storeyId != null && !storeyId.equals(0)) {
            redisKeyPattern += Common.UNDERLINE + Common.REDIS_KEY_STOREY + storeyId;
        }
        redisKeyPattern += "*";
        Jedis jedis = null;
        List<Map<String, String>> mapList = new ArrayList<>();
        Map<String, List<Map<String, String>>> storeyMap;
        try {
            jedis = RedisUtil.getJedis();
            if (jedis != null) {
                Set<String> keys = jedis.keys(redisKeyPattern);
                if (keys.size() > 0) {
                    for (String key : keys) {
                        Map<String, String> valueMap = jedis.hgetAll(key);
                        mapList.add(valueMap);
                    }
                }
            } else {
                log.warn("jedis is null, 请检查redis相关是否正常");
                return Result.failure(FailureCode.CODE600);
            }
        } catch (Exception e) {
            log.error("redis 查询数据错误, redisKeyPattern: {}, {}", redisKeyPattern, e.getMessage());
            return Result.failure(FailureCode.CODE602.getCode(), "redis 查询数据错误, redisKeyPattern: " + redisKeyPattern + ", " + e.getMessage());
        } finally {
            RedisUtil.close(jedis);
        }
        storeyMap = mapList.stream().collect(Collectors.groupingBy(map -> map.get("storeyId")));
        storeyMap.values().forEach(list -> list.sort(Comparator.comparing(map -> map.get("priority")))); // 根据priority对list内容排序
        Map<String, List<Map<String, String>>> finalMap = new LinkedHashMap<>();
        // 根据map中的list排序
        storeyMap.entrySet().stream().sorted(Comparator.comparing(map -> map.getValue().get(0).get("storeyPriority"))).forEach(e -> finalMap.put(e.getKey(), e.getValue()));
        return Result.success(finalMap);
    }


    @GetMapping(value = "redis/set")
    public Result setRedisDataV2 (EquipmentStatusDto dto){
        String redisKey = Common.REDIS_KEY_CITY + dto.getCitycode() + Common.UNDERLINE +
                Common.REDIS_KEY_BUILDING + dto.getBuildingId() + Common.UNDERLINE  +
                getStoreyGenderCode(dto.getStoreyGender()) + Common.UNDERLINE  +
                Common.REDIS_KEY_STOREY + dto.getStoreyId() + Common.UNDERLINE  +
                Common.REDIS_KEY_EQ + dto.getEqId();
        Jedis jedis = null;
        Map<String, String> param = new HashMap<>();
        try {
            jedis = RedisUtil.getJedis();
            if (jedis != null) {
                if (jedis.exists(redisKey)){
                    String status = jedis.hget(redisKey, "status");
                    if (status.equals(dto.getStatus())) {
                        if (dto.getStatus().equals("0")) {
                            param.put("createTimeStr", dto.getCreateTimeStr());
                        }
                    } else {
                        param.put("status", dto.getStatus());
                        if (dto.getStatus().equals("0")) {
                            param.put("createTimeStr", dto.getCreateTimeStr());
                        }
                    }
                } else {
                    param = ObjectUtil.toMap(dto, String.class, "cityId");
                }
                if (param.size() == 1) {
                    jedis.hset(redisKey, param);
                } else if (param.size() > 1){
                    jedis.hmset(redisKey, param);
                }
            } else {
                log.warn("jedis is null");
                return Result.failure(FailureCode.CODE600);
            }
        } catch (Exception e) {
            log.error("redis 数据更新存储错误, redisKey: {}, {}", redisKey, e.getMessage());
            if (jedis != null) {
                jedis.del(redisKey);
                log.info("该 redisKey {} 更新失败，删除", redisKey);
            }
            return Result.failure(FailureCode.CODE601.getCode(), "redis 数据更新存储错误, redisKey: " + redisKey + "----" + e.getMessage());
        } finally {
            RedisUtil.close(jedis);
        }
        return Result.success();
    }


    // gender 为 0，1，2
    private String getStoreyGenderCode (String gender) {
        String storeyGenderCode = Common.REDIS_KEY_STOREY_ALL;
        if ("1".equals(gender)) {
            storeyGenderCode = Common.REDIS_KEY_STOREY_MALE;
        } else if ("2".equals(gender)) {
            storeyGenderCode = Common.REDIS_KEY_STOREY_FEMALE;
        }
        return storeyGenderCode;
    }

}
