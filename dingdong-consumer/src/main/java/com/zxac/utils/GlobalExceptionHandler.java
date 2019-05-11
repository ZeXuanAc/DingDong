package com.zxac.utils;

import com.zxac.exception.AuthException;
import com.zxac.exception.BusinessException;
import com.zxac.exception.FailureCode;
import com.zxac.model.Result;
import lombok.extern.slf4j.Slf4j;
import org.springframework.validation.BindException;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import javax.servlet.http.HttpServletRequest;


@CrossOrigin
@RestControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

    @ExceptionHandler
    @ResponseBody
    public <T> Result<?> defaultExceptionHandler(HttpServletRequest request, Exception e) {
        e.printStackTrace();
        if(e instanceof BusinessException) {
            log.warn("业务异常：" + e.getMessage());
            BusinessException businessException = (BusinessException)e;
            return Result.failure(businessException.getCode(), businessException.getMessage());
        }
        if(e instanceof AuthException) {
//            log.warn("权限异常：" + e.getMessage());
            AuthException authException = (AuthException)e;
            return Result.failure(authException.getCode(), authException.getMessage());
        }
        if(e instanceof BindException) {
            log.warn("参数绑定错误：" + e.getMessage());
            return Result.failure(FailureCode.CODE510);
        }
        //未知错误
        return Result.failure(FailureCode.CODE1);
    }

}
