package com.user.crm.workbench.controller;

import com.github.pagehelper.PageInfo;
import com.user.crm.commons.constant.Const;
import com.user.crm.commons.pojo.ReturnObject;
import com.user.crm.commons.utils.DateUtils;
import com.user.crm.commons.utils.UUIDUtils;
import com.user.crm.settings.pojo.DicValue;
import com.user.crm.settings.pojo.User;
import com.user.crm.settings.service.DicValueService;
import com.user.crm.settings.service.UserService;
import com.user.crm.workbench.mapper.ActivityMapper;
import com.user.crm.workbench.pojo.Activity;
import com.user.crm.workbench.pojo.Clue;
import com.user.crm.workbench.pojo.ClueActivityRelation;
import com.user.crm.workbench.pojo.ClueRemark;
import com.user.crm.workbench.pojo.vo.ClueVo;
import com.user.crm.workbench.service.ActivityService;
import com.user.crm.workbench.service.ClueActivityRelationService;
import com.user.crm.workbench.service.ClueRemarkService;
import com.user.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

/**
 * @ClassName ClueController
 * @Description
 * @Author 14036
 * @Version: 1.0
 */
@Controller
public class ClueController {

    @Autowired
    private ClueService clueService;

    @Autowired
    private ClueRemarkService clueRemarkService;

    @Autowired
    private ActivityService activityService;

    @Autowired
    private ClueActivityRelationService clueActivityRelationService;

    /**
     * 线索首页
     *
     * @return
     */
    @RequestMapping("/workbench/clue/toIndex")
    public String toIndex() {

        return "workbench/clue/index";
    }

    /**
     * 无条件 分页查询 返回首页
     *
     * @param request
     * @return
     */
    @RequestMapping("/workbench/clue/queryAllForSplitPage")
    public String queryAllForSplitPage(HttpServletRequest request) {
        //清空条件
        request.getSession().removeAttribute("clueVo");

        //获取无条件 线索分页对象
        PageInfo<Clue> pageInfo = clueService.queryAllClueForSplitPage(1, Const.CLUE_PAGE_SIZE);
        //放入请求域
        request.setAttribute("pageInfo", pageInfo);

        return "forward:/workbench/clue/toIndex";
    }

    @RequestMapping("/workbench/clue/AjaxSplitPage")
    @ResponseBody
    public Object AjaxSplitPage(HttpServletRequest request) {
        //获取无条件 线索分页对象
        PageInfo<Clue> pageInfo = clueService.queryAllClueForSplitPage(1, Const.CLUE_PAGE_SIZE);
        //放入Session域
        request.getSession().setAttribute("pageInfo", pageInfo);
        //取返回结果
        return request.getAttribute("returnObject");
    }

    /**
     * 多条件 分页查询
     *
     * @param clueVo
     * @param session
     */
    @RequestMapping("/workbench/clue/ajaxConditionForSplitPage")
    @ResponseBody
    public void ajaxConditionForSplitPage(ClueVo clueVo, HttpSession session) {
        PageInfo<Clue> cluePageInfo = clueService.queryClueByConditionForSplitPage(clueVo);

        //判断 条件页 与 现有页
        if (clueVo.getPageNum() > cluePageInfo.getPages()) {
            clueVo.setPageNum(cluePageInfo.getPages());
            cluePageInfo = clueService.queryClueByConditionForSplitPage(clueVo);
        }

        //放入session域
        session.setAttribute("pageInfo", cluePageInfo);
        //同时将查询条件放入session域中
        session.setAttribute("clueVo", clueVo);
    }

    /**
     * 保存线索
     */
    @RequestMapping("/workbench/clue/saveClue")
    public String saveClue(Clue clue, HttpServletRequest request) {
        User user = (User) request.getSession().getAttribute(Const.LOGIN_SESSION_USER);
        //封装参数
        clue.setId(UUIDUtils.getUUID());
        clue.setCreateBy(user.getId());
        clue.setCreateTime(DateUtils.formatDateTime(new Date()));
        //调用service层
        ReturnObject returnObject = new ReturnObject();
        try {
            int count = clueService.saveClue(clue);
            if (count > 0) {
                returnObject.setCode(Const.RETURN_OBJECT_CODE_SUCCESSFUL);
            } else {
                returnObject.setCode(Const.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统繁忙，请稍后重试...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Const.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙，请稍后重试...");
        }

        request.setAttribute("returnObject", returnObject);

        return "forward:/workbench/clue/AjaxSplitPage";

    }


    /**
     * 根据线索id进入细节页面
     *
     * @param id
     * @param request
     * @return
     */
    @RequestMapping("/workbench/clue/queryClueForDetailById")
    public String queryClueForDetailById(String id, HttpServletRequest request) {
        //查询线索详细信息
        Clue clue = clueService.queryClueForDetailById(id);
        //查询线索的备注信息
        List<ClueRemark> clueRemarkList = clueRemarkService.queryAllClueRemarkForDetailByClueId(id);
        //跟该线索相关联的市场活动信息
        List<Activity> activityList = activityService.queryActivityListByClueId(id);

        //放入request域中
        request.setAttribute("clue", clue);
        request.setAttribute("clueRemarkList", clueRemarkList);
        request.setAttribute("activityList", activityList);

        return "workbench/clue/detail";
    }

    /**
     * 批量删除
     */
    @RequestMapping("/workbench/clue/deleteBatchClue")
    @ResponseBody
    public Object deleteBatchClue(@RequestParam("id") String[] ids, HttpServletRequest request) {
        ReturnObject returnObject = new ReturnObject();
        try {
            int count = clueService.deleteBatchByIds(ids);

            if (count > 0) {
                returnObject.setCode(Const.RETURN_OBJECT_CODE_SUCCESSFUL);
            } else {
                returnObject.setCode(Const.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统繁忙，请稍后重试...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Const.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙，请稍后重试...");
        }

        return returnObject;
    }

    /**
     * 编辑第一步 查询
     */
    @RequestMapping("/workbench/clue/editClueById")
    @ResponseBody
    public Object editClueById(String id) {
        //查询
        Clue clue = clueService.queryClueById(id);
        return clue;
    }

    /**
     * 编辑第二步 更新
     *
     * @param clue
     * @param session
     * @return
     */
    @RequestMapping("/workbench/clue/saveEditClueById")
    @ResponseBody
    public Object saveEditClueById(Clue clue, HttpSession session) {
        User user = (User) session.getAttribute(Const.LOGIN_SESSION_USER);
        //封装参数
        clue.setEditBy(user.getId());
        clue.setEditTime(DateUtils.formatDateTime(new Date()));

        ReturnObject returnObject = new ReturnObject();
        try {
            int count = clueService.saveEditClueById(clue);
            if (count > 0) {
                returnObject.setCode(Const.RETURN_OBJECT_CODE_SUCCESSFUL);
            } else {
                returnObject.setCode(Const.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统繁忙，请稍后重试...");
            }

        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Const.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙，请稍后重试...");
        }
        return returnObject;
    }


    /**
     * 根据name模糊查询市场活动，并且把已经跟clueId关联过的市场活动排除
     */
    @RequestMapping("/workbench/clue/queryActivityForDetailByExcludeClueId")
    @ResponseBody
    public Object queryActivityForDetailByExcludeClueId(String name, String clueId) {
        //封装参数
        Map<String, String> map = new HashMap<>();
        map.put("name", name);
        map.put("clueId", clueId);
        //查询
        List<Activity> activityList = activityService.queryActivityListByNameExcludeClueId(map);

        return activityList;
    }


    /**
     * 创建线索与活动的关联关系
     * @param activityId
     * @param clueId
     * @return
     */
    @RequestMapping("/workbench/clue/createClueActivityRelation")
    @ResponseBody
    public Object createClueActivityRelation(String[] activityId, String clueId) {
        List<ClueActivityRelation> activityRelationList = new ArrayList<>();
        ClueActivityRelation relation = null;
        //封装参数
        //由于前端为空，不能发送请求，故不用进行非空判断
        for (String id : activityId) {
            relation = new ClueActivityRelation();
            relation.setId(UUIDUtils.getUUID());
            relation.setActivityId(id);
            relation.setClueId(clueId);
            activityRelationList.add(relation);
        }
        //批量插入
        ReturnObject returnObject = new ReturnObject();
        try {
            int count = clueActivityRelationService.createClueActivityRelationList(activityRelationList);
            if (count > 0) {
                returnObject.setCode(Const.RETURN_OBJECT_CODE_SUCCESSFUL);
                //成功后，要查询插入成功的市场活动信息
                List<Activity> activityList = activityService.queryActivityListForDetailByIds(activityId);
                returnObject.setRetData(activityList);
            } else {
                returnObject.setCode(Const.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统繁忙，请稍后重试...");
            }

        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Const.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙，请稍后重试...");
        }

        return returnObject;
    }

    /**
     * 解除线索与活动的关联关系
     */
    @RequestMapping("/workbench/clue/deleteClueActivityRelation")
    @ResponseBody
    public Object deleteClueActivityRelation(ClueActivityRelation relation){
        //删除
        ReturnObject returnObject = new ReturnObject();
        try {
            int count = clueActivityRelationService.deleteClueActivityRelationByActivityIdAndClueId(relation);
            if (count>0){
                returnObject.setCode(Const.RETURN_OBJECT_CODE_SUCCESSFUL);
            }else {
                returnObject.setCode(Const.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统繁忙，请稍后重试...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Const.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙，请稍后重试...");
        }

        return returnObject;
    }

    /**
     * 去往转换页面
     */
    @RequestMapping("/workbench/clue/toClueConvert")
    public String toClueConvert(String clueId,HttpServletRequest request){
        //查询线索明细
        Clue clue = clueService.queryClueForDetailById(clueId);
        request.setAttribute("clue", clue);
        return "workbench/clue/convert";
    }

    /**
     * 根据 活动name模糊查询 和 线索id 获取与之关联的活动
     */
    @RequestMapping("/workbench/clue/queryActivityForConvertByIncludeClueId")
    @ResponseBody
    public Object queryActivityForConvertByIncludeClueId(String activityName,String clueId){
        //封装参数
        Map<String,Object> map = new HashMap<>();
        map.put("name", activityName);
        map.put("clueId", clueId);
        //查询
        List<Activity> activityList = activityService.queryActivityForConvertByIncludeClueId(map);
        //返回查询结果
        return activityList;
    }

    /**
     * 线索转换
     */
    @RequestMapping("/workbench/clue/covertClue")
    @ResponseBody
    public Object covertClue(String money,String name,String expectedDate,String stage,String activityId,String clueId,boolean isCreateTran,HttpSession session){

        //封装参数
        Map<String,Object> map = new HashMap<>();
        map.put("money", money);
        map.put("name", name);
        map.put("expectedDate",expectedDate);
        map.put("stage", stage);
        map.put("activityId", activityId);
        map.put("clueId", clueId);
        map.put("isCreateTran",isCreateTran);
        map.put(Const.LOGIN_SESSION_USER,session.getAttribute(Const.LOGIN_SESSION_USER));

        //转换
        ReturnObject returnObject = new ReturnObject();
        try {
            clueService.saveConvertClue(map);
            returnObject.setCode(Const.RETURN_OBJECT_CODE_SUCCESSFUL);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Const.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙，请稍后重试....");
        }
        return returnObject;
    }

}