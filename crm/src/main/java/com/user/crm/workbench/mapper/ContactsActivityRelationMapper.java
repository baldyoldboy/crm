package com.user.crm.workbench.mapper;

import com.user.crm.workbench.pojo.ContactsActivityRelation;
import com.user.crm.workbench.pojo.ContactsActivityRelationExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface ContactsActivityRelationMapper {
    long countByExample(ContactsActivityRelationExample example);

    int deleteByExample(ContactsActivityRelationExample example);

    int deleteByPrimaryKey(String id);

    int insert(ContactsActivityRelation row);

    int insertSelective(ContactsActivityRelation row);

    List<ContactsActivityRelation> selectByExample(ContactsActivityRelationExample example);

    ContactsActivityRelation selectByPrimaryKey(String id);

    int updateByExampleSelective(@Param("row") ContactsActivityRelation row, @Param("example") ContactsActivityRelationExample example);

    int updateByExample(@Param("row") ContactsActivityRelation row, @Param("example") ContactsActivityRelationExample example);

    int updateByPrimaryKeySelective(ContactsActivityRelation row);

    int updateByPrimaryKey(ContactsActivityRelation row);

    /**
     * 批量插入
     * @param contactsActivityRelationList
     * @return
     */
    int insertContactsActivityRelationByList(@Param("contactsActivityRelationList") List<ContactsActivityRelation> contactsActivityRelationList);
}