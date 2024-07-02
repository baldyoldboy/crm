package com.user.crm.workbench.service;

import com.github.pagehelper.PageInfo;
import com.user.crm.workbench.pojo.Transaction;
import com.user.crm.workbench.pojo.vo.FunnelVo;

import java.util.List;
import java.util.Map;

/**
 * @ClassName TransactionService
 * @Description
 * @Author 14036
 * @Version: 1.0
 */
public interface TransactionService {
    PageInfo<Transaction> queryAllForSplitPage(int pageNum,int pageSize);

    /**
     * 创建交易
     * @param map
     */
    void saveCreateTran(Map<String,Object> map);

    /**
     * 根据id查询交易详情
     */
    Transaction queryTransactionForDetailById(String id);

    /**
     * 查询各阶段交易条数 用于漏斗图
     */
    List<FunnelVo> queryCountOfTranGroupByStage();

}
