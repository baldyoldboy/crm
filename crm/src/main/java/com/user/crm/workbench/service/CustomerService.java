package com.user.crm.workbench.service;

import com.github.pagehelper.PageInfo;
import com.user.crm.workbench.pojo.Customer;
import com.user.crm.workbench.pojo.vo.CustomerVo;

import java.util.List;

/**
 * @ClassName CustomerService
 * @Description
 * @Author 14036
 * @Version: 1.0
 */
public interface CustomerService {
    /**
     * 无条件 分页查询
     * @param pageNum
     * @param pageSize
     * @return
     */
    PageInfo<Customer> queryAllForSplitPage(int pageNum,int pageSize);

    /**
     * 多条件分页查询
     */
    PageInfo<Customer> queryConditionForSlitPage(CustomerVo customerVo);

    /**
     * 添加用户
     */
    int addCustomer(Customer customer);

    /**
     * 批量删除
     */
    int removeCustomerForArray(String[] ids);

    /**
     * 根据id查询用户
     * @param id
     * @return
     */
    Customer queryCustomerById(String id);

    /**
     * 保存更新
     * @return
     */

    int modifyCustomer(Customer customer);

    List<String> queryCustomerNameByName(String name);
}
