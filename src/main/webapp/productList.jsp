<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>商品列表</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <nav>
        <div class="container">
            <a href="${pageContext.request.contextPath}/index.jsp" class="logo">🛒 电商平台</a>
            <ul>
                <li><a href="${pageContext.request.contextPath}/products">商品列表</a></li>
                <c:if test="${not empty sessionScope.user}">
                    <li><a href="${pageContext.request.contextPath}/cart">购物车</a></li>
                    <li><a href="${pageContext.request.contextPath}/order">我的订单</a></li>
                    <c:if test="${sessionScope.role == 'admin'}">
                        <li><a href="${pageContext.request.contextPath}/admin/dashboard">管理后台</a></li>
                    </c:if>
                    <li><a href="${pageContext.request.contextPath}/auth?action=logout">退出</a></li>
                </c:if>
                <c:if test="${empty sessionScope.user}">
                    <li><a href="${pageContext.request.contextPath}/login.jsp">登录</a></li>
                </c:if>
            </ul>
        </div>
    </nav>

    <div class="container">
        <h2 style="margin: 30px 0 20px;">商品列表</h2>
        
        <div class="search-box">
            <form action="${pageContext.request.contextPath}/products" method="get">
                <input type="hidden" name="action" value="search">
                <input type="text" name="keyword" placeholder="搜索商品..." value="${keyword}">
                <button type="submit" class="btn btn-primary">搜索</button>
            </form>
        </div>

        <c:if test="${not empty keyword}">
            <p>搜索结果：<strong>${keyword}</strong></p>
        </c:if>
        
        <c:if test="${not empty category}">
            <p>分类：<strong>${category}</strong></p>
        </c:if>

        <div class="product-grid">
            <c:forEach var="product" items="${products}">
                <div class="product-card">
                    <a href="${pageContext.request.contextPath}/products?action=detail&id=${product.id}" style="text-decoration: none; color: inherit;">
                        <img src="${pageContext.request.contextPath}/${product.imageUrl}" alt="${product.name}" onerror="this.src='https://dummyimage.com/300x200/ccc/000?text=No+Image'">
                        <div class="product-info">
                            <div class="product-name">${product.name}</div>
                            <div class="product-price">¥<fmt:formatNumber value="${product.price}" pattern="#,##0.00"/></div>
                            <div class="product-stock">库存：${product.stock}</div>
                        </div>
                    </a>
                    <div style="padding: 0 15px 15px;">
                        <c:if test="${product.stock > 0}">
                            <form action="${pageContext.request.contextPath}/cart" method="post" style="margin-top: 10px;">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="productId" value="${product.id}">
                                <input type="hidden" name="quantity" value="1">
                                <button type="submit" class="btn btn-primary" style="width: 100%;">
                                    加入购物车
                                </button>
                            </form>
                        </c:if>
                        <c:if test="${product.stock <= 0}">
                            <button class="btn" style="width: 100%; background-color: #95a5a6; color: white; margin-top: 10px;" disabled>
                                缺货
                            </button>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </div>

        <c:if test="${empty products}">
            <div class="card" style="text-align: center; padding: 50px;">
                <p style="font-size: 1.2rem; color: #7f8c8d;">暂无商品</p>
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
