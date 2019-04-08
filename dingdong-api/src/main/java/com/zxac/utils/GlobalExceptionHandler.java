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
    public Result processException(Exception ex, HttpServletRequest request, HttpServletResponse response){
          
        if(ex instanceof MissingServletRequestParameterException){
            LOGGER.error("=======" + ex.getMessage() + "=======");
            return Result.failure("400", ex.getMessage());
        }
        return Result.failure("500", ex.getMessage());
          
    }  
  
}  