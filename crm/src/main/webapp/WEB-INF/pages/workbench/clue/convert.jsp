<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String path = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
    <base href="<%=path%>">
    <meta charset="UTF-8">

    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>


    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
          rel="stylesheet"/>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <script type="text/javascript">
        $(function () {
            $("#isCreateTransaction").click(function () {
                if (this.checked) {
                    $("#create-transaction2").show(200);
                } else {
                    $("#create-transaction2").hide(200);
                }
            });

            //搜索市场活动源
            $("#searchSource").click(function (){
                //弹出搜索市场活动的模态窗口
                $("#searchActivityModal").modal("show");
                //给搜索框添加事件
                $("#searchActivityTXT").keydown(function (e){
                    if (e.keyCode==13){
                        e.preventDefault();
                    }
                })

                $("#searchActivityTXT").keyup(function (){
                    //获取参数
                    var activityName = this.value;
                    var clueId = "${clue.id}";

                    //发送请求
                    $.ajax({
                        url:"workbench/clue/queryActivityForConvertByIncludeClueId",
                        data:{
                            activityName:activityName,
                            clueId:clueId
                        },
                        method:"get",
                        dataType:"json",
                        success:function (activityList){
                            //根据返回结果，生成响应信息
                            var htmlStr = "";
                            $.each(activityList,function (index,obj){
                                htmlStr+="<tr>";
                                htmlStr+="    <td><input type=\"radio\" value=\""+obj.id+"\" activityName=\""+obj.name+"\" name=\"activity\"/></td>";
                                htmlStr+="    <td>"+obj.name+"</td>";
                                htmlStr+="    <td>"+obj.startDate+"</td>";
                                htmlStr+="    <td>"+obj.endDate+"</td>";
                                htmlStr+="    <td>"+obj.owner+"</td>";
                                htmlStr+="</tr>";
                            });
                            //覆盖写
                            $("#tbody").html($(htmlStr));
                        }
                    });
                });

            });

            //单选框点击事件
            $("#tbody").on("click","input[type='radio']",function (){
                //获取参数
                var activityId = this.value;
                var activityName = $(this).attr("activityName");

                //赋值
                $("#activityId").val(activityId);
                $("#activityName").val(activityName);

                //关闭模态窗口
                $("#searchActivityModal").modal("hide");
            });

            //点击"转换"按钮,完成线索转换的功能
            $("#convertBtn").click(function (){

                if (window.confirm("确定转换吗？")){
                    //获取参数
                    var money = $("#tradeMoney").val();
                    var name = $("#tradeName").val();
                    var expectedDate = $("#expectedDate").val();
                    var stage = $("#stage").val();
                    var activityId =$("#activityId").val();
                    var clueId = "${clue.id}";
                    var isCreateTran = $("#isCreateTransaction").prop("checked");
                    //发送post异步请求
                    $.ajax({
                        url:"workbench/clue/covertClue",
                        data:{
                            money:money,
                            name:name,
                            expectedDate:expectedDate,
                            stage:stage,
                            activityId:activityId,
                            clueId:clueId,
                            isCreateTran:isCreateTran
                        },
                        method: "post",
                        dataType: "json",
                        success:function (data){
                            if (data.code=="1"){
                                window.location.href="workbench/clue/queryAllForSplitPage";
                            }else {
                                alert(data.message)
                            }
                        }
                    })
                }

            });
            //取消
            $("#cancel").click(function (){
                window.history.back();
            })


            //加日历
            addCalendar();

        });

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



    </script>

</head>
<body>

<!-- 搜索市场活动的模态窗口 -->
<div class="modal fade" id="searchActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">搜索市场活动</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" id="searchActivityTXT" class="form-control" style="width: 300px;"
                                   placeholder="请输入市场活动名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td></td>
                        <td>名称</td>
                        <td>开始日期</td>
                        <td>结束日期</td>
                        <td>所有者</td>
                        <td></td>
                    </tr>
                    </thead>
                    <tbody id="tbody">
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<div id="title" class="page-header" style="position: relative; left: 20px;">
    <h4>转换线索 <small>${clue.fullname}${clue.appellation}-${clue.company}</small></h4>
</div>
<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
    新建客户：${clue.company}
</div>
<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
    新建联系人：${clue.fullname}${clue.appellation}
</div>
<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
    <input type="checkbox" id="isCreateTransaction"/>
    为客户创建交易
</div>
<div id="create-transaction2"
     style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;">

    <form>

        <div class="form-group" style="width: 400px; position: relative; left: 20px;">
            <label for="tradeMoney">金额</label>
            <input type="text" class="form-control" id="tradeMoney">
        </div>
        <div class="form-group" style="width: 400px;position: relative; left: 20px;">
            <label for="tradeName">交易名称</label>
            <input type="text" class="form-control" id="tradeName" value="${clue.company}-">
        </div>
        <div class="form-group" style="width: 400px;position: relative; left: 20px;">
            <label for="expectedDate">预计成交日期</label>
            <input type="text" class="form-control myDate" id="expectedDate">
        </div>
        <div class="form-group" style="width: 400px;position: relative; left: 20px;">
            <label for="stage">阶段</label>
            <select id="stage" class="form-control">
                <option></option>
                <c:forEach items="${stageList}" var="stage">
                    <option value="${stage.id}">${stage.value}</option>
                </c:forEach>
            </select>
        </div>
        <div class="form-group" style="width: 400px;position: relative; left: 20px;">
            <label for="activityName">市场活动源&nbsp;&nbsp;
                <a href="javascript:void(0);" id="searchSource" style="text-decoration: none;">
                    <span class="glyphicon glyphicon-search"></span>
                </a>
            </label>
            <input id="activityId" type="hidden">
            <input type="text" class="form-control" id="activityName" placeholder="点击上面搜索" readonly>
        </div>
    </form>

</div>

<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
    记录的所有者：<br>
    <b>${clue.owner}</b>
</div>
<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
    <input class="btn btn-primary" type="button" id="convertBtn" value="转换">
    &nbsp;&nbsp;&nbsp;&nbsp;
    <input class="btn btn-default" type="button" id="cancel" value="取消">
</div>
</body>
</html>