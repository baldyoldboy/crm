package com.user.crm.workbench.service;

import com.user.crm.workbench.pojo.ClueRemark;

import java.util.List;

/**
 * @ClassName ClueRemarkService
 * @Description
 * @Author 14036
 * @Version: 1.0
 */
public interface ClueRemarkService {
    /**
     * 根据线索id查询与之关联的所有线索备注
     * @param clueId
     * @return
     */
    List<ClueRemark> queryAllClueRemarkForDetailByClueId(String clueId);

    /**
     * 保存线索备注
     */
    int saveClueRemark(ClueRemark clueRemark);

    /**
     * 删除线索备注
     */
    int deleteClueRemarkById(String id);

    /**
     * 更新线索备注
     */
    int updateClueRemark(ClueRemark clueRemark);


}
