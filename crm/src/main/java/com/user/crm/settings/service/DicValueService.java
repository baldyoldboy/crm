package com.user.crm.settings.service;

import com.user.crm.settings.pojo.DicValue;

import java.util.List;

/**
 * @ClassName DicValueService
 * @Description
 * @Author 14036
 * @Version: 1.0
 */
public interface DicValueService {
    List<DicValue> queryDicValueByTypeCode(String typeCode);
}
