package com.user.crm.workbench.mapper;

import com.user.crm.workbench.pojo.Transaction;
import com.user.crm.workbench.pojo.TransactionExample;
import java.util.List;

import com.user.crm.workbench.pojo.vo.FunnelVo;
import org.apache.ibatis.annotations.Param;

public interface TransactionMapper {
    long countByExample(TransactionExample example);

    int deleteByExample(TransactionExample example);

    int deleteByPrimaryKey(String id);

    int insert(Transaction row);

    int insertSelective(Transaction row);

    List<Transaction> selectByExample(TransactionExample example);

    Transaction selectByPrimaryKey(String id);

    int updateByExampleSelective(@Param("row") Transaction row, @Param("example") TransactionExample example);

    int updateByExample(@Param("row") Transaction row, @Param("example") TransactionExample example);

    int updateByPrimaryKeySelective(Transaction row);

    int updateByPrimaryKey(Transaction row);

    /**
     * 查询所有的交易 用于分页
     */
    List<Transaction> queryAllTransactionForSplitPage();

    /**
     * 根据id查询详细信息
     * @param id
     * @return
     */
    Transaction queryTransactionForDetailById(String id);

    /**
     * 查询各阶段交易条数 用于漏斗图
     */
    List<FunnelVo> selectCountOfTranGroupByStage();
}