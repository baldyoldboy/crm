package com.user.crm.workbench.mapper;

import com.user.crm.workbench.pojo.ClueActivityRelation;
import com.user.crm.workbench.pojo.ClueActivityRelationExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface ClueActivityRelationMapper {
    long countByExample(ClueActivityRelationExample example);

    int deleteByExample(ClueActivityRelationExample example);

    int deleteByPrimaryKey(String id);

    int insert(ClueActivityRelation row);

    int insertSelective(ClueActivityRelation row);

    List<ClueActivityRelation> selectByExample(ClueActivityRelationExample example);

    ClueActivityRelation selectByPrimaryKey(String id);

    int updateByExampleSelective(@Param("row") ClueActivityRelation row, @Param("example") ClueActivityRelationExample example);

    int updateByExample(@Param("row") ClueActivityRelation row, @Param("example") ClueActivityRelationExample example);

    int updateByPrimaryKeySelective(ClueActivityRelation row);

    int updateByPrimaryKey(ClueActivityRelation row);

    /**
     * 批量插入
     */
    int insertBatch(List<ClueActivityRelation> clueActivityRelationList);

    /**
     * 根据活动id 与线索id删除
     */
    int deleteClueActivityRelationByActivityIdAndClueId(ClueActivityRelation relation);
}