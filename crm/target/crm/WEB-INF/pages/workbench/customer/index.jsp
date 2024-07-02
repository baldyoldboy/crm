<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
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

        $(function () {
            //定制字段
            $("#definedColumns > li").click(function (e) {
                //防止下拉菜单消失
                e.stopPropagation();
            });

            //加日历
            addCalendar();
            //给列表的复选框添加点击事件
            addCheckboxClick();

            //给查询添加点击事件
            $("#searchBtn").click(function () {
                ajaxConditionForSplitPage(1);
            })

            //给“创建”按钮添加点击事件
            $("#createCustomerBtn").click(function () {
                //初始化
                $("#createForm").get(0).reset();
                //显示模态窗口
                $("#createCustomerModal").modal("show");
            });

            //给”保存创建“添加点击事件
            $("#saveCreateCustomerBtn").click(function () {
                //获取参数
                var owner = $("#create-owner").val();
                var name = $.trim($("#create-name").val());
                var website = $.trim($("#create-website").val());
                var phone = $.trim($("#create-phone").val());
                var contact_summary = $.trim($("#create-contactSummary").val());
                var next_contact_time = $("#create-nextContactTime").val();
                var description = $.trim($("#create-description").val());
                var address = $.trim($("#create-address").val());
                //表单验证
                if (owner == "") {
                    alert("所有者不能为空");
                    return;
                }
                if (name == "") {
                    alert("名称不能为空");
                    return;
                }
                //发送请求
                $.ajax({
                    url: "workbench/customer/saveCreateCustomer",
                    data: {
                        owner: owner,
                        name: name,
                        website: website,
                        phone: phone,
                        contact_summary: contact_summary,
                        next_contact_time: next_contact_time,
                        description: description,
                        address: address
                    },
                    method: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data.code == "1") {
                            //关闭模态窗口
                            $("#createCustomerModal").modal("hide");
                            //刷新页面
                            ajaxConditionForSplitPage(1);
                        } else {
                            alert(data.message);
                            $("#createCustomerModal").modal("show");
                        }
                    }
                });

            });

            //给批量删除添加点击事件
            $("#deleteCustomerBtn").click(function () {
                var checks = $("#tbody input[type='checkbox']:checked");
                //判断
                if (checks.size() == 0) {
                    alert("请选择要删除的用户");
                    return;
                }
                if (window.confirm("您确定删除" + checks.size() + "位用户信息吗？")) {
                    //获取id
                    var ids = "";
                    var pageNum = $(".active").attr("pageNum");
                    $.each(checks, function (index) {
                        if (index != checks.size() - 1) {
                            ids += "id=" + $(this).val() + "&";
                        } else {
                            ids += "id=" + $(this).val();
                        }
                    });
                    //发送请求
                    $.ajax({
                            url: "workbench/customer/removeBatchCustomer",
                            data: ids,
                            method: "get",
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
                        }
                    );
                }
            });

            //给"修改"添加点击事件
            $("#editCustomerBtn").click(function (){

                var checks = $("#tbody input[type='checkbox']:checked");
                if (checks.size()==0){
                    alert("请选择要修改的用户");
                    return;
                }
                if (checks.size()>1){
                    alert("每次只能修改一条用户");
                    return;
                }
                //获取参数
                var id = checks.get(0).value;

                //发送请求
                $.ajax({
                    url:"workbench/customer/queryCustomerById",
                    data:{
                        id:id
                    },
                    method:"get",
                    dataType:"json",
                    success:function (obj){
                        //给修改框赋值
                        $("#edit-id").val(obj.id);
                        $("#edit-owner").val(obj.owner);
                        $("#edit-name").val(obj.name);
                        $("#edit-website").val(obj.website);
                        $("#edit-phone").val(obj.phone);
                        $("#edit-contactSummary").val(obj.contactSummary );
                        $("#edit-nextContactTime").val(obj.nextContactTime);
                        $("#edit-description").val(obj.description    );
                        $("#edit-address").val(obj.address        );
                        //显示模态窗口
                        $("#editCustomerModal").modal("show");
                    }
                })
            });

            //给“更新”添加点击事件
            $("#saveEditCustomerBtn").click(function (){
                //获取参数
                var id             = $("#edit-id").val();
                var owner          = $("#edit-owner").val();
                var name           = $.trim($("#edit-name").val());
                var website        = $.trim($("#edit-website").val());
                var phone          = $.trim($("#edit-phone").val());
                var contactSummary = $.trim($("#edit-contactSummary").val());
                var nextContactTime= $("#edit-nextContactTime").val();
                var description    = $.trim($("#edit-description").val());
                var address        = $.trim($("#edit-address").val());
                var pageNum        = $(".active").attr("pageNum");
                //表单验证
                if (owner == "") {
                    alert("所有者不能为空");
                    return;
                }
                if (name == "") {
                    alert("名称不能为空");
                    return;
                }
                //发送请求
                $.ajax({
                    url:"workbench/customer/saveEditCustomer",
                    data:{
                        id               :id             ,
                        owner            :owner          ,
                        name             :name           ,
                        website          :website        ,
                        phone            :phone          ,
                        contactSummary   :contactSummary ,
                        nextContactTime  :nextContactTime,
                        description      :description    ,
                        address          :address
                    },
                    method:"post",
                    dataType:"json",
                    success:function (data){
                        if (data.code=="1"){
                            //模态窗口关闭
                            $("#editCustomerModal").modal("hide");
                            //刷新页面
                            ajaxConditionForSplitPage(pageNum);
                        }else {
                            alert(data.meassage);
                            $("#editCustomerModal").modal("show");
                        }
                    }
                });

            });



        });

        //给列表的复选框添加点击事件
        function addCheckboxClick() {
            //给全选框添加点击事件
            $("#checkAll").click(function () {
                $("#tbody input[type='checkbox']").prop("checked", this.checked);
            });
            //给小复选框添加点击事件
            $("#table input[type='checkbox']").click(function () {
                if ($("#tbody input[type='checkbox']").size() == $("#tbody input[type='checkbox']:checked").size()) {
                    $("#checkAll").prop("checked", true);
                } else {
                    $("#checkAll").prop("checked", false);
                }
            });
        }

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

        //多条件分页
        function ajaxConditionForSplitPage(pageNum) {
            //获取条件
            var name = $("#name").val();
            var owner = $("#owner").val();
            var phone = $("#phone").val();
            var website = $("#website").val();
            var pageSize = $("#pageSize").val();

            $.ajax({
                url: "workbench/customer/queryConditionForSplitPage",
                data: {
                    name: name,
                    owner: owner,
                    phone: phone,
                    website: website,
                    pageSize: pageSize,
                    pageNum: pageNum
                },
                method: "get",
                success: function () {
                    //刷新页面
                    $("#table").load("workbench/customer/toIndex #table", function () {
                        //给列表的复选框添加点击事件
                        addCheckboxClick()
                    });
                }
            })

        }

    </script>
</head>
<body>

<!-- 创建客户的模态窗口 -->
<div class="modal fade" id="createCustomerModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建客户</h4>
            </div>
            <div class="modal-body">
                <form id="createForm" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-owner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-owner">
                                <c:forEach items="${applicationScope.userList}" var="u">
                                    <option value="${u.id}">${u.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-name" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-name">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-website">
                        </div>
                        <label for="create-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-phone">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-description" class="col-sm-2 control-label">描述</label>
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
                <button type="button" class="btn btn-primary" id="saveCreateCustomerBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改客户的模态窗口 -->
<div class="modal fade" id="editCustomerModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改客户</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <input type="hidden" id="edit-id">
                    <div class="form-group">
                        <label for="edit-owner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-owner">
                                <c:forEach items="${applicationScope.userList}" var="u">
                                    <option value="${u.id}">${u.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-name" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-name" value="动力节点">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-website"
                                   value="http://www.bjpowernode.com">
                        </div>
                        <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-phone" value="010-84846003">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-description" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-description"></textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-nextContactTime">
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1"
                                          id="edit-address">北京大兴大族企业湾</textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveEditCustomerBtn">更新</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>客户列表</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">
        <%--搜索框--%>
        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input class="form-control" id="name" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" id="owner" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司座机</div>
                        <input class="form-control" id="phone" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司网站</div>
                        <input class="form-control" id="website" type="text">
                    </div>
                </div>

                <button type="button" id="searchBtn" class="btn btn-default">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="createCustomerBtn">
                    <span class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button type="button" class="btn btn-default" id="editCustomerBtn"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" id="deleteCustomerBtn" class="btn btn-danger"><span
                        class="glyphicon glyphicon-minus"></span> 删除
                </button>
            </div>

        </div>
        <%--列表和页码栏--%>
        <div id="table">
            <div style="position: relative;top: 10px;">
                <table class="table table-hover">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td><input type="checkbox" id="checkAll"/></td>
                        <td>名称</td>
                        <td>所有者</td>
                        <td>公司座机</td>
                        <td>公司网站</td>
                    </tr>
                    </thead>
                    <tbody id="tbody">
                    <c:forEach items="${pageInfo.list}" var="customer">
                        <tr>
                            <td><input value="${customer.id}" type="checkbox"/></td>
                            <td><a style="text-decoration: none; cursor: pointer;"
                                   onclick="window.location.href='detail.jsp';">${customer.name}</a></td>
                            <td>${customer.owner}</td>
                            <td>${customer.phone}</td>
                            <td>${customer.website}</td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>

            <div style="height: 50px; position: relative;top: 30px;">
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
                                <c:when test="${customerVo.pageSize == 10}">
                                    <option value="10" selected>10</option>
                                    <option value="20">20</option>
                                    <option value="30">30</option>
                                </c:when>
                                <c:when test="${customerVo.pageSize == 20}">
                                    <option value="10">10</option>
                                    <option value="20" selected>20</option>
                                    <option value="30">30</option>
                                </c:when>
                                <c:when test="${customerVo.pageSize == 30}">
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
                                    <li class="disabled"><a href="javascript:void(0);">首页</a></li>
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
                                    <li class="disabled"><a href="javascript:void(0);">上一页</a></li>
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
                                    <li class="disabled"><a href="javascript:void(0);">下一页</a></li>
                                </c:otherwise>
                            </c:choose>
                            <c:choose>
                                <c:when test="${pageInfo.isLastPage}">
                                    <li class="disabled"><a href="javascript:void(0);">末页</a></li>
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