package com.ecommerce.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.ecommerce.dao.CartDAO;
import com.ecommerce.model.CartItem;
import com.ecommerce.model.User;

/**
 * 购物车Servlet - 处理购物车操作
 */
@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private CartDAO cartDAO = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        List<CartItem> cartItems = cartDAO.getCartItems(user.getId());
        double total = cartItems.stream()
                .mapToDouble(CartItem::getSubtotal)
                .sum();
        
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("total", total);
        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            handleAdd(request, response, user.getId());
        } else if ("update".equals(action)) {
            handleUpdate(request, response);
        } else if ("remove".equals(action)) {
            handleRemove(request, response);
        }
    }

    /**
     * 添加到购物车
     */
    private void handleAdd(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws IOException {
        int productId = Integer.parseInt(request.getParameter("productId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        
        if (cartDAO.addToCart(userId, productId, quantity)) {
            response.sendRedirect("cart");
        } else {
            response.sendRedirect("products?error=添加失败");
        }
    }

    /**
     * 更新购物车数量
     */
    private void handleUpdate(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int cartItemId = Integer.parseInt(request.getParameter("cartItemId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        
        cartDAO.updateCartItemQuantity(cartItemId, quantity);
        response.sendRedirect("cart");
    }

    /**
     * 从购物车移除
     */
    private void handleRemove(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int cartItemId = Integer.parseInt(request.getParameter("cartItemId"));
        
        cartDAO.removeFromCart(cartItemId);
        response.sendRedirect("cart");
    }
}
