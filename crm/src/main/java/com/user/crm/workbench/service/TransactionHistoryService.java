package com.user.crm.workbench.service;

import com.user.crm.workbench.pojo.TransactionHistory;
import com.user.crm.workbench.pojo.TransactionRemark;

import java.util.List;

/**
 * @ClassName TransactionHistoryService
 * @Description
 * @Author 14036
 * @Version: 1.0
 */
public interface TransactionHistoryService {
    /**
     * 根据交易id查询交易备注列表
     * @param tranId
     * @return
     */
    List<TransactionHistory> queryTransactionRemarkListByTranId(String tranId);
}
