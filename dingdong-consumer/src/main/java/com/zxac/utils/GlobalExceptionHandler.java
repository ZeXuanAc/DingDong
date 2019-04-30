package com.zxac.utils;

import com.zxac.exception.BusinessException;
import com.zxac.exception.FailureCode;
import com.zxac.model.Result;
import lombok.extern.slf4j.Slf4j;
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
            log.error("业务异常：" + e.getMessage());
            BusinessException businessException = (BusinessException)e;
            return Result.failure(businessException.getCode(), businessException.getMessage());
        }
        //未知错误
        return Result.failure(FailureCode.CODE1);
    }

}
