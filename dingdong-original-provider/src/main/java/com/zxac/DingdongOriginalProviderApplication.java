package com.zxac;

import org.springframework.boot.WebApplicationType;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;

@SpringBootApplication()
public class DingdongOriginalProviderApplication {

    public static void main(String[] args) {
        new SpringApplicationBuilder().sources(DingdongOriginalProviderApplication.class)
                .web(WebApplicationType.NONE)
                .run(args);
    }

}

