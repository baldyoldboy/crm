package com.user.crm.workbench.mapper;

import com.user.crm.workbench.pojo.Activity;
import com.user.crm.workbench.pojo.ActivityExample;
import java.util.List;
import java.util.Map;

import com.user.crm.workbench.pojo.vo.ActivityVo;
import org.apache.ibatis.annotations.Param;

public interface ActivityMapper {
    long countByExample(ActivityExample example);

    int deleteByExample(ActivityExample example);

    int deleteByPrimaryKey(String id);



    int insertSelective(Activity row);

    List<Activity> selectByExample(ActivityExample example);

    Activity selectByPrimaryKey(String id);

    int updateByExampleSelective(@Param("row") Activity row, @Param("example") ActivityExample example);

    int updateByExample(@Param("row") Activity row, @Param("example") ActivityExample example);

    int updateByPrimaryKeySelective(Activity row);

    int updateByPrimaryKey(Activity row);

    /**
     * 插入活动
     */
    int insertActivity(Activity row);

    /**
     * 无条件查询
     */
    List<Activity> selectAllActivities();



    /**
     * 多条件分页查询 所有的活动
     */
    List<Activity> selectAllByConditionsForSplitPage(ActivityVo vo);

    /**
     * 查询所有的条数
     */
    int countAllByConditionsForSplitPage(Map<String,Object> map);

    /**
     * 根据ids批量删除
     * @param ids
     * @return
     */
    int deleteBatchByIds(String[] ids);

    /**
     * 更新市场活动
     */
    int updateActivity(Activity activity);

    /**
     * 根据ids批量查询
     */
    List<Activity> selectActivitiesByIds(String[] ids);

    /**
     * 批量添加
     */
    int insertActivities(List<Activity> activityList);

    /**
     * 根据id查询市场活动详情
     */
    Activity selectActivityDetailById(String id);

    /**
     * 根据线索id 查询与之关联的活动信息
     */
    List<Activity> selectActivityListByClueId(String clueId);

    /**
     * 根据name模糊查询市场活动，并且把已经跟clueId关联过的市场活动排除
     */
    List<Activity> selectActivityListByNameExcludeClueId(Map<String,String> map);

    /**
     * 根据线索ids 查询 简短的市场活动信息
     */
    List<Activity> selectActivityListForDetailByIds(String[] ids);

    /**
     * 根据name模糊查询 和clueId关联过的市场活动
     */
    List<Activity> selectActivityForConvertByIncludeClueId(Map<String,Object> map);

    /**
     * 根据name模糊查询
     */
    List<Activity> selectActivityByName(String name);

}