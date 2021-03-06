package com.zxac.utils;

import com.zxac.constant.Common;
import com.zxac.exception.BusinessException;
import com.zxac.exception.FailureCode;
import lombok.extern.slf4j.Slf4j;
import redis.clients.jedis.*;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;


@Slf4j
public final class RedisUtil {

    // token过期时间，单位为秒, 默认为30天
    public static int tokenExpire = 30 * 24 * 60 * 60;

    // Redis服务器IP
    private static String ADDR = Common.IP;

    // Redis的端口号
    private static int PORT = Common.PORT;

    // 访问密码
    private static String AUTH = Common.AUTH;

    // 可用连接实例的最大数目，默认值为8；
    // 如果赋值为-1，则表示不限制；如果pool已经分配了maxActive个jedis实例，则此时pool的状态为exhausted(耗尽)。
    private static int MAX_ACTIVE = 1024;

    // 控制一个pool最多有多少个状态为idle(空闲的)的jedis实例，默认值也是8。
    private static int MAX_IDLE = 200;

    // 等待可用连接的最大时间，单位毫秒，默认值为-1，表示永不超时。如果超过等待时间，则直接抛出JedisConnectionException；
    private static int MAX_WAIT = 10000;

    private static int TIMEOUT = 10000;

    // 在borrow一个jedis实例时，是否提前进行validate操作；如果为true，则得到的jedis实例均是可用的；
    private static boolean TEST_ON_BORROW = true;

    private static JedisPool jedisPool = null;

    /*
      初始化Redis连接池
     */
    static {
        try {
            JedisPoolConfig config = new JedisPoolConfig();
            config.setMaxTotal(MAX_ACTIVE);
            config.setMaxIdle(MAX_IDLE);
            config.setMaxWaitMillis(MAX_WAIT);
            config.setTestOnBorrow(TEST_ON_BORROW);
            jedisPool = new JedisPool(config, ADDR, PORT, TIMEOUT, AUTH);
        } catch (Exception e) {
            log.error("初始化 jedisPool 失败", e.getMessage());
        }
    }

    /**
     * 获取Jedis实例
     * @return
     */
    public synchronized static Jedis getJedis() {
        try {
            if (jedisPool != null) {
                return jedisPool.getResource();
            } else {
                return null;
            }
        } catch (Exception e) {
            log.error("获取 jedis 失败", e.getMessage());
            return null;
        }
    }

    /**
     * 关闭jedis连接
     * @param jedis
     */
    public static void close (Jedis jedis) {
        if (jedis != null) {
            jedis.close();
        }
    }

    public static Map<String, Response<Map<String, String>>> getKeys (String pattern) {
        Jedis jedis = null;
        try {
            jedis = RedisUtil.getJedis();
            if (jedis != null) {
                Pipeline pipeline = jedis.pipelined();
                Set<String> keys = jedis.keys(pattern);
                Map<String, Response<Map<String,String>>> responses = new HashMap<>(keys.size());
                keys.forEach(key -> responses.put(key, pipeline.hgetAll(key)));
                pipeline.sync();
                return responses;
            } else {
                log.error("jedis is null");
                throw new BusinessException(FailureCode.CODE600);
            }
        } catch (Exception e) {
            log.error("获取redis key异常, pattern: ", pattern);
            throw new BusinessException(FailureCode.CODE604);
        } finally {
            close(jedis);
        }
    }

    /**
     * 删除多个key
     * @param pattern
     */
    public static void delKeys (String pattern) {
        Jedis jedis = null;
        try {
            jedis = RedisUtil.getJedis();
            if (jedis != null) {
                Pipeline pipeline = jedis.pipelined();
                Set<String> keys = jedis.keys(pattern);
                String[] keysArr = new String[keys.size()];
                pipeline.del(keys.toArray(keysArr));
                pipeline.sync();
            } else {
                log.error("jedis is null");
                throw new BusinessException(FailureCode.CODE600);
            }
        } catch (Exception e) {
            log.error("删除redis key异常, pattern: ", pattern);
            throw new BusinessException(FailureCode.CODE603);
        } finally {
            close(jedis);
        }
    }


    /**
     * 关闭jedisPool
     * @param jedis
     */
    public static void returnResource(final Jedis jedis) {
        if (jedis != null) {
            jedisPool.close();
        }
    }
}
