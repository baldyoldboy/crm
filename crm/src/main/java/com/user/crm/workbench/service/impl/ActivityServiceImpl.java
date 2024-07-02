package com.user.crm.workbench.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.user.crm.workbench.mapper.ActivityMapper;
import com.user.crm.workbench.pojo.Activity;
import com.user.crm.workbench.pojo.vo.ActivityVo;
import com.user.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * @ClassName ActivityServiceImpl
 * @Description
 * @Author 14036
 * @Version: 1.0
 */
@Service
public class ActivityServiceImpl implements ActivityService {
    @Autowired
    private ActivityMapper activityMapper;
    @Override
    public int saveActivity(Activity activity) {
        return activityMapper.insertActivity(activity);
    }

    @Override
    public PageInfo<Activity> queryAllForSplitPage(int pageNum, int pageSize) {
        //设置分页插件
        PageHelper.startPage(pageNum, pageSize);
        //查询所有的活动
        List<Activity> activityList = activityMapper.selectAllActivities();
        //封装进PageInfo中
        PageInfo<Activity> pageInfo = new PageInfo<>(activityList);

        return pageInfo;
    }

    @Override
    public PageInfo<Activity> queryAllByConditionsForSplitPage(ActivityVo vo) {
        //设置分页插件
        //取分页参数
        int pageNum = vo.getPageNum();
        int pageSize = vo.getPageSize();
        PageHelper.startPage(pageNum,pageSize);
        //经行有条件的查询
        List<Activity> activityList = activityMapper.selectAllByConditionsForSplitPage(vo);
        //将查询到的结果封装到PageInfo中
        PageInfo<Activity> pageInfo = new PageInfo<>(activityList);

        return pageInfo;
    }


    @Override
    public int deleteBatchByIds(String[] ids) {
        return activityMapper.deleteBatchByIds(ids);
    }

    @Override
    public Activity queryActivityById(String id) {
        return  activityMapper.selectByPrimaryKey(id);
    }

    @Override
    public int saveEditActivity(Activity activity) {
        return activityMapper.updateActivity(activity);
    }

    @Override
    public List<Activity> queryAllActivities() {
        return activityMapper.selectAllActivities();
    }

    @Override
    public List<Activity> queryActivitiesByIds(String[] ids) {
        return activityMapper.selectActivitiesByIds(ids);
    }

    @Override
    public int addActivities(List<Activity> activityList) {
        return activityMapper.insertActivities(activityList);
    }

    @Override
    public Activity queryActivityDetailById(String id) {
        return activityMapper.selectActivityDetailById(id);
    }

    @Override
    public List<Activity> queryActivityListByClueId(String clueId) {
        return activityMapper.selectActivityListByClueId(clueId);
    }

    @Override
    public List<Activity> queryActivityListByNameExcludeClueId(Map<String, String> map) {
        return activityMapper.selectActivityListByNameExcludeClueId(map);
    }

    @Override
    public List<Activity> queryActivityListForDetailByIds(String[] ids) {
        return activityMapper.selectActivityListForDetailByIds(ids);
    }

    @Override
    public List<Activity> queryActivityForConvertByIncludeClueId(Map<String, Object> map) {
        return activityMapper.selectActivityForConvertByIncludeClueId(map);
    }

    @Override
    public List<Activity> queryActivityByName(String name) {
        return activityMapper.selectActivityByName(name);
    }
}
