package com.user.crm.workbench.service.impl;

import com.user.crm.workbench.mapper.ClueRemarkMapper;
import com.user.crm.workbench.pojo.ClueRemark;
import com.user.crm.workbench.service.ClueRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @ClassName ClueRemarkServiceImpl
 * @Description
 * @Author 14036
 * @Version: 1.0
 */
@Service
public class ClueRemarkServiceImpl implements ClueRemarkService {

    @Autowired
    private ClueRemarkMapper clueRemarkMapper;
    @Override
    public List<ClueRemark> queryAllClueRemarkForDetailByClueId(String clueId) {
        return clueRemarkMapper.selectAllClueRemarkByClueId(clueId);
    }

    @Override
    public int saveClueRemark(ClueRemark clueRemark) {
        return clueRemarkMapper.insertSelective(clueRemark);
    }

    @Override
    public int deleteClueRemarkById(String id) {
        return clueRemarkMapper.deleteByPrimaryKey(id);
    }

    @Override
    public int updateClueRemark(ClueRemark clueRemark) {
        return clueRemarkMapper.updateByPrimaryKeySelective(clueRemark);
    }


}
