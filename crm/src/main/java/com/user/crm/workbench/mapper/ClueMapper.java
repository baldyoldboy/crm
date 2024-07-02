package com.user.crm.workbench.mapper;

import com.user.crm.workbench.pojo.Clue;
import com.user.crm.workbench.pojo.ClueExample;
import java.util.List;

import com.user.crm.workbench.pojo.vo.ClueVo;
import org.apache.ibatis.annotations.Param;

public interface ClueMapper {
    long countByExample(ClueExample example);

    int deleteByExample(ClueExample example);

    int deleteByPrimaryKey(String id);

    int insert(Clue row);

    int insertSelective(Clue row);

    List<Clue> selectByExample(ClueExample example);

    Clue selectByPrimaryKey(String id);

    int updateByExampleSelective(@Param("row") Clue row, @Param("example") ClueExample example);

    int updateByExample(@Param("row") Clue row, @Param("example") ClueExample example);

    int updateByPrimaryKeySelective(Clue row);

    int updateByPrimaryKey(Clue row);

    /**
     * 查询所有的线索
     * @return
     */
    List<Clue> selectAllClue();

    /**
     * 有条件查询
     * @param clueVo
     * @return
     */
    List<Clue> selectClueByCondition(ClueVo clueVo);

    /**
     * 根据id查询线索的详细信息
     */
    Clue selectClueForDetailById(String id);

    /**
     * 批量删除
     */
    int deleteBatchByIds(@Param("ids") String[] ids);

    /**
     * 更新 编辑
     * @param clue
     * @return
     */
    int updateForSaveEditClue(Clue clue);

}