package com.zxac.model;

import lombok.*;

/**
 * redis 数据存储格式
 */
@ToString
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RedisValue {

    private String status;

    private String createTimeStr;

}
