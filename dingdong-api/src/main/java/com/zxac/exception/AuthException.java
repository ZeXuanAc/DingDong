package com.zxac.exception;

public class AuthException extends RuntimeException{

	private static final long serialVersionUID = 13344L;

	private String code;  //错误码

	public AuthException() {}

	public AuthException(FailureCode failureCode) {
		super(failureCode.getName());
		this.code = failureCode.getCode();
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}
}
