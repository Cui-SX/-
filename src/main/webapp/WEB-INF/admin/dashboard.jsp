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
        .btn { padding: 12px 24px; border-radius: 5px; text-decoration: none; display: inline-flex; align-items: center; gap: 8px; font-size: 14px; font-weight: 500; transition: transform 0.2s, box-shadow 0.2s; border: none; cursor: pointer; }
        .btn:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0,0,0,0.2); }
        .btn-primary { background: #007bff; color: white; }
        .btn-success { background: #28a745; color: white; }
        .btn-warning { background: #ffc107; color: black; }
        .btn-info { background: #17a2b8; color: white; }
        .btn-purple { background: #6f42c1; color: white; }
        .btn-orange { background: #fd7e14; color: white; }
        .btn-teal { background: #20c997; color: white; }
        .btn-danger { background: #dc3545; color: white; }
        .btn-dark { background: #343a40; color: white; }
        .section-title { font-size: 1.2rem; font-weight: bold; margin: 30px 0 15px 0; color: #333; border-left: 4px solid #007bff; padding-left: 10px; }
        .button-group { display: flex; flex-wrap: wrap; gap: 12px; margin-bottom: 20px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🏪 管理后台</h1>
        <p>欢迎，<strong><%= session.getAttribute("username") %></strong> (<%= session.getAttribute("role") %>)</p>
        
        <hr style="margin: 20px 0;">
        
        <h2>📊 销售统计</h2>
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

        <!-- 商品管理 -->
        <h3 class="section-title">🛍️ 商品管理</h3>
        <div class="button-group">
            <a href="${pageContext.request.contextPath}/admin/product/edit" class="btn btn-primary">
                ➕ 添加新商品
            </a>
            <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-success">
                📋 商品列表
            </a>
        </div>

        <!-- 订单管理 -->
        <h3 class="section-title">📦 订单管理</h3>
        <div class="button-group">
            <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-warning">
                📝 订单列表
            </a>
            <a href="${pageContext.request.contextPath}/admin/stats" class="btn btn-info">
                📈 销售统计报表
            </a>
        </div>

        <!-- 用户分析 -->
        <h3 class="section-title">👥 用户分析</h3>
        <div class="button-group">
            <a href="${pageContext.request.contextPath}/admin/history" class="btn btn-purple">
                👁️ 用户浏览历史
            </a>
        </div>

        <!-- 系统管理 -->
        <h3 class="section-title">⚙️ 系统管理</h3>
        <div class="button-group">
            <a href="${pageContext.request.contextPath}/admin/logs" class="btn btn-dark">
                📜 系统日志
            </a>
            <a href="${pageContext.request.contextPath}/auth?action=logout" class="btn btn-danger">
                🚪 退出登录
            </a>
        </div>
    </div>
    
    <footer style="text-align: center; margin-top: 30px; padding: 20px; color: #666;">
        <p>&copy; 2025 电商平台. All rights reserved.</p>
    </footer>
</body>
</html>
