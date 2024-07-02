package com.user.crm.workbench.controller;

import com.user.crm.workbench.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * @ClassName CharController
 * @Description
 * @Author 14036
 * @Version: 1.0
 */
@Controller
public class CharController {
    @Autowired
    private TransactionService transactionService;
    @RequestMapping("/workbench/chart/transaction/index")
    public String toTransactionIndex(){
        return "workbench/chart/transaction/index";
    }

    @RequestMapping("/workbench/chart/transaction/queryCountOfTranGroupByStage")
    @ResponseBody
    public Object queryCountOfTranGroupByStage(){
        return transactionService.queryCountOfTranGroupByStage();
    }
}
