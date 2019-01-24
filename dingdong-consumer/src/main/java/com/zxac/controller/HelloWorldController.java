package com.zxac.controller;


import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloWorldController {


    @GetMapping(value = "/")
    public Object hello () {
        return "hello world";
    }


    @GetMapping(value = "hello1")
    public Object hello1 (@RequestParam(value = "name", required = false) String name,
                          @RequestParam(value = "age", required = false) Integer age) {
        return "name: " + name + " age: " + age;
    }
}
