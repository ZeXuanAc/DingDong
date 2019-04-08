package com.zxac.controller;


import com.zxac.model.Result;
import com.zxac.utils.RedisUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import redis.clients.jedis.Jedis;

import java.util.Set;

@RestController
@Slf4j
public class MainController {

    @GetMapping(value = "/keys")
    public Result hello () {
        Result result = new Result();
        Set<String> keys = null;
        Jedis jedis = null;
        try {
            jedis = RedisUtil.getJedis();
            keys = jedis.keys("*");
        } catch (Exception e) {
            log.error("获取 redis 失败");
            throw new RuntimeException("获取 redis 失败");
        } finally {
            RedisUtil.returnResource(jedis);
        }
        result.setData(keys);
        result.setCode("200");
        return result;
    }

}
