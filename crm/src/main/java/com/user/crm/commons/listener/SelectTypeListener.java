package com.user.crm.commons.listener;

import com.user.crm.settings.pojo.DicValue;
import com.user.crm.settings.pojo.User;
import com.user.crm.settings.service.DicValueService;
import com.user.crm.settings.service.UserService;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.util.List;

/**
 * @ClassName SelectTypeListner
 * @Description
 * @Author 14036
 * @Version: 1.0
 */

@WebListener
public class SelectTypeListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent servletContextEvent) {
        //手工从Spring容器中获取ProductTypeServiceImpl的对象
        ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext-*.xml");
        //获取所有的用户
        UserService userService = context.getBean("userServiceImpl", UserService.class);
        List<User> userList = userService.queryAllUsers();
        //获取称呼标签
        DicValueService dicValueService = context.getBean("dicValueServiceImpl", DicValueService.class);
        List<DicValue> appellationList = dicValueService.queryDicValueByTypeCode("appellation");
        //获取状态标签
        List<DicValue> clueStateList = dicValueService.queryDicValueByTypeCode("clueState");
        //获取线索来源标签
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        //获取阶段的标签
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        //获取交易类型
        List<DicValue> transactionTypeList = dicValueService.queryDicValueByTypeCode("transactionType");

        ServletContext servletContext = servletContextEvent.getServletContext();
        servletContext.setAttribute("userList",userList);
        servletContext.setAttribute("appellationList",appellationList);
        servletContext.setAttribute("clueStateList",clueStateList);
        servletContext.setAttribute("sourceList",sourceList);
        servletContext.setAttribute("stageList",stageList);
        servletContext.setAttribute("transactionTypeList",transactionTypeList);
    }

    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent) {

    }
}
