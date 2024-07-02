package com.user.crm.workbench.service;

import com.github.pagehelper.PageInfo;
import com.user.crm.workbench.pojo.Activity;
import com.user.crm.workbench.pojo.vo.ActivityVo;

import java.util.List;
import java.util.Map;

/**
 * @ClassName ActivityService
 * @Description
 * @Author 14036
 * @Version: 1.0
 */
public interface ActivityService {
    /**
     * 保存市场活动
     */
    int saveActivity(Activity activity);

    /**
     * 分页无条件 查询
     */
    PageInfo<Activity> queryAllForSplitPage(int pageNum,int pageSize);

    /**
     * 分页多条件查询 全部市场活动
     */
    PageInfo<Activity> queryAllByConditionsForSplitPage(ActivityVo activityVo);

    /**
     * 批量删除根据ids
     */
    int deleteBatchByIds(String[] ids);

    /**
     * 根据id查询市场活动 用于修改市场活动
     */
    Activity queryActivityById(String id);

    /**
     * 更新市场活动
     */
    int saveEditActivity(Activity activity);

    /**
     * 查询所有的市场活动
     */
    List<Activity> queryAllActivities();

    /**
     * 根据ids查询市场活动
     */

    List<Activity> queryActivitiesByIds(String[] ids);

    /**
     * 批量添加
     */
    int addActivities(List<Activity> activityList);

    /**
     * 根据id查询市场活动详情
     */
    Activity queryActivityDetailById(String id);

    /**
     * 根据线索id 查询与之关联的活动信息
     */
    List<Activity> queryActivityListByClueId(String clueId);

    /**
     * 根据name模糊查询市场活动，并且把已经跟clueId关联过的市场活动排除
     */
    List<Activity> queryActivityListByNameExcludeClueId(Map<String,String> map);

    /**
     * 根据ids 查询简短的市场活动信息
     */
    List<Activity> queryActivityListForDetailByIds(String[] ids);

    /**
     * 根据name模糊查询 和clueId关联过的市场活动
     */
    List<Activity> queryActivityForConvertByIncludeClueId(Map<String,Object> map);

    /**
     * 根据name模糊查询所有的市场活动
     * @param name
     * @return
     */
    List<Activity> queryActivityByName(String name);
}
