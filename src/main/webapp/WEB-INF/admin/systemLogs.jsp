<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>系统日志 - 管理后台</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .search-form {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            align-items: center;
        }
        .search-form input, .search-form select {
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .log-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.9rem;
        }
        .log-table th, .log-table td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        .log-table th {
            background: #f8f9fa;
            font-weight: bold;
            position: sticky;
            top: 0;
        }
        .log-table tr:hover {
            background: #f8f9fa;
        }
        .action-badge {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 3px;
            font-size: 0.8rem;
            font-weight: bold;
        }
        .action-LOGIN { background: #d4edda; color: #155724; }
        .action-LOGOUT { background: #fff3cd; color: #856404; }
        .action-VIEW { background: #cce5ff; color: #004085; }
        .action-ORDER { background: #f8d7da; color: #721c24; }
        .action-CART { background: #e2e3e5; color: #383d41; }
        .action-ADMIN { background: #d1c4e9; color: #4527a0; }
        .details-cell {
            max-width: 300px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        .details-cell:hover {
            white-space: normal;
            word-break: break-all;
        }
        .ip-cell {
            font-family: monospace;
            font-size: 0.85rem;
        }
        .stats-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }
        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px;
            border-radius: 8px;
            text-align: center;
        }
        .stat-card h4 {
            margin: 0 0 5px 0;
            font-size: 0.9rem;
        }
        .stat-card p {
            margin: 0;
            font-size: 1.5rem;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <jsp:include page="/header.jsp" />
    
    <div class="container">
        <h2 style="margin: 30px 0 20px;">📋 系统日志</h2>
        <div style="margin-bottom: 20px;">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn">返回仪表板</a>
        </div>
        
        <div class="search-form">
            <form action="${pageContext.request.contextPath}/admin/logs" method="get" style="display: flex; flex-wrap: wrap; gap: 10px; align-items: center; width: 100%;">
                <input type="text" name="username" placeholder="用户名..." value="${searchUsername}" style="width: 150px;">
                <select name="action" style="width: 150px;">
                    <option value="">所有操作类型</option>
                    <option value="LOGIN" ${searchAction == 'LOGIN' ? 'selected' : ''}>登录</option>
                    <option value="LOGOUT" ${searchAction == 'LOGOUT' ? 'selected' : ''}>登出</option>
                    <option value="VIEW_PRODUCT" ${searchAction == 'VIEW_PRODUCT' ? 'selected' : ''}>浏览商品</option>
                    <option value="ADD_CART" ${searchAction == 'ADD_CART' ? 'selected' : ''}>加入购物车</option>
                    <option value="CREATE_ORDER" ${searchAction == 'CREATE_ORDER' ? 'selected' : ''}>创建订单</option>
                    <option value="PAY_ORDER" ${searchAction == 'PAY_ORDER' ? 'selected' : ''}>支付订单</option>
                </select>
                <label>从:</label>
                <input type="date" name="startDate" value="${startDate}">
                <label>至:</label>
                <input type="date" name="endDate" value="${endDate}">
                <button type="submit" class="btn btn-primary">搜索</button>
                <a href="${pageContext.request.contextPath}/admin/logs" class="btn">重置</a>
            </form>
        </div>
        
        <div class="card" style="overflow-x: auto; max-height: 600px; overflow-y: auto;">
            <table class="log-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>时间</th>
                        <th>用户</th>
                        <th>操作</th>
                        <th>详情</th>
                        <th>IP地址</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="log" items="${logs}">
                        <tr>
                            <td>${log.id}</td>
                            <td><fmt:formatDate value="${log.createdAt}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                            <td>${not empty log.username ? log.username : '-'}</td>
                            <td>
                                <c:set var="actionClass" value="" />
                                <c:if test="${log.action.contains('LOGIN')}"><c:set var="actionClass" value="action-LOGIN" /></c:if>
                                <c:if test="${log.action.contains('LOGOUT')}"><c:set var="actionClass" value="action-LOGOUT" /></c:if>
                                <c:if test="${log.action.contains('VIEW')}"><c:set var="actionClass" value="action-VIEW" /></c:if>
                                <c:if test="${log.action.contains('ORDER')}"><c:set var="actionClass" value="action-ORDER" /></c:if>
                                <c:if test="${log.action.contains('CART')}"><c:set var="actionClass" value="action-CART" /></c:if>
                                <c:if test="${log.action.contains('ADMIN')}"><c:set var="actionClass" value="action-ADMIN" /></c:if>
                                <span class="action-badge ${actionClass}">${log.action}</span>
                            </td>
                            <td class="details-cell" title="${log.details}">${log.details}</td>
                            <td class="ip-cell">${log.ipAddress}</td>
                        </tr>
                    </c:forEach>
                    
                    <c:if test="${empty logs}">
                        <tr>
                            <td colspan="6" style="text-align: center; padding: 30px; color: #7f8c8d;">
                                暂无日志记录
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
        
        <p style="margin-top: 15px; color: #7f8c8d; font-size: 0.9rem;">
            显示最近 ${logs.size()} 条日志记录
        </p>
    </div>
    
    <footer style="margin-top: 50px;">
        <div class="container">
            <p>&copy; 2025 电商平台. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>
