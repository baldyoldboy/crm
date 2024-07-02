package com.user.crm.workbench.service.impl;

import com.user.crm.workbench.mapper.TransactionHistoryMapper;
import com.user.crm.workbench.pojo.TransactionHistory;
import com.user.crm.workbench.pojo.TransactionRemark;
import com.user.crm.workbench.service.TransactionHistoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @ClassName TransactionHistoryServiceImpl
 * @Description
 * @Author 14036
 * @Version: 1.0
 */
@Service
public class TransactionHistoryServiceImpl implements TransactionHistoryService {
    @Autowired
    private TransactionHistoryMapper transactionHistoryMapper;
    @Override
    public List<TransactionHistory> queryTransactionRemarkListByTranId(String tranId) {
        return transactionHistoryMapper.selectTransactionHistoryForDetailByTranId(tranId);
    }
}
