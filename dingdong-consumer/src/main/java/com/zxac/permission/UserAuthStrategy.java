package com.zxac.permission;

import org.apache.commons.lang3.ArrayUtils;
import org.springframework.stereotype.Component;

/**
 *
 * 用户权限控制策略算法实现类
 * @author TanRq
 *
 */
@Component
public class UserAuthStrategy implements AuthStrategy {

	@Override
	public boolean executeAuth(Module[] modules, String role) throws Exception {

		// 如果角色是admin，则该注释下的所有方法都能访问
		if (ArrayUtils.contains(role.split(","), "admin")) {
			return true;
		}
		// 不是admin角色，如果module是admin则返回false
		return !ArrayUtils.contains(modules, Module.ADMIN);
	}

}

