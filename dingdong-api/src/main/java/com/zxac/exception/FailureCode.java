package com.zxac.exception;

public enum FailureCode {

    CODE1("-1", "系统错误"),

    CODE500("500", "服务器繁忙"),
    CODE501("501", "location地址格式错误"),


    // redis 相关
    CODE600("600", "jedis is null, 请检查redis相关是否正常"),
    CODE601("601", "redis 更新错误"),
    CODE602("602", "jedis is null"),
    CODE603("603", "jedis 删除key异常"),

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

    // 用户相关
    CODE750("750", "用户信息修改异常"),
    CODE751("751", "mysql 用户信息修改错误"),
    CODE752("752", "修改用户信息请携带用户id"),
    CODE753("753", "修改redis用户信息错误"),
    CODE754("754", "修改用户信息请携带用户token"),

    CODE770("770", "关注building失败，参数错误"),
    CODE771("771", "关注building失败，mysql插入错误"),
    CODE772("772", "已关注此building"),
    CODE773("773", "关注building异常"),

    CODE775("775", "取消关注失败，参数错误"),
    CODE776("776", "取消关注失败, mysql数据错误（不存在或存在多条）"),
    CODE777("777", "取消关注失败, 删除失败"),
    CODE778("778", "取消关注异常"),

    CODE779("779", "查询是否已关注失败，参数异常"),
    CODE780("780", "查询是否已关注异常"),
    CODE785("785", "查询allFollowBuilding异常"),
    CODE786("786", "查询allFollowBuilding失败，参数异常"),

    CODE790("790", "管理员--登陆失败"),
    CODE791("791", "管理员--登陆缺失参数"),
    CODE794("794", "管理平台--获取用户信息失败"),
    CODE795("795", "管理平台--获取用户信息失败--参数缺失"),
    CODE796("796", "管理平台--获取用户信息失败--查询用户为空"),
    CODE797("797", "管理平台--登出用户失败"),
    CODE799("799", "管理平台--获取用户数异常"),

    // city接口相关
    CODE800("800", "管理平台--查询cityList异常"),
    CODE810("810", "管理平台--新增city异常"),
    CODE811("811", "管理平台--新增city失败--插入mysql数据异常"),
    CODE812("812", "管理平台--新增city失败--请携带name和citycode"),
    CODE813("813", "管理平台--新增city失败--该citycode已存在"),
    CODE820("820", "管理平台--删除city异常"),
    CODE821("821", "管理平台--删除city异常--删除mysql数据异常"),
    CODE822("822", "管理平台--删除city失败--请携带正确citycode"),
    CODE823("823", "管理平台--删除city失败--数据库无此citycode数据"),
    CODE830("830", "管理平台--更新city异常"),
    CODE831("831", "管理平台--更新city失败--更新mysql数据异常"),
    CODE832("832", "管理平台--更新city失败--请携带正确cityId"),
    CODE833("833", "管理平台--更新city失败--请携带正确citycode"),


    // 权限相关
    CODE900("900", "admin平台无token参数或token失效"),

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
