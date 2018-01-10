package com.sojson.user.controller;

import com.sojson.common.controller.BaseController;
import com.sojson.common.model.UUser;
import com.sojson.core.shiro.token.manager.TokenManager;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;

/**
 * @Author: hsq.
 * @Description:
 * @Date:Created in 2018/1/9 17:16.
 * @Modified By:
 */
@Controller
@RequestMapping(value = "/user")
public class LoginHandler extends BaseController{

    /**
     * 登录跳转
     * @return
     */
    @RequestMapping(value="/login",method= RequestMethod.GET)
    public ModelAndView login(){
        return new ModelAndView("/login");
    }

    @RequestMapping(value="/submitLogin",method=RequestMethod.POST)
    @ResponseBody
    public Object submitLogin(String pswd, String email, Boolean rememberMe, HttpServletRequest request){
        Subject currUser = SecurityUtils.getSubject();
        UUser uUser = new UUser();
        uUser.setPswd(pswd);
        uUser.setEmail(email);
        if (!currUser.isAuthenticated()){
            UUser user = TokenManager.login(uUser,rememberMe);
            if (user == null){
                return "登录失败";
            }
        }
        return  "登录成功";
    }
}
