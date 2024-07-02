package com.user.crm.workbench.mapper;

import com.user.crm.workbench.pojo.TransactionRemark;
import com.user.crm.workbench.pojo.TransactionRemarkExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface TransactionRemarkMapper {
    long countByExample(TransactionRemarkExample example);

    int deleteByExample(TransactionRemarkExample example);

    int deleteByPrimaryKey(String id);

    int insert(TransactionRemark row);

    int insertSelective(TransactionRemark row);

    List<TransactionRemark> selectByExample(TransactionRemarkExample example);

    TransactionRemark selectByPrimaryKey(String id);

    int updateByExampleSelective(@Param("row") TransactionRemark row, @Param("example") TransactionRemarkExample example);

    int updateByExample(@Param("row") TransactionRemark row, @Param("example") TransactionRemarkExample example);

    int updateByPrimaryKeySelective(TransactionRemark row);

    int updateByPrimaryKey(TransactionRemark row);

    /**
     * 批量插入
     */
    int insertTransactionRemarkByList(List<TransactionRemark> transactionRemarkList);

    /**
     * 根据交易id查询交易备注列表
     * @param tranId
     * @return
     */
    List<TransactionRemark> selectTransactionRemarkListByTranId(String tranId);
}