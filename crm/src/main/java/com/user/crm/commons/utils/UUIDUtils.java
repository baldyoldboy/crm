package com.user.crm.commons.utils;

import java.util.UUID;

/**
 * @ClassName UUIDUtils
 * @Description
 * @Author 14036
 * @Version: 1.0
 */
public class UUIDUtils {
    public static String getUUID(){
       return UUID.randomUUID().toString().replaceAll("-", "");
    }
}
