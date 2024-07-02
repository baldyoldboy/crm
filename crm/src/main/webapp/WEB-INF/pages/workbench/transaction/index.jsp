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

        $(function () {
            //给创建添加点击事件
            $("#createTransactionBtn").click(function (){
                //发送同步请求
                window.location.href="workbench/transaction/toSave";
            });



        });

    </script>
</head>
<body>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>交易列表</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input class="form-control" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">客户名称</div>
                        <input class="form-control" type="text">
                    </div>
                </div>

                <br>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">阶段</div>
                        <select class="form-control">
                            <option></option>
                            <c:forEach items="${stageList}" var="stage">
                                <option value="${stage.id}">${stage.value}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">类型</div>
                        <select class="form-control">
                            <option></option>
                            <c:forEach items="${transactionTypeList}" var="t">
                                <option value="${t.id}">${t.value}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">来源</div>
                        <select class="form-control" id="create-clueSource">
                            <option></option>
                            <c:forEach items="${sourceList}" var="source">
                                <option value="${source.id}">${source.value}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">联系人名称</div>
                        <input class="form-control" type="text">
                    </div>
                </div>

                <button type="submit" class="btn btn-default">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="createTransactionBtn"><span
                        class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button type="button" class="btn btn-default" onclick="window.location.href='edit.html';"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除
                </button>
            </div>


        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox"/></td>
                    <td>名称</td>
                    <td>客户名称</td>
                    <td>阶段</td>
                    <td>类型</td>
                    <td>所有者</td>
                    <td>来源</td>
                    <td>联系人名称</td>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${tranPageInfo.list}" var="tran">
                    <tr>
                        <td><input value="${tran.id}" type="checkbox"/></td>
                        <td><a style="text-decoration: none; cursor: pointer;"
                               onclick="window.location.href='workbench/transaction/toTransactionDetail?tranId=${tran.id}';">${tran.name}</a></td>
                        <td>${tran.customerId}</td>
                        <td>${tran.stage}</td>
                        <td>${tran.type}</td>
                        <td>${tran.owner}</td>
                        <td>${tran.source}</td>
                        <td>${tran.contactsId}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 20px;">
            <div>
                <button type="button" class="btn btn-default" style="cursor: default;">共<b>${tranPageInfo.total}</b>条记录
                </button>
            </div>
            <div class="btn-group" style="position: relative;top: -34px; left: 110px;">
                <button type="button" class="btn btn-default" style="cursor: default;">显示</button>
                <div class="btn-group">
                    <select id="pageSize" onchange=""
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
            <div style="position: relative;top: -88px; left: 285px;">
                <nav>
                    <ul class="pagination">
                        <c:if test="${tranPageInfo.isFirstPage}">
                            <li class="disabled"><a href="javascript:void(0);">首页</a></li>
                        </c:if>
                        <c:if test="${!tranPageInfo.isFirstPage}">
                            <li><a href="javascript:">首页</a></li>
                        </c:if>
                        <c:if test="${tranPageInfo.hasPreviousPage}">

                        </c:if>
                        <c:if test="${tranPageInfo.hasPreviousPage}">
                            <li class="disabled"><a href="javascript:void(0);">上一页</a></li>
                        </c:if>
                        <c:forEach begin="1" end="${tranPageInfo.pages}" var="i">
                            <c:if test="${tranPageInfo.pageNum == i}">
                                <li class="active"><a href="#">${i}</a></li>
                            </c:if>
                            <c:if test="${tranPageInfo.pageNum != i}">
                                <li><a href="#">${i}</a></li>
                            </c:if>
                        </c:forEach>
                        <c:if test="${tranPageInfo.hasNextPage}">
                            <li><a href="#">下一页</a></li>
                        </c:if>
                        <c:if test="${!tranPageInfo.hasNextPage}">
                            <li class="disabled"><a href="javascript:void(0);">下一页</a></li>
                        </c:if>
                        <c:if test="${tranPageInfo.isLastPage}">
                            <li class="disabled"><a href="javascript:void(0);">末页</a></li>
                        </c:if>
                        <c:if test="${!tranPageInfo.isLastPage}">
                            <li ><a href="#">末页</a></li>
                        </c:if>
                    </ul>
                </nav>
            </div>
        </div>

    </div>

</div>
</body>
</html>