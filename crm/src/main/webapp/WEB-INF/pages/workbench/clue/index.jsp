<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<html>
<head>
    <base href="<%=path%>">
    <meta charset="UTF-8">

    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
          rel="stylesheet"/>

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <script type="text/javascript">

        //添加日历
        function addCalendar() {
            $(".myDate").datetimepicker({
                format: "yyyy-mm-dd",
                language: 'zh-CN',
                weekStart: 1,
                todayBtn: true,
                autoclose: 1,
                todayHighlight: 1,
                startView: 2,
                minView: 2,
                maxView: 4,
                forceParse: 0,
                clearBtn: true,
                initialDate: new Date(),//初始化显示的日期
            })
        }


        $(function () {
            //点击”创建”按钮
            $("#createClueBtn").click(function () {
                //重置窗口
                $("#createClueForm").get(0).reset();

                //弹出创建线索的模态窗口
                $("#createClueModal").modal("show");
            });

            //加日历
            addCalendar();

            //点击”保存”按钮，完成创建线索的功能
            $("#saveCreateClueBtn").click(function () {
                //获取参数
                var fullname = $.trim($("#create-fullname").val());
                var appellation = $("#create-appellation").val();
                var owner = $("#create-owner").val();
                var company = $.trim($("#create-company").val());
                var job = $.trim($("#create-job").val());
                var email = $.trim($("#create-email").val());
                var phone = $.trim($("#create-phone").val());
                var website = $.trim($("#create-website").val());
                var mphone = $.trim($("#create-mphone").val());
                var state = $("#create-state").val();
                var source = $("#create-source").val();
                var description = $.trim($("#create-description").val());
                var contactSummary = $.trim($("#create-contactSummary").val());
                var nextContactTime = $("#create-nextContactTime").val();
                var address = $.trim($("#create-address").val());
                //表单验证
                if (fullname == "") {
                    alert("姓名不能为空");
                    return;
                }
                if (company == "") {
                    alert("公司不能为空");
                    return;
                }
                // var emailRegExp = /^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/;
                // if (!emailRegExp.test(email)){
                //     alert("邮箱地址格式不对");
                //     return;
                // }
                // var urlRegExp =/^http|https:\/\/([\w-]+\.)+[\w-]+(\/[\w-.\/?%&=]*)?$/;
                // if (!urlRegExp.test(website)){
                //     alert("网站格式不对");
                //     return;
                // }
                // var mphoneRegExp = /^([1][3,4,5,6,7,8,9])\d{9}$/;
                // if (!mphoneRegExp.test(mphone)){
                //     alert("手机的电话号码格式不对");
                //     return;
                // }
                // var phoneRegExp = /^0\d{2,3}-\d{7,8}$/
                // if (!phoneRegExp.test(phone)){
                //     alert("座机的电话格式不对");
                //     return;
                // }
                //发送请求

                $.ajax({
                    url: "workbench/clue/saveClue",
                    data: {
                        fullname: fullname,
                        appellation: appellation,
                        owner: owner,
                        company: company,
                        job: job,
                        email: email,
                        phone: phone,
                        website: website,
                        mphone: mphone,
                        state: state,
                        source: source,
                        description: description,
                        contactSummary: contactSummary,
                        nextContactTime: nextContactTime,
                        address: address
                    },
                    method: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data.code == "1") {
                            //关闭模态窗口
                            $("#createClueModal").modal("hide");
                            //刷新线索列表
                            $("#table").load("workbench/clue/toIndex #table", function () {
                                //给复选框添加点击事件
                                addCheckboxClick();

                            });
                        } else {
                            //提示信息
                            alert(data.message);
                            //模态窗口不关闭，列表也不刷新。
                            $("#createClueModal").modal("show");
                        }
                    }
                });
            });

            //给查询按钮添加点击事件
            $("#searchBtn").click(function () {
                ajaxConditionForSplitPage(1);
            })

            //给复选框添加点击事件
            addCheckboxClick();

            //批量删除
            $("#deleteBatchClueBtn").click(function () {
                //获取id 和 页码
                var checks = $("#tbody input[type='checkbox']:checked");
                var pageNum = $(".active").attr("pageNum");
                //判断个数
                if (checks.size() == 0) {
                    alert("请选择将要删除的线索");
                    return;
                }

                if (confirm("您确定要删除" + checks.size() + "条线索吗?")) {
                    var ids = "";
                    $.each(checks, function (index) {
                        if (index == checks.size() - 1) {
                            ids += "id=" + $(this).val();
                        } else {
                            ids += "id=" + $(this).val() + "&";
                        }
                    });
                    //发送请求
                    $.ajax({
                        url: "workbench/clue/deleteBatchClue",
                        data: ids,
                        method: "post",
                        dataType: "json",
                        success: function (data) {
                            if (data.code == "1") {
                                //刷新页面
                                ajaxConditionForSplitPage(pageNum);
                            } else {
                                //提示信息
                                alert(data.message);
                            }
                        }
                    });
                }
            });

            //编辑线索的点击事件
            $("#editClueBtn").click(function () {
                var checks = $("#tbody input[type='checkbox']:checked");
                if (checks.size() == 0) {
                    alert("请选择将要修改的线索")
                    return;
                }
                if (checks.size() > 1) {
                    alert("每次只能修改一条线索");
                    return;
                }
                var id = checks.get(0).value;
                $.ajax({
                    url: "workbench/clue/editClueById",
                    data: "id=" + id,
                    method: "get",
                    dataType: "json",
                    success: function (clue) {
                        //显示修改的模态窗口
                        $("#editClueModal").modal("show");
                        //把线索的信息显示在修改的模态窗口上
                        $("#edit-id").val(clue.id)
                        $("#edit-owner").val(clue.owner);
                        $("#edit-company").val(clue.company);
                        $("#edit-fullname").val(clue.fullname);
                        $("#edit-appellation").val(clue.appellation);
                        $("#edit-job").val(clue.job);
                        $("#edit-email").val(clue.email);
                        $("#edit-phone").val(clue.phone);
                        $("#edit-website").val(clue.website);
                        $("#edit-mphone").val(clue.mphone);
                        $("#edit-state").val(clue.state);
                        $("#edit-source").val(clue.source);
                        $("#edit-description").val(clue.description);
                        $("#edit-contactSummary").val(clue.contactSummary);
                        $("#edit-nextContactTime").val(clue.nextContactTime);
                        $("#edit-address").val(clue.address);
                    }
                });
            });

            //给更新按钮绑定点击事件
            $("#saveEditClueBtn").click(function () {
                //获取所有的参数
                var id = $("#edit-id").val();
                var owner = $("#edit-owner").val();
                var company = $.trim($("#edit-company").val());
                var fullname = $.trim($("#edit-fullname").val());
                var appellation = $("#edit-appellation").val();
                var job = $.trim($("#edit-job").val());
                var email = $.trim($("#edit-email").val());
                var phone = $.trim($("#edit-phone").val());
                var website = $.trim($("#edit-website").val());
                var mphone = $.trim($("#edit-mphone").val());
                var state = $("#edit-state").val();
                var source = $("#edit-source").val();
                var description = $.trim($("#edit-description").val());
                var contactSummary = $.trim($("#edit-contactSummary").val());
                var nextContactTime = $("#edit-nextContactTime").val();
                var address = $.trim($("#edit-address").val());

                //获取页码
                var pageNum = $(".active").attr("pageNum");

                $.ajax({
                    url: "workbench/clue/saveEditClueById",
                    data: {
                        id:id,
                        fullname: fullname,
                        appellation: appellation,
                        owner: owner,
                        company: company,
                        job: job,
                        email: email,
                        phone: phone,
                        website: website,
                        mphone: mphone,
                        state: state,
                        source: source,
                        description: description,
                        contactSummary: contactSummary,
                        nextContactTime: nextContactTime,
                        address: address
                    },
                    method:"post",
                    dataType:"json",
                    success:function (data){
                        if (data.code == "1"){
                            //关闭模态窗口
                            $("#editClueModal").modal("hide");
                            //刷新页面
                            ajaxConditionForSplitPage(pageNum);
                        }else {
                            //提示信息
                            alert(data.message);
                            //模态窗口不关
                            $("#editClueModal").modal("show");
                        }
                    }
                })

            });


        });

        function ajaxConditionForSplitPage(pageNum) {
            //获取条件
            var fullname = $("#search-fullname").val();
            var company = $("#search-company").val();
            var phone = $("#search-phone").val();
            var source = $("#search-source").val();
            var owner = $("#search-owner").val();
            var mphone = $("#search-mphone").val();
            var state = $("#search-state").val();
            var pageSize = $("#pageSize").val();
            //发送ajax请求
            $.ajax({
                url: "workbench/clue/ajaxConditionForSplitPage",
                data: {
                    fullname: fullname,
                    company: company,
                    phone: phone,
                    source: source,
                    owner: owner,
                    mphone: mphone,
                    state: state,
                    pageNum: pageNum,
                    pageSize: pageSize
                },
                method: "get",
                success: function () {
                    //刷新线索列表
                    $("#table").load("workbench/clue/toIndex #table", function () {
                        //给复选框添加点击事件
                        addCheckboxClick();
                    });
                }
            })


        }

        //查看线索明细的功能
        function queryClueForDetail(id) {
            window.location.href = "workbench/clue/queryClueForDetailById?id=" + id;
        }

        //给复选框添加点击事件
        function addCheckboxClick() {
            //全选按钮
            $("#checkAll").click(function () {
                $("#tbody input[type='checkbox']").prop("checked", this.checked)
            })

            //小按钮
            $("#tbody input[type='checkbox']").click(function () {
                var checks = $("#tbody input[type='checkbox']:checked");
                if (checks.size() == $("#tbody input[type='checkbox']").size()) {
                    $("#checkAll").prop("checked", true);
                } else {
                    $("#checkAll").prop("checked", false);
                }
            });
        }


    </script>
</head>
<body>

<!-- 创建线索的模态窗口 -->
<div class="modal fade" id="createClueModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">创建线索</h4>
            </div>
            <div class="modal-body">
                <form id="createClueForm" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-owner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-owner">
                                <c:forEach items="${userList}" var="user">
                                    <option value="${user.id}">${user.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-company" class="col-sm-2 control-label">公司<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-company">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-appellation" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-appellation">
                                <option></option>
                                <c:forEach items="${appellationList}" var="app">
                                    <option value="${app.id}">${app.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-fullname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-fullname">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-job">
                        </div>
                        <label for="create-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-email">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-phone">
                        </div>
                        <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-website">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-mphone">
                        </div>
                        <label for="create-state" class="col-sm-2 control-label">线索状态</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-state">
                                <option></option>
                                <c:forEach items="${clueStateList}" var="state">
                                    <option value="${state.id}">${state.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-source" class="col-sm-2 control-label">线索来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-source">
                                <option></option>
                                <c:forEach items="${sourceList}" var="source">
                                    <option value="${source.id}">${source.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>


                    <div class="form-group">
                        <label for="create-description" class="col-sm-2 control-label">线索描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-description"></textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control myDate" id="create-nextContactTime" readonly>
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="create-address"></textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveCreateClueBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改线索的模态窗口 -->
<div class="modal fade" id="editClueModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">修改线索</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <input type="hidden" id="edit-id">
                    <div class="form-group">
                        <label for="edit-owner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-owner">
                                <c:forEach items="${userList}" var="user">
                                    <option value="${user.id}">${user.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-company" class="col-sm-2 control-label">公司<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-company" value="动力节点">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-appellation">
                                <option></option>
                                <c:forEach items="${appellationList}" var="app">
                                    <option value="${app.id}">${app.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-fullname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-fullname" value="李四">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-job" value="CTO">
                        </div>
                        <label for="edit-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-phone" value="010-84846003">
                        </div>
                        <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-website"
                                   value="http://www.bjpowernode.com">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-mphone" value="12345678901">
                        </div>
                        <label for="edit-state" class="col-sm-2 control-label">线索状态</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-state">
                                <option></option>
                                <c:forEach items="${clueStateList}" var="state">
                                    <option value="${state.id}">${state.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-source" class="col-sm-2 control-label">线索来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-source">
                                <option></option>
                                <c:forEach items="${sourceList}" var="source">
                                    <option value="${source.id}">${source.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-description" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3"
                                      id="edit-description">这是一条线索的描述信息</textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3"
                                          id="edit-contactSummary">这个线索即将被转换</textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control myDate" id="edit-nextContactTime"
                                       value="2017-05-01" readonly>
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1"
                                          id="edit-address">北京大兴区大族企业湾</textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveEditClueBtn">更新</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>线索列表</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input value="${clueVo.fullname}" class="form-control" id="search-fullname" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司</div>
                        <input value="${clueVo.company}" class="form-control" id="search-company" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司座机</div>
                        <input value="${clueVo.phone}" class="form-control" name="search-phone" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">线索来源</div>
                        <select id="search-source" value="${clueVo.source}" class="form-control">
                            <option></option>
                            <c:forEach items="${sourceList}" var="source">
                                <option value="${source.id}">${source.value}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <br>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input id="search-owner" value="${clueVo.owner}" class="form-control" type="text">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">手机</div>
                        <input id="search-mphone" value="${clueVo.mphone}" class="form-control" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">线索状态</div>
                        <select id="search-state" value="${clueVo.state}" class="form-control">
                            <option></option>
                            <c:forEach items="${clueStateList}" var="state">
                                <option value="${state.id}">${state.value}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <button type="button" id="searchBtn" class="btn btn-default">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="createClueBtn"><span
                        class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button type="button" class="btn btn-default" id="editClueBtn"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" id="deleteBatchClueBtn" class="btn btn-danger"><span
                        class="glyphicon glyphicon-minus"></span> 删除
                </button>
            </div>


        </div>

        <div id="table">
            <div style="position: relative;top: 50px;">
                <table class="table table-hover">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td><input id="checkAll" type="checkbox"/></td>
                        <td>名称</td>
                        <td>公司</td>
                        <td>公司座机</td>
                        <td>手机</td>
                        <td>线索来源</td>
                        <td>所有者</td>
                        <td>线索状态</td>
                    </tr>
                    </thead>
                    <tbody id="tbody">
                    <c:forEach items="${pageInfo.list}" var="clue">
                        <tr>
                            <td>
                                <input value="${clue.id}" type="checkbox"/>
                            </td>
                            <td>
                                <a style="text-decoration: none; cursor: pointer;"
                                   onclick="queryClueForDetail('${clue.id}')">${clue.fullname}${clue.appellation}</a>
                            </td>
                            <td>${clue.company}</td>
                            <td>${clue.phone}</td>
                            <td>${clue.mphone}</td>
                            <td>${clue.source}</td>
                            <td>${clue.owner}</td>
                            <td>${clue.state}</td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>

            <div style="height: 50px; position: relative;top: 60px;">
                <div>
                    <button type="button" class="btn btn-default" style="cursor: default;">共<b>${pageInfo.total}</b>条记录
                    </button>
                </div>
                <div class="btn-group" style="position: relative;top: -34px; left: 110px;">
                    <button type="button" class="btn btn-default" style="cursor: default;">显示</button>
                    <div class="btn-group">
                        <select id="pageSize" onchange="ajaxConditionForSplitPage(${pageInfo.pageNum})"
                                class="btn btn-default" style="height: 34px;">
                            <c:choose>
                                <c:when test="${clueVo.pageSize == 10}">
                                    <option value="10" selected>10</option>
                                    <option value="20">20</option>
                                    <option value="30">30</option>
                                </c:when>
                                <c:when test="${clueVo.pageSize == 20}">
                                    <option value="10">10</option>
                                    <option value="20" selected>20</option>
                                    <option value="30">30</option>
                                </c:when>
                                <c:when test="${clueVo.pageSize == 30}">
                                    <option value="10">10</option>
                                    <option value="20">20</option>
                                    <option value="30" selected>30</option>
                                </c:when>
                                <c:otherwise>
                                    <option value="10">10</option>
                                    <option value="20">20</option>
                                    <option value="30">30</option>
                                </c:otherwise>
                            </c:choose>
                        </select>
                    </div>
                    <button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
                </div>
                <div style="position: relative;top: -88px; left: 285px;">
                    <nav>
                        <ul class="pagination">
                            <c:choose>
                                <c:when test="${pageInfo.isFirstPage}">
                                    <li class="disabled"><a href="javascript:;">首页</a></li>
                                </c:when>
                                <c:otherwise>
                                    <li><a href="javascript:ajaxConditionForSplitPage(1)">首页</a></li>
                                </c:otherwise>
                            </c:choose>
                            <c:choose>
                                <c:when test="${pageInfo.hasPreviousPage}">
                                    <li><a href="javascript:ajaxConditionForSplitPage(${pageInfo.prePage})">上一页</a>
                                    </li>
                                </c:when>
                                <c:otherwise>
                                    <li class="disabled"><a href="javascript:;">上一页</a></li>
                                </c:otherwise>
                            </c:choose>
                            <c:forEach begin="1" end="${pageInfo.pages}" var="i">
                                <c:choose>
                                    <c:when test="${pageInfo.pageNum == i}">
                                        <li pageNum="${pageInfo.pageNum}" class="active"><a
                                                href="javascript:ajaxConditionForSplitPage(${i})">${i}</a></li>
                                    </c:when>
                                    <c:otherwise>
                                        <li><a href="javascript:ajaxConditionForSplitPage(${i})">${i}</a></li>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>

                            <c:choose>
                                <c:when test="${pageInfo.hasNextPage}">
                                    <li><a href="javascript:ajaxConditionForSplitPage(${pageInfo.nextPage})">下一页</a>
                                    </li>
                                </c:when>
                                <c:otherwise>
                                    <li class="disabled"><a href="#">下一页</a></li>
                                </c:otherwise>
                            </c:choose>
                            <c:choose>
                                <c:when test="${pageInfo.isLastPage}">
                                    <li class="disabled"><a href="javascript:;">末页</a></li>
                                </c:when>
                                <c:otherwise>
                                    <li><a href="javascript:ajaxConditionForSplitPage(${pageInfo.pages})">末页</a></li>
                                </c:otherwise>
                            </c:choose>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>


    </div>

</div>
</body>
</html>