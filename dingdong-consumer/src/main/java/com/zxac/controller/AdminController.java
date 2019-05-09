package com.zxac.controller;


import com.alibaba.dubbo.config.annotation.Reference;
import com.zxac.constant.Common;
import com.zxac.exception.BusinessException;
import com.zxac.exception.FailureCode;
import com.zxac.model.Result;
import com.zxac.service.AdminService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;

@RestController
@Slf4j
public class AdminController {

    @Reference(application = "${dubbo.application.id}", url = "dubbo://localhost:12345")
    private AdminService adminService;

    @GetMapping(value = "backEnd/login")
    public Result autoLogin(HttpServletRequest request, String username, String password){
        try {
            Result result = adminService.login(username, password);
            if (result.getCode().equals(Common.SUCCESS_CODE)) {
                request.getSession().setAttribute("token", result.getMsg());
                request.getSession().setAttribute("uid", result.getData());
            }
            return result;
        } catch (Exception e) {
            log.warn("admin login: ", e);
            throw new BusinessException(FailureCode.CODE790);
        }
    }


    @GetMapping(value = "admin/userInfo")
    public Result userInfo(HttpServletRequest request, String token){
        try {
            Integer uid = (Integer) request.getSession().getAttribute("uid");
            return adminService.userInfo(uid);
        } catch (Exception e) {
            log.warn("admin userInfo: ", e);
            throw new BusinessException(FailureCode.CODE794);
        }
    }

    @GetMapping(value = "admin/logout")
    public Result logout(HttpServletRequest request){
        try {
            request.getSession().removeAttribute("token");
            return Result.success("登出成功");
        } catch (Exception e) {
            log.warn("admin logout: ", e);
            throw new BusinessException(FailureCode.CODE797);
        }
    }

}
