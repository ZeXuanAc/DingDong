package com.zxac.controller;


import com.zxac.constant.Common;
import com.zxac.model.EquipmentStatusDto;
import com.zxac.model.RedisValue;
import com.zxac.model.Result;
import com.zxac.utils.JsonUtil;
import com.zxac.utils.RedisUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import redis.clients.jedis.Jedis;


@RestController
@Slf4j
public class RedisController {


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
                            redisValue.setCreateTime(dto.getCreateTime());
                        }
                    } else {
                        redisValue.setStatus(dto.getStatus());
                        if (dto.getStatus().equals("0")) {
                            redisValue.setCreateTime(dto.getCreateTime());
                        }
                    }
                } else {
                    redisValue = RedisValue.builder().createTime(dto.getCreateTime()).status(dto.getStatus()).build();
                }
                jedis.set(redisKey, JsonUtil.toJson(redisValue));
            }
        } catch (Exception e) {
            log.error("redis 数据更新存储错误", e);
            return Result.failure(Common.FAILURE_CODE_500, "redis 数据更新存储错误");
        } finally {
            RedisUtil.returnResource(jedis);
        }
        return Result.success();
    }
}
