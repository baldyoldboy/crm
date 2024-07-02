package com.user.crm.settings.interceptor;

import com.user.crm.commons.constant.Const;
import com.user.crm.settings.pojo.User;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * @ClassName LoginInterceptor
 * @Description
 * @Author 14036
 * @Version: 1.0
 */

/**
 * 登入验证拦截器
 */
public class LoginInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object o) throws Exception {
       //从Session中取user
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute(Const.LOGIN_SESSION_USER);
        if (user == null) {
            //重定向到首页页面
            response.sendRedirect(request.getContextPath());
            return false;
        }

        return true;
    }

    @Override
    public void postHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, ModelAndView modelAndView) throws Exception {

    }

    @Override
    public void afterCompletion(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, Exception e) throws Exception {

    }
}
