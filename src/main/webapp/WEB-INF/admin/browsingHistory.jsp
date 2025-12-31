<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户浏览历史 - 管理后台</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .search-form {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .search-form input {
            padding: 10px;
            margin-right: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .history-table {
            width: 100%;
            border-collapse: collapse;
        }
        .history-table th, .history-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        .history-table th {
            background: #f8f9fa;
            font-weight: bold;
        }
        .history-table tr:hover {
            background: #f8f9fa;
        }
        .product-thumb {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 5px;
        }
        .view-count {
            color: #3498db;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <jsp:include page="/header.jsp" />
    
    <div class="container">
        <h2 style="margin: 30px 0 20px;">👁️ 用户浏览历史</h2>
        <div style="margin-bottom: 20px;">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn">返回仪表板</a>
        </div>
        
        <div class="search-form">
            <form action="${pageContext.request.contextPath}/admin/history" method="get">
                <input type="text" name="username" placeholder="按用户名搜索..." value="${searchUsername}">
                <button type="submit" class="btn btn-primary">搜索</button>
                <a href="${pageContext.request.contextPath}/admin/history" class="btn">重置</a>
            </form>
        </div>
        
        <div class="card">
            <table class="history-table">
                <thead>
                    <tr>
                        <th>用户名</th>
                        <th>商品图片</th>
                        <th>商品名称</th>
                        <th>浏览次数</th>
                        <th>首次浏览</th>
                        <th>最近浏览</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="history" items="${historyList}">
                        <tr>
                            <td>${history.username}</td>
                            <td>
                                <img src="${pageContext.request.contextPath}/${history.product.imageUrl}" 
                                     alt="${history.product.name}" 
                                     class="product-thumb"
                                     onerror="this.src='https://dummyimage.com/50x50/ccc/000?text=No'">
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/products?action=detail&id=${history.product.id}">
                                    ${history.product.name}
                                </a>
                            </td>
                            <td class="view-count">${history.viewCount} 次</td>
                            <td><fmt:formatDate value="${history.createdAt}" pattern="yyyy-MM-dd HH:mm"/></td>
                            <td><fmt:formatDate value="${history.lastViewedAt}" pattern="yyyy-MM-dd HH:mm"/></td>
                        </tr>
                    </c:forEach>
                    
                    <c:if test="${empty historyList}">
                        <tr>
                            <td colspan="6" style="text-align: center; padding: 30px; color: #7f8c8d;">
                                暂无浏览记录
                            </td>
                        </tr>
                    </c:if>
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
