package com.zxac;

import org.springframework.boot.WebApplicationType;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;

@SpringBootApplication()
public class DingdongProviderApplication {

    public static void main(String[] args) {
        //使用非 Web 环境启动 Spring容器，提供dubbo rpc 服务
        new SpringApplicationBuilder().sources(DingdongProviderApplication.class)
                .web(WebApplicationType.NONE)
                .run(args);
    }

}

