package com.sojson.user.controller;

import com.sojson.common.controller.BaseController;
import com.sojson.common.model.UUser;
import com.sojson.common.utils.LoggerUtils;
import com.sojson.core.shiro.token.manager.TokenManager;
import com.sojson.user.service.UUserService;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.DisabledAccountException;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * @Author: hsq.
 * @Description:
 * @Date:Created in 2018/1/9 17:16.
 * @Modified By:
 */
@Controller
@RequestMapping(value = "/uLogin")
public class LoginHandler extends BaseController{

    /**
     * 页面根路径.
     */
    private static final String UI_PATH = "/user/";

    @Resource
    UUserService userService;

    /**
     * 登录跳转
     * @return
     */
    @RequestMapping(value="/login",method= RequestMethod.GET)
    public ModelAndView login(){
        return new ModelAndView(UI_PATH+"login");
    }

    @RequestMapping(value="/submitLogin",method=RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> submitLogin(UUser uUser, Boolean rememberMe, HttpServletRequest request){
        Subject currUser = SecurityUtils.getSubject();
        try{
            if (!currUser.isAuthenticated()){
                UUser user = TokenManager.login(uUser,rememberMe);
                if (user != null){
                    resultMap.put("status", 200);
                    resultMap.put("message", "登录成功");
                }
            }
        }catch (DisabledAccountException e) {
            resultMap.put("status", 500);
            resultMap.put("message", "帐号已经禁用。");
        } catch (Exception e) {
            resultMap.put("status", 500);
            resultMap.put("message", "帐号或密码错误");
        }

        return  resultMap;
    }

    @RequestMapping(value="/success",method=RequestMethod.GET)
    @ResponseBody
    public ModelAndView success(){
        return new ModelAndView(UI_PATH+"success");
    }

    /**
     * 退出
     * @return
     */
    @RequestMapping(value="logout",method =RequestMethod.GET)
    @ResponseBody
    public Map<String,Object> logout(){
        try {
            TokenManager.logout();
            resultMap.put("status", 200);
        } catch (Exception e) {
            resultMap.put("status", 500);
            logger.error("errorMessage:" + e.getMessage());
            LoggerUtils.fmtError(getClass(), e, "退出出现错误，%s。", e.getMessage());
        }
        return resultMap;
    }
}
