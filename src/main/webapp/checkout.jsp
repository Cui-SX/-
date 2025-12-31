<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>订单结算</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <nav>
        <div class="container">
            <a href="${pageContext.request.contextPath}/" class="logo">🛒 电商平台</a>
            <ul>
                <li><a href="${pageContext.request.contextPath}/products">商品列表</a></li>
                <li><a href="${pageContext.request.contextPath}/cart">购物车</a></li>
                <li><a href="${pageContext.request.contextPath}/order">我的订单</a></li>
                <li><a href="${pageContext.request.contextPath}/auth?action=logout">退出</a></li>
            </ul>
        </div>
    </nav>

    <div class="container">
        <h2 style="margin: 30px 0 20px;">订单结算</h2>

        <div class="card">
            <h3>订单商品</h3>
            <table style="margin-top: 15px;">
                <thead>
                    <tr>
                        <th>商品名称</th>
                        <th>单价</th>
                        <th>数量</th>
                        <th>小计</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${cartItems}">
                        <tr>
                            <td>${item.product.name}</td>
                            <td>¥<fmt:formatNumber value="${item.product.price}" pattern="#,##0.00"/></td>
                            <td>${item.quantity}</td>
                            <td>¥<fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <div style="text-align: right; margin-top: 20px;">
                <h3>订单总额：¥<fmt:formatNumber value="${total}" pattern="#,##0.00"/></h3>
            </div>
        </div>

        <div class="card" style="margin-top: 20px;">
            <h3>配送信息</h3>
            <form action="${pageContext.request.contextPath}/order" method="post" style="margin-top: 20px;">
                <input type="hidden" name="action" value="place">
                
                <div class="form-group">
                    <label for="shippingAddress">收货地址 *</label>
                    <textarea id="shippingAddress" name="shippingAddress" rows="4" required 
                              placeholder="请输入详细的收货地址">${sessionScope.user.address}</textarea>
                </div>
                
                <div class="form-group">
                    <button type="submit" class="btn btn-success" style="font-size: 1.1rem; padding: 12px 30px;">
                        提交订单
                    </button>
                    <a href="${pageContext.request.contextPath}/cart" class="btn" style="background-color: #95a5a6; color: white; margin-left: 10px;">
                        返回购物车
                    </a>
                </div>
            </form>
        </div>
    </div>

    <footer>
        <div class="container">
            <p>&copy; 2025 电商平台. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>
