package com.user.crm.workbench.pojo.vo;

/**
 * @ClassName ClueVo
 * @Description
 * @Author 14036
 * @Version: 1.0
 */
public class ClueVo {

    private String fullname ;
    private String company  ;
    private String phone   ;
    private String source  ;
    private String owner   ;
    private String mphone  ;
    private String state   ;

    private int    pageNum ;
    private int    pageSize;

    public ClueVo() {
    }

    public ClueVo(String fullname, String company, String phone, String source, String owner, String mphone, String state, int pageNum, int pageSize) {
        this.fullname = fullname;
        this.company = company;
        this.phone = phone;
        this.source = source;
        this.owner = owner;
        this.mphone = mphone;
        this.state = state;
        this.pageNum = pageNum;
        this.pageSize = pageSize;
    }

    @Override
    public String toString() {
        return "ClueVo{" +
                "fullname='" + fullname + '\'' +
                ", company='" + company + '\'' +
                ", phone='" + phone + '\'' +
                ", source='" + source + '\'' +
                ", owner='" + owner + '\'' +
                ", mphone='" + mphone + '\'' +
                ", state='" + state + '\'' +
                ", pageNum=" + pageNum +
                ", pageSize=" + pageSize +
                '}';
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public String getCompany() {
        return company;
    }

    public void setCompany(String company) {
        this.company = company;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public String getOwner() {
        return owner;
    }

    public void setOwner(String owner) {
        this.owner = owner;
    }

    public String getMphone() {
        return mphone;
    }

    public void setMphone(String mphone) {
        this.mphone = mphone;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
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
}
