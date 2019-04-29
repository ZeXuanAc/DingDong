package com.zxac.exception;

public enum FailureCode {

    CODE600("600", "jedis is null, 请检查redis相关是否正常"),

    CODE601("601", "redis 更新错误"),

    CODE602("602", "jedis is null")
    ;

    private String name;
    private String code;

    FailureCode(String code, String name) {
        this.name = name;
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public String getCode() {
        return code;
    }

    @Override
    public String toString() {
        return this.code + "_" + this.name;
    }

}
