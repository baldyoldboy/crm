package com.user.crm.settings.controller;

import com.user.crm.commons.constant.Const;
import com.user.crm.commons.pojo.ReturnObject;
import com.user.crm.commons.utils.DateUtils;
import com.user.crm.settings.pojo.User;
import com.user.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Date;

/**
 * @ClassName UserController
 * @Description
 * @Author 14036
 * @Version: 1.0
 */
@Controller
public class UserController {
    @Autowired
    private UserService userService;

    /**
     * 十天免登入 根据判断cookie
     * @param request
     * @return
     */
    @RequestMapping("/settings/qx/user/toLogin")
    public String toLogin(HttpServletRequest request){
        Cookie[] cookies = request.getCookies();
        if (cookies!=null){
            //获得十天免登入的cookie 中的账号和密码
            String loginAct = null;
            String loginPwd = null;
            for (Cookie cookie : cookies) {
                if ("loginAct".equals(cookie.getName())) {
                        loginAct = cookie.getValue();
                }
                if ("loginPwd".equals(cookie.getName())){
                    loginPwd = cookie.getValue();
                }
            }
            User user = null;
            if (loginAct!=null&&loginPwd!=null){
                //验证登入
                user = userService.queryUserByLoginActAndPwd(loginAct, loginPwd);
            }
            if (user!=null){
                //验证成功
                //重定向
                return "redirect:/workbench/index";
            }else {
                //跳转到index
                return "settings/qx/user/login";
            }
        }else {
            //跳转到index
            return "settings/qx/user/login";
        }
    }

    /**
     * 登入功能
     * @param loginAct
     * @param loginPwd
     * @param isRemPwd
     * @param request
     * @param response
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/settings/qx/user/login",method = RequestMethod.POST)
    public Object login(String loginAct, String loginPwd, boolean isRemPwd, HttpServletRequest request, HttpServletResponse response){
        //调用Service层查询用户
        User user = userService.queryUserByLoginActAndPwd(loginAct, loginPwd);
        ReturnObject returnObject = new ReturnObject();
        //根据查询结果生成响应信息
        if (user !=null){
            //进一步判断账号是否合法
            //user.getExpireTime()   //2019-10-20
            //        new Date()     //2020-09-10
            //排除掉不合法的，剩下的就都是合法的
            //现在的时间大于到期时间
            if (DateUtils.formatDate(new Date()).compareTo(user.getExpireTime())>0){
                //用户已过期
                returnObject.setCode(Const.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("用户已过期！");
                
            } else if (Const.ACCOUNT_LOCK_STATE.equals(user.getLockState())) {
                //账号被锁定
                returnObject.setCode(Const.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("账号被锁定！");
            } else if (!user.getAllowIps().contains(request.getRemoteAddr())) {
                //ip受限
                returnObject.setCode(Const.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("ip受限！");
            }else {
                //账号合法
                returnObject.setCode(Const.RETURN_OBJECT_CODE_SUCCESSFUL);

                //将user存入session
                HttpSession session = request.getSession();
                session.setAttribute(Const.LOGIN_SESSION_USER, user);

                //判断是否记住密码
                if (isRemPwd){
                    //创建cookie
                    Cookie cookie = new Cookie("JSESSIONID",request.getSession().getId());
                    Cookie cookie1 = new Cookie("loginAct",user.getLoginAct());
                    Cookie cookie2 = new Cookie("loginPwd", user.getLoginPwd());
                    //设置cookie
                    cookie.setMaxAge(10*24*3600);
                    cookie1.setMaxAge(10*24*3600);
                    cookie2.setMaxAge(10*24*3600);
                    cookie.setPath(request.getContextPath());
                    cookie1.setPath(request.getContextPath());
                    cookie2.setPath(request.getContextPath());
                    //响应给浏览器
                    response.addCookie(cookie);
                    response.addCookie(cookie1);
                    response.addCookie(cookie2);
                }else {
                    //创建cookie
                    Cookie cookie1 = new Cookie("loginAct","1");
                    Cookie cookie2 = new Cookie("loginPwd", "1");
                    //清除cookie
                    cookie1.setMaxAge(0);
                    cookie2.setMaxAge(0);
                    cookie1.setPath(request.getContextPath());
                    cookie2.setPath(request.getContextPath());
                    //响应给浏览器
                    response.addCookie(cookie1);
                    response.addCookie(cookie2);
                }

            }
        }else {
            //账号或密码错误
            returnObject.setCode(Const.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("账号或密码错误！");
        }

        return returnObject;
    }

    /**
     * 安全退出
     * @param request
     * @return
     */
    @RequestMapping("/settings/qx/user/quit")
    public String quit(HttpServletRequest request,HttpServletResponse response){
        //获取Cookie
        Cookie[] cookies = request.getCookies();
        for (Cookie cookie : cookies) {
            if ("loginAct".equals(cookie.getName())|| "loginPwd".equals(cookie.getName()) ||"JSESSIONID".equals(cookie.getName())) {
                cookie.setMaxAge(0);
                cookie.setPath(request.getContextPath());
                response.addCookie(cookie);
            }
        }
        //销毁Session
        request.getSession().invalidate();

        //重定向到首页
        return "redirect:/";

    }
}
