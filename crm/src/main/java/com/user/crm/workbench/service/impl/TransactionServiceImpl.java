package com.user.crm.workbench.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.user.crm.commons.constant.Const;
import com.user.crm.commons.utils.DateUtils;
import com.user.crm.commons.utils.UUIDUtils;
import com.user.crm.settings.pojo.User;
import com.user.crm.workbench.mapper.CustomerMapper;
import com.user.crm.workbench.mapper.TransactionHistoryMapper;
import com.user.crm.workbench.mapper.TransactionMapper;
import com.user.crm.workbench.pojo.Customer;
import com.user.crm.workbench.pojo.Transaction;
import com.user.crm.workbench.pojo.TransactionHistory;
import com.user.crm.workbench.pojo.vo.FunnelVo;
import com.user.crm.workbench.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * @ClassName TransactionServiceImpl
 * @Description
 * @Author 14036
 * @Version: 1.0
 */
@Service
public class TransactionServiceImpl implements TransactionService {
    @Autowired
    private TransactionMapper transactionMapper;

    @Autowired
    private CustomerMapper customerMapper;

    @Autowired
    private TransactionHistoryMapper transactionHistoryMapper;


    @Override
    public PageInfo<Transaction> queryAllForSplitPage(int pageNum,int pageSize) {
        //设置分页
        PageHelper.startPage(pageNum, pageSize);
        //查询
        List<Transaction> transactionList = transactionMapper.queryAllTransactionForSplitPage();
        PageInfo<Transaction> transactionPageInfo = new PageInfo<>(transactionList);
        return transactionPageInfo;
    }

    @Override
    public void saveCreateTran(Map<String, Object> map) {
        //根据customerName 查询 customer
        User user = (User) map.get(Const.LOGIN_SESSION_USER);
        String customerName = (String) map.get("customerName");
        Customer customer = customerMapper.selectCustomerByName(customerName);
        if (customer == null){
            //没有则创建一个新的
            customer = new Customer();
            customer.setId(UUIDUtils.getUUID());
            customer.setOwner(user.getId());
            customer.setName(customerName);
            customer.setCreateBy(user.getId());
            customer.setCreateTime(DateUtils.formatDateTime(new Date()));
            customerMapper.insertSelective(customer);
        }
        //封装Transaction对象
        Transaction transaction = new Transaction();
        transaction.setId(UUIDUtils.getUUID());
        transaction.setOwner(user.getId());
        transaction.setMoney((String) map.get("money"));
        transaction.setName((String) map.get("name"));
        transaction.setExpectedDate((String) map.get("expectedDate"));
        transaction.setCustomerId(customer.getId());
        transaction.setStage((String) map.get("stage"));
        transaction.setType((String) map.get("type"));
        transaction.setSource((String) map.get("source"));
        transaction.setActivityId((String) map.get("activityId"));
        transaction.setContactsId((String) map.get("contactsId"));
        transaction.setCreateBy(user.getId());
        transaction.setCreateTime(DateUtils.formatDateTime(new Date()));
        transaction.setDescription((String) map.get("description"));
        transaction.setContactSummary((String) map.get("contactSummary"));
        transaction.setNextContactTime((String) map.get("nextContactTime"));
        //插入数据库
        transactionMapper.insertSelective(transaction);
        //封装TransactionHistory对象
        TransactionHistory transactionHistory = new TransactionHistory();
        transactionHistory.setId(UUIDUtils.getUUID());
        transactionHistory.setStage(transaction.getStage());
        transactionHistory.setMoney(transaction.getMoney());
        transactionHistory.setExpectedDate(transaction.getExpectedDate());
        transactionHistory.setCreateBy(transaction.getCreateBy());
        transactionHistory.setCreateTime(transaction.getCreateTime());
        transactionHistory.setTranId(transaction.getId());
        transactionHistoryMapper.insertSelective(transactionHistory);
    }

    @Override
    public Transaction queryTransactionForDetailById(String id) {
        return transactionMapper.queryTransactionForDetailById(id);
    }

    @Override
    public List<FunnelVo> queryCountOfTranGroupByStage() {
        return transactionMapper.selectCountOfTranGroupByStage();
    }
}
