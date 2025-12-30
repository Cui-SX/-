<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>商品管理 - 管理后台</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <jsp:include page="/header.jsp" />
    
    <div class="container">
        <h2 style="margin: 30px 0 20px;">商品管理</h2>
        <div style="margin-bottom: 20px;">
            <a href="${pageContext.request.contextPath}/admin/products?action=new" class="btn btn-primary">添加新商品</a>
            <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="btn" style="margin-left: 10px;">返回仪表板</a>
        </div>
        
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>商品名称</th>
                    <th>价格</th>
                    <th>库存</th>
                    <th>分类</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="product" items="${products}">
                    <tr>
                        <td>${product.id}</td>
                        <td>${product.name}</td>
                        <td>¥<fmt:formatNumber value="${product.price}" pattern="#,##0.00"/></td>
                        <td>${product.stock}</td>
                        <td>${product.category}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/admin/products?action=edit&id=${product.id}" class="btn" style="padding: 5px 10px; font-size: 0.9rem;">编辑</a>
                            <a href="${pageContext.request.contextPath}/admin/products?action=delete&id=${product.id}" class="btn" style="padding: 5px 10px; font-size: 0.9rem; background: #e74c3c;" onclick="return confirm('确定要删除这个商品吗？')">删除</a>
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
