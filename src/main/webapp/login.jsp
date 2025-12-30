<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>登录 - 电商平台</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
            padding: 20px;
        }
        .login-container {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            max-width: 450px;
            width: 100%;
        }
        .login-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .login-header h2 {
            color: #2c3e50;
            margin-bottom: 10px;
        }
        .login-header p {
            color: #7f8c8d;
            font-size: 0.9rem;
        }
        .tabs {
            display: flex;
            margin-bottom: 30px;
            border-bottom: 2px solid #ecf0f1;
        }
        .tab {
            flex: 1;
            padding: 15px;
            text-align: center;
            cursor: pointer;
            background: transparent;
            border: none;
            font-size: 1rem;
            font-weight: 500;
            color: #7f8c8d;
            transition: all 0.3s;
            position: relative;
        }
        .tab.active {
            color: #667eea;
        }
        .tab.active::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            right: 0;
            height: 2px;
            background: #667eea;
        }
        .tab:hover {
            color: #667eea;
        }
        .tab-content {
            display: none;
        }
        .tab-content.active {
            display: block;
        }
        .error-message {
            background: #e74c3c;
            color: white;
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 20px;
            text-align: center;
        }
        .success-message {
            background: #27ae60;
            color: white;
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 20px;
            text-align: center;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #2c3e50;
            font-weight: 500;
        }
        .form-group input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 1rem;
            box-sizing: border-box;
        }
        .form-group input:focus {
            outline: none;
            border-color: #667eea;
        }
        .btn-login {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            transition: transform 0.2s;
        }
        .btn-login:hover {
            transform: translateY(-2px);
        }
        .login-footer {
            text-align: center;
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid #ecf0f1;
        }
        .login-footer a {
            color: #667eea;
            text-decoration: none;
        }
        .login-footer a:hover {
            text-decoration: underline;
        }
    </style>
    <script>
        function switchTab(event, tabName) {
            // 隐藏所有选项卡内容
            var contents = document.getElementsByClassName('tab-content');
            for (var i = 0; i < contents.length; i++) {
                contents[i].classList.remove('active');
            }
            
            // 移除所有选项卡的激活状态
            var tabs = document.getElementsByClassName('tab');
            for (var i = 0; i < tabs.length; i++) {
                tabs[i].classList.remove('active');
            }
            
            // 激活当前选项卡
            document.getElementById(tabName + '-content').classList.add('active');
            event.currentTarget.classList.add('active');
        }
    </script>
</head>
<body>
    <div class="login-container">
        <div class="login-header">
            <h2>🛒 电商平台</h2>
            <p>欢迎回来，请选择登录方式</p>
        </div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="error-message">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
        
        <% if (request.getAttribute("success") != null) { %>
            <div class="success-message">
                <%= request.getAttribute("success") %>
            </div>
        <% } %>

        <div class="tabs">
            <button class="tab active" onclick="switchTab(event, 'user')">👤 用户登录</button>
            <button class="tab" onclick="switchTab(event, 'admin')">🔐 管理员登录</button>
        </div>

        <!-- 用户登录表单 -->
        <div id="user-content" class="tab-content active">
            <form action="auth" method="post">
                <input type="hidden" name="action" value="login">
                
                <div class="form-group">
                    <label for="user-username">用户名</label>
                    <input type="text" id="user-username" name="username" required autofocus>
                </div>

                <div class="form-group">
                    <label for="user-password">密码</label>
                    <input type="password" id="user-password" name="password" required>
                </div>

                <button type="submit" class="btn-login">登录</button>
            </form>
        </div>

        <!-- 管理员登录表单 -->
        <div id="admin-content" class="tab-content">
            <form action="admin/auth" method="post">
                <input type="hidden" name="action" value="login">
                
                <div class="form-group">
                    <label for="admin-username">管理员账号</label>
                    <input type="text" id="admin-username" name="username" required>
                </div>

                <div class="form-group">
                    <label for="admin-password">密码</label>
                    <input type="password" id="admin-password" name="password" required>
                </div>

                <button type="submit" class="btn-login">登录</button>
            </form>
        </div>

        <div class="login-footer">
            <p>还没有账号？<a href="register.jsp">立即注册</a></p>
            <p style="margin-top: 10px;"><a href="index.jsp">返回首页</a></p>
        </div>
    </div>
</body>
</html>
