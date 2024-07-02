package com.user.crm.workbench.controller;

import com.user.crm.commons.constant.Const;
import com.user.crm.commons.pojo.ReturnObject;
import com.user.crm.commons.utils.DateUtils;
import com.user.crm.commons.utils.UUIDUtils;
import com.user.crm.settings.pojo.User;
import com.user.crm.workbench.pojo.ActivityRemark;
import com.user.crm.workbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.UUID;

/**
 * @ClassName ActivityRemarkController
 * @Description
 * @Author 14036
 * @Version: 1.0
 */
@Controller
public class ActivityRemarkController {
    @Autowired
    private ActivityRemarkService activityRemarkService;

    /**
     * 保存市场活动备注
     * @param remark
     * @param session
     * @return
     */
    @RequestMapping("/workbench/activity/saveActivityRemark")
    @ResponseBody
    public Object saveActivityRemark(ActivityRemark remark, HttpSession session){
        //封装数据
        User user = (User) session.getAttribute(Const.LOGIN_SESSION_USER);
        remark.setId(UUIDUtils.getUUID());
        remark.setCreateTime(DateUtils.formatDateTime(new Date()));
        remark.setCreateBy(user.getId());
        remark.setEditFlag(Const.ACTIVITY_REMARK_NO_EDIT);
        ReturnObject returnObject = new ReturnObject();
        try {
            int count = activityRemarkService.insertActivityRemark(remark);
            if (count>0){
                returnObject.setCode(Const.RETURN_OBJECT_CODE_SUCCESSFUL);
                returnObject.setRetData(remark);
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
     * 删除市场活动备注
     */
    @RequestMapping("/workbench/activity/deleteActivityRemark")
    @ResponseBody
    public Object deleteActivityRemark(String id){
        ReturnObject returnObject = new ReturnObject();
        //删除
        try {
            int count = activityRemarkService.deleteActivityRemark(id);
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
     * 更新市场活动备注
     */
    @RequestMapping("/workbench/activity/saveEditActivityRemark")
    @ResponseBody
    public Object saveEditActivityRemark(ActivityRemark remark,HttpSession session){
        //封装参数
        User user = (User) session.getAttribute(Const.LOGIN_SESSION_USER);
        remark.setEditBy(user.getId());
        remark.setEditTime(DateUtils.formatDateTime(new Date()));
        remark.setEditFlag(Const.ACTIVITY_REMARK_YES_EDIT);
        //更新
        ReturnObject returnObject = new ReturnObject();
        try {
            int count = activityRemarkService.saveEditActivityRemark(remark);
            if (count>0){
                returnObject.setCode(Const.RETURN_OBJECT_CODE_SUCCESSFUL);
                returnObject.setRetData(remark);
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


}
