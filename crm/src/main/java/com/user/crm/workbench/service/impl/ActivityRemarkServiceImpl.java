package com.user.crm.workbench.service.impl;

import com.user.crm.workbench.mapper.ActivityMapper;
import com.user.crm.workbench.mapper.ActivityRemarkMapper;
import com.user.crm.workbench.pojo.ActivityRemark;
import com.user.crm.workbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @ClassName ActivityRemarkServiceImpl
 * @Description
 * @Author 14036
 * @Version: 1.0
 */
@Service
public class ActivityRemarkServiceImpl implements ActivityRemarkService {
    @Autowired
    private ActivityRemarkMapper activityRemarkMapper;
    @Override
    public List<ActivityRemark> queryActivityRemarkByActivityId(String activityId) {
        return activityRemarkMapper.selectActivityRemarkByActivityId(activityId);
    }

    @Override
    public int insertActivityRemark(ActivityRemark activityRemark) {
        return activityRemarkMapper.insertActivityRemark(activityRemark);
    }

    @Override
    public int deleteActivityRemark(String id) {
        return activityRemarkMapper.deleteByPrimaryKey(id);
    }

    @Override
    public int saveEditActivityRemark(ActivityRemark activityRemark) {
        return activityRemarkMapper.updateByPrimaryKeySelective(activityRemark);
    }
}
