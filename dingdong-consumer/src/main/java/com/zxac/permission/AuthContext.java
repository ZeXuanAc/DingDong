package com.zxac.permission;

/**
 * 权限策略上下文控制类
 * @author TanRq
 *
 */
public class AuthContext {

	private AuthStrategy authStrategy;

	public AuthContext(AuthStrategy strategy) {
		this.authStrategy = strategy;
	}

	/**
	 * 执行策略
	 *
	 * @param modules
	 * @param role
	 * @return
	 * @throws Exception
	 */
	public boolean execute(Module[] modules, String role) throws Exception {
		return this.authStrategy.executeAuth(modules, role);
	}

}
