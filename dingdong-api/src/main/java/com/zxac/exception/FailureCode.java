package com.zxac.exception;

public enum FailureCode {

    CODE1("-1", "系统错误"),

    CODE500("500", "服务器繁忙"),
    CODE501("501", "location地址格式错误"),
    CODE510("510", "参数绑定错误（请检查数据类型）"),
    // 权限相关
    CODE520("520", "admin平台无token参数或token失效"),
    CODE530("530", "权限校验失败"),

    // redis 相关
    CODE600("600", "jedis is null, 请检查redis相关是否正常"),
    CODE601("601", "redis 更新错误"),
    CODE602("602", "jedis is null"),
    CODE603("603", "jedis 删除key异常"),

    // 通用
    CODE650("650", "管理平台--新增数据失败--mysql插入异常"),
    CODE651("651", "管理平台--删除数据失败--mysql删除异常"),
    CODE652("652", "管理平台--更新数据失败--mysql更新异常"),

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

    // city接口相关 （800 ~ 849）
    CODE800("800", "管理平台--查询cityList异常"),
    CODE810("810", "管理平台--新增city异常"),
    CODE812("812", "管理平台--新增city失败--请携带name和citycode"),
    CODE813("813", "管理平台--新增city失败--该citycode已存在"),
    CODE820("820", "管理平台--删除city异常"),
    CODE822("822", "管理平台--删除city失败--请携带正确citycode"),
    CODE823("823", "管理平台--删除city失败--数据库无此citycode数据"),
    CODE830("830", "管理平台--更新city异常"),
    CODE832("832", "管理平台--更新city失败--请携带正确cityId"),
    CODE833("833", "管理平台--更新city失败--请携带正确citycode"),

    // building 相关 （850 ~ 899）
    CODE850("850", "管理平台--查询building失败--请携带正确adminId"),
    CODE851("851", "管理平台--新增building失败--请携带完整参数"),
    CODE852("852", "管理平台--新增building异常"),
    CODE853("853", "管理平台--新增building失败--admin-building插入异常"),
    CODE858("858", "管理平台--buildingId不能为空"),
    CODE860("860", "管理平台--删除building失败--请先删除该building相关storey数据"),
    CODE861("861", "管理平台--删除building异常"),
    CODE865("865", "管理平台--更新building异常"),
    CODE866("866", "管理平台--获取buildingList信息（adminId）异常"),


    // storey 相关 （900 ~ 949）
    CODE900("900", "管理平台--查询storey信息异常"),


    // equipment 相关 (950 ~ 999 )



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
