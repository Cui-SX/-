<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>订单管理</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
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
    </style>
</head>
<body>
    <nav>
        <div class="container">
            <a href="${pageContext.request.contextPath}/index.jsp" class="logo">🛒 电商平台 - 管理后台</a>
            <ul>
                <li><a href="${pageContext.request.contextPath}/admin/dashboard">仪表板</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/products">商品管理</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/orders">订单管理</a></li>
                <li><a href="${pageContext.request.contextPath}/products">前台</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/auth?action=logout">退出</a></li>
            </ul>
        </div>
    </nav>

    <div class="container">
        <h2 style="margin: 30px 0 20px;">订单管理</h2>

        <!-- 搜索表单 -->
        <div class="card" style="margin-bottom: 20px; padding: 20px;">
            <form action="${pageContext.request.contextPath}/admin/orders" method="get" style="display: flex; flex-wrap: wrap; gap: 15px; align-items: flex-end;">
                <div style="flex: 1; min-width: 200px;">
                    <label for="username" style="display: block; margin-bottom: 5px; font-weight: bold;">用户名</label>
                    <input type="text" id="username" name="username" value="${username}" placeholder="输入用户名" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
                </div>
                <div style="flex: 1; min-width: 150px;">
                    <label style="display: block; margin-bottom: 5px; font-weight: bold;">价格范围</label>
                    <div style="display: flex; gap: 5px;">
                        <input type="number" name="minPrice" value="${minPrice}" placeholder="最低价" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
                        <span style="align-self: center;">-</span>
                        <input type="number" name="maxPrice" value="${maxPrice}" placeholder="最高价" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
                    </div>
                </div>
                <div style="flex: 1; min-width: 250px;">
                    <label style="display: block; margin-bottom: 5px; font-weight: bold;">时间范围</label>
                    <div style="display: flex; gap: 5px;">
                        <input type="date" name="startDate" value="${startDate}" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
                        <span style="align-self: center;">至</span>
                        <input type="date" name="endDate" value="${endDate}" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
                    </div>
                </div>
                <div>
                    <button type="submit" class="btn btn-primary" style="padding: 9px 20px;">查询</button>
                    <a href="${pageContext.request.contextPath}/admin/orders" class="btn" style="background: #95a5a6; color: white; padding: 9px 20px; text-decoration: none;">重置</a>
                </div>
            </form>
        </div>

        <c:if test="${not empty orders}">
            <c:forEach var="order" items="${orders}">
                <div class="card" style="margin-bottom: 20px;">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
                        <div>
                            <strong>订单号：${order.id}</strong>
                            <span style="margin-left: 20px; color: #7f8c8d;">
                                用户ID: ${order.userId}
                            </span>
                            <span style="margin-left: 20px; color: #7f8c8d;">
                                用户名: ${order.username}
                            </span>
                            <span style="margin-left: 20px; color: #7f8c8d;">
                                <fmt:formatDate value="${order.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
                            </span>
                        </div>
                        <div>
                            <form action="${pageContext.request.contextPath}/admin/order/updateStatus" method="post" style="display: inline;">
                                <input type="hidden" name="orderId" value="${order.id}">
                                <select name="status" onchange="this.form.submit()" class="order-status status-${order.status}">
                                    <option value="pending" ${order.status == 'pending' ? 'selected' : ''}>待处理</option>
                                    <option value="processing" ${order.status == 'processing' ? 'selected' : ''}>处理中</option>
                                    <option value="shipped" ${order.status == 'shipped' ? 'selected' : ''}>已发货</option>
                                    <option value="delivered" ${order.status == 'delivered' ? 'selected' : ''}>已送达</option>
                                    <option value="cancelled" ${order.status == 'cancelled' ? 'selected' : ''}>已取消</option>
                                </select>
                            </form>
                        </div>
                    </div>
                    
                    <table style="margin-bottom: 15px;">
                        <thead>
                            <tr>
                                <th>商品名称</th>
                                <th>单价</th>
                                <th>数量</th>
                                <th>小计</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${order.orderItems}">
                                <tr>
                                    <td>${item.product.name}</td>
                                    <td>¥<fmt:formatNumber value="${item.price}" pattern="#,##0.00"/></td>
                                    <td>${item.quantity}</td>
                                    <td>¥<fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <div>
                            <strong>收货地址：</strong>${order.shippingAddress}
                        </div>
                        <div>
                            <strong>订单总额：¥<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></strong>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:if>

        <c:if test="${empty orders}">
            <div class="card" style="text-align: center; padding: 50px;">
                <p style="font-size: 1.2rem; color: #7f8c8d;">暂无订单</p>
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
