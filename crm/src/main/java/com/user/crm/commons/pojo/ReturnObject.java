package com.user.crm.commons.pojo;

/**
 * @ClassName RetutnObj
 * @Description
 * @Author 14036
 * @Version: 1.0
 */
public class ReturnObject {
    private String code;//处理成功获取失败的标记，1--成功，0--失败
    private String message;//提示信息
    private Object retData;//其他信息

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Object getRetData() {
        return retData;
    }

    public void setRetData(Object retData) {
        this.retData = retData;
    }
}
