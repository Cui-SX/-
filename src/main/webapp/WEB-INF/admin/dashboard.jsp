<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>管理后台</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
        .container { max-width: 1200px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .card { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        .btn { padding: 10px 20px; border-radius: 5px; text-decoration: none; display: inline-block; }
        .btn-primary { background: #007bff; color: white; }
        .btn-success { background: #28a745; color: white; }
        .btn-warning { background: #ffc107; color: black; }
    </style>
</head>
<body>
    <div class="container">
        <h1>管理后台</h1>
        <p>欢迎，<%= session.getAttribute("username") %> (<%= session.getAttribute("role") %>)</p>
        
        <hr style="margin: 20px 0;">
        
        <h2>销售统计</h2>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin-bottom: 30px;">
            <div class="card" style="text-align: center; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white;">
                <h3 style="margin-bottom: 10px;">📦 总订单数</h3>
                <p style="font-size: 2.5rem; font-weight: bold; margin: 0;">
                    <c:choose>
                        <c:when test="${not empty stats && stats.totalOrders ne null}">${stats.totalOrders}</c:when>
                        <c:otherwise>0</c:otherwise>
                    </c:choose>
                </p>
            </div>
            
            <div class="card" style="text-align: center; background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); color: white;">
                <h3 style="margin-bottom: 10px;">💰 总销售额</h3>
                <p style="font-size: 2.5rem; font-weight: bold; margin: 0;">
                    <c:choose>
                        <c:when test="${not empty stats && stats.totalRevenue ne null}">
                            ¥<fmt:formatNumber value="${stats.totalRevenue}" pattern="#,##0.00"/>
                        </c:when>
                        <c:otherwise>¥0.00</c:otherwise>
                    </c:choose>
                </p>
            </div>
        </div>

        <h2>快捷操作</h2>
        <div style="margin-top: 20px;">
            <a href="${pageContext.request.contextPath}/admin/product/edit" class="btn btn-primary" style="margin-right: 10px;">
                添加新商品
            </a>
            <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-success" style="margin-right: 10px;">
                商品管理
            </a>
            <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-warning" style="margin-right: 10px;">
                订单管理
            </a>
            <a href="${pageContext.request.contextPath}/admin/auth?action=logout" class="btn" style="background: #dc3545; color: white;">
                退出登录
            </a>
        </div>
    </div>
</body>
</html>
        <div class="container">
            <p>&copy; 2025 电商平台. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>
