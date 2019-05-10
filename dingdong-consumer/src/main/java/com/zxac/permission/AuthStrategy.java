package com.zxac.permission;

/**
 * 策略接口，所有策略都应该实现的接口
 *
 */
public interface AuthStrategy {

	boolean executeAuth(Module[] modules, String role) throws Exception;

}
