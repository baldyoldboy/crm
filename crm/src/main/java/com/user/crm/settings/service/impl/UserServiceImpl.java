package com.user.crm.settings.service.impl;

import com.user.crm.commons.constant.Const;
import com.user.crm.settings.mapper.UserMapper;
import com.user.crm.settings.pojo.User;
import com.user.crm.settings.pojo.UserExample;
import com.user.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @ClassName UserServiceImpl
 * @Description
 * @Author 14036
 * @Version: 1.0
 */
@Service
public class UserServiceImpl implements UserService {
    @Autowired
    private UserMapper userMapper;
    @Override
    public User queryUserByLoginActAndPwd(String loginAct, String loginPwd) {
        UserExample example = new UserExample();
        example.createCriteria().andLoginActEqualTo(loginAct).andLoginPwdEqualTo(loginPwd);
        List<User> users = userMapper.selectByExample(example);
        if (users.size()>0){
            return users.get(0);
        }
        return null;
    }

    @Override
    public List<User> queryAllUsers() {
        return userMapper.selectAllUsers();
    }
}
