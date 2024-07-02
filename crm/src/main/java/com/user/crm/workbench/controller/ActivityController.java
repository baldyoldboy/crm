package com.user.crm.workbench.controller;

import com.github.pagehelper.PageInfo;
import com.user.crm.commons.constant.Const;
import com.user.crm.commons.pojo.ReturnObject;
import com.user.crm.commons.utils.DateUtils;
import com.user.crm.commons.utils.FileNameUtil;
import com.user.crm.commons.utils.HSSFUtils;
import com.user.crm.commons.utils.UUIDUtils;
import com.user.crm.settings.pojo.User;
import com.user.crm.settings.service.UserService;
import com.user.crm.workbench.pojo.Activity;
import com.user.crm.workbench.pojo.ActivityRemark;
import com.user.crm.workbench.pojo.vo.ActivityVo;
import com.user.crm.workbench.service.ActivityRemarkService;
import com.user.crm.workbench.service.ActivityService;
import org.apache.poi.hssf.usermodel.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.nio.file.Files;
import java.util.*;

/**
 * @ClassName ActivityController
 * @Description
 * @Author 14036
 * @Version: 1.0
 */
@Controller
public class ActivityController {
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ActivityRemarkService activityRemarkService;

    @RequestMapping("/workbench/activity/index")
    public String toIndex() {
        return "workbench/activity/index";
    }


    /**
     * 无条件分页查询 跳转到首页
     *
     * @param request
     * @return
     */
    @RequestMapping("/workbench/activity/queryAllForSplitPage")
    public String queryAllForSplitPage(HttpServletRequest request) {
        //分页查询
        PageInfo<Activity> pageInfo = activityService.queryAllForSplitPage(1, Const.ACTIVITY_PAGE_SIZE);
        //存入request域中
        request.setAttribute("activityInfo", pageInfo);
        //将条件体从Session清空
        request.getSession().removeAttribute("activityVo");

        return "workbench/activity/index";
    }

    /**
     * save的请求
     *
     * @param activity
     * @param session
     * @param request
     * @return
     */
    @RequestMapping("/workbench/activity/saveActivity")
    public Object saveActivity(int pageSize, Activity activity, HttpSession session, HttpServletRequest request) {
        //封装参数
        activity.setId(UUIDUtils.getUUID());
        activity.setCreateTime(DateUtils.formatDateTime(new Date()));
        //目前用户的id
        User user = (User) session.getAttribute(Const.LOGIN_SESSION_USER);
        activity.setCreateBy(user.getId());
        int count = -1;
        ReturnObject returnObject = new ReturnObject();
        //插入数据库
        try {
            count = activityService.saveActivity(activity);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Const.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙,请稍后重试...");
        }

        if (count > 0) {
            //插入成功
            returnObject.setCode(Const.RETURN_OBJECT_CODE_SUCCESSFUL);
        } else {
            //插入失败
            returnObject.setCode(Const.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙,请稍后重试...");
        }
        //将returnObject放入request域
        request.setAttribute("returnObject", returnObject);
        //清空session域中的条件
        session.removeAttribute("activityVo");
        //将pageSize的放入Session中
        ActivityVo activityVo = new ActivityVo();
        activityVo.setPageSize(pageSize);
        session.setAttribute("activityVo", activityVo);

        return "forward:/workbench/activity/saveAjaxSplit";
    }

    /**
     * save时的ajax分页
     *
     * @return
     */
    @RequestMapping("/workbench/activity/saveAjaxSplit")
    @ResponseBody
    public Object saveAjaxSplit(HttpSession session, HttpServletRequest request) {
        //从session域中获取pageSize
        ActivityVo activityVo = (ActivityVo) session.getAttribute("activityVo");
        PageInfo<Activity> pageInfo = activityService.queryAllForSplitPage(1, activityVo.getPageSize());
        session.setAttribute("activityInfo", pageInfo);
        ReturnObject returnObject = (ReturnObject) request.getAttribute("returnObject");
        return returnObject;
    }


    /**
     * ajax 多条件分页查询
     */
    @ResponseBody
    @RequestMapping("/workbench/activity/queryAllByConditionsForSplitPage")
    public void queryAllByConditionsForSplitPage(ActivityVo vo, HttpSession session) {
        //调用service层，查询数据
        PageInfo<Activity> pageInfo = activityService.queryAllByConditionsForSplitPage(vo);

        //判断一下查询出来的有多少页 与原来查询的有多少页
        if (pageInfo.getPages() < vo.getPageNum()) {
            //如果查出来的页数 比 条件体中的小
            //则重新查询
            vo.setPageNum(pageInfo.getPages());
            pageInfo = activityService.queryAllByConditionsForSplitPage(vo);
        }
        //将查询到的数据存于Session域
        session.setAttribute("activityInfo", pageInfo);
        //同时将查询条件放入session域中
        session.setAttribute("activityVo", vo);
    }

    /**
     * 批量删除
     *
     * @param id
     * @param vo
     * @param request
     * @return
     */
    @RequestMapping("/workbench/activity/deleteBatchByIds")
    public String deleteBatchByIds(String[] id, ActivityVo vo, HttpServletRequest request) {
        int count = -1;
        ReturnObject returnObject = new ReturnObject();
        try {
            count = activityService.deleteBatchByIds(id);
            if (count > 0) {
                //删除成功
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
        //将数据放入request域中
        request.setAttribute("activityVo", vo);
        request.setAttribute("returnObject", returnObject);
        return "forward:/workbench/activity/deleteByConditionsSplitPage";
    }

    /**
     * 删除时 的多条件分页查询
     *
     * @return
     */
    @RequestMapping("/workbench/activity/deleteByConditionsSplitPage")
    @ResponseBody
    public Object deleteByConditionsSplitPage(HttpServletRequest request) {
        ActivityVo activityVo = (ActivityVo) request.getAttribute("activityVo");
        ReturnObject returnObject = (ReturnObject) request.getAttribute("returnObject");
        PageInfo<Activity> pageInfo = activityService.queryAllByConditionsForSplitPage(activityVo);
        //判断一下查询出来的有多少页 与原来查询的有多少页
        if (pageInfo.getPages() < activityVo.getPageNum()) {
            //如果查出来的页数 比 条件体中的小
            //则重新查询
            activityVo.setPageNum(pageInfo.getPages());
            pageInfo = activityService.queryAllByConditionsForSplitPage(activityVo);
        }

        request.getSession().setAttribute("activityInfo", pageInfo);
        //同时将查询条件放入session域中
        request.getSession().setAttribute("activityVo", activityVo);
        return returnObject;
    }

    /**
     * 根据id查询市场活动
     */
    @RequestMapping("/workbench/activity/queryActivityById")
    @ResponseBody
    public Object queryActivityById(String id) {
        //根据id查询市场活动
        Activity activity = activityService.queryActivityById(id);
        //根据查询结果，返回响应信息
        return activity;
    }

    /**
     * 更新市场活动
     */
    @RequestMapping("/workbench/activity/saveEditActivity")
    @ResponseBody
    public Object saveEditActivity(Activity activity, HttpSession session) {
        //封装参数
        activity.setEditTime(DateUtils.formatDateTime(new Date()));
        User user = ((User) session.getAttribute(Const.LOGIN_SESSION_USER));
        activity.setEditBy(user.getId());

        ReturnObject returnObject = new ReturnObject();
        //保存编辑市场活动
        int count = -1;
        try {
            count = activityService.saveEditActivity(activity);
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


    @RequestMapping("/workbench/activity/fileDownload1")
    public void fileDownload(HttpServletResponse response) throws IOException {
        //1.设置响应类型
        response.setContentType("application/octet-stream;charset=UTF-8");
        //2.获取输出流
        ServletOutputStream os = response.getOutputStream();

        //浏览器接收到响应信息之后，默认情况下，直接在显示窗口中打开响应信息；即使打不开，也会调用应用程序打开；只有实在打不开，才会激活文件下载窗口。
        //可以设置响应头信息，使浏览器接收到响应信息之后，直接激活文件下载窗口，即使能打开也不打开
        //3.设置响应头信息
        response.addHeader("Content-Disposition", "attachment;filename=studentList.xls");

        //4.读取excel文件(InputStream),输出到浏览器中
        InputStream is = new FileInputStream("D:\\Users\\studentList.xls");
        byte[] buff = new byte[256];
        int readCount = 0;
        while ((readCount = is.read(buff)) != -1) {
            os.write(buff, 0, readCount);
        }

        //5.刷新缓冲区
        os.flush();

        //6.关闭资源
        is.close();
        //os不是我们自己创建的而是由tomcat创建的，所以不用关
    }


    @RequestMapping("/workbench/activity/fileDownload2")
    public ResponseEntity<byte[]> downloadFile() throws IOException {
        File file = new File("D:\\Users\\studentList.xls");
        //创建响应头对象
        HttpHeaders headers = new HttpHeaders();
        //设置响应内容类型
        headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
        //设置响应头信息
        headers.setContentDispositionFormData("attachment", file.getName());

        //下载文件
        ResponseEntity<byte[]> entity = new ResponseEntity<>(Files.readAllBytes(file.toPath()), headers, HttpStatus.OK);

        return entity;
    }

    /**
     * 批量导出市场活动
     */
    @RequestMapping("/workbench/activity/exportAllActivities")
    public void exportAllActivities(HttpServletRequest request, HttpServletResponse response) throws IOException {
        //查询所有的市场活动信息
        List<Activity> activityList = activityService.queryAllActivities();
        //生成excel文件
        HSSFWorkbook workbook = new HSSFWorkbook();
        HSSFSheet sheet = workbook.createSheet("市场活动列表");
        //创建第一行
        HSSFRow row = sheet.createRow(0);
        //创建列
        HSSFCell cell = row.createCell(0);
        cell.setCellValue("ID");
        cell = row.createCell(1);
        cell.setCellValue("所有者");
        cell = row.createCell(2);
        cell.setCellValue("活动名称");
        cell = row.createCell(3);
        cell.setCellValue("开始日期");
        cell = row.createCell(4);
        cell.setCellValue("结束日期");
        cell = row.createCell(5);
        cell.setCellValue("活动成本");
        cell = row.createCell(6);
        cell.setCellValue("描述");
        cell = row.createCell(7);
        cell.setCellValue("创建时间");
        cell = row.createCell(8);
        cell.setCellValue("创建者");
        cell = row.createCell(9);
        cell.setCellValue("修改时间");
        cell = row.createCell(10);
        cell.setCellValue("修改者");

        Activity activity = null;
        //遍历列表
        if (activityList != null && activityList.size() > 0) {
            for (int i = 0; i < activityList.size(); i++) {
                activity = activityList.get(i);
                //创建行
                row = sheet.createRow(i + 1);
                //创建列
                cell = row.createCell(0);
                cell.setCellValue(activity.getId());
                cell = row.createCell(1);
                cell.setCellValue(activity.getOwner());
                cell = row.createCell(2);
                cell.setCellValue(activity.getName());
                cell = row.createCell(3);
                cell.setCellValue(activity.getStartDate());
                cell = row.createCell(4);
                cell.setCellValue(activity.getEndDate());
                cell = row.createCell(5);
                cell.setCellValue(activity.getCost());
                cell = row.createCell(6);
                cell.setCellValue(activity.getDescription());
                cell = row.createCell(7);
                cell.setCellValue(activity.getCreateTime());
                cell = row.createCell(8);
                cell.setCellValue(activity.getCreateBy());
                cell = row.createCell(9);
                cell.setCellValue(activity.getEditTime());
                cell = row.createCell(10);
                cell.setCellValue(activity.getEditBy());
            }
        }

        //根据workbook生成excel文件
      /*  String realPath = request.getServletContext().getRealPath("/download");
        String fileName =UUIDUtils.getUUID()+".xls";
        System.out.println(realPath);
        File file = new File(realPath);
        // 如果服务器目录不存在则新建
        if(!file.exists()){
            file.mkdirs();
        }*/

        /*OutputStream os = new FileOutputStream(realPath+File.separator+fileName);
        workbook.write(os);*/

        //关闭资源
       /* os.close();
        workbook.close();*/

        //把生成的文件下载到客户端
        //设置响应类型
        response.setContentType("application/octet-stream;charset=UTF-8");
        //设置响应头
        response.addHeader("Content-Disposition", "attachment;filename=activityList.xls");

        //获取输出流
        ServletOutputStream out = response.getOutputStream();

        workbook.write(out);


        //读取excel文件
       /* InputStream is = new FileInputStream(realPath+File.separator+fileName);
        byte[] buff = new byte[256];
        int readCount = 0;

        while ((readCount = is.read(buff))!=-1){
            out.write(buff,0,readCount);
        }*/
        //刷新缓冲区
        out.flush();

        //关闭资源
        workbook.close();

    }

    /**
     * 选择导出
     */

    @RequestMapping("/workbench/activity/exportSelectActivities")
    public void exportSelectActivities(String[] id, HttpServletResponse response) throws IOException {
        System.out.println(id);
        //查询
        List<Activity> activityList = activityService.queryActivitiesByIds(id);

        //生成excel文件
        HSSFWorkbook workbook = new HSSFWorkbook();
        HSSFSheet sheet = workbook.createSheet("市场活动列表");
        //创建第一行
        HSSFRow row = sheet.createRow(0);
        //创建列
        HSSFCell cell = row.createCell(0);
        cell.setCellValue("ID");
        cell = row.createCell(1);
        cell.setCellValue("所有者");
        cell = row.createCell(2);
        cell.setCellValue("活动名称");
        cell = row.createCell(3);
        cell.setCellValue("开始日期");
        cell = row.createCell(4);
        cell.setCellValue("结束日期");
        cell = row.createCell(5);
        cell.setCellValue("活动成本");
        cell = row.createCell(6);
        cell.setCellValue("描述");
        cell = row.createCell(7);
        cell.setCellValue("创建时间");
        cell = row.createCell(8);
        cell.setCellValue("创建者");
        cell = row.createCell(9);
        cell.setCellValue("修改时间");
        cell = row.createCell(10);
        cell.setCellValue("修改者");

        Activity activity = null;
        //遍历列表
        if (activityList != null && activityList.size() > 0) {
            for (int i = 0; i < activityList.size(); i++) {
                activity = activityList.get(i);
                //创建行
                row = sheet.createRow(i + 1);
                //创建列
                cell = row.createCell(0);
                cell.setCellValue(activity.getId());
                cell = row.createCell(1);
                cell.setCellValue(activity.getOwner());
                cell = row.createCell(2);
                cell.setCellValue(activity.getName());
                cell = row.createCell(3);
                cell.setCellValue(activity.getStartDate());
                cell = row.createCell(4);
                cell.setCellValue(activity.getEndDate());
                cell = row.createCell(5);
                cell.setCellValue(activity.getCost());
                cell = row.createCell(6);
                cell.setCellValue(activity.getDescription());
                cell = row.createCell(7);
                cell.setCellValue(activity.getCreateTime());
                cell = row.createCell(8);
                cell.setCellValue(activity.getCreateBy());
                cell = row.createCell(9);
                cell.setCellValue(activity.getEditTime());
                cell = row.createCell(10);
                cell.setCellValue(activity.getEditBy());
            }
        }

        //把生成的文件下载到客户端
        //设置响应类型
        response.setContentType("application/octet-stream;charset=UTF-8");
        //设置响应头
        response.addHeader("Content-Disposition", "attachment;filename=activityList.xls");

        //获取输出流
        ServletOutputStream os = response.getOutputStream();


        //直接通过输出流来写
        workbook.write(os);

        os.flush();
        workbook.close();
    }

    @RequestMapping("/workbench/activity/fileUploadTest")
    @ResponseBody
    public Object fileUploadTest(String name, MultipartFile multipartFile, HttpServletRequest request) throws IOException {
        String path = request.getServletContext().getRealPath("/upload");
        File dirFile = new File(path);
        if (!dirFile.exists()) {
            dirFile.mkdirs();
        }
        System.out.println("name=" + name);
        System.out.println(multipartFile.getName());
        String originalFilename = multipartFile.getOriginalFilename();
        System.out.println(originalFilename);
        File file = new File(path + File.separator + UUIDUtils.getUUID() + FileNameUtil.getFileType(originalFilename));
        multipartFile.transferTo(file);
        //返回响应信息
        ReturnObject returnObject = new ReturnObject();
        returnObject.setCode(Const.RETURN_OBJECT_CODE_SUCCESSFUL);
        returnObject.setMessage("上传成功！");

        return returnObject;
    }

    /**
     * 导入市场活动 解析excel文件
     */
    @RequestMapping("/workbench/activity/importActivitiesByExcel")
    @ResponseBody
    public Object importActivitiesByExcel(MultipartFile multipartFile, HttpServletRequest request) {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute(Const.LOGIN_SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        try {
//            String dirPath = request.getServletContext().getRealPath("/upload");
//            File dirFile = new File(dirPath);
//            if (!dirFile.exists()) {
//                dirFile.mkdirs();
//            }
//            String originalFilename = multipartFile.getOriginalFilename();
//            String filePath = dirPath + File.separator + UUIDUtils.getUUID() + FileNameUtil.getFileType(originalFilename);
//            File file = new File(filePath);
            //将文件下载到服务器中
//            multipartFile.transferTo(file);
            InputStream is = multipartFile.getInputStream();


            //解析excel文件
//            InputStream is = new FileInputStream(filePath);
            HSSFWorkbook workbook = new HSSFWorkbook(is);
            HSSFSheet sheet = workbook.getSheetAt(0);
            HSSFRow row =null;
            HSSFCell cell = null;
            Activity activity = null;
            List<Activity> activityList = new ArrayList<>();
            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                activity = new Activity();
                row = sheet.getRow(i);
                activity.setId(UUIDUtils.getUUID());//id
                activity.setOwner(user.getId());//owner
                activity.setCreateTime(DateUtils.formatDateTime(new Date()));//createTime
                activity.setCreateBy(user.getId());//createBy
                for (int j = 0; j < row.getLastCellNum(); j++) {
                    cell = row.getCell(j);
                    //获取列中的数据
                    String value = HSSFUtils.getCellValueForStr(cell);
                    if(j==0){
                        activity.setName(value);
                    }else if(j==1){
                        activity.setStartDate(value);
                    }else if(j==2){
                        activity.setEndDate(value);
                    }else if(j==3){
                        activity.setCost(value);
                    }else if(j==4){
                        activity.setDescription(value);
                    }
                }
                //每一行中所有列都封装完成之后，把activity保存到list中
                activityList.add(activity);
            }
            //调用service方法，添加数据
            int count = activityService.addActivities(activityList);

            returnObject.setCode(Const.RETURN_OBJECT_CODE_SUCCESSFUL);
            returnObject.setRetData(count);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Const.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙，请稍后重试...");
        }

        return returnObject;
    }

    /**
     * 查看市场活动详情
     */
    @RequestMapping("/workbench/activity/queryActivityDetail")
    public String queryActivityDetail(String activityId,HttpServletRequest request){
        //获取市场活动数据
        Activity activity = activityService.queryActivityDetailById(activityId);
        //获取相关的市场活动评论数据
        List<ActivityRemark> activityRemarkList = activityRemarkService.queryActivityRemarkByActivityId(activityId);

        //存入request
        request.setAttribute("activity", activity);
        request.setAttribute("activityRemarkList",activityRemarkList);

        return "workbench/activity/detail";
    }

}

