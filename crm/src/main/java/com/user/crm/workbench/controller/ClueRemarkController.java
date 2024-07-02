package com.user.crm.workbench.controller;

import com.mysql.cj.Session;
import com.user.crm.commons.constant.Const;
import com.user.crm.commons.pojo.ReturnObject;
import com.user.crm.commons.utils.DateUtils;
import com.user.crm.commons.utils.UUIDUtils;
import com.user.crm.settings.pojo.User;
import com.user.crm.workbench.pojo.ClueRemark;
import com.user.crm.workbench.service.ClueRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;

/**
 * @ClassName ClueRemarkController
 * @Description
 * @Author 14036
 * @Version: 1.0
 */
@Controller
public class ClueRemarkController {
    @Autowired
    private ClueRemarkService clueRemarkService;

    /**
     * 保存线索备注
     * @param clueRemark
     * @param session
     * @return
     */
    @RequestMapping("/workbench/clue/saveClueRemark")
    @ResponseBody
    public Object saveClueRemark(ClueRemark clueRemark, HttpSession session){
        User user = (User) session.getAttribute(Const.LOGIN_SESSION_USER);
        //封装参数
        clueRemark.setId(UUIDUtils.getUUID());
        clueRemark.setCreateBy(user.getId());
        clueRemark.setCreateTime(DateUtils.formatDateTime(new Date()));
        clueRemark.setEditFlag(Const.CLUE_REMARK_NO_EDIT);
        //保存
        ReturnObject returnObject = new ReturnObject();
        try {
            int count = clueRemarkService.saveClueRemark(clueRemark);
            if (count>0){
                returnObject.setCode(Const.RETURN_OBJECT_CODE_SUCCESSFUL);
                returnObject.setRetData(clueRemark);
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
     * 删除备注
     */
    @RequestMapping("/workbench/clue/deleteClueRemark")
    @ResponseBody
    public Object deleteClueRemark(String id){
        //删除
        ReturnObject returnObject = new ReturnObject();
        try {
            int count = clueRemarkService.deleteClueRemarkById(id);
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

    @RequestMapping("/workbench/clue/saveEditClueRemark")
    @ResponseBody
    public Object saveEditClueRemark(ClueRemark clueRemark, HttpSession session){
        User user = (User) session.getAttribute(Const.LOGIN_SESSION_USER);
        //封装参数
        clueRemark.setEditBy(user.getId());
        clueRemark.setEditTime(DateUtils.formatDateTime(new Date()));
        clueRemark.setEditFlag(Const.CLUE_REMARK_YES_EDIT);
        //更新
        ReturnObject returnObject = new ReturnObject();
        try {
            int count = clueRemarkService.updateClueRemark(clueRemark);
            if (count>0){
                returnObject.setCode(Const.RETURN_OBJECT_CODE_SUCCESSFUL);
                returnObject.setRetData(clueRemark);
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
