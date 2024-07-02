package com.user.crm.workbench.mapper;

import com.user.crm.workbench.pojo.Contacts;
import com.user.crm.workbench.pojo.Customer;
import com.user.crm.workbench.pojo.CustomerExample;

import java.util.Arrays;
import java.util.List;

import com.user.crm.workbench.pojo.vo.CustomerVo;
import org.apache.ibatis.annotations.Param;

public interface CustomerMapper {
    long countByExample(CustomerExample example);

    int deleteByExample(CustomerExample example);

    int deleteByPrimaryKey(String id);

    int insert(Customer row);

    int insertSelective(Customer row);

    List<Customer> selectByExample(CustomerExample example);

    Customer selectByPrimaryKey(String id);

    int updateByExampleSelective(@Param("row") Customer row, @Param("example") CustomerExample example);

    int updateByExample(@Param("row") Customer row, @Param("example") CustomerExample example);

    int updateByPrimaryKeySelective(Customer row);

    int updateByPrimaryKey(Customer row);

    List<Customer> selectAllForSplitPage();

    List<Customer> selectConditionForSplitPage(CustomerVo customerVo);

    /**
     * 批量删除
     */
    int deleteCustomerForArray(String[] ids);

    /**
     * 根据名字 模糊查询客户名称
     * @param name
     * @return
     */
    List<String> selectCustomerNameByName(String name);

    /**
     * 根据名字 精确查询
     */
    Customer selectCustomerByName(String name);
}