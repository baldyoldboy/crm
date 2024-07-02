package com.user.crm.workbench.pojo.vo;

/**
 * @ClassName ActivityVo
 * @Description
 * @Author 14036
 * @Version: 1.0
 */

/**
 * 活动条件查询体
 */
public class ActivityVo {
    private String name;
    private String owner;
    private String startDate;
    private String endDate;
    private int pageNum;
    private int pageSize;

    @Override
    public String toString() {
        return "ActivityVo{" +
                "name='" + name + '\'' +
                ", owner='" + owner + '\'' +
                ", startDate='" + startDate + '\'' +
                ", endDate='" + endDate + '\'' +
                ", pageNum=" + pageNum +
                ", pageSize=" + pageSize +
                '}';
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getOwner() {
        return owner;
    }

    public void setOwner(String owner) {
        this.owner = owner;
    }

    public String getStartDate() {
        return startDate;
    }

    public void setStartDate(String startDate) {
        this.startDate = startDate;
    }

    public String getEndDate() {
        return endDate;
    }

    public void setEndDate(String endDate) {
        this.endDate = endDate;
    }

    public int getPageNum() {
        return pageNum;
    }

    public void setPageNum(int pageNum) {
        this.pageNum = pageNum;
    }

    public int getPageSize() {
        return pageSize;
    }

    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }

    public ActivityVo() {
    }

    public ActivityVo(String name, String owner, String startDate, String endDate, int pageNum, int pageSize) {
        this.name = name;
        this.owner = owner;
        this.startDate = startDate;
        this.endDate = endDate;
        this.pageNum = pageNum;
        this.pageSize = pageSize;
    }
}
