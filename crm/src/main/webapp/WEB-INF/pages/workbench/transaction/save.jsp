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
    <script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
    <script type="text/javascript">
        $(function (){
            //给市场活动源添加事件
            $("#activitySourceA").click(function (){
                //初始化
                $("#activityNameTXT").val("");
                $("#activityTbody").html("");
                $("#findMarketActivity").modal("show");
            })

            $("#activityNameTXT").keydown(function (e){
                if (e.keyCode==13){
                    e.preventDefault();
                }
            })

            $("#activityNameTXT").keyup(function (){
                var activityName = this.value;
                if (activityName==""){
                    return;
                }
                $.ajax({
                    url:"workbench/transaction/queryActivityByActivityName",
                    data: {
                        activityName:activityName
                    },
                    method:"get",
                    dataType:"json",
                    success:function (data){
                        var strHtml = "";
                        $.each(data,function (index,obj){
                            strHtml+="<tr>";
                            strHtml+="    <td><input type=\"radio\" activityName=\""+obj.name+"\" name=\"activity\" value=\""+obj.id+"\"/></td>";
                            strHtml+="    <td>"+obj.name+"</td>";
                            strHtml+="    <td>"+obj.startDate+"</td>";
                            strHtml+="    <td>"+obj.endDate+"</td>";
                            strHtml+="    <td>"+obj.owner+"</td>";
                            strHtml+="</tr>";
                        });
                        //添加（覆盖写）
                        $("#activityTbody").html($(strHtml));
                    }
                });
            });

            //给单选框添加点击事件
            $("#activityTbody").on("click","input[type='radio']",function (){
                var activityId = $(this).val();
                var activityName = $(this).attr("activityName");
                $("#create-activityName").val(activityName);
                $("#create-activityId").val(activityId);
                //关闭模态窗口
                $("#findMarketActivity").modal("hide");
            });


            //给联系人添加事件
            $("#contactsNameA").click(function (){
                //初始化
                $("#contactsNameTXT").val("");
                $("#contactTbody").html("");
                //显示模态窗口
                $("#findContacts").modal("show");
            })

            $("#contactsNameTXT").keydown(function (e){
                if (e.keyCode==13){
                    e.preventDefault();
                }
            });

            $("#contactsNameTXT").keydown(function (){
                var contactsName = this.value;
                $.ajax({
                    url:"workbench/transaction/queryContactsByName",
                    data:{
                        contactsName:contactsName
                    },
                    method:"get",
                    dataType: "json",
                    success:function (data){
                        var strHtml="";
                        $.each(data,function (index,obj){
                            strHtml+="<tr>";
                            strHtml+="    <td><input type=\"radio\" contactsName=\""+obj.fullname+"\" value=\""+obj.id+"\" name=\"activity\"/></td>";
                            strHtml+="    <td>"+obj.fullname+"</td>";
                            strHtml+="    <td>"+obj.email+"</td>";
                            strHtml+="    <td>"+obj.mphone+"</td>";
                            strHtml+="</tr>";
                        });
                        $("#contactTbody").html($(strHtml));
                    }
                })

            })

            $("#contactTbody").on("click","input[type='radio']",function (){
                var contactsId= $(this).val();
                var contactsName = $(this).attr("contactsName");
                //赋值
                $("#create-contactsId").val(contactsId);
                $("#create-contactsName").val(contactsName);
                //隐藏
                $("#findContacts").modal("hide");
            })

            //加日历
            addCalendar();

            //配置可能性 给"阶段"下拉框添加change事件
            $("#create-stage").change(function (){
                //获取下拉框的值
                var stageName = $("#create-stage option:selected").text();

                //表单验证
                if (stageName==""){
                    return;
                }

                //发送请求
                $.ajax({
                    url:"workbench/transaction/getPossibility",
                    data:{
                        stageName:stageName
                    },
                    method:"get",
                    dataType:"json",
                    success:function (data){
                        $("#create-possibility").val(data+"%");
                    }
                })
            });

            //客户名称自动补全
            $("#create-customerName").typeahead({
                source:function (jquery,process){
                    //每次键盘弹起，都自动触发本函数；我们可以向后台送请求，查询客户表中所有的名称，把客户名称以[]字符串形式返回前台，赋值给source
                    //process：是个函数，能够将['xxx','xxxxx','xxxxxx',.....]字符串赋值给source，从而完成自动补全
                    //jquery：在容器中输入的关键字

                    //发送请求
                    $.ajax({
                        url:"workbench/transaction/queryCustomerNameByName",
                        data:{
                            customerName:jquery
                        },
                        method:"get",
                        dataType:"json",
                        success:function (data){
                            process(data);
                        }
                    })

                }
            });

            //给“保存”按钮添加点击事件
            $("#saveCreateTranBtn").click(function (){
               //获取参数
                var owner          =$("#create-owner").val();
                var money          =$.trim($("#create-money").val());
                var name           =$.trim($("#create-name").val());
                var expectedDate   =$("#create-expectedDate").val();
                var stage          =$("#create-stage").val();
                var type           =$("#create-type").val();
                var source         =$("#create-source").val();
                var activityId     =$("#create-activityId").val();
                var contactsId     =$("#create-contactsId").val();
                var description    =$.trim($("#create-description").val());
                var contactSummary =$.trim($("#create-contactSummary").val());
                var nextContactTime=$("#create-nextContactTime").val();

                var customerName     =$.trim($("#create-customerName").val());

                //表单验证
                if (name==""){
                    alert("名称不能为空！")
                    return;
                }
                if (expectedDate==""){
                    alert("预计成交日期不能为空！")
                    return;
                }
                if (customerName==""){
                    alert("客户名称不能为空！")
                    return;
                }
                if (stage==""){
                    alert("阶段不能为空！")
                    return;
                }
                //成本只能为非负数
                var regExp = /^(([1-9]\d*)|0)$/;
                if (!regExp.test(money)) {
                    alert("金额只能为非负整数");
                    return;
                }

               //发送请求
                $.ajax({
                    url:"workbench/transaction/saveCreateTran",
                    data:{
                        owner          :owner          ,
                        money          :money          ,
                        name           :name           ,
                        expectedDate   :expectedDate   ,
                        stage          :stage          ,
                        type           :type           ,
                        source         :source         ,
                        activityId     :activityId     ,
                        contactsId     :contactsId     ,
                        description    :description    ,
                        contactSummary :contactSummary ,
                        nextContactTime:nextContactTime,
                        customerName   :customerName
                    },
                    method:"post",
                    dataType:"json",
                    success:function (data){
                        if (data.code=="1"){
                            window.location.href="workbench/transaction/queryAllForSplitPage";
                        }else {
                            alert(data.message);
                            return;
                        }

                    }
                })
            });



        });

        //加日历
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



    </script>

</head>
<body>

<!-- 查找市场活动 -->
<div class="modal fade" id="findMarketActivity" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">查找市场活动</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" id="activityNameTXT" class="form-control" style="width: 300px;"
                                   placeholder="请输入市场活动名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable3" class="table table-hover"
                       style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td></td>
                        <td>名称</td>
                        <td>开始日期</td>
                        <td>结束日期</td>
                        <td>所有者</td>
                    </tr>
                    </thead>
                    <tbody id="activityTbody">
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- 查找联系人 -->
<div class="modal fade" id="findContacts" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">查找联系人</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" id="contactsNameTXT" class="form-control" style="width: 300px;"
                                   placeholder="请输入联系人名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td></td>
                        <td>名称</td>
                        <td>邮箱</td>
                        <td>手机</td>
                    </tr>
                    </thead>
                    <tbody id="contactTbody">
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>


<div style="position:  relative; left: 30px;">
    <h3>创建交易</h3>
    <div style="position: relative; top: -40px; left: 70%;">
        <button type="button" class="btn btn-primary" id="saveCreateTranBtn">保存</button>
        <button type="button" class="btn btn-default">取消</button>
    </div>
    <hr style="position: relative; top: -40px;">
</div>
<form class="form-horizontal" role="form" style="position: relative; top: -30px;">

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
        <label for="create-money" class="col-sm-2 control-label">金额</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-money">
        </div>
    </div>

    <div class="form-group">
        <label for="create-name" class="col-sm-2 control-label">名称<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-name">
        </div>
        <label for="create-expectedDate" class="col-sm-2 control-label">预计成交日期<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control myDate" id="create-expectedDate" readonly>
        </div>
    </div>

    <div class="form-group">
        <label for="create-customerName" class="col-sm-2 control-label">客户名称<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-customerName"
                   placeholder="支持自动补全，输入客户不存在则新建">
        </div>
        <label for="create-stage" class="col-sm-2 control-label">阶段<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-stage">
                <option></option>
               <c:forEach items="${stageList}" var="stage">
                   <option value="${stage.id}">${stage.value}</option>
               </c:forEach>
            </select>
        </div>
    </div>

    <div class="form-group">
        <label for="create-type" class="col-sm-2 control-label">类型</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-type">
                <option></option>
                <c:forEach items="${transactionTypeList}" var="transactionType">
                    <option value="${transactionType.id}">${transactionType.value}</option>
                </c:forEach>
            </select>
        </div>
        <label for="create-possibility" class="col-sm-2 control-label">可能性</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-possibility" readonly>
        </div>
    </div>

    <div class="form-group">
        <label for="create-source" class="col-sm-2 control-label">来源</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-source">
                <option></option>
               <c:forEach items="${sourceList}" var="source">
                   <option value="${source.id}">${source.value}</option>
               </c:forEach>
            </select>
        </div>
        <label for="create-activityName" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a
                href="javascript:void(0);" id="activitySourceA"><span
                class="glyphicon glyphicon-search"></span></a></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-activityName" readonly>
            <input type="hidden" id="create-activityId">
        </div>
    </div>

    <div class="form-group">
        <label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a
                href="javascript:void(0);" id="contactsNameA"><span
                class="glyphicon glyphicon-search"></span></a></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="hidden" id="create-contactsId">
            <input type="text" class="form-control" id="create-contactsName" readonly>
        </div>
    </div>

    <div class="form-group">
        <label for="create-description" class="col-sm-2 control-label">描述</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea class="form-control" rows="3" id="create-description"></textarea>
        </div>
    </div>

    <div class="form-group">
        <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
        </div>
    </div>

    <div class="form-group">
        <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control myDate" id="create-nextContactTime" readonly>
        </div>
    </div>

</form>
</body>
</html>