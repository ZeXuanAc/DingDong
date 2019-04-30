package com.zxac.exception;

public enum FailureCode {

    CODE1("-1", "系统错误"),

    CODE500("500", "服务器繁忙"),

    // redis 相关
    CODE600("600", "jedis is null, 请检查redis相关是否正常"),
    CODE601("601", "redis 更新错误"),
    CODE602("602", "jedis is null"),

    // 登陆相关错误
    CODE700("700", "登陆异常"),
    CODE701("701", "redis token不存在或者过期"),
    CODE702("702", "phone为空或格式错误"),
    CODE703("703", "用户名或密码错误"),
    CODE704("704", "注册前请填写完整相关信息"),
    CODE705("705", "注册异常"),
    CODE706("706", "自动登陆异常"),
    CODE707("707", "请输入密码"),
    CODE708("708", "账号已存在，请使用其他手机号注册"),
    CODE709("709", "注册中数据插入失败"),
    CODE710("710", "自动登陆token为空"),
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
