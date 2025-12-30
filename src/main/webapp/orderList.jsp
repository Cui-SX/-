<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>我的订单</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .order-status {
            padding: 5px 10px;
            border-radius: 3px;
            font-size: 0.9rem;
            color: white;
        }
        .status-pending { background-color: #f39c12; }
        .status-processing { background-color: #3498db; }
        .status-shipped { background-color: #9b59b6; }
        .status-delivered { background-color: #27ae60; }
        .status-cancelled { background-color: #e74c3c; }
        .order-card {
            margin-bottom: 20px;
            padding: 20px;
            border: 1px solid #eee;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            background: #fff;
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />

    <div class="container">
        <h2 style="margin: 30px 0 20px;">我的订单</h2>

        <c:if test="${not empty orders}">
            <c:forEach var="order" items="${orders}">
                <div class="card order-card">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; border-bottom: 2px solid #3498db; padding-bottom: 10px;">
                        <div>
                            <strong style="font-size: 1.1rem;">订单号：${order.id}</strong>
                            <span style="margin-left: 20px; color: #7f8c8d;">
                                <fmt:formatDate value="${order.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
                            </span>
                        </div>
                        <div>
                            <span class="order-status status-${order.status}">
                                <c:choose>
                                    <c:when test="${order.status == 'pending'}">待支付</c:when>
                                    <c:when test="${order.status == 'completed'}">已完成</c:when>
                                    <c:when test="${order.status == 'processing'}">处理中</c:when>
                                    <c:when test="${order.status == 'shipped'}">已发货</c:when>
                                    <c:when test="${order.status == 'delivered'}">已送达</c:when>
                                    <c:when test="${order.status == 'cancelled'}">已取消</c:when>
                                    <c:otherwise>${order.status}</c:otherwise>
                                </c:choose>
                            </span>
                            <c:if test="${order.status == 'pending'}">
                                <form action="order" method="post" style="display:inline; margin-left: 10px;">
                                    <input type="hidden" name="action" value="pay">
                                    <input type="hidden" name="orderId" value="${order.id}">
                                    <button type="submit" class="btn" style="padding: 5px 10px; font-size: 0.9rem;">立即付款</button>
                                </form>
                            </c:if>
                        </div>
                    </div>
                    
                    <table style="width: 100%; border-collapse: collapse;">
                        <thead>
                            <tr style="background-color: #f8f9fa;">
                                <th style="padding: 10px; text-align: left; border-bottom: 2px solid #dee2e6;">商品名称</th>
                                <th style="padding: 10px; text-align: right; border-bottom: 2px solid #dee2e6;">单价</th>
                                <th style="padding: 10px; text-align: center; border-bottom: 2px solid #dee2e6;">数量</th>
                                <th style="padding: 10px; text-align: right; border-bottom: 2px solid #dee2e6;">小计</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${order.orderItems}">
                                <tr>
                                    <td style="padding: 10px; border-bottom: 1px solid #dee2e6;">${item.product.name}</td>
                                    <td style="padding: 10px; text-align: right; border-bottom: 1px solid #dee2e6;">¥<fmt:formatNumber value="${item.price}" pattern="#,##0.00"/></td>
                                    <td style="padding: 10px; text-align: center; border-bottom: 1px solid #dee2e6;">${item.quantity}</td>
                                    <td style="padding: 10px; text-align: right; border-bottom: 1px solid #dee2e6;">¥<fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/></td>
                                </tr>
                            </c:forEach>
                            <tr style="background-color: #f8f9fa; font-weight: bold;">
                                <td colspan="3" style="padding: 10px; text-align: right;">订单总额：</td>
                                <td style="padding: 10px; text-align: right; color: #e74c3c; font-size: 1.1rem;">¥<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></td>
                            </tr>
                            <tr>
                                <td colspan="4" style="padding: 10px; background-color: #fff;"><strong>收货地址：</strong>${order.shippingAddress}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </c:forEach>
        </c:if>

        <c:if test="${empty orders}">
            <div class="card" style="text-align: center; padding: 50px;">
                <p style="font-size: 1.2rem; color: #7f8c8d; margin-bottom: 20px;">暂无订单</p>
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
