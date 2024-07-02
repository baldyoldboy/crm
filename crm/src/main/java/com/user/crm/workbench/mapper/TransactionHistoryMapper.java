package com.user.crm.workbench.mapper;

import com.user.crm.workbench.pojo.TransactionHistory;
import com.user.crm.workbench.pojo.TransactionHistoryExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface TransactionHistoryMapper {
    long countByExample(TransactionHistoryExample example);

    int deleteByExample(TransactionHistoryExample example);

    int deleteByPrimaryKey(String id);

    int insert(TransactionHistory row);

    int insertSelective(TransactionHistory row);

    List<TransactionHistory> selectByExample(TransactionHistoryExample example);

    TransactionHistory selectByPrimaryKey(String id);

    int updateByExampleSelective(@Param("row") TransactionHistory row, @Param("example") TransactionHistoryExample example);

    int updateByExample(@Param("row") TransactionHistory row, @Param("example") TransactionHistoryExample example);

    int updateByPrimaryKeySelective(TransactionHistory row);

    int updateByPrimaryKey(TransactionHistory row);

    /**
     * 根据交易Id查询Transaction阶段历史
     */
    List<TransactionHistory> selectTransactionHistoryForDetailByTranId(String tranId);
}