package com.user.crm.workbench.service;

import com.user.crm.workbench.pojo.ClueActivityRelation;

import java.util.List;

/**
 * @ClassName ClueActivityRelationService
 * @Description
 * @Author 14036
 * @Version: 1.0
 */
public interface ClueActivityRelationService {

    int createClueActivityRelationList(List<ClueActivityRelation> clueActivityRelationList);

    int deleteClueActivityRelationByActivityIdAndClueId(ClueActivityRelation relation);
}
