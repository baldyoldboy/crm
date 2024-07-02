<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<html>
<head>
    <base href="<%=path%>">
    <title>文件下载</title>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script>
        $(function (){
            //给下载添加单击事件
           $("input").click(function (){
               //发送下载的请求
                window.location.href="workbench/activity/fileDownload2";
           })
        })
    </script>
</head>
<body>
    <h1>文件下载</h1>
    <hr/>
    <input type="button" value="下载">
</body>
</html>
