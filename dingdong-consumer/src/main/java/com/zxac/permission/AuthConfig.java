package com.zxac.permission;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.zxac.exception.FailureCode;
import com.zxac.model.Result;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.Signature;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.OutputStream;
import java.lang.reflect.Method;

/**
 * 权限认证配置，利用切面技术
 *
 */
@Aspect
@Component
@Slf4j
public class AuthConfig {

	@Autowired
	private AuthStrategy authStrategy;

	@Around("execution(* com.zxac.controller..*.*(..))")
	public Object executeAround(ProceedingJoinPoint jp) throws Throwable{
		//获取RequestAttributes
	    RequestAttributes requestAttributes = RequestContextHolder.getRequestAttributes();
	    //从获取RequestAttributes中获取HttpServletRequest的信息
	    HttpServletRequest request = (HttpServletRequest) requestAttributes.resolveReference(RequestAttributes.REFERENCE_REQUEST);
	    HttpServletResponse response = ((ServletRequestAttributes)requestAttributes).getResponse();

		String role = (String) request.getSession().getAttribute("role");

	    Signature signature = jp.getSignature();
	    MethodSignature methodSignature = (MethodSignature)signature;
	    Method targetMethod = methodSignature.getMethod();

	    Method realMethod = jp.getTarget().getClass().getDeclaredMethod(signature.getName(), targetMethod.getParameterTypes());

	    Object obj = null;

	    if(isHasPermission(realMethod, role)) {
	    	obj =  jp.proceed();//用户拥有该方法权限时执行方法里面的内容
	    } else {//用户没有权限，则直接返回没有权限的通知
	    	response.setHeader("Content-type","application/json; charset=UTF-8");
	    	OutputStream outputStream = response.getOutputStream();
			Result result = Result.failure(FailureCode.CODE530);
	    	outputStream.write(new ObjectMapper().writeValueAsString(result).getBytes("UTF-8"));
	    }
	    return obj;
	}

	/**
	 * 判断用户是否拥有权限, 如果没有PermissionModule 注释，则默认不受权限控制，直接访问，如果有PermissionModule注释，再根据role判断是否存在权限
	 * @param realMethod
	 * @param role
	 * @return
	 */
	private boolean isHasPermission(Method realMethod, String role) {
		try {
			if(realMethod.isAnnotationPresent(PermissionModule.class)) {
				PermissionModule permissionModule = realMethod.getAnnotation(PermissionModule.class);
				Module[] modules = permissionModule.belong();
				//执行权限策略，判断用户权限
				return new AuthContext(authStrategy).execute(modules, role);
			}
			return true;
		}catch(Exception e) {
			log.warn(e.getMessage());
			return false;
		}
	}
}

