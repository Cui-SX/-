<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>订单提交成功</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <nav>
        <div class="container">
            <a href="index.jsp" class="logo">🛒 电商平台</a>
            <ul>
                <li><a href="products">商品列表</a></li>
                <li><a href="cart">购物车</a></li>
                <li><a href="order">我的订单</a></li>
                <li><a href="auth?action=logout">退出</a></li>
            </ul>
        </div>
    </nav>

    <div class="container">
        <div class="card" style="text-align: center; padding: 50px; margin-top: 50px;">
            <h1 style="color: #27ae60; margin-bottom: 20px;">✓ 订单提交成功！</h1>
            <p style="font-size: 1.2rem; margin-bottom: 10px;">订单号：<strong>${orderId}</strong></p>
            <p style="color: #7f8c8d; margin-bottom: 30px;">${message}</p>
            <div>
                <a href="order" class="btn btn-primary" style="margin-right: 10px;">查看订单</a>
                <a href="products" class="btn btn-success">继续购物</a>
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
