package com.user.crm.workbench.service.impl;

import com.user.crm.workbench.mapper.TransactionRemarkMapper;
import com.user.crm.workbench.pojo.TransactionRemark;
import com.user.crm.workbench.service.TransactionRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @ClassName TransactionRemarkServiceImpl
 * @Description
 * @Author 14036
 * @Version: 1.0
 */
@Service
public class TransactionRemarkServiceImpl implements TransactionRemarkService {

    @Autowired
    private TransactionRemarkMapper transactionRemarkMapper;
    @Override
    public List<TransactionRemark> queryTransactionRemarkListByTranId(String tranId) {
        return transactionRemarkMapper.selectTransactionRemarkListByTranId(tranId);
    }
}
