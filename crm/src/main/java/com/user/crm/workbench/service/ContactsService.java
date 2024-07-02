package com.user.crm.workbench.service;

import com.user.crm.workbench.pojo.Contacts;

import java.util.List;

/**
 * @ClassName ContactsService
 * @Description
 * @Author 14036
 * @Version: 1.0
 */
public interface ContactsService {
    List<Contacts> queryContactsByName(String name);
}
