<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 - 服务器错误</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container" style="margin-top: 50px; max-width: 900px;">
        <div class="card">
            <h2 style="margin-bottom: 10px;">500 - 服务器内部错误</h2>
            <p style="color: #7f8c8d; margin-bottom: 20px;">页面处理失败，请查看下方错误信息。</p>

            <div style="background: #fff6f6; border: 1px solid #f5c2c7; padding: 15px; border-radius: 6px; overflow:auto;">
                <pre style="margin: 0; white-space: pre-wrap;"><%= (exception != null ? exception.toString() : "(no exception)") %></pre>
            </div>

            <div style="margin-top: 20px;">
                <a class="btn" href="index.jsp">返回首页</a>
                <a class="btn btn-primary" style="margin-left: 10px;" href="login.jsp">返回登录</a>
            </div>
        </div>
    </div>
</body>
</html>
