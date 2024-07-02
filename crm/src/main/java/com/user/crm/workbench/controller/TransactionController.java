package com.user.crm.workbench.controller;

import com.github.pagehelper.PageInfo;
import com.user.crm.commons.constant.Const;
import com.user.crm.commons.pojo.ReturnObject;
import com.user.crm.workbench.pojo.*;
import com.user.crm.workbench.service.*;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;
import java.util.ResourceBundle;

/**
 * @ClassName TransactionController
 * @Description
 * @Author 14036
 * @Version: 1.0
 */
@Controller
public class TransactionController {

    @Autowired
    private TransactionService transactionService;

    @Autowired
    private ActivityService activityService;

    @Autowired
    private ContactsService contactsService;

    @Autowired
    private CustomerService customerService;
    @Autowired
    private TransactionRemarkService transactionRemarkService;
    @Autowired
    private TransactionHistoryService transactionHistoryService;

    @RequestMapping("/workbench/transaction/toIndex")
    public String toIndex(){
        return "workbench/transaction/index";
    }

    /**
     * 无条件 分页请求
     * @param request
     * @return
     */
    @RequestMapping("/workbench/transaction/queryAllForSplitPage")
    public String queryAllForSplitPage(HttpServletRequest request){
        PageInfo<Transaction> transactionPageInfo = transactionService.queryAllForSplitPage(1, 10);
        request.setAttribute("tranPageInfo",transactionPageInfo);
        return "forward:/workbench/transaction/toIndex";
    }

    /**
     * 跳转到创建页面
     */
    @RequestMapping("/workbench/transaction/toSave")
    public String toSave(){
        return "workbench/transaction/save";
    }

    @RequestMapping("/workbench/transaction/queryActivityByActivityName")
    @ResponseBody
    public Object queryActivityByActivityName(String activityName){
        List<Activity> activityList = activityService.queryActivityByName(activityName);
        return activityList;
    }

    @RequestMapping("/workbench/transaction/queryContactsByName")
    @ResponseBody
    public Object queryContactsByName(String contactsName){
        List<Contacts> contactsList = contactsService.queryContactsByName(contactsName);
        return contactsList;
    }

    /**
     * 根据阶段获取可能性 解析properties文件
     * @param stageName
     * @return
     */
    @RequestMapping("/workbench/transaction/getPossibility")
    @ResponseBody
    public Object getPossibility(String stageName){
        //解析properties文件，返回可能性的值
        ResourceBundle bundle = ResourceBundle.getBundle("possibility");
        String possibility = bundle.getString(stageName);
        //返回响应信息
        return possibility;
    }

    /**
     * 根据用户名模糊查询用户名列表
     * @param customerName
     * @return
     */
    @RequestMapping("/workbench/transaction/queryCustomerNameByName")
    @ResponseBody
    public Object queryCustomerNameByName(String customerName){
        List<String> nameList = customerService.queryCustomerNameByName(customerName);
        return nameList;
    }

    /**
     * 创建交易
     * @param map
     * @param session
     * @return
     */
    @RequestMapping("/workbench/transaction/saveCreateTran")
    @ResponseBody
    public Object saveCreateTran(@RequestParam Map<String,Object> map, HttpSession session){
        //封装参数
        map.put(Const.LOGIN_SESSION_USER,session.getAttribute(Const.LOGIN_SESSION_USER));
        //调用service层的方法
        ReturnObject returnObject = new ReturnObject();
        try {
            transactionService.saveCreateTran(map);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Const.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙，请稍后重试...");
        }
        returnObject.setCode(Const.RETURN_OBJECT_CODE_SUCCESSFUL);
        return returnObject;
    }

    @RequestMapping("/workbench/transaction/toTransactionDetail")
    public String toTransactionDetail(String tranId,HttpServletRequest request){
        //根据id查询Transaction信息
        Transaction transaction = transactionService.queryTransactionForDetailById(tranId);
        //根据id查询Transaction备注信息
        List<TransactionRemark> transactionRemarkList = transactionRemarkService.queryTransactionRemarkListByTranId(tranId);
        //根据id查询Transaction阶段历史
        List<TransactionHistory> transactionHistoryList = transactionHistoryService.queryTransactionRemarkListByTranId(tranId);
        //根据阶段名查询可能性
        ResourceBundle bundle = ResourceBundle.getBundle("possibility");
        String possibility = bundle.getString(transaction.getStage());
        transaction.setPossibility(possibility+"%");
        request.setAttribute("tran",transaction);
        request.setAttribute("tranRemarkList", transactionRemarkList);
        request.setAttribute("tranHistoryList", transactionHistoryList);

        //跳转页面
        return "workbench/transaction/detail";
    }


}
