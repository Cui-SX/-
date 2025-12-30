<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>购物车</title>
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
                <c:if test="${sessionScope.role == 'admin'}">
                    <li><a href="admin/dashboard.jsp">管理后台</a></li>
                </c:if>
                <li><a href="auth?action=logout">退出</a></li>
            </ul>
        </div>
    </nav>

    <div class="container">
        <h2 style="margin: 30px 0 20px;">购物车</h2>

        <c:if test="${not empty cartItems}">
            <table>
                <thead>
                    <tr>
                        <th>商品</th>
                        <th>单价</th>
                        <th>数量</th>
                        <th>小计</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${cartItems}">
                        <tr>
                            <td>${item.product.name}</td>
                            <td>¥<fmt:formatNumber value="${item.product.price}" pattern="#,##0.00"/></td>
                            <td>
                                <form action="cart" method="post" style="display: inline;">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="cartItemId" value="${item.id}">
                                    <input type="number" name="quantity" value="${item.quantity}" 
                                           min="1" max="${item.product.stock}" 
                                           style="width: 60px; padding: 5px;"
                                           onchange="this.form.submit()">
                                </form>
                            </td>
                            <td>¥<fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/></td>
                            <td>
                                <form action="cart" method="post" style="display: inline;">
                                    <input type="hidden" name="action" value="remove">
                                    <input type="hidden" name="cartItemId" value="${item.id}">
                                    <button type="submit" class="btn btn-danger" 
                                            onclick="return confirm('确定要删除这个商品吗？')">
                                        删除
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <div class="card" style="margin-top: 20px;">
                <div style="text-align: right;">
                    <h3>总计：¥<fmt:formatNumber value="${total}" pattern="#,##0.00"/></h3>
                    <a href="order?action=checkout" class="btn btn-success" 
                       style="margin-top: 10px; font-size: 1.1rem; padding: 12px 30px;">
                        去结算
                    </a>
                </div>
            </div>
        </c:if>

        <c:if test="${empty cartItems}">
            <div class="card" style="text-align: center; padding: 50px;">
                <p style="font-size: 1.2rem; color: #7f8c8d; margin-bottom: 20px;">购物车是空的</p>
                <a href="products" class="btn btn-primary">去购物</a>
            </div>
        </c:if>
    </div>

    <footer>
        <div class="container">
            <p>&copy; 2025 电商平台. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>
