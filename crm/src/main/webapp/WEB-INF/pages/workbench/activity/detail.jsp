<%@page contentType="text/html;charset=utf-8" language="java" %>
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

    <script type="text/javascript">

        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;

        $(function () {
            $("#remark").focus(function () {
                if (cancelAndSaveBtnDefault) {
                    //设置remarkDiv的高度为130px
                    $("#remarkDiv").css("height", "130px");
                    //显示
                    $("#cancelAndSaveBtn").show("2000");
                    cancelAndSaveBtnDefault = false;
                }
            });

            $("#cancelBtn").click(function () {
                //显示
                $("#cancelAndSaveBtn").hide();
                //设置remarkDiv的高度为130px
                $("#remarkDiv").css("height", "90px");
                cancelAndSaveBtnDefault = true;
            });

            $("#remarkList").on("mouseover",".remarkDiv",function () {
                $(this).children("div").children("div").show();
            });


            $("#remarkList").on("mouseout",".remarkDiv",function () {
                $(this).children("div").children("div").hide();
            });

            $("#remarkList").on("mouseover",".myHref",function () {
                $(this).children("span").css("color","red");
            });

            $("#remarkList").on("mouseout",".myHref",function () {
                $(this).children("span").css("color","#E6E6E6");
            });

            //给评论输入框添加键盘按下事件
            $("#remarkDiv").keydown(function (e){
                if (e.keyCode == 13){
                    $("#saveRemarkBtn").trigger("click");
                }
            })


            //给保存按钮添加单击事件
            $("#saveRemarkBtn").click(function (e){
                //发送ajax请求保存remark
                var noteContent = $.trim($("#remark").val());
                //在js中使用JSTL时，记得使用""括起来
                var activityId = "${activity.id}";

                if (noteContent==""){
                    alert("备注内容不能为空");
                    return;
                }

                $.ajax({
                    url:"workbench/activity/saveActivityRemark",
                    data:{
                        noteContent:noteContent,
                        activityId:activityId
                    },
                    method:"post",
                    dataType:"json",
                    success:function (data){
                        if (data.code == "1"){
                            //清空输入框
                            $("#remark").val("");
                            //刷新备注列表
                            var htmlStr = "";
                            htmlStr+="<div id=\"div_"+data.retData.id+"\" class=\"remarkDiv\" style=\"height: 60px;\">";
                            htmlStr+="    <img title=\"${sessionScope.user.name}\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">";
                            htmlStr+="        <div style=\"position: relative; top: -40px; left: 40px;\" >";
                            htmlStr+="            <h5>"+data.retData.noteContent+"</h5>";
                            htmlStr+="            <font color=\"grey\">市场活动</font> <font color=\"grey\">-</font> <b>${activity.name}</b> <small style=\"color: grey;\"> "+data.retData.createTime+" 由${sessionScope.user.name}创建</small>";
                            htmlStr+="             <div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">";
                            htmlStr+="                <a class=\"myHref\" href=\"javascript:void(0);\" name=\"editA\"  remarkId=\""+data.retData.id+"\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
                            htmlStr+="                &nbsp;&nbsp;&nbsp;&nbsp;";
                            htmlStr+="                <a class=\"myHref\" href=\"javascript:void(0);\" name=\"deleteA\" remarkId=\""+data.retData.id+"\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
                            htmlStr+="            </div>";
                            htmlStr+="        </div>";
                            htmlStr+="</div>";
                            //添加
                            $("#remarkDiv").before(htmlStr);
                        }else {
                            alert(data.message);
                        }
                    }
                });
            });

            //给删除添加单击事件
            $("#remarkList").on("click","a[name='deleteA']",function (){
               //获取参数
               var id = $(this).attr("remarkId");
               //发送删除请求
                $.ajax({
                    url:"workbench/activity/deleteActivityRemark",
                    data:{
                        id:id
                    },
                    method:"post",
                    dataType: "json",
                    success:function (data){
                        if (data.code == "1"){
                            //刷新列表
                            $("#div_"+id).remove();
                        }else {
                            //提示信息
                            alert(data.message);
                        }
                    }
                })

            });

            //修改市场活动备注
            $("#remarkList").on("click","a[name='editA']",function (){
                //弹出修改市场活动备注的模态窗口
                $("#editRemarkModal").modal("show");
                //获取id,和 noteContent
                var id = $(this).attr("remarkId");
                var noteContent = $("#div_"+id+" h5").text();
                //将其赋值到模态窗口
                $("#remarkId").val(id);
                $("#noteContent").val(noteContent);
            });

            //保存修改市场活动备注
            $("#updateRemarkBtn").click(function (){
                //获取参数
                var id = $("#remarkId").val();
                var noteContent = $("#noteContent").val();

                //备注内容不能为空
                if (noteContent==""){
                    alert("备注内容不能为空");
                    return;
                }

                //发送更新请求
                $.ajax({
                    url:"workbench/activity/saveEditActivityRemark",
                    data:{
                        id:id,
                        noteContent:noteContent
                    },
                    method:"post",
                    dataType:"json",
                    success:function (data){

                        if (data.code=="1"){
                            //修改成功之后,关闭模态窗口
                            $("#editRemarkModal").modal("hide");
                            //刷新备注列表
                            $("#div_"+id+" h5").text(data.retData.noteContent);
                            $("#div_"+id+" small").text(" "+data.retData.editTime+" 由${sessionScope.user.name}修改");
                        }else {
                            //修改失败,提示信息,模态窗口不关闭,列表也不刷新
                            alert(data.message)
                            $("#editRemarkModal").modal("show");
                        }

                    }
                })
            })



        });

    </script>

</head>
<body>

<!-- 修改市场活动备注的模态窗口 -->
<div class="modal fade" id="editRemarkModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 40%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改备注</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <%-- 备注的id --%>
                    <input type="hidden" id="remarkId">
                    <div class="form-group">
                        <label for="noteContent" class="col-sm-2 control-label">内容</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="noteContent"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
            </div>
        </div>
    </div>
</div>


<!-- 返回按钮 -->
<div style="position: relative; top: 35px; left: 10px;">
    <a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left"
                                                                         style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; left: 40px; top: -30px;">
    <div class="page-header">
        <h3>市场活动-${activity.name} <small>${activity.startDate} ~ ${activity.endDate}</small></h3>
    </div>

</div>

<br/>
<br/>
<br/>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: rgb(128,128,128);">所有者</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.owner}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: rgb(128,128,128);">名称</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.name}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>

    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; rgb(128,128,128);">开始日期</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.startDate}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px;rgb(128,128,128);">结束日期</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.endDate}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color:rgb(128,128,128);">成本</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.cost}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color:rgb(128,128,128);">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>&nbsp;${activity.createBy}&nbsp;</b><small
                style="font-size: 10px; color: grey;">${activity.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: grey;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.editBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: grey;">${activity.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: grey;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${activity.description}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div id="remarkList" style="position: relative; top: 30px; left: 40px;">
    <div class="page-header">
        <h4>备注</h4>
    </div>
    <!-- 备注 -->
    <c:forEach items="${activityRemarkList}" var="remark">
        <div id="div_${remark.id}" class="remarkDiv" style="height: 60px;">
            <img title="${remark.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
            <div style="position: relative; top: -40px; left: 40px;">
                <h5>${remark.noteContent}</h5>
                <font color="grey">市场活动</font> <font color="grey">-</font> <b>${activity.name}</b> <small style="color: grey;">
                ${remark.editFlag == "0"?remark.createTime:remark.editTime} 由${remark.editFlag == "0"?remark.createBy:remark.editBy}${remark.editFlag == "0"?"创建":"修改"}</small>
                <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                    <a class="myHref" href="javascript:void(0);" name="editA" remarkId="${remark.id}"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <a class="myHref" href="javascript:void(0);" name="deleteA" remarkId="${remark.id}"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
                </div>
            </div>
        </div>
    </c:forEach>



    <div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
        <form role="form" style="position: relative;top: 10px; left: 10px;">
            <textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"
                      placeholder="添加备注..."></textarea>
            <p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
                <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
                <button id="saveRemarkBtn" type="button" class="btn btn-primary">保存</button>
            </p>
        </form>
    </div>
</div>
<div style="height: 200px;"></div>
</body>
</html>