package com.zxac.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Component;

@Component
@PropertySource(value = "classpath:config/url_connection.properties")
public class UrlConfig {

    @Value("${redis_set}")
    public String redisSetUrl;

}
