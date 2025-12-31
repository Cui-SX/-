package com.ecommerce.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.ecommerce.dao.CartDAO;
import com.ecommerce.dao.OrderDAO;
import com.ecommerce.dao.SystemLogDAO;
import com.ecommerce.model.CartItem;
import com.ecommerce.model.Order;
import com.ecommerce.model.OrderItem;
import com.ecommerce.model.User;
import com.ecommerce.util.EmailUtil;

/**
 * 订单Servlet - 处理订单创建、查看
 */
@WebServlet("/order")
public class OrderServlet extends HttpServlet {
    private OrderDAO orderDAO = new OrderDAO();
    private CartDAO cartDAO = new CartDAO();
    private SystemLogDAO systemLogDAO = new SystemLogDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("checkout".equals(action)) {
            handleCheckout(request, response, user.getId());
        } else if ("detail".equals(action)) {
            handleDetail(request, response);
        } else {
            handleList(request, response, user.getId());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("place".equals(action)) {
            handlePlaceOrder(request, response, user);
        } else if ("pay".equals(action)) {
            handlePayOrder(request, response, user);
        }
    }

    /**
     * 支付订单
     */
    private void handlePayOrder(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        Order order = orderDAO.getOrderById(orderId);
        
        if (order != null && order.getUserId() == user.getId() && "pending".equals(order.getStatus())) {
            // 更新状态为已完成 (已支付)
            if (orderDAO.updateOrderStatus(orderId, "completed")) {
                // 记录支付日志
                systemLogDAO.log(user.getId(), user.getUsername(), "ORDER_PAID", 
                    "订单支付成功，订单ID: " + orderId + "，金额: ¥" + order.getTotalAmount(), 
                    request.getRemoteAddr(), request.getHeader("User-Agent"));
                // 发送确认邮件
                EmailUtil.sendOrderConfirmation(user.getEmail(), user.getFullName(), orderId, order.getTotalAmount());
                response.sendRedirect("order?action=detail&id=" + orderId + "&message=Payment successful! Email sent.");
            } else {
                response.sendRedirect("order?action=detail&id=" + orderId + "&error=Payment failed.");
            }
        } else {
            response.sendRedirect("order");
        }
    }

    /**
     * 结账页面
     */
    private void handleCheckout(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws ServletException, IOException {
        System.out.println("[OrderServlet] 进入结账页面 - userId: " + userId);
        List<CartItem> cartItems = cartDAO.getCartItems(userId);
        System.out.println("[OrderServlet] 获取到购物车商品数量: " + cartItems.size());
        
        if (cartItems.isEmpty()) {
            System.out.println("[OrderServlet] 购物车为空，重定向到购物车页面");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        
        double total = cartItems.stream()
                .mapToDouble(CartItem::getSubtotal)
                .sum();
        System.out.println("[OrderServlet] 计算总额: " + total);
        
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("total", total);
        request.getRequestDispatcher("checkout.jsp").forward(request, response);
    }

    /**
     * 提交订单
     */
    private void handlePlaceOrder(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        String shippingAddress = request.getParameter("shippingAddress");
        System.out.println("[OrderServlet] 提交订单 - userId: " + user.getId() + ", 地址: " + shippingAddress);
        
        // 获取购物车商品
        List<CartItem> cartItems = cartDAO.getCartItems(user.getId());
        System.out.println("[OrderServlet] 获取购物车商品数量: " + cartItems.size());
        
        if (cartItems.isEmpty()) {
            System.out.println("[OrderServlet] 购物车为空，无法提交订单");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        
        // 计算总金额
        double totalAmount = cartItems.stream()
                .mapToDouble(CartItem::getSubtotal)
                .sum();
        System.out.println("[OrderServlet] 订单总额: " + totalAmount);
        
        // 创建订单
        Order order = new Order(user.getId(), totalAmount, shippingAddress);
        
        // 添加订单项
        List<OrderItem> orderItems = new ArrayList<>();
        for (CartItem cartItem : cartItems) {
            OrderItem item = new OrderItem(0, cartItem.getProductId(), 
                    cartItem.getQuantity(), cartItem.getProduct().getPrice());
            orderItems.add(item);
        }
        order.setOrderItems(orderItems);
        
        // 保存订单
        int orderId = orderDAO.createOrder(order);
        System.out.println("[OrderServlet] 创建订单结果 - orderId: " + orderId);
        
        if (orderId > 0) {
            // 清空购物车
            cartDAO.clearCart(user.getId());
            
            // 记录订单创建日志
            systemLogDAO.log(user.getId(), user.getUsername(), "ORDER_CREATE", 
                "创建订单成功，订单ID: " + orderId + "，金额: ¥" + totalAmount, 
                request.getRemoteAddr(), request.getHeader("User-Agent"));
            
            // 订单创建成功，状态为待支付
            // EmailUtil.sendOrderConfirmation(...) - 移至支付成功后发送
            
            // 重定向到订单列表或详情页进行支付
            response.sendRedirect(request.getContextPath() + "/order?action=detail&id=" + orderId + "&message=Order placed. Please pay to complete.");
        } else {
            System.out.println("[OrderServlet] 订单创建失败");
            request.setAttribute("error", "订单提交失败，请重试");
            request.setAttribute("cartItems", cartItems);
            request.setAttribute("total", totalAmount);
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
        }
    }

    /**
     * 订单列表
     */
    private void handleList(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws ServletException, IOException {
        List<Order> orders = orderDAO.getOrdersByUserId(userId);
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("orderList.jsp").forward(request, response);
    }

    /**
     * 订单详情
     */
    private void handleDetail(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int orderId = Integer.parseInt(request.getParameter("id"));
        Order order = orderDAO.getOrderById(orderId);
        request.setAttribute("order", order);
        request.getRequestDispatcher("orderDetail.jsp").forward(request, response);
    }
}
