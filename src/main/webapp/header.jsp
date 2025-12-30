<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<nav>
    <div class="container">
        <a href="${pageContext.request.contextPath}/index.jsp" class="logo">🛒 电商平台</a>
        <ul>
            <li><a href="${pageContext.request.contextPath}/products">商品列表</a></li>
            <c:if test="${not empty sessionScope.user}">
                <li><a href="${pageContext.request.contextPath}/cart">购物车</a></li>
                <li><a href="${pageContext.request.contextPath}/order">我的订单</a></li>
                
                <c:if test="${sessionScope.user.role == 'admin' || sessionScope.user.role == 'sales_manager'}">
                    <li><a href="${pageContext.request.contextPath}/admin/products">商品管理</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/orders">订单管理</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/stats">销售报表</a></li>
                </c:if>
                
                <li>Welcome, ${sessionScope.user.fullName}</li>
                <li>
                    <form action="${pageContext.request.contextPath}/deleteAccount" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete your account? This cannot be undone.');">
                        <button type="submit" style="background:none;border:none;color:red;cursor:pointer;text-decoration:underline;">注销账号</button>
                    </form>
                </li>
                <li><a href="${pageContext.request.contextPath}/auth?action=logout">退出登录</a></li>
            </c:if>
            <c:if test="${empty sessionScope.user}">
                <li><a href="${pageContext.request.contextPath}/login.jsp">登录</a></li>
                <li><a href="${pageContext.request.contextPath}/register.jsp">注册</a></li>
            </c:if>
        </ul>
    </div>
</nav>
