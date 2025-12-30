<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>订单详情 #${order.id}</title>
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
        .detail-card {
            background: #fff;
            padding: 30px;
            border-radius: 5px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            margin-bottom: 20px;
        }
        .info-row {
            display: flex;
            margin-bottom: 15px;
            border-bottom: 1px solid #eee;
            padding-bottom: 15px;
        }
        .info-label {
            width: 120px;
            font-weight: bold;
            color: #7f8c8d;
        }
        .info-value {
            flex: 1;
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />

    <div class="container">
        <div style="display: flex; justify-content: space-between; align-items: center; margin: 30px 0 20px;">
            <h2>订单详情 #${order.id}</h2>
            <a href="order" class="btn" style="background-color: #95a5a6;">返回列表</a>
        </div>

        <c:if test="${not empty param.message}">
            <div class="alert alert-success">${param.message}</div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger">${param.error}</div>
        </c:if>

        <div class="detail-card">
            <div class="info-row">
                <div class="info-label">订单状态</div>
                <div class="info-value">
                    <span class="order-status status-${order.status}">
                        <c:choose>
                            <c:when test="${order.status == 'pending'}">待支付</c:when>
                            <c:when test="${order.status == 'processing'}">处理中</c:when>
                            <c:when test="${order.status == 'shipped'}">已发货</c:when>
                            <c:when test="${order.status == 'delivered'}">已送达</c:when>
                            <c:when test="${order.status == 'cancelled'}">已取消</c:when>
                            <c:otherwise>${order.status}</c:otherwise>
                        </c:choose>
                    </span>
                    <c:if test="${order.status == 'pending'}">
                        <form action="order" method="post" style="display:inline; margin-left: 20px;">
                            <input type="hidden" name="action" value="pay">
                            <input type="hidden" name="orderId" value="${order.id}">
                            <button type="submit" class="btn btn-primary">立即付款</button>
                        </form>
                    </c:if>
                </div>
            </div>
            
            <div class="info-row">
                <div class="info-label">下单时间</div>
                <div class="info-value"><fmt:formatDate value="${order.createdAt}" pattern="yyyy-MM-dd HH:mm:ss"/></div>
            </div>
            
            <div class="info-row">
                <div class="info-label">收货地址</div>
                <div class="info-value">${order.shippingAddress}</div>
            </div>
            
            <div class="info-row">
                <div class="info-label">订单总额</div>
                <div class="info-value" style="font-size: 1.2rem; font-weight: bold; color: #e74c3c;">
                    ¥<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/>
                </div>
            </div>
        </div>

        <div class="detail-card">
            <h3>商品清单</h3>
            <table style="width: 100%; border-collapse: collapse; margin-top: 15px;">
                <thead>
                    <tr style="background-color: #f8f9fa; text-align: left;">
                        <th style="padding: 12px;">商品名称</th>
                        <th style="padding: 12px;">单价</th>
                        <th style="padding: 12px;">数量</th>
                        <th style="padding: 12px;">小计</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${order.orderItems}">
                        <tr style="border-bottom: 1px solid #eee;">
                            <td style="padding: 12px;">${item.product.name}</td>
                            <td style="padding: 12px;">¥<fmt:formatNumber value="${item.price}" pattern="#,##0.00"/></td>
                            <td style="padding: 12px;">${item.quantity}</td>
                            <td style="padding: 12px;">¥<fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <footer>
        <div class="container">
            <p>&copy; 2025 电商平台. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>
