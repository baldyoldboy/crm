package com.user.crm.workbench.pojo.vo;

/**
 * @ClassName CustomerVo
 * @Description
 * @Author 14036
 * @Version: 1.0
 */
public class CustomerVo {
    private String name;
    private String owner;
    private String phone;
    private String website;
    private int pageSize;
    private int pageNum;

    @Override
    public String toString() {
        return "CustomerVo{" +
                "name='" + name + '\'' +
                ", owner='" + owner + '\'' +
                ", phone='" + phone + '\'' +
                ", website='" + website + '\'' +
                ", pageSize=" + pageSize +
                ", pageNum=" + pageNum +
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

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getWebsite() {
        return website;
    }

    public void setWebsite(String website) {
        this.website = website;
    }

    public int getPageSize() {
        return pageSize;
    }

    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }

    public int getPageNum() {
        return pageNum;
    }

    public void setPageNum(int pageNum) {
        this.pageNum = pageNum;
    }

    public CustomerVo(String name, String owner, String phone, String website, int pageSize, int pageNum) {
        this.name = name;
        this.owner = owner;
        this.phone = phone;
        this.website = website;
        this.pageSize = pageSize;
        this.pageNum = pageNum;
    }

    public CustomerVo() {
    }
}
