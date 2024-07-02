package com.user.crm.workbench.service;

import com.user.crm.workbench.pojo.ActivityRemark;

import java.util.List;

/**
 * @ClassName ActivityRemarkService
 * @Description
 * @Author 14036
 * @Version: 1.0
 */
public interface ActivityRemarkService {
    /**
     * 根据activityId查询ActivityRemarkList
     * @param activityId
     * @return
     */
    List<ActivityRemark> queryActivityRemarkByActivityId(String activityId);

    /**
     * 插入remark
     * @param activityRemark
     * @return
     */
    int insertActivityRemark(ActivityRemark activityRemark);

    /**
     * 删除市场活动备注
     * @param id
     * @return
     */
    int deleteActivityRemark(String id);

    /**
     * 保存编辑的市场活动备注
     */
    int saveEditActivityRemark(ActivityRemark activityRemark);
}
