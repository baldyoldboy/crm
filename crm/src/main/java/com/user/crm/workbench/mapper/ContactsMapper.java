package com.user.crm.workbench.mapper;

import com.user.crm.workbench.pojo.Contacts;
import com.user.crm.workbench.pojo.ContactsExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface ContactsMapper {
    long countByExample(ContactsExample example);

    int deleteByExample(ContactsExample example);

    int deleteByPrimaryKey(String id);

    int insert(Contacts row);

    int insertSelective(Contacts row);

    List<Contacts> selectByExample(ContactsExample example);

    Contacts selectByPrimaryKey(String id);

    int updateByExampleSelective(@Param("row") Contacts row, @Param("example") ContactsExample example);

    int updateByExample(@Param("row") Contacts row, @Param("example") ContactsExample example);

    int updateByPrimaryKeySelective(Contacts row);

    int updateByPrimaryKey(Contacts row);

    List<Contacts> selectContactsByName(String name);
}