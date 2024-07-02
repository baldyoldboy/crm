package com.user.crm.workbench.service.impl;

import com.user.crm.workbench.mapper.ClueActivityRelationMapper;
import com.user.crm.workbench.pojo.ClueActivityRelation;
import com.user.crm.workbench.service.ClueActivityRelationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @ClassName ClueActivityRelationServiceImpl
 * @Description
 * @Author 14036
 * @Version: 1.0
 */
@Service
public class ClueActivityRelationServiceImpl implements ClueActivityRelationService{
    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;

    @Override
    public int createClueActivityRelationList(List<ClueActivityRelation> clueActivityRelationList) {
        return clueActivityRelationMapper.insertBatch(clueActivityRelationList);
    }

    @Override
    public int deleteClueActivityRelationByActivityIdAndClueId(ClueActivityRelation relation) {
        return clueActivityRelationMapper.deleteClueActivityRelationByActivityIdAndClueId(relation);
    }
}
