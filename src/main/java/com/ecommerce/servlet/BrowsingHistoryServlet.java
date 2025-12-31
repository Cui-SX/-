package com.ecommerce.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.ecommerce.dao.BrowsingHistoryDAO;
import com.ecommerce.model.BrowsingHistory;
import com.ecommerce.model.User;

/**
 * 浏览历史Servlet
 */
@WebServlet("/history")
public class BrowsingHistoryServlet extends HttpServlet {
    private BrowsingHistoryDAO browsingHistoryDAO = new BrowsingHistoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // 获取用户的浏览历史（最近50条）
        List<BrowsingHistory> historyList = browsingHistoryDAO.getUserHistory(user.getId(), 50);
        request.setAttribute("historyList", historyList);
        
        request.getRequestDispatcher("/browsingHistory.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("clear".equals(action)) {
            // 清除浏览历史
            browsingHistoryDAO.clearUserHistory(user.getId());
            response.sendRedirect(request.getContextPath() + "/history?message=cleared");
        } else {
            response.sendRedirect(request.getContextPath() + "/history");
        }
    }
}
