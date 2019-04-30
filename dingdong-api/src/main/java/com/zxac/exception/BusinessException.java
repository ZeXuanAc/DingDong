package com.zxac.exception;

public class BusinessException extends RuntimeException{

	private static final long serialVersionUID = 1L;

	private String code;  //错误码

	public BusinessException() {}

	public BusinessException(FailureCode failureCode) {
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
