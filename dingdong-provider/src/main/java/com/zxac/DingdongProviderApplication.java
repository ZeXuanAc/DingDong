package com.zxac;

import org.springframework.boot.WebApplicationType;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;

import javax.annotation.PostConstruct;
import java.util.TimeZone;

@SpringBootApplication()
public class DingdongProviderApplication {

    //设置时区 相差8小时
    @PostConstruct
    void started() {
        TimeZone.setDefault(TimeZone.getTimeZone("UTC"));
    }

    public static void main(String[] args) {
        //使用非 Web 环境启动 Spring容器，提供dubbo rpc 服务
        new SpringApplicationBuilder().sources(DingdongProviderApplication.class)
                .web(WebApplicationType.NONE)
                .run(args);
    }

}

