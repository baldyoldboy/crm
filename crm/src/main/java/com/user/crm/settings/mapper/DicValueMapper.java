package com.user.crm.settings.mapper;


import java.util.List;

import com.user.crm.settings.pojo.DicValue;
import com.user.crm.settings.pojo.DicValueExample;
import org.apache.ibatis.annotations.Param;

public interface DicValueMapper {
    long countByExample(DicValueExample example);

    int deleteByExample(DicValueExample example);

    int deleteByPrimaryKey(String id);

    int insert(DicValue row);

    int insertSelective(DicValue row);

    List<DicValue> selectByExample(DicValueExample example);

    DicValue selectByPrimaryKey(String id);

    int updateByExampleSelective(@Param("row") DicValue row, @Param("example") DicValueExample example);

    int updateByExample(@Param("row") DicValue row, @Param("example") DicValueExample example);

    int updateByPrimaryKeySelective(DicValue row);

    int updateByPrimaryKey(DicValue row);

    List<DicValue> selectDicValueByTypeCode(String typeCode);
}