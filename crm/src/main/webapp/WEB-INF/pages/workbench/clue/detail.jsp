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

            $("#remarkList").on("mouseover",".remarkDiv",function (){
                $(this).children("div").children("div").show();
            })

            $("#remarkList").on("mouseout",".remarkDiv",function (){
                $(this).children("div").children("div").hide();
            })

            $("#remarkList").on("mouseover",".myHref",function (){
                $(this).children("span").css("color", "red");
            })
            $("#remarkList").on("mouseout",".myHref",function (){
                $(this).children("span").css("color", "#E6E6E6");
            })

            //给评论输入框添加键盘按下事件
            $("#remarkDiv").keydown(function (e){
                if (e.keyCode==13){
                    $("#saveRemarkBtn").trigger("click");
                }
            })


            //给保存按钮添加点击事件
            $("#saveRemarkBtn").click(function (){
                //获取参数
                var noteContent = $("#remark").val();
                var clueId = "${clue.id}";

                if (noteContent=="") {
                    alert("内容不能为空");
                    return;
                }
                $.ajax({
                    url:"workbench/clue/saveClueRemark",
                    data:{
                        noteContent:noteContent,
                        clueId:clueId
                    },
                    method:"post",
                    dataType:"json",
                    success:function (data){
                        if (data.code == "1") {
                            //清空输入框
                            $("#remark").val("");

                            //生成备注
                            var htmlStr="";
                            htmlStr +="<div id=\"div_"+data.retData.id+"\" class=\"remarkDiv\" style=\"height: 60px;\">";
                            htmlStr +="    <img title=\""+data.retData.createBy+"\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">";
                            htmlStr +="        <div style=\"position: relative; top: -40px; left: 40px;\" >";
                            htmlStr +="            <h5>"+data.retData.noteContent+"</h5>" ;
                            htmlStr +="            <font color=\"grey\">线索</font> <font color=\"grey\">-</font> <b>${clue.fullname}${clue.appellation}-${clue.company}</b> <small style=\"color: grey;\"> "+data.retData.createTime+" 由${sessionScope.user.name}创建</small>" ;
                            htmlStr +="            <div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">" ;
                            htmlStr +="                <a class=\"myHref\" remarkId=\""+data.retData.id+"\" name=\"editA\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>" ;
                            htmlStr +="                &nbsp;&nbsp;&nbsp;&nbsp;" ;
                            htmlStr +="                <a class=\"myHref\" remarkId=\""+data.retData.id+"\" name=\"deleteA\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>" ;
                            htmlStr +="            </div>";
                            htmlStr +="        </div>";
                            htmlStr +="</div>";
                            //添加
                            $("#remarkDiv").before($(htmlStr));
                        }else {
                            alert(data.message);
                        }

                    }
                })
            });

            //给删除添加点击事件
            $("#remarkList").on("click","a[name='deleteA']",function (){
               //获取参数
                var id = $(this).attr("remarkId");
                $.ajax({
                    url:"workbench/clue/deleteClueRemark",
                    data:"id="+id,
                    method: "post",
                    dataType: "json",
                    success:function (data){
                        if (data.code=="1"){
                            //将备注去掉
                            $("#div_"+id).remove();
                        }else {
                            alert(data.message);
                        }

                    }
                });
            });

            //给编辑添加点击事件
            $("#remarkList").on("click","a[name='editA']",function (){
                //获取参数
                var id = $(this).attr("remarkId");
                var noteContent = $("#div_"+id+" h5").text()
                //给模态窗口赋值
                $("#remarkId").val(id);
                $("#noteContent").val(noteContent);
                //弹出修改市场活动备注的模态窗口
                $("#editRemarkModal").modal("show");
            });

            //给更新添加点击事件
            $("#updateRemarkBtn").click(function (){
                //获取参数
                var id = $("#remarkId").val();
                var noteContent = $.trim($("#noteContent").val());

                if (noteContent==""){
                    alert("内容不能为空");
                    return;
                }
                //发送请求
                $.ajax({
                    url:"workbench/clue/saveEditClueRemark",
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

                            //更新内容
                            $("#div_"+id+" h5").text(data.retData.noteContent);
                            $("#div_"+id+" small").text(" "+data.retData.editTime+" 由${sessionScope.user.name}修改");

                        }else {
                            //修改失败,提示信息,模态窗口不关闭,列表也不刷新
                            alert(data.message);
                            $("#editRemarkModal").modal("show");
                        }
                    }
                });
            });

            //给关联市场活动添加点击事件
            $("#relatedActivityA").click(function (){
                //初始化
                //将搜索框清空
                $("#relatedActivityTXT").val("");
                //将列表清空
                $("#tbody").html("");

                //显示模态窗口
                $("#bundModal").modal("show");
            });

            $("#relatedActivityTXT").keydown(function (e){
                if (e.keyCode == 13){
                    e.preventDefault();
                }
            })

            $("#relatedActivityTXT").keyup(function (){
                //获取参数
                var name = $(this).val();
                var clueId = "${clue.id}";

                //发送请求
                $.ajax({
                    url:"workbench/clue/queryActivityForDetailByExcludeClueId",
                    data:{
                        name:name,
                        clueId:clueId
                    },
                    method:"post",
                    dataType:"json",
                    success:function (data){
                        //根据返回结果生成市场活动列表
                        var htmlStr="";
                        $.each(data,function (){
                            htmlStr+="<tr id=\"tr_"+this.id+"\">";
                            htmlStr+="    <td><input value=\""+this.id+"\" type=\"checkbox\"/></td>";
                            htmlStr+="    <td>"+this.name+"</td>";
                            htmlStr+="    <td>"+this.startDate+"</td>";
                            htmlStr+="    <td>"+this.endDate+"</td>";
                            htmlStr+="    <td>"+this.owner+"</td>";
                            htmlStr+="</tr>";
                        });
                        //覆盖写
                        $("#tbody").html(htmlStr);

                    }
                });
            });

            //复选框加点击事件
            $("#checkAll").click(function (){
                $("#tbody input[type='checkbox']").prop("checked",this.checked);
            })
            $("#tbody").on("click","input[type='checkbox']",function (){
                if ($("#tbody input[type='checkbox']:checked").size()==$("#tbody input[type='checkbox']").size()){
                    $("#checkAll").prop("checked",true);
                }else {
                    $("#checkAll").prop("checked",false);
                }
            })

            //点击"关联"按钮,完成线索关联市场活动的功能
            $("#relatedActivityBtn").click(function (){
               //获取参数
                var checks = $("#tbody input:checked");
                if (checks.size()==0){
                    alert("请选择要关联的活动");
                    return;
                }
                var ids="";
                $.each(checks,function (){
                   ids+="activityId="+this.value+"&"
                });
                var clueId = "${clue.id}";

                //发送请求
                $.ajax({
                    url:"workbench/clue/createClueActivityRelation",
                    data:ids+"clueId="+clueId,
                    method:"post",
                    dataType:"json",
                    success:function (data){
                        if (data.code=="1"){
                            var htmlStr = "";
                            $.each(data.retData,function (){
                                //在查询列表中去除
                                $("#tr_"+this.id).remove();
                                //在关联列表添加
                                htmlStr+="<tr id=\"actTr_"+this.id+"\">";
                                htmlStr+="    <td>"+this.name+"</td>";
                                htmlStr+="    <td>"+this.startDate+"</td>";
                                htmlStr+="    <td>"+this.endDate+"</td>";
                                htmlStr+="    <td>"+this.owner+"</td>";
                                htmlStr+="    <td><a href=\"javascript:void(0);\" activityId=\""+this.id+"\"  style=\"text-decoration: none;\"><span class=\"glyphicon glyphicon-remove\"></span>解除关联</a></td>";
                                htmlStr+="</tr>";
                            });
                            $("#activityBody").append($(htmlStr));
                            //将全选框清空
                            $("#checkAll").prop("checked",false);
                        }else {
                            alert(data.message);
                        }
                    }
                });
            });

            //解除线索关联市场活动
            $("#activityBody").on("click","a",function (){

                if (window.confirm("确定删除吗？")){
                    //获取参数
                    var activityId = $(this).attr("activityId");
                    var clueId = "${clue.id}";
                    //发送请求
                    $.ajax({
                        url:"workbench/clue/deleteClueActivityRelation",
                        data:{
                            activityId:activityId,
                            clueId:clueId
                        },
                        method:"post",
                        dataType:"json",
                        success:function (data){
                            if (data.code=="1"){
                                //刷新已经关联的市场活动列表
                                $("#actTr_"+activityId).remove();
                            }else {
                                alert(data.message);
                            }
                        }
                    });
                }
            });

            //点击"转换"按钮,跳转到线索转换页面
            $("#clueConvertBtn").click(function (){
                //发送同步请求
                window.location.href="workbench/clue/toClueConvert?clueId="+"${clue.id}";
            })

        });

    </script>

</head>
<body>

<!-- 关联市场活动的模态窗口 -->
<div class="modal fade" id="bundModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">关联市场活动</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input id="relatedActivityTXT" type="text" class="form-control" style="width: 300px;"
                                   placeholder="请输入市场活动名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td><input id="checkAll" type="checkbox"/></td>
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
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" id="relatedActivityBtn">关联</button>
            </div>
        </div>
    </div>
</div>


<!-- 修改线索备注的模态窗口 -->
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
        <h3>${clue.fullname}${clue.appellation} <small>${clue.company}</small></h3>
    </div>
    <div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
        <button type="button" class="btn btn-default" id="clueConvertBtn"><span
                class="glyphicon glyphicon-retweet"></span> 转换
        </button>

    </div>
</div>

<br/>
<br/>
<br/>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: grey;">名称</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.fullname}${clue.appellation}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: grey;">所有者</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.owner}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: grey;">公司</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.company}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: grey;">职位</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.job}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: grey;">邮箱</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.email}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: grey;">公司座机</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.phone}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: grey;">公司网站</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.website}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: grey;">手机</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.mphone}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: grey;">线索状态</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.state}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: grey;">线索来源</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.source}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: grey;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.createBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: grey;">${clue.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 60px;">
        <div style="width: 300px; color: grey;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.editBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: grey;">${clue.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 70px;">
        <div style="width: 300px; color: grey;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${clue.description}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 80px;">
        <div style="width: 300px; color: grey;">联系纪要</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${clue.contactSummary}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 90px;">
        <div style="width: 300px; color: grey;">下次联系时间</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.nextContactTime}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 100px;">
        <div style="width: 300px; color: grey;">详细地址</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${clue.address}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div id="remarkList" style="position: relative; top: 40px; left: 40px;">
    <div class="page-header">
        <h4>备注</h4>
    </div>
    <!-- 备注 -->
    <c:forEach items="#{clueRemarkList}" var="remark">
        <div id="div_${remark.id}" class="remarkDiv" style="height: 60px;">
            <img title="${remark.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
            <div style="position: relative; top: -40px; left: 40px;">
                <h5>${remark.noteContent}</h5>
                <font color="grey">线索</font> <font color="grey">-</font> <b>${clue.fullname}${clue.appellation}-${clue.company}</b> <small
                    style="color: grey;"> ${remark.editFlag == "0"?remark.createTime:remark.editTime} 由${remark.editFlag == "0"?remark.createBy:remark.editBy}${remark.editFlag == "0"?"创建":"编辑"}</small>
                <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                    <a class="myHref" remarkId="${remark.id}" href="javascript:void(0);" name="editA"><span class="glyphicon glyphicon-edit"
                                                                       style="font-size: 20px; color: #E6E6E6;"></span></a>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <a class="myHref" remarkId="${remark.id}" href="javascript:void(0);" name="deleteA"><span class="glyphicon glyphicon-remove"
                                                                       style="font-size: 20px; color: #E6E6E6;"></span></a>
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
                <button type="button" class="btn btn-primary" id="saveRemarkBtn">保存</button>
            </p>
        </form>
    </div>
</div>

<!-- 市场活动 -->
<div>
    <div style="position: relative; top: 60px; left: 40px;">
        <div class="page-header">
            <h4>市场活动</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table class="table table-hover" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>名称</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                    <td>所有者</td>
                    <td></td>
                </tr>
                </thead>
                <tbody id="activityBody">
                <c:forEach items="${activityList}" var="activity">
                    <tr id="actTr_${activity.id}">
                        <td>${activity.name}</td>
                        <td>${activity.startDate}</td>
                        <td>${activity.endDate}</td>
                        <td>${activity.owner}</td>
                        <td><a href="javascript:void(0);" style="text-decoration: none;" activityId="${activity.id}"><span
                                class="glyphicon glyphicon-remove"></span>解除关联</a></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <div>
            <a href="javascript:void(0);" id="relatedActivityA" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
        </div>
    </div>
</div>


<div style="height: 200px;"></div>
</body>
</html>