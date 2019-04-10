package com.zxac.constant;

public class Common {

    public static final boolean SUCCESS = true;
    public static final boolean FAILURE = false;

    // 成功代码
    public static final String SUCCESS_CODE = "200";

    // 默认错误代码，500 表示服务端错误
    public static final String FAILURE_CODE_500 = "500";

    // 默认错误代码，6~ 表示redis错误
    public static final String FAILURE_CODE_600 = "600"; // jedis is null
    public static final String FAILURE_CODE_601 = "601"; // redis 更新错误
    public static final String FAILURE_CODE_602 = "602"; // redis 查询错误

    // redis key 的代号
    public static final String REDIS_KEY_CITY = "C";
    public static final String REDIS_KEY_BUILDING = "B";
    public static final String REDIS_KEY_STOREY = "S";
    public static final String REDIS_KEY_EQ = "E";
    public static final String UNDERLINE = "_";

    // 阿里云ip, redis端口
//    public static String IP = "47.107.118.14";
    public static String IP = "127.0.0.1";
    public static int PORT = 6380;
    public static String AUTH = "czx";

}
