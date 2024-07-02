package com.user.crm.workbench.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.user.crm.workbench.mapper.CustomerMapper;
import com.user.crm.workbench.pojo.Customer;
import com.user.crm.workbench.pojo.vo.CustomerVo;
import com.user.crm.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @ClassName CustomerServiceImpl
 * @Description
 * @Author 14036
 * @Version: 1.0
 */
@Service
public class CustomerServiceImpl implements CustomerService {
    @Autowired
    private CustomerMapper customerMapper;
    @Override
    public PageInfo<Customer> queryAllForSplitPage(int pageNum, int pageSize) {
        //设置分页
        PageHelper.startPage(pageNum,pageSize);
        //查询
        List<Customer> customerList = customerMapper.selectAllForSplitPage();
        //封装
        PageInfo<Customer> customerPageInfo = new PageInfo<>(customerList);
        return customerPageInfo;
    }

    @Override
    public PageInfo<Customer> queryConditionForSlitPage(CustomerVo customerVo) {
        //设置分页
        PageHelper.startPage(customerVo.getPageNum(), customerVo.getPageSize());
        //查询
        List<Customer> customerList = customerMapper.selectConditionForSplitPage(customerVo);
        //封装
        PageInfo<Customer> customerPageInfo = new PageInfo<>(customerList);
        return customerPageInfo;
    }

    @Override
    public int addCustomer(Customer customer) {
        return customerMapper.insertSelective(customer);
    }

    @Override
    public int removeCustomerForArray(String[] ids) {
        return customerMapper.deleteCustomerForArray(ids);
    }

    @Override
    public Customer queryCustomerById(String id) {
        return customerMapper.selectByPrimaryKey(id);
    }

    @Override
    public int modifyCustomer(Customer customer) {
        return customerMapper.updateByPrimaryKeySelective(customer);
    }

    @Override
    public List<String> queryCustomerNameByName(String name) {
        return customerMapper.selectCustomerNameByName(name);
    }
}
