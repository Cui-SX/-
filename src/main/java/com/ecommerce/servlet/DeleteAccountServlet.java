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

@WebServlet("/deleteAccount")
public class DeleteAccountServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user != null) {
            if (userDAO.deleteUser(user.getId())) {
                session.invalidate(); // 注销会话
                resp.sendRedirect("login.jsp?message=Account deleted successfully");
            } else {
                resp.sendRedirect("profile.jsp?error=Failed to delete account");
            }
        } else {
            resp.sendRedirect("login.jsp");
        }
    }
}
