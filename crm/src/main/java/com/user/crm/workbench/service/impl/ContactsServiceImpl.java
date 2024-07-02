package com.user.crm.workbench.service.impl;

import com.user.crm.workbench.mapper.ContactsMapper;
import com.user.crm.workbench.pojo.Contacts;
import com.user.crm.workbench.service.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @ClassName ContactsServiceImpl
 * @Description
 * @Author 14036
 * @Version: 1.0
 */
@Service
public class ContactsServiceImpl implements ContactsService {
    @Autowired
    private ContactsMapper contactsMapper;
    @Override
    public List<Contacts> queryContactsByName(String name) {
        return contactsMapper.selectContactsByName(name);
    }
}
