<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product != null ? '编辑' : '添加'}商品</title>
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
    
    <div class="container" style="max-width: 800px;">
        <h2 style="margin: 30px 0 20px;">${product != null ? '编辑' : '添加'}商品</h2>

        <div class="card">
            <form action="${pageContext.request.contextPath}/admin/product/${product != null ? 'update' : 'add'}" method="post" enctype="multipart/form-data">
                <c:if test="${product != null}">
                    <input type="hidden" name="id" value="${product.id}">
                </c:if>

                <div class="form-group">
                    <label for="name">商品名称 *</label>
                    <input type="text" id="name" name="name" value="${product.name}" required>
                </div>

                <div class="form-group">
                    <label for="description">商品描述</label>
                    <textarea id="description" name="description" rows="4">${product.description}</textarea>
                </div>

                <div class="form-group">
                    <label for="price">价格 *</label>
                    <input type="number" id="price" name="price" step="0.01" min="0" 
                           value="${product.price}" required>
                </div>

                <div class="form-group">
                    <label for="stock">库存 *</label>
                    <input type="number" id="stock" name="stock" min="0" 
                           value="${product.stock}" required>
                </div>

                <div class="form-group">
                    <label for="category">分类</label>
                    <input type="text" id="category" name="category" value="${product.category}">
                </div>

                <div class="form-group">
                    <label for="imageFile">商品图片</label>
                    <c:if test="${not empty product.imageUrl}">
                        <div style="margin-bottom: 10px;">
                            <img src="${pageContext.request.contextPath}/${product.imageUrl}" alt="Current Image" style="max-width: 200px; max-height: 150px; border: 1px solid #ddd; padding: 5px;">
                            <input type="hidden" name="currentImageUrl" value="${product.imageUrl}">
                        </div>
                    </c:if>
                    <input type="file" id="imageFile" name="imageFile" accept="image/*">
                    <p style="font-size: 0.8rem; color: #888; margin-top: 5px;">上传新图片将自动重命名为商品名称。支持 jpg, png, gif 等格式。</p>
                </div>

                <div class="form-group">
                    <button type="submit" class="btn btn-primary">
                        ${product != null ? '更新' : '添加'}商品
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/products" 
                       class="btn" style="background-color: #95a5a6; color: white; margin-left: 10px;">
                        取消
                    </a>
                </div>
            </form>
        </div>
    </div>

    <footer>
        <div class="container">
            <p>&copy; 2025 电商平台. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>
