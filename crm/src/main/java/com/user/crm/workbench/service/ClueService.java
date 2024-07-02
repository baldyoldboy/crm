package com.user.crm.workbench.service;

import com.github.pagehelper.PageInfo;
import com.user.crm.workbench.pojo.Clue;
import com.user.crm.workbench.pojo.vo.ClueVo;

import java.util.Map;

/**
 * @ClassName ClueService
 * @Description
 * @Author 14036
 * @Version: 1.0
 */
public interface ClueService {
    /**
     * 无条件分页查询
     * @param pageNum
     * @param pageSize
     * @return
     */
    PageInfo<Clue> queryAllClueForSplitPage(int pageNum, int pageSize);

    /**
     * 多条件分页查询
     * @param clueVo
     * @return
     */
    PageInfo<Clue> queryClueByConditionForSplitPage(ClueVo clueVo);

    /**
     * 插入线索
     * @param clue
     * @return
     */
    int saveClue(Clue clue);

    /**
     * 根据id查看线索详情
     * @param id
     * @return
     */
    Clue queryClueForDetailById(String id);

    /**
     * 批量删除
     */
    int deleteBatchByIds(String[] ids );

    /**
     * 查询线索 根据id
     */
    Clue queryClueById(String id);

    /**
     * 更新线索
     */
    int saveEditClueById(Clue clue);

    /**
     * 线索转换
     */
    void saveConvertClue(Map<String,Object> map);

}
