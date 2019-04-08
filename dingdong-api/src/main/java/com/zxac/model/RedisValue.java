package com.zxac.model;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 * redis 数据存储格式
 */
@ToString
@Getter
@Setter
@Builder
public class RedisValue {

    private String status;

    private String createTime;
}
