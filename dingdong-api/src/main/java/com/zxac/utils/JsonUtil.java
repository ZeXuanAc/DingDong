package com.zxac.utils;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;

import java.io.IOException;

@Slf4j
public class JsonUtil {

    private static ObjectMapper mapper = new ObjectMapper();

    public static ObjectMapper getMapper () {
        return mapper;
    }


    /**
     * 转换为json
     * @param bean
     * @return
     */
    public static String toJson(Object bean) {
        if (bean == null) {
            return null;
        }
        try {
            return mapper.writeValueAsString(bean);
        } catch (JsonProcessingException e) {
            log.warn("bean序列化失败：" + bean);
            throw new RuntimeException("bean序列化失败：" + bean);
        }
    }


    /**
     * 转换为bean
     * @param json
     * @param clazz
     * @param <T>
     * @return
     */
    public static <T> T toBean(String json, Class<T> clazz){
        if(json == null){
            return null;
        }
        try {
            return mapper.readValue(json, clazz);
        } catch (IOException e) {
            log.warn("bean反序列化失败：" + json);
            throw new RuntimeException("bean反序列化失败：" + json);
        }
    }

    /**
     * 反序列化字符串成为对象
     * @param json
     * @param valueTypeRef
     * @return
     */
    public static <T> T toBean(String json, TypeReference<T> valueTypeRef) {
        if (json == null) {
            return null;
        }
        try {
            return mapper.readValue(json, valueTypeRef);
        } catch (Exception e) {
            log.warn("bean反序列化失败：" + json);
            throw new RuntimeException("bean反序列化失败：" + json);
        }
    }

}
