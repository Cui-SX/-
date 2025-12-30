<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>销售统计 - 管理后台</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <jsp:include page="/header.jsp" />
    
    <div class="container">
        <h2 style="margin: 30px 0 20px;">销售统计报表</h2>
        <div style="margin-bottom: 20px;">
            <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="btn">返回仪表板</a>
        </div>
        
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; margin-bottom: 30px;">
            <div class="card" style="text-align: center; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px;">
                <h3 style="margin-bottom: 15px; font-size: 1.2rem;">📦 订单总数</h3>
                <p style="font-size: 3rem; font-weight: bold; margin: 0;">${stats.totalOrders != null ? stats.totalOrders : 0}</p>
            </div>
            
            <div class="card" style="text-align: center; background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); color: white; padding: 30px;">
                <h3 style="margin-bottom: 15px; font-size: 1.2rem;">💰 销售总额</h3>
                <p style="font-size: 3rem; font-weight: bold; margin: 0;">¥<fmt:formatNumber value="${stats.totalRevenue != null ? stats.totalRevenue : 0}" pattern="#,##0"/></p>
            </div>
        </div>
        
        <div class="card">
            <h3 style="margin-bottom: 20px;">订单状态分布</h3>
            <table>
                <thead>
                    <tr>
                        <th>状态</th>
                        <th>订单数量</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="entry" items="${stats.statusCounts}">
                        <tr>
                            <td>
                                <c:choose>
                                    <c:when test="${entry.key == 'pending'}">待支付</c:when>
                                    <c:when test="${entry.key == 'completed'}">已完成</c:when>
                                    <c:when test="${entry.key == 'processing'}">处理中</c:when>
                                    <c:when test="${entry.key == 'shipped'}">已发货</c:when>
                                    <c:when test="${entry.key == 'delivered'}">已送达</c:when>
                                    <c:when test="${entry.key == 'cancelled'}">已取消</c:when>
                                    <c:otherwise>${entry.key}</c:otherwise>
                                </c:choose>
                            </td>
                            <td>${entry.value}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
    
    <footer style="margin-top: 50px;">
        <div class="container">
            <p>&copy; 2025 电商平台. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>
