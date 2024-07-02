package com.user.crm.workbench.mapper;

import com.user.crm.workbench.pojo.ActivityRemark;
import com.user.crm.workbench.pojo.ActivityRemarkExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface ActivityRemarkMapper {
    long countByExample(ActivityRemarkExample example);

    int deleteByExample(ActivityRemarkExample example);

    int deleteByPrimaryKey(String id);

    int insert(ActivityRemark row);

    int insertSelective(ActivityRemark row);

    List<ActivityRemark> selectByExample(ActivityRemarkExample example);

    ActivityRemark selectByPrimaryKey(String id);

    int updateByExampleSelective(@Param("row") ActivityRemark row, @Param("example") ActivityRemarkExample example);

    int updateByExample(@Param("row") ActivityRemark row, @Param("example") ActivityRemarkExample example);

    int updateByPrimaryKeySelective(ActivityRemark row);

    int updateByPrimaryKey(ActivityRemark row);

    /**
     * 根据activityId查询ActivityRemarkList
     * @param activityId
     * @return
     */
    List<ActivityRemark> selectActivityRemarkByActivityId(String activityId);

    /**
     * 插入市场活动备注
     * @param activityRemark
     * @return
     */
    int insertActivityRemark(ActivityRemark activityRemark);

}