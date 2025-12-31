<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.name} - 商品详情</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .product-detail {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 40px;
            margin: 30px 0;
        }
        .product-image {
            width: 100%;
            max-height: 500px;
            object-fit: contain;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .product-info-detail h1 {
            font-size: 2rem;
            margin-bottom: 20px;
            color: #2c3e50;
        }
        .price-tag {
            font-size: 2.5rem;
            color: #e74c3c;
            font-weight: bold;
            margin: 20px 0;
        }
        .stock-info {
            font-size: 1.1rem;
            color: #27ae60;
            margin-bottom: 20px;
        }
        .stock-info.low {
            color: #f39c12;
        }
        .stock-info.out {
            color: #e74c3c;
        }
        .description {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
            line-height: 1.8;
        }
        .description h3 {
            margin-bottom: 15px;
            color: #34495e;
        }
        .category-badge {
            display: inline-block;
            background: #3498db;
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.9rem;
            margin-bottom: 15px;
        }
        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }
        .action-buttons form {
            flex: 1;
        }
        .quantity-input {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 20px;
        }
        .quantity-input input {
            width: 80px;
            padding: 10px;
            text-align: center;
            font-size: 1.1rem;
            border: 2px solid #ddd;
            border-radius: 5px;
        }
        .back-link {
            display: inline-block;
            margin-bottom: 20px;
            color: #3498db;
            text-decoration: none;
        }
        .back-link:hover {
            text-decoration: underline;
        }
        @media (max-width: 768px) {
            .product-detail {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />

    <div class="container">
        <a href="${pageContext.request.contextPath}/products" class="back-link">← 返回商品列表</a>
        
        <c:if test="${not empty product}">
            <div class="product-detail">
                <div class="product-image-container">
                    <img src="${pageContext.request.contextPath}/${product.imageUrl}" 
                         alt="${product.name}" 
                         class="product-image"
                         onerror="this.src='https://dummyimage.com/500x400/ccc/000?text=No+Image'">
                </div>
                
                <div class="product-info-detail">
                    <c:if test="${not empty product.category}">
                        <span class="category-badge">${product.category}</span>
                    </c:if>
                    
                    <h1>${product.name}</h1>
                    
                    <div class="price-tag">¥<fmt:formatNumber value="${product.price}" pattern="#,##0.00"/></div>
                    
                    <c:choose>
                        <c:when test="${product.stock > 10}">
                            <div class="stock-info">✓ 库存充足 (${product.stock}件)</div>
                        </c:when>
                        <c:when test="${product.stock > 0}">
                            <div class="stock-info low">⚠ 库存紧张，仅剩 ${product.stock} 件</div>
                        </c:when>
                        <c:otherwise>
                            <div class="stock-info out">✗ 暂时缺货</div>
                        </c:otherwise>
                    </c:choose>
                    
                    <div class="description">
                        <h3>商品描述</h3>
                        <p>${not empty product.description ? product.description : '暂无描述'}</p>
                    </div>
                    
                    <c:if test="${product.stock > 0}">
                        <form action="${pageContext.request.contextPath}/cart" method="post">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="productId" value="${product.id}">
                            
                            <div class="quantity-input">
                                <label>购买数量：</label>
                                <input type="number" name="quantity" value="1" min="1" max="${product.stock}">
                            </div>
                            
                            <div class="action-buttons">
                                <button type="submit" class="btn btn-primary" style="width: 100%; padding: 15px; font-size: 1.2rem;">
                                    🛒 加入购物车
                                </button>
                            </div>
                        </form>
                    </c:if>
                    
                    <c:if test="${product.stock <= 0}">
                        <button class="btn" style="width: 100%; padding: 15px; font-size: 1.2rem; background-color: #95a5a6; color: white;" disabled>
                            暂时缺货
                        </button>
                    </c:if>
                </div>
            </div>
        </c:if>
        
        <c:if test="${empty product}">
            <div class="card" style="text-align: center; padding: 50px;">
                <p style="font-size: 1.5rem; color: #e74c3c;">商品不存在或已下架</p>
                <a href="${pageContext.request.contextPath}/products" class="btn btn-primary" style="margin-top: 20px;">
                    返回商品列表
                </a>
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
