package com.ecommerce.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.ecommerce.dao.SystemLogDAO;
import com.ecommerce.dao.UserDAO;
import com.ecommerce.model.User;

/**
 * 用户认证Servlet - 处理登录、注册、登出
 */
@WebServlet("/auth")
public class AuthServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    private SystemLogDAO systemLogDAO = new SystemLogDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("logout".equals(action)) {
            handleLogout(request, response);
        } else {
            response.sendRedirect("login.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        
        if ("login".equals(action)) {
            handleLogin(request, response);
        } else if ("register".equals(action)) {
            handleRegister(request, response);
        } else {
            response.sendRedirect("index.jsp");
        }
    }

    /**
     * 处理登录
     */
    private void handleLogin(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        User user = userDAO.login(username, password);
        
        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("role", user.getRole());
            
            // 记录登录日志
            systemLogDAO.log(user.getId(), username, "LOGIN", "用户登录成功", 
                request.getRemoteAddr(), request.getHeader("User-Agent"));
            
            // 根据角色自动跳转
            if (user.isAdmin() || "sales_manager".equals(user.getRole())) {
                // 管理员和销售经理跳转到管理后台
                response.sendRedirect("admin/dashboard");
            } else {
                // 普通用户跳转到商品页面
                response.sendRedirect("products");
            }
        } else {
            // 记录登录失败日志
            systemLogDAO.log(null, username, "LOGIN_FAILED", "用户登录失败：用户名或密码错误", 
                request.getRemoteAddr(), request.getHeader("User-Agent"));
            request.setAttribute("error", "用户名或密码错误");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    /**
     * 处理注册
     */
    private void handleRegister(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        
        // 验证
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "两次输入的密码不一致");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        if (userDAO.usernameExists(username)) {
            request.setAttribute("error", "用户名已存在");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        if (userDAO.emailExists(email)) {
            request.setAttribute("error", "邮箱已被注册");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        // 创建用户
        User user = new User(username, password, email, fullName);
        if (userDAO.register(user)) {
            // 记录注册日志
            systemLogDAO.log(null, username, "REGISTER", "新用户注册成功", 
                request.getRemoteAddr(), request.getHeader("User-Agent"));
            request.setAttribute("success", "注册成功，请登录");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "注册失败，请稍后重试");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }

    /**
     * 处理登出
     */
    private void handleLogout(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            Integer userId = (Integer) session.getAttribute("userId");
            String username = (String) session.getAttribute("username");
            
            // 记录登出日志
            systemLogDAO.log(userId, username, "LOGOUT", "用户登出", 
                request.getRemoteAddr(), request.getHeader("User-Agent"));
            
            session.invalidate();
        }
        response.sendRedirect("login.jsp");
    }
}
