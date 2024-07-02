package com.user.crm.workbench.controller;

import com.github.pagehelper.PageInfo;
import com.user.crm.commons.constant.Const;
import com.user.crm.commons.pojo.ReturnObject;
import com.user.crm.commons.utils.DateUtils;
import com.user.crm.commons.utils.UUIDUtils;
import com.user.crm.settings.pojo.User;
import com.user.crm.workbench.pojo.Customer;
import com.user.crm.workbench.pojo.vo.CustomerVo;
import com.user.crm.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;

/**
 * @ClassName CustomerController
 * @Description
 * @Author 14036
 * @Version: 1.0
 */
@Controller
public class CustomerController {
    @Autowired
    private CustomerService customerService;
    @RequestMapping("/workbench/customer/toIndex")
    public String toIndex(){
        return "workbench/customer/index";
    }

    /**
     * 无条件分页查询
     * @param request
     * @return
     */
    @RequestMapping("/workbench/customer/queryAllForSplitPage")
    public String queryAllForSplitPage(HttpServletRequest request){
        //查询
        PageInfo<Customer> customerPageInfo = customerService.queryAllForSplitPage(1, Const.CUSTOMER_PAGE_SIZE);
        //放入请求域中
        request.setAttribute("pageInfo",customerPageInfo);
        //请求转发
        return "forward:/workbench/customer/toIndex";
    }

    /**
     * 多条件分页查询
     */
    @RequestMapping("/workbench/customer/queryConditionForSplitPage")
    @ResponseBody
    public void queryConditionForSplitPage(CustomerVo customerVo, HttpSession session){
        //查询
        PageInfo<Customer> customerPageInfo = customerService.queryConditionForSlitPage(customerVo);

        //判断
        if (customerPageInfo.getPages()<customerVo.getPageNum()){
            customerVo.setPageNum(customerPageInfo.getPages());
            customerPageInfo = customerService.queryConditionForSlitPage(customerVo);
        }

        //放入session域
        session.setAttribute("pageInfo", customerPageInfo);
        //条件
        session.setAttribute("customerVo", customerVo);
    }

    /**
     * 创建用户
     */
    @RequestMapping("/workbench/customer/saveCreateCustomer")
    @ResponseBody
    public Object saveCreateCustomer(Customer customer,HttpSession session,HttpServletRequest request){
        User user = (User) session.getAttribute(Const.LOGIN_SESSION_USER);
        System.out.println(request.getServletPath());
        System.out.println(request.getContextPath());
        //封装参数
        customer.setId(UUIDUtils.getUUID());
        customer.setCreateBy(user.getId());
        customer.setCreateTime(DateUtils.formatDateTime(new Date()));
        //调用service层的方法
        ReturnObject returnObject = new ReturnObject();
        try {
            int count = customerService.addCustomer(customer);
            if (count>0){
                returnObject.setCode(Const.RETURN_OBJECT_CODE_SUCCESSFUL);
            }else {
                returnObject.setCode(Const.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统繁忙，请稍后重试....");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Const.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙，请稍后重试....");
        }

        return returnObject;
    }

    /**
     * 批量删除
     */
    @RequestMapping("/workbench/customer/removeBatchCustomer")
    @ResponseBody
    public Object removeBatchCustomer(String[] id){
        ReturnObject returnObject = new ReturnObject();
        try {
            int count = customerService.removeCustomerForArray(id);
            if (count>0){
                returnObject.setCode(Const.RETURN_OBJECT_CODE_SUCCESSFUL);
            }else {
                returnObject.setCode(Const.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统繁忙，请稍后重试...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Const.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙，请稍后重试...");
        }
        return returnObject;
    }

    /**
     * 根据id查看 客户信息（编辑第一步）
     */
    @RequestMapping("/workbench/customer/queryCustomerById")
    @ResponseBody
    public Object queryCustomerById(String id){
        Customer customer = customerService.queryCustomerById(id);
        return customer;
    }

    @RequestMapping("/workbench/customer/saveEditCustomer")
    @ResponseBody
    public Object saveEditCustomer(Customer customer,HttpSession session){
        User user = (User) session.getAttribute(Const.LOGIN_SESSION_USER);
        //封装参数
        customer.setEditBy(user.getId());
        customer.setEditTime(DateUtils.formatDateTime(new Date()));
        //更新
        ReturnObject returnObject = new ReturnObject();
        try {
            int count = customerService.modifyCustomer(customer);
            if (count>0){
                returnObject.setCode(Const.RETURN_OBJECT_CODE_SUCCESSFUL);
            }else {
                returnObject.setCode(Const.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统繁忙，请稍后重试...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Const.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙，请稍后重试...");
        }
        return returnObject;
    }

}
