package com.user.crm.workbench.mapper;

import com.user.crm.workbench.pojo.CustomerRemark;
import com.user.crm.workbench.pojo.CustomerRemarkExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface CustomerRemarkMapper {
    long countByExample(CustomerRemarkExample example);

    int deleteByExample(CustomerRemarkExample example);

    int deleteByPrimaryKey(String id);

    int insert(CustomerRemark row);

    int insertSelective(CustomerRemark row);

    List<CustomerRemark> selectByExample(CustomerRemarkExample example);

    CustomerRemark selectByPrimaryKey(String id);

    int updateByExampleSelective(@Param("row") CustomerRemark row, @Param("example") CustomerRemarkExample example);

    int updateByExample(@Param("row") CustomerRemark row, @Param("example") CustomerRemarkExample example);

    int updateByPrimaryKeySelective(CustomerRemark row);

    int updateByPrimaryKey(CustomerRemark row);

    /**
     * 批量插入客户备注表
     */
    int insertCustomerRemarkByList(@Param("customerRemarkList") List<CustomerRemark> customerRemarkList);
}