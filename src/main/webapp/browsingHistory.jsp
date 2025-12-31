<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>浏览历史</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .history-item {
            display: flex;
            align-items: center;
            padding: 15px;
            border-bottom: 1px solid #eee;
            transition: background 0.2s;
        }
        .history-item:hover {
            background: #f8f9fa;
        }
        .history-item img {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 8px;
            margin-right: 20px;
        }
        .history-info {
            flex: 1;
        }
        .history-info h4 {
            margin: 0 0 8px 0;
            color: #2c3e50;
        }
        .history-info h4 a {
            color: #2c3e50;
            text-decoration: none;
        }
        .history-info h4 a:hover {
            color: #3498db;
        }
        .history-meta {
            display: flex;
            gap: 20px;
            color: #7f8c8d;
            font-size: 0.9rem;
        }
        .view-count {
            color: #3498db;
        }
        .clear-btn {
            margin-bottom: 20px;
        }
        .message {
            padding: 15px;
            background: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
            border-radius: 5px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />

    <div class="container">
        <h2 style="margin: 30px 0 20px;">📜 我的浏览历史</h2>
        
        <c:if test="${param.message == 'cleared'}">
            <div class="message">浏览历史已清除</div>
        </c:if>
        
        <c:if test="${not empty historyList}">
            <div class="clear-btn">
                <form action="${pageContext.request.contextPath}/history" method="post" 
                      onsubmit="return confirm('确定要清除所有浏览历史吗？');">
                    <input type="hidden" name="action" value="clear">
                    <button type="submit" class="btn" style="background: #e74c3c; color: white;">
                        🗑️ 清除浏览历史
                    </button>
                </form>
            </div>
        </c:if>
        
        <div class="card">
            <c:forEach var="history" items="${historyList}">
                <div class="history-item">
                    <a href="${pageContext.request.contextPath}/products?action=detail&id=${history.product.id}">
                        <img src="${pageContext.request.contextPath}/${history.product.imageUrl}" 
                             alt="${history.product.name}"
                             onerror="this.src='https://dummyimage.com/80x80/ccc/000?text=No+Image'">
                    </a>
                    <div class="history-info">
                        <h4>
                            <a href="${pageContext.request.contextPath}/products?action=detail&id=${history.product.id}">
                                ${history.product.name}
                            </a>
                        </h4>
                        <div class="history-meta">
                            <span>¥<fmt:formatNumber value="${history.product.price}" pattern="#,##0.00"/></span>
                            <span class="view-count">浏览 ${history.viewCount} 次</span>
                            <span>最后浏览: <fmt:formatDate value="${history.lastViewedAt}" pattern="yyyy-MM-dd HH:mm"/></span>
                        </div>
                    </div>
                    <form action="${pageContext.request.contextPath}/cart" method="post">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="productId" value="${history.product.id}">
                        <input type="hidden" name="quantity" value="1">
                        <c:if test="${history.product.stock > 0}">
                            <button type="submit" class="btn btn-primary">加入购物车</button>
                        </c:if>
                        <c:if test="${history.product.stock <= 0}">
                            <button type="button" class="btn" style="background: #95a5a6; color: white;" disabled>缺货</button>
                        </c:if>
                    </form>
                </div>
            </c:forEach>
            
            <c:if test="${empty historyList}">
                <div style="text-align: center; padding: 50px; color: #7f8c8d;">
                    <p style="font-size: 1.2rem;">暂无浏览历史</p>
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-primary" style="margin-top: 15px;">
                        去逛逛
                    </a>
                </div>
            </c:if>
        </div>
    </div>

    <footer>
        <div class="container">
            <p>&copy; 2025 电商平台. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>
