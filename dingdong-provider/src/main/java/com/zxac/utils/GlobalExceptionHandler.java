package com.zxac.utils;

import com.zxac.model.Result;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@CrossOrigin  
@RestControllerAdvice  
public class GlobalExceptionHandler {  
  
     private static Logger LOGGER = LoggerFactory.getLogger(GlobalExceptionHandler.class);  
      
    @ExceptionHandler  
    public Result processException(Exception e, HttpServletRequest request, HttpServletResponse response){
          
        if(e instanceof MissingServletRequestParameterException){
            LOGGER.error("=======" + e.getMessage() + "=======");
            return Result.failure("400", e.getMessage());
        }
        LOGGER.error("=======" + e.getCause().getMessage() + "=======");
        return Result.failure("500", e.getMessage());
          
    }  
  
}  