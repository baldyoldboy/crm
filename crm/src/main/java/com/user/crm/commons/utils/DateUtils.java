package com.user.crm.commons.utils;

/**
 * @ClassName DateUtils
 * @Description
 * @Author 14036
 * @Version: 1.0
 */

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * 时间的工具类
 */
public class DateUtils {

    /**
     * 对指定的对象进行格式化 yyyy-MM-dd HH:mm:ss
     * @param date
     * @return
     */
    public static String formatDateTime(Date date){
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return simpleDateFormat.format(date);
    }

    /**
     * 对指定的对象进行格式化 yyyy-MM-dd
     * @param date
     * @return
     */
    public static String formatDate(Date date){
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
        return simpleDateFormat.format(date);
    }

    /**
     * 对指定的对象进行格式化 HH:mm:ss
     * @param date
     * @return
     */
    public static String formatTime(Date date){
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("HH:mm:ss");
        return simpleDateFormat.format(date);
    }

}
