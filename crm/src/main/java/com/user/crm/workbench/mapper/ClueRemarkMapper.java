package com.user.crm.workbench.mapper;

import com.user.crm.workbench.pojo.ClueRemark;
import com.user.crm.workbench.pojo.ClueRemarkExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface ClueRemarkMapper {
    long countByExample(ClueRemarkExample example);

    int deleteByExample(ClueRemarkExample example);

    int deleteByPrimaryKey(String id);

    int insert(ClueRemark row);

    int insertSelective(ClueRemark row);

    List<ClueRemark> selectByExample(ClueRemarkExample example);

    ClueRemark selectByPrimaryKey(String id);

    int updateByExampleSelective(@Param("row") ClueRemark row, @Param("example") ClueRemarkExample example);

    int updateByExample(@Param("row") ClueRemark row, @Param("example") ClueRemarkExample example);

    int updateByPrimaryKeySelective(ClueRemark row);

    int updateByPrimaryKey(ClueRemark row);

    /**
     * 根据线索id查询与之关联的线索备注
     * @param clueId
     * @return
     */
    List<ClueRemark> selectAllClueRemarkByClueId(String clueId);
}