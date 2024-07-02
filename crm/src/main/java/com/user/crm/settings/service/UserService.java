package com.user.crm.settings.service;

import com.user.crm.settings.pojo.User;

import java.util.List;

/**
 * @ClassName UserService
 * @Description
 * @Author 14036
 * @Version: 1.0
 */
public interface UserService {
    /**
     * 根据用户名和密码查询用户
     * @param loginAct
     * @param loginPwd
     * @return
     */
    User queryUserByLoginActAndPwd(String loginAct,String loginPwd);

    /**
     * 查询所有的用户
     * @return
     */
    List<User> queryAllUsers();

}
