package com.user.crm.workbench.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.user.crm.commons.constant.Const;
import com.user.crm.commons.utils.DateUtils;
import com.user.crm.commons.utils.UUIDUtils;
import com.user.crm.settings.pojo.User;
import com.user.crm.workbench.mapper.*;
import com.user.crm.workbench.pojo.*;
import com.user.crm.workbench.pojo.vo.ClueVo;
import com.user.crm.workbench.service.ClueActivityRelationService;
import com.user.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * @ClassName ClueServiceImpl
 * @Description
 * @Author 14036
 * @Version: 1.0
 */
@Service
public class ClueServiceImpl implements ClueService {
    @Autowired
    private ClueMapper clueMapper;

    @Autowired
    private CustomerMapper customerMapper;

    @Autowired
    private ContactsMapper contactsMapper;

    @Autowired
    private ClueRemarkMapper clueRemarkMapper;

    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;
    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;
    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;

    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;

    @Autowired
    private TransactionMapper transactionMapper;

    @Autowired
    private TransactionRemarkMapper transactionRemarkMapper;

    @Override
    public PageInfo<Clue> queryAllClueForSplitPage(int pageNum, int pageSize) {
        //设置分页插件
        PageHelper.startPage(pageNum,pageSize);

        //查询
        List<Clue> clueList = clueMapper.selectAllClue();
        PageInfo<Clue> cluePageInfo = new PageInfo<>(clueList);
        return cluePageInfo;
    }

    @Override
    public PageInfo<Clue> queryClueByConditionForSplitPage(ClueVo clueVo) {
        //设置分页条件
        PageHelper.startPage(clueVo.getPageNum(), clueVo.getPageSize());
        //查询
        List<Clue> clueList = clueMapper.selectClueByCondition(clueVo);

        PageInfo<Clue> cluePageInfo = new PageInfo<>(clueList);

        return cluePageInfo;
    }

    @Override
    public int saveClue(Clue clue) {
        return clueMapper.insert(clue);
    }

    @Override
    public Clue queryClueForDetailById(String id) {
        return clueMapper.selectClueForDetailById(id);
    }

    @Override
    public int deleteBatchByIds(String[] ids) {
        return clueMapper.deleteBatchByIds(ids);
    }

    @Override
    public Clue queryClueById(String id) {
        return clueMapper.selectByPrimaryKey(id);
    }

    @Override
    public int saveEditClueById(Clue clue) {
        return clueMapper.updateForSaveEditClue(clue);
    }

    @Override
    public void saveConvertClue(Map<String, Object> map) {
        //根据clueId查询线索信息
        String clueId = (String) map.get("clueId");
        Clue clue = clueMapper.selectByPrimaryKey(clueId);
        User user = (User) map.get(Const.LOGIN_SESSION_USER);
        //把线索中有关公司的信息转换到客户表中
        //封装客户信息
        Customer customer = new Customer();
        customer.setId(UUIDUtils.getUUID());
        customer.setOwner(user.getId());
        customer.setName(clue.getCompany());
        customer.setWebsite(clue.getWebsite());
        customer.setPhone(clue.getPhone());
        customer.setCreateBy(user.getId());
        customer.setCreateTime(DateUtils.formatDateTime(new Date()));
        customer.setContactSummary(clue.getContactSummary());
        customer.setNextContactTime(clue.getNextContactTime());
        customer.setDescription(clue.getDescription());
        customer.setAddress(clue.getAddress());
        //插入客户表
        customerMapper.insertSelective(customer);
        //把线索中有关个人的信息转换到联系人表中
        //封装联系人信息
        Contacts contacts = new Contacts();
        contacts.setId(UUIDUtils.getUUID());
        contacts.setOwner(user.getId());
        contacts.setSource(clue.getSource());
        contacts.setCustomerId(customer.getId());
        contacts.setFullname(clue.getFullname());
        contacts.setAppellation(clue.getAppellation());
        contacts.setEmail(clue.getEmail());
        contacts.setMphone(clue.getMphone());
        contacts.setJob(clue.getJob());
        contacts.setCreateBy(user.getId());
        contacts.setCreateTime(DateUtils.formatDateTime(new Date()));
        contacts.setDescription(clue.getDescription());
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setAddress(clue.getAddress());
        //插入联系人表
        contactsMapper.insertSelective(contacts);

        //根据clueId查询线索的备注信息
        ClueRemarkExample clueRemarkExample = new ClueRemarkExample();
        clueRemarkExample.createCriteria().andClueIdEqualTo(clueId);
        List<ClueRemark> clueRemarkList = clueRemarkMapper.selectByExample(clueRemarkExample);

        if (clueRemarkList!=null && clueRemarkList.size()!=0){
            List<CustomerRemark> customerRemarkList = new ArrayList<>();
            List<ContactsRemark> contactsRemarkList = new ArrayList<>();
            CustomerRemark customerRemark = null;
            ContactsRemark contactsRemark = null;
            for (ClueRemark clueRemark : clueRemarkList) {
                //把线索的备注信息转换到客户备注表中一份
                //封装客户备注表信息
                customerRemark = new CustomerRemark();
                customerRemark.setId(UUIDUtils.getUUID());
                customerRemark.setNoteContent(clueRemark.getNoteContent());
                customerRemark.setCreateBy(clueRemark.getCreateBy());
                customerRemark.setCreateTime(clueRemark.getCreateTime());
                customerRemark.setEditBy(clueRemark.getEditBy());
                customerRemark.setEditTime(clueRemark.getEditTime());
                customerRemark.setEditFlag(clueRemark.getEditFlag());
                customerRemark.setCustomerId(customer.getId());
                //添加
                customerRemarkList.add(customerRemark);
                //把线索的备注信息转换到联系人备注表中一份
                //封装联系人备注表信息
                contactsRemark= new ContactsRemark();
                contactsRemark.setId(UUIDUtils.getUUID());
                contactsRemark.setNoteContent(clueRemark.getNoteContent());
                contactsRemark.setCreateBy(clueRemark.getCreateBy());
                contactsRemark.setCreateTime(clueRemark.getCreateTime());
                contactsRemark.setEditBy(clueRemark.getEditBy());
                contactsRemark.setEditTime(clueRemark.getEditTime());
                contactsRemark.setEditFlag(clueRemark.getEditFlag());
                contactsRemark.setContactsId(contacts.getId());
                //添加
                contactsRemarkList.add(contactsRemark);
            }
            //插入客户备注表
            customerRemarkMapper.insertCustomerRemarkByList(customerRemarkList);
            //插入联系人备注表
            contactsRemarkMapper.insertContactsRemarkByList(contactsRemarkList);
        }
        //根据clueId查询 线索和市场活动的关联表获取 关联的市场活动id
        ClueActivityRelationExample clueActivityRelationExample = new ClueActivityRelationExample();
        clueActivityRelationExample.createCriteria().andClueIdEqualTo(clueId);
        List<ClueActivityRelation> activityRelationList = clueActivityRelationMapper.selectByExample(clueActivityRelationExample);
        if (activityRelationList!=null&&activityRelationList.size()!=0){
            //把线索和市场活动的关联关系转换到联系人和市场活动的关联关系表中
            List<ContactsActivityRelation> contactsActivityRelationList = new ArrayList<>();
            ContactsActivityRelation carRelation= null;
            for (ClueActivityRelation relation : activityRelationList) {
                //封装联系人和市场活动的关联
                carRelation = new ContactsActivityRelation();
                carRelation.setId(UUIDUtils.getUUID());
                carRelation.setContactsId(contacts.getId());
                carRelation.setActivityId(relation.getActivityId());
                //添加
                contactsActivityRelationList.add(carRelation);
            }
            //插入联系人和市场活动的关联关系表
            contactsActivityRelationMapper.insertContactsActivityRelationByList(contactsActivityRelationList);
        }
        //判断是否需要创建交易
        if ((boolean)map.get("isCreateTran")){
            //如果需要创建交易,还要往交易表中添加一条记录
            //封装交易信息
            Transaction transaction = new Transaction();
            transaction.setId(UUIDUtils.getUUID());
            transaction.setOwner(user.getId());
            transaction.setMoney((String) map.get("money"));
            transaction.setName((String)map.get("name"));
            transaction.setExpectedDate((String)map.get("expectedDate"));
            transaction.setCustomerId(customer.getId());
            transaction.setStage((String) map.get("stage"));
            transaction.setActivityId((String)map.get("activityId"));
            transaction.setContactsId(contacts.getId());
            transaction.setCreateBy(user.getId());
            transaction.setCreateTime(DateUtils.formatDateTime(new Date()));
            //插入交易表
            transactionMapper.insertSelective(transaction);
            //如果需要创建交易,还要把线索的备注信息转换到交易备注表中一份
            if (clueRemarkList!=null&&clueRemarkList.size()!=0){
                //封装交易备注信息
                List<TransactionRemark> transactionRemarkList = new ArrayList<>();
                TransactionRemark tsRemark = null;
                for (ClueRemark clueRemark : clueRemarkList) {
                    tsRemark = new TransactionRemark();
                    tsRemark.setId(UUIDUtils.getUUID());
                    tsRemark.setNoteContent(clueRemark.getNoteContent());
                    tsRemark.setCreateBy(clueRemark.getCreateBy());
                    tsRemark.setCreateTime(clueRemark.getCreateTime());
                    tsRemark.setEditBy(clueRemark.getEditBy());
                    tsRemark.setEditTime(clueRemark.getEditTime());
                    tsRemark.setEditFlag(clueRemark.getEditFlag());
                    tsRemark.setTranId(transaction.getId());
                    //添加
                    transactionRemarkList.add(tsRemark);
                }
                //插入交易备注表
                transactionRemarkMapper.insertTransactionRemarkByList(transactionRemarkList);
            }
        }

        //删除线索的备注
        clueRemarkMapper.deleteByExample(clueRemarkExample);
        //删除线索和市场活动的关联关系
        clueActivityRelationMapper.deleteByExample(clueActivityRelationExample);
        //删除线索
        clueMapper.deleteByPrimaryKey(clueId);
    }
}
