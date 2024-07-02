<%@page contentType="text/html;charset=utf-8" language="java" %>
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
        function creatActivityAjax() {
            //初始化
            //重置表单
            $("#createActivityForm").get(0).reset()
            //弹出创建市场活动的模态窗口
            $("#createActivityModal").modal("show");
        }


        //点击保存按钮时发送ajax请求
        function saveActivity() {
            //获取数据
            var owner = $("#create-marketActivityOwner").val();
            var name = $.trim($("#create-marketActivityName").val());
            var startDate = $("#create-startDate").val();
            var endDate = $("#create-endDate").val();
            var cost = $.trim($("#create-cost").val());
            var description = $.trim($("#create-description").val());
            //将pageSize获取到
            var pageSize = $("#pageSize").val();

            //进行表单验证
            if (owner == "") {
                alert("所有者不能为空");
                return;
            }
            if (name == "") {
                alert("名称不能为空");
                return;
            }
            if (startDate != "" && endDate != "") {
                //使用字符串的大小来代替日期的大小
                if (endDate < startDate) {
                    alert("结束日期不能比开始日期小")
                    return;
                }
            }

            //成本只能为非负数
            var regExp = /^(([1-9]\d*)|0)$/;
            if (!regExp.test(cost)) {
                alert("成本只能为非负整数");
                return;
            }
            //发送ajax请求
            $.ajax({
                url: "workbench/activity/saveActivity",
                data: {
                    owner: owner,
                    name: name,
                    startDate: startDate,
                    endDate: endDate,
                    cost: cost,
                    description: description,
                    pageSize: pageSize
                },
                method: "post",
                dataType: "json",
                success: function (data) {
                    if (data.code == "1") {
                        // 关闭模态窗口
                        $("#createActivityModal").modal("hide");
                        //重新加载 列表
                        $("#table").load("http://localhost:8080/crm/workbench/activity/index #table", function () {
                            //加日历
                            addCalendar();
                            //添加全选按钮 和 小按钮的点击事件
                            addCheckBoxClick();

                        })
                    } else {
                        //提示信息创建失败
                        alert(data.message);
                        alert(data.message);
                        //模态窗口不关闭,
                        $("#createActivityModal").modal("show");
                    }
                }
            })
        }


        $(function () {
            //添加日历
            addCalendar();
            //按钮添加点击事件
            addCheckBoxClick();


        })

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

        //添加全选按钮 和 小按钮的点击事件
        function addCheckBoxClick() {
            //给全选按钮添加点击事件
            $("#checkAll").click(function () {
                //获取全选按钮的状态
                //获取其他的小按钮
                $("#tbody input[type='checkbox']").prop("checked", this.checked);
            })
            //给小按钮添加点击事件
            $("#tbody input[type='checkbox']").click(function () {
                //获取所有的小按钮
                if ($("#tbody input[type='checkbox']").size() == $("#tbody input[type='checkbox']:checked").size()) {
                    $("#checkAll").prop("checked", true);
                } else {
                    $("#checkAll").prop("checked", false);
                }
            });
        }

        //批量删除
        function deleteActivity(page) {
            //获取条件
            var name = $("#name").val();
            var owner = $("#owner").val();
            var startDate = $("#startDate").val();
            var endDate = $("#endDate").val();
            var pageNum = page;
            var pageSize = $("#pageSize").val();

            //删除的ids
            var checks = $("#tbody input[type='checkbox']:checked");

            //判断个数
            if (checks.size() == 0) {
                alert("请选择将要删除的活动");
                return;
            }

            if (confirm("您确定删除" + checks.size() + "条活动吗？")) {
                ids = "";
                $.each(checks, function (index) {
                    if (index != checks.size() - 1) {
                        ids += "id=" + $(this).val() + "&";
                    } else {
                        ids += "id=" + $(this).val();
                    }
                })

                //发送ajax请求
                $.ajax({
                    url: "workbench/activity/deleteBatchByIds",
                    data: ids + "&name=" + name + "&owner=" + owner + "&startDate=" + startDate + "&endDate" + endDate + "&pageNum=" + pageNum + "&pageSize=" + pageSize,
                    method: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data.code == "1") {
                            //删除成功
                            //刷新容器
                            $("#table").load("http://localhost:8080/crm/workbench/activity/index #table", function () {
                                //添加日历
                                addCalendar();
                                //添加全选按钮 和 小按钮的点击事件
                                addCheckBoxClick();
                            });
                        } else {
                            alert(data.message);
                        }
                    }
                });

            }

        }

        //封装  多条件分页AJAX请求
        function ajaxConditionsForSplitPage(pageNum) {
            //获取参数
            var name = $("#name").val();
            var owner = $("#owner").val();
            var startDate = $("#startDate").val();
            var endDate = $("#endDate").val();
            var pageNum = pageNum;
            var pageSize = $("#pageSize").val();

            //发送ajax 多条件查询分页请求
            $.ajax({
                url: "workbench/activity/queryAllByConditionsForSplitPage",
                data: {
                    name: name,
                    owner: owner,
                    startDate: startDate,
                    endDate: endDate,
                    pageNum: pageNum,
                    pageSize: pageSize
                },
                method: "post",
                success: function () {
                    //重新加载显示分页数据的容器
                    $("#table").load("http://localhost:8080/crm/workbench/activity/index #table", function () {
                        //添加日历
                        addCalendar();
                        //添加全选按钮 和 小按钮的点击事件
                        addCheckBoxClick();
                    });
                }
            })
        }


        //点击页码时，绑定多条件查询事件
        //改变pageSize时 绑定多条件查询事件

        //“修改”第一步 查询单个信息
        function editActivity() {
            //获取被选中的小框个数 只能为一个
            var checks = $("#tbody input[type='checkbox']:checked");
            if (checks.size() == 0) {
                alert("请选择要修改的市场活动");
                return;
            }
            if (checks.size() > 1) {
                alert("每次只能修改一条市场活动");
                return;
            }
            var id = checks[0].value;
            $.ajax({
                url: "workbench/activity/queryActivityById",
                method: "get",
                data: {
                    id: id
                },
                dataType: "json",
                success: function (data) {
                    //把市场活动的信息显示在修改的模态窗口上
                    $("#edit-marketActivityId").val(data.id);
                    $("#edit-marketActivityOwner").val(data.owner);
                    $("#edit-marketActivityName").val(data.name);
                    $("#edit-startDate").val(data.startDate);
                    $("#edit-endDate").val(data.endDate);
                    $("#edit-cost").val(data.cost);
                    $("#edit-description").val(data.description);
                    //显示模态窗口
                    $("#editActivityModal").modal("show");
                }
            })
        }

        //“编辑第二步” 更新数据库
        function saveEditActivity() {
            //获取更新参数
            var id = $("#edit-marketActivityId").val();
            var owner = $("#edit-marketActivityOwner").val();
            var name = $.trim($("#edit-marketActivityName").val());
            var startDate = $("#edit-startDate").val();
            var endDate = $("#edit-endDate").val();
            var cost = $.trim($("#edit-cost").val());
            var description = $.trim($("#edit-description").val());

            //获取页数 由于更新模块不在刷新的范围 所以不能从模块中传过来
            var pageNum = $.trim($("#pageNum").text());

            //表单验证
            if (owner == "") {
                alert("所有者不能为空");
                return;
            }
            if (name == "") {
                alert("名称不能为空");
                return;
            }
            if (startDate != "" && endDate != "") {
                //使用字符串的大小来代替日期的大小
                if (endDate < startDate) {
                    alert("结束日期不能比开始日期小")
                    return;
                }
            }

            //成本只能为非负数
            var regExp = /^(([1-9]\d*)|0)$/;
            if (!regExp.test(cost)) {
                alert("成本只能为非负整数");
                return;
            }

            //发送ajax请求
            $.ajax({
                url: "workbench/activity/saveEditActivity",
                method: "post",
                data: {
                    id: id,
                    owner: owner,
                    name: name,
                    startDate: startDate,
                    endDate: endDate,
                    cost: cost,
                    description: description
                },
                dataType: "json",
                success: function (data) {
                    if (data.code == "1") {
                        //关闭模态窗口
                        $("#editActivityModal").modal("hide");
                        //多条件分页查询
                        ajaxConditionsForSplitPage(pageNum);
                    } else {
                        //提示信息
                        alert(data.message);
                        //模态窗口不关闭
                        $("#editActivityModal").modal("show");
                    }
                }
            });
        }

        //下载（导出）要发同步请求
        //批量导出
        function exportAllActivities() {
            window.location.href = "workbench/activity/exportAllActivities";
        }

        //选择导出
        function exportSelectActivities() {
            //获取参数
            //导出的ids
            var checks = $("#tbody input[type='checkbox']:checked");

            //判断个数
            if (checks.size() == 0) {
                alert("请选择将要导出的活动");
                return;
            }

            var ids = "";
            $.each(checks, function (index) {
                if (index != checks.size() - 1) {
                    ids += "id=" + $(this).val() + "&";
                } else {
                    ids += "id=" + $(this).val();
                }
            });
            window.location.href = "workbench/activity/exportSelectActivities?"+ids;
            checks.prop("checked",false);
            $("#checkAll").prop("checked",false);
        }

        //导入
        function importActivities(){
            //先判断文件名是否符合要求
            var fileName =$("#activityFile").val();
            //截取类型
            var type=fileName.substring(fileName.lastIndexOf(".")+1).toLowerCase();
            if(type != "xls"){
                alert("只支持xls文件");
                return;
            }
            //判断文件的大小
            //获取文件
            var file = $("#activityFile")[0].files[0];
            if (file.size >5*1024*1024){
                alert("文件大小不超过5MB");
                return;
            }
            //FormData是ajax提供的接口,可以模拟键值对向后台提交参数;
            //FormData最大的优势是不但能提交文本数据，还能提交二进制数据
            var formData = new FormData();
            formData.append("multipartFile",file);
            //发送ajax请求
            $.ajax({
                url:"workbench/activity/importActivitiesByExcel",
                data:formData,
                processData:false,//设置ajax向后台提交参数之前，是否把参数统一转换成字符串：true--是,false--不是,默认是true
                contentType:false,//设置ajax向后台提交参数之前，是否把所有的参数统一按urlencoded编码：true--是,false--不是，默认是true
                type:"post",
                dataType:"json",
                success:function (data){
                    if (data.code == "1"){
                        //提示成功导入记录条数
                        alert("成功导入"+data.retData+"条记录");
                        //关闭模态窗口
                        $("#importActivityModal").modal("hide");
                        //刷新市场活动列表,显示第一页数据,保持每页显示条数不变
                        ajaxConditionsForSplitPage(1);
                    }else {
                        //提示信息
                        alert(data.message);
                        //模态窗口不关闭
                        $("#importActivityModal").modal("show");
                    }
                }
            })



        }



    </script>
</head>
<body>

<!-- 创建市场活动的模态窗口 -->
<div class="modal fade" id="createActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
            </div>
            <div class="modal-body">

                <form id="createActivityForm" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-marketActivityOwner">
                                <c:forEach items="${userList}" var="u">
                                    <option value="${u.id}">${u.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-marketActivityName">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-startDate" class="col-sm-2 control-label ">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control myDate" id="create-startDate" readonly>
                        </div>
                        <label for="create-endDate" class="col-sm-2 control-label ">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control myDate" id="create-endDate" readonly>
                        </div>
                    </div>
                    <div class="form-group">

                        <label for="create-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-cost">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-description" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-description"></textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" onclick="saveActivity()" id="saveActivityBtn">保存
                </button>
            </div>
        </div>
    </div>
</div>

<!-- 修改市场活动的模态窗口 -->
<div class="modal fade" id="editActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form">
                    <%--市场活动的id--%>
                    <input type="hidden" id="edit-marketActivityId">
                    <div class="form-group">
                        <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-marketActivityOwner">
                                <c:forEach items="${userList}" var="u">
                                    <option value="${u.id}">${u.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-marketActivityName">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-startDate" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control myDate" id="edit-startDate" readonly>
                        </div>
                        <label for="edit-endDate" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control myDate" id="edit-endDate" readonly>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-cost">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-description" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-description"></textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" onclick="saveEditActivity()">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 导入市场活动的模态窗口 -->
<div class="modal fade" id="importActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
            </div>
            <div class="modal-body" style="height: 350px;">
                <div style="position: relative;top: 20px; left: 50px;">
                    请选择要上传的文件：<small style="color: gray;">[仅支持.xls]</small>
                </div>
                <div style="position: relative;top: 40px; left: 50px;">
                    <input type="file" id="activityFile">
                </div>
                <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;">
                    <h3>重要提示</h3>
                    <ul>
                        <li>操作仅针对Excel，仅支持后缀名为XLS的文件。</li>
                        <li>给定文件的第一行将视为字段名。</li>
                        <li>请确认您的文件大小不超过5MB。</li>
                        <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                        <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                        <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                        <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                    </ul>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button onclick="importActivities()" type="button" class="btn btn-primary">导入</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>市场活动列表</h3>
        </div>
    </div>
</div>

<div id="table" style="position: relative; top: -20px; left: 0px; width: 100%; height: 700px;" class="clearfix">
    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input class="form-control" type="text" id="name" value="${activityVo.name}">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="owner" value="${activityVo.owner}">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">开始日期</div>
                        <input class="form-control myDate" type="text" id="startDate" value="${activityVo.startDate}"
                               readonly/>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">结束日期</div>
                        <input class="form-control myDate" type="text" id="endDate" value="${activityVo.endDate}"
                               readonly>
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="searchBtn"
                        onclick="ajaxConditionsForSplitPage(1)">查询
                </button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" onclick="creatActivityAjax()" id="creatActivityBtn">
                    <span class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button type="button" class="btn btn-default" onclick="editActivity()"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" class="btn btn-danger" id="delBtn"
                        onclick="deleteActivity(${activityInfo.pageNum})"><span
                        class="glyphicon glyphicon-minus"></span> 删除
                </button>
            </div>
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal">
                    <span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）
                </button>
                <button id="exportActivityAllBtn" onclick="exportAllActivities()" type="button" class="btn btn-default"><span
                        class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）
                </button>
                <button id="exportActivitySelectBtn" onclick="exportSelectActivities()" type="button" class="btn btn-default"><span
                        class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）
                </button>
            </div>
        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="checkAll"/></td>
                    <td>名称</td>
                    <td>所有者</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                </tr>
                </thead>
                <tbody id="tbody">
                <c:forEach items="${activityInfo.list}" var="act">
                    <tr class="active">
                        <td><input type="checkbox" value="${act.id}"/></td>
                        <td>
                            <a style="text-decoration: none; cursor: pointer;"
                               href='workbench/activity/queryActivityDetail?activityId=${act.id}'>${act.name}
                            </a>
                        </td>
                        <td>${act.owner}</td>
                        <td>${act.startDate}</td>
                        <td>${act.endDate}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>


        <div style="height: 50px; position: relative;top: 30px;">
            <div id="mytotal">
                <button type="button" class="btn btn-default" style="cursor: default;">共<b
                        style="padding: 0 7px">${activityInfo.total}</b>条记录
                </button>
            </div>
            <div class="btn-group" style="position: relative;top: -34px; left: 110px;">
                <button type="button" class="btn btn-default" style="cursor: default;">显示</button>
                <div class="btn-group">
                    <select id="pageSize" onchange="ajaxConditionsForSplitPage(${activityInfo.pageNum})"
                            class="btn btn-default" style="height: 34px;">
                        <c:choose>
                            <c:when test="${activityVo.pageSize == 10}">
                                <option value="10" selected>10</option>
                                <option value="20">20</option>
                                <option value="30">30</option>
                            </c:when>
                            <c:when test="${activityVo.pageSize == 20}">
                                <option value="10">10</option>
                                <option value="20" selected>20</option>
                                <option value="30">30</option>
                            </c:when>
                            <c:when test="${activityVo.pageSize == 30}">
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

            <div id="mypage" style="position: relative;top: -88px; left: 285px;">
                <nav>
                    <ul class="pagination">
                        <li>
                            <c:choose>
                                <c:when test="${activityInfo.isFirstPage}">
                                    <a href="javascript:;">首页</a>
                                </c:when>
                                <c:otherwise>
                                    <a href="javascript:ajaxConditionsForSplitPage(1)">首页</a>
                                </c:otherwise>
                            </c:choose>
                        </li>
                        <li>
                            <c:choose>
                                <c:when test="${activityInfo.hasPreviousPage}">
                                    <a href="javascript:ajaxConditionsForSplitPage(${activityInfo.prePage})">上一页</a>
                                </c:when>
                                <c:otherwise>
                                    <a href="javascript:;">上一页</a>
                                </c:otherwise>
                            </c:choose>
                        </li>
                        <%--页码栏--%>
                        <c:forEach begin="1" end="${activityInfo.pages}" var="i">
                            <c:if test="${activityInfo.pageNum == i}">
                                <li class="active"><a
                                        href="javascript:ajaxConditionsForSplitPage(${i})">${i}</a>
                                </li>
                            </c:if>
                            <c:if test="${activityInfo.pageNum != i}">
                                <li>
                                    <a href="javascript:ajaxConditionsForSplitPage(${i})">${i}</a>
                                </li>
                            </c:if>
                        </c:forEach>
                        <%--下一页--%>
                        <li>
                            <c:choose>
                                <c:when test="${activityInfo.hasNextPage}">
                                    <a href="javascript:ajaxConditionsForSplitPage(${activityInfo.nextPage})">下一页</a>
                                </c:when>
                                <c:otherwise>
                                    <a href="javascript:;">下一页</a>
                                </c:otherwise>
                            </c:choose>
                        </li>
                        <%--尾页--%>
                        <li>
                            <c:choose>
                                <c:when test="${activityInfo.isLastPage}">
                                    <a href="javascript:;">末页</a>
                                </c:when>
                                <c:otherwise>
                                    <a href="javascript:ajaxConditionsForSplitPage(${activityInfo.pages})">末页</a>
                                </c:otherwise>
                            </c:choose>
                        </li>
                        <li style=" margin-left:150px;color: #0e90d2;height: 35px; line-height: 35px;">总共&nbsp;&nbsp;&nbsp;<font
                                style="color:orange;">${activityInfo.pages}</font>&nbsp;&nbsp;&nbsp;页&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            当前&nbsp;&nbsp;&nbsp;<font
                                    style="color:orange;" id="pageNum">${activityInfo.pageNum}</font>&nbsp;&nbsp;&nbsp;页&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        </li>
                    </ul>
                </nav>
            </div>
        </div>


    </div>

</div>

<script type="text/javascript">


</script>

</body>
</html>