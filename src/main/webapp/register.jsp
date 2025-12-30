<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户注册</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <nav>
        <div class="container">
            <a href="index.jsp" class="logo">🛒 电商平台</a>
            <ul>
                <li><a href="index.jsp">首页</a></li>
                <li><a href="login.jsp">登录</a></li>
            </ul>
        </div>
    </nav>

    <div class="container" style="max-width: 500px; margin-top: 50px;">
        <div class="card">
            <h2 style="text-align: center; margin-bottom: 30px;">用户注册</h2>
            
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>
            
            <form action="auth" method="post">
                <input type="hidden" name="action" value="register">
                
                <div class="form-group">
                    <label for="username">用户名 *</label>
                    <input type="text" id="username" name="username" required>
                </div>
                
                <div class="form-group">
                    <label for="email">邮箱 *</label>
                    <input type="email" id="email" name="email" required>
                </div>
                
                <div class="form-group">
                    <label for="fullName">姓名 *</label>
                    <input type="text" id="fullName" name="fullName" required>
                </div>
                
                <div class="form-group">
                    <label for="password">密码 *</label>
                    <input type="password" id="password" name="password" required minlength="6">
                </div>
                
                <div class="form-group">
                    <label for="confirmPassword">确认密码 *</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required minlength="6">
                </div>
                
                <div class="form-group">
                    <button type="submit" class="btn btn-success" style="width: 100%;">
                        注册
                    </button>
                </div>
            </form>
            
            <div style="text-align: center; margin-top: 20px;">
                <p>已有账号？<a href="login.jsp" style="color: #3498db;">立即登录</a></p>
            </div>
        </div>
    </div>

    <footer>
        <div class="container">
            <p>&copy; 2025 电商平台. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>
