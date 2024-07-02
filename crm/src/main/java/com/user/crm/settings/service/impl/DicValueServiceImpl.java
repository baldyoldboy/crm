package com.user.crm.settings.service.impl;

import com.user.crm.settings.mapper.DicValueMapper;
import com.user.crm.settings.pojo.DicValue;
import com.user.crm.settings.service.DicValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @ClassName DicValueServiceImpl
 * @Description
 * @Author 14036
 * @Version: 1.0
 */
@Service
public class DicValueServiceImpl implements DicValueService {
    @Autowired
    private DicValueMapper dicValueMapper;
    @Override
    public List<DicValue> queryDicValueByTypeCode(String typeCode) {
        return dicValueMapper.selectDicValueByTypeCode(typeCode);
    }
}
