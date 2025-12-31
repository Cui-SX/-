<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>销售统计 - 管理后台</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .search-form {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .search-form .form-row {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            align-items: center;
            margin-bottom: 15px;
        }
        .search-form input {
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .search-form label {
            font-weight: bold;
            color: #34495e;
        }
        .result-summary {
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            color: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: center;
        }
        .result-summary h3 {
            margin: 0 0 10px 0;
        }
        .result-summary .total {
            font-size: 2.5rem;
            font-weight: bold;
        }
        .orders-table {
            width: 100%;
            border-collapse: collapse;
        }
        .orders-table th, .orders-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        .orders-table th {
            background: #f8f9fa;
        }
    </style>
</head>
<body>
    <jsp:include page="/header.jsp" />
    
    <div class="container">
        <h2 style="margin: 30px 0 20px;">📊 销售统计报表</h2>
        <div style="margin-bottom: 20px;">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn">返回仪表板</a>
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
        
        <!-- 新增：订单查询功能 -->
        <div class="card" style="margin-top: 30px;">
            <h3 style="margin-bottom: 20px;">🔍 订单查询与统计</h3>
            <div class="search-form">
                <form action="${pageContext.request.contextPath}/admin/stats" method="get">
                    <div class="form-row">
                        <label>用户名:</label>
                        <input type="text" name="username" placeholder="按用户名搜索..." value="${searchUsername}">
                        
                        <label>开始日期:</label>
                        <input type="date" name="startDate" value="${searchStartDate}">
                        
                        <label>结束日期:</label>
                        <input type="date" name="endDate" value="${searchEndDate}">
                    </div>
                    <div class="form-row">
                        <button type="submit" class="btn btn-primary">查询订单</button>
                        <a href="${pageContext.request.contextPath}/admin/stats" class="btn">重置</a>
                    </div>
                </form>
            </div>
            
            <c:if test="${not empty searchOrders}">
                <div class="result-summary">
                    <h3>查询结果统计</h3>
                    <p>共 <strong>${searchOrders.size()}</strong> 笔订单</p>
                    <p class="total">总金额: ¥<fmt:formatNumber value="${searchTotalAmount}" pattern="#,##0.00"/></p>
                </div>
                
                <table class="orders-table">
                    <thead>
                        <tr>
                            <th>订单ID</th>
                            <th>用户名</th>
                            <th>金额</th>
                            <th>状态</th>
                            <th>下单时间</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="order" items="${searchOrders}">
                            <tr>
                                <td>#${order.id}</td>
                                <td>${order.username}</td>
                                <td>¥<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${order.status == 'pending'}">待支付</c:when>
                                        <c:when test="${order.status == 'completed'}">已完成</c:when>
                                        <c:when test="${order.status == 'shipped'}">已发货</c:when>
                                        <c:when test="${order.status == 'cancelled'}">已取消</c:when>
                                        <c:otherwise>${order.status}</c:otherwise>
                                    </c:choose>
                                </td>
                                <td><fmt:formatDate value="${order.createdAt}" pattern="yyyy-MM-dd HH:mm"/></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
            
            <c:if test="${searchPerformed && empty searchOrders}">
                <div style="text-align: center; padding: 30px; color: #7f8c8d;">
                    没有找到符合条件的订单
                </div>
            </c:if>
        </div>
    </div>
    
    <footer style="margin-top: 50px;">
        <div class="container">
            <p>&copy; 2025 电商平台. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>
