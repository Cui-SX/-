package com.ecommerce.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.ecommerce.dao.UserDAO;
import com.ecommerce.model.User;

/**
 * 销售经理/管理员登录认证Servlet
 */
@WebServlet("/admin/auth")
public class AdminAuthServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("logout".equals(action)) {
            handleLogout(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        
        if ("login".equals(action)) {
            handleLogin(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }

    /**
     * 处理销售经理/管理员登录
     */
    private void handleLogin(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        System.out.println("AdminAuth - 尝试登录: " + username);
        
        User user = userDAO.login(username, password);
        
        if (user != null) {
            System.out.println("AdminAuth - 登录成功: " + user.getUsername() + ", 角色: " + user.getRole());
            
            HttpSession session = request.getSession(true);
            
            // 确保 session cookie 路径正确
            if (session.isNew()) {
                System.out.println("AdminAuth - 创建新 Session");
            }
            
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("role", user.getRole());
            
            // 设置 session 超时时间（30分钟）
            session.setMaxInactiveInterval(1800);
            
            System.out.println("AdminAuth - Session ID: " + session.getId());
            System.out.println("AdminAuth - Session user: " + session.getAttribute("user"));
            System.out.println("AdminAuth - Session role: " + session.getAttribute("role"));
            
            // 根据角色自动跳转
            if ("admin".equals(user.getRole()) || "sales_manager".equals(user.getRole())) {
                // 管理员和销售经理跳转到管理后台
                String redirectUrl = request.getContextPath() + "/admin/dashboard";
                System.out.println("AdminAuth - 重定向到: " + redirectUrl);
                response.sendRedirect(redirectUrl);
                return;
            } else {
                // 普通用户跳转到商品页面
                String redirectUrl = request.getContextPath() + "/products";
                System.out.println("AdminAuth - 重定向到: " + redirectUrl);
                response.sendRedirect(redirectUrl);
                return;
            }
        } else {
            System.out.println("AdminAuth - 登录失败: 用户名或密码错误");
            request.setAttribute("error", "用户名或密码错误");
            request.getRequestDispatcher("../login.jsp").forward(request, response);
        }
    }

    /**
     * 处理登出
     */
    private void handleLogout(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}
