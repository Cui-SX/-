<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>订单管理 - 管理后台</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .status-pending { color: #f39c12; }
        .status-processing { color: #3498db; }
        .status-completed { color: #27ae60; }
        .status-shipped { color: #9b59b6; }
        .status-delivered { color: #27ae60; }
        .status-cancelled { color: #e74c3c; }
    </style>
</head>
<body>
    <jsp:include page="/header.jsp" />
    
    <div class="container">
        <h2 style="margin: 30px 0 20px;">订单管理</h2>
        <div style="margin-bottom: 20px;">
            <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="btn">返回仪表板</a>
        </div>
        
        <table>
            <thead>
                <tr>
                    <th>订单编号</th>
                    <th>用户ID</th>
                    <th>订单金额</th>
                    <th>订单状态</th>
                    <th>创建时间</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="order" items="${orders}">
                    <tr>
                        <td>#${order.id}</td>
                        <td>${order.userId}</td>
                        <td>¥<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></td>
                        <td class="status-${order.status}">
                            <c:choose>
                                <c:when test="${order.status == 'pending'}">待支付</c:when>
                                <c:when test="${order.status == 'completed'}">已完成</c:when>
                                <c:when test="${order.status == 'processing'}">处理中</c:when>
                                <c:when test="${order.status == 'shipped'}">已发货</c:when>
                                <c:when test="${order.status == 'delivered'}">已送达</c:when>
                                <c:when test="${order.status == 'cancelled'}">已取消</c:when>
                                <c:otherwise>${order.status}</c:otherwise>
                            </c:choose>
                        </td>
                        <td><fmt:formatDate value="${order.createdAt}" pattern="yyyy-MM-dd HH:mm"/></td>
                        <td>
                            <c:if test="${order.status == 'pending'}">
                                <a href="${pageContext.request.contextPath}/admin/orders?action=updateStatus&id=${order.id}&status=cancelled" class="btn" style="padding: 5px 10px; font-size: 0.85rem; background: #e74c3c;" onclick="return confirm('确定取消此订单？')">取消订单</a>
                            </c:if>
                            <c:if test="${order.status == 'completed'}">
                                <a href="${pageContext.request.contextPath}/admin/orders?action=updateStatus&id=${order.id}&status=shipped" class="btn" style="padding: 5px 10px; font-size: 0.85rem; background: #9b59b6;">标记为已发货</a>
                            </c:if>
                            <c:if test="${order.status == 'shipped'}">
                                <a href="${pageContext.request.contextPath}/admin/orders?action=updateStatus&id=${order.id}&status=delivered" class="btn" style="padding: 5px 10px; font-size: 0.85rem; background: #27ae60;">标记为已送达</a>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
    
    <footer style="margin-top: 50px;">
        <div class="container">
            <p>&copy; 2025 电商平台. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>
