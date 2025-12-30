<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>电商平台 - 首页</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <nav>
        <div class="container">
            <a href="index.jsp" class="logo">🛒 电商平台</a>
            <ul>
                <li><a href="products">商品列表</a></li>
                <% if (session.getAttribute("user") != null) { %>
                    <li><a href="cart">购物车</a></li>
                    <li><a href="order">我的订单</a></li>
                    <% if ("admin".equals(session.getAttribute("role"))) { %>
                        <li><a href="admin/dashboard.jsp">管理后台</a></li>
                    <% } %>
                    <li><a href="auth?action=logout">退出</a></li>
                <% } else { %>
                    <li><a href="login.jsp">登录</a></li>
                    <li><a href="register.jsp">注册</a></li>
                <% } %>
            </ul>
        </div>
    </nav>

    <div class="container" style="margin-top: 50px;">
        <div class="card" style="text-align: center; padding: 50px;">
            <h1 style="font-size: 3rem; margin-bottom: 20px;">欢迎来到电商平台</h1>
            <p style="font-size: 1.2rem; color: #7f8c8d; margin-bottom: 30px;">
                发现优质商品，享受便捷购物体验
            </p>
            <div>
                <% if (session.getAttribute("user") != null) { %>
                    <a href="products" class="btn btn-primary" style="font-size: 1.1rem; padding: 15px 30px;">
                        开始购物
                    </a>
                <% } else { %>
                    <a href="login.jsp" class="btn btn-primary" style="font-size: 1.1rem; padding: 15px 30px; margin-right: 10px;">
                        立即登录
                    </a>
                    <a href="register.jsp" class="btn btn-success" style="font-size: 1.1rem; padding: 15px 30px;">
                        注册账号
                    </a>
                <% } %>
            </div>
        </div>

        <div style="margin-top: 50px;">
            <h2 style="text-align: center; margin-bottom: 30px;">平台特色</h2>
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px;">
                <div class="card" style="text-align: center;">
                    <h3>🎯 精选商品</h3>
                    <p>严选优质商品，保证质量</p>
                </div>
                <div class="card" style="text-align: center;">
                    <h3>🚀 快速配送</h3>
                    <p>高效物流，快速送达</p>
                </div>
                <div class="card" style="text-align: center;">
                    <h3>💳 安全支付</h3>
                    <p>多种支付方式，安全可靠</p>
                </div>
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
