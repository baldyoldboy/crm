package com.user.crm.commons.constant;

import com.alibaba.druid.sql.visitor.functions.Char;

/**
 * @ClassName Const
 * @Description
 * @Author 14036
 * @Version: 1.0
 */
public class Const {
    /**
     * 账号锁定值
     */
    public static final String ACCOUNT_LOCK_STATE = "0" ;

    /**
     * 保存ReturnObject类中的Code值
     * 0 表示失败
     * 1 表示成功
     */
    public static final String RETURN_OBJECT_CODE_FAIL="0";
    public static final String RETURN_OBJECT_CODE_SUCCESSFUL="1";

    /**
     * 登入时存入Session域的用户对象名称
     */
    public static final String LOGIN_SESSION_USER="user";




    /**
     * 用户账号状态锁定的值
     */
    public static final String LOCK_STATE_USER= "0";



    /**
     * 市场活动中无条件查询分页 每页默认的条数
     */
    public static int ACTIVITY_PAGE_SIZE=10;

    /**
     * 线索页面中无条件查询分页 每页默认的条数
     */
    public static int CLUE_PAGE_SIZE=10;

    /**
     * 客户页面中无条件查询分页 每页默认的条数
     */
    public static int CUSTOMER_PAGE_SIZE=10;

    /**
     * 市场活动备注中是否进行了修改 0 代表没有
     */
    public static String ACTIVITY_REMARK_NO_EDIT="0";
    /**
     * 市场活动备注中是否进行了修改 1 代表修改了
     */
    public static String ACTIVITY_REMARK_YES_EDIT="1";


    /**
     * 线索备注中是否进行了修改 0 代表没有
     */
    public static String CLUE_REMARK_NO_EDIT="0";
    /**
     * 线索备注中是否进行了修改 1 代表修改了
     */
    public static String CLUE_REMARK_YES_EDIT="1";





}
