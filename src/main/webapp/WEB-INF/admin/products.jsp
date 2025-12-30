<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>商品管理</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
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
        <div style="display: flex; justify-content: space-between; align-items: center; margin: 30px 0 20px;">
            <h2>商品管理</h2>
            <a href="${pageContext.request.contextPath}/admin/product/edit" class="btn btn-primary">添加商品</a>
        </div>

        <c:if test="${not empty products}">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>商品名称</th>
                        <th>分类</th>
                        <th>价格</th>
                        <th>库存</th>
                        <th>创建时间</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="product" items="${products}">
                        <tr>
                            <td>${product.id}</td>
                            <td>${product.name}</td>
                            <td>${product.category}</td>
                            <td>¥<fmt:formatNumber value="${product.price}" pattern="#,##0.00"/></td>
                            <td>${product.stock}</td>
                            <td><fmt:formatDate value="${product.createdAt}" pattern="yyyy-MM-dd"/></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/admin/product/edit?id=${product.id}" 
                                   class="btn btn-warning" style="margin-right: 5px;">编辑</a>
                                <form action="${pageContext.request.contextPath}/admin/product/delete" method="post" style="display: inline;">
                                    <input type="hidden" name="id" value="${product.id}">
                                    <button type="submit" class="btn btn-danger" 
                                            onclick="return confirm('确定要删除这个商品吗？')">删除</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:if>

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
