package com.ecommerce.servlet;

import java.io.IOException;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.ecommerce.dao.OrderDAO;
import com.ecommerce.model.User;

@WebServlet("/admin/stats")
public class SalesStatsServlet extends HttpServlet {
    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!isAdmin(req)) {
            resp.sendRedirect("../login.jsp");
            return;
        }

        Map<String, Object> stats = orderDAO.getSalesStatistics();
        req.setAttribute("stats", stats);
        req.getRequestDispatcher("/admin/salesStats.jsp").forward(req, resp);
    }

    private boolean isAdmin(HttpServletRequest req) {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        return user != null && ("admin".equals(user.getRole()) || "sales_manager".equals(user.getRole()));
    }
}
