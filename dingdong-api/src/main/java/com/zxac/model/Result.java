package com.zxac.model;


import com.zxac.constant.Common;
import com.zxac.exception.FailureCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;

/**
 *  统一消息结果格式
 */

@Getter
@Setter
@ToString
@NoArgsConstructor
public class Result<T> implements Serializable {

    // 返回状态
    private boolean success;

    // 结果返回代码
    private String code;

    // 返回时的消息
    private String msg;

    // 结果携带的数据包
    private T data;


    public Result(boolean success, String code, String msg, T data) {
        this.success = success;
        this.code = code;
        this.msg = msg;
        this.data = data;
    }


    public static Result success () {
        return success("");
    }

    public static Result success (String msg) {
        return success(msg, null);
    }

    public static <T> Result success (T data) {
        return success("", data);
    }

    public static <T> Result success (String msg, T data) {
        return success(Common.SUCCESS_CODE, msg, data);
    }

    public static <T> Result<T> success (String code, String msg, T data) {
        return new Result<>(Common.SUCCESS, code, msg, data);
    }

    public static Result failure () {
        return failure("");
    }

    public static Result failure (String msg) {
        return failure(FailureCode.CODE500.getCode(), msg);
    }

    public static Result failure (FailureCode failureCode) {
        return failure(failureCode.getCode(), failureCode.getName(), null);
    }

    public static Result failure (String code, String msg) {
        return failure(code, msg, null);
    }

    public static <T> Result<T> failure (String code, String msg, T data) {
        return new Result<>(Common.FAILURE, code, msg, data);
    }

}
