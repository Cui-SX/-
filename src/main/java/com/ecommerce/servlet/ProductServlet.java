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
import com.ecommerce.dao.ProductDAO;
import com.ecommerce.dao.SystemLogDAO;
import com.ecommerce.model.Product;
import com.ecommerce.model.User;

/**
 * 商品Servlet - 处理商品浏览、搜索
 */
@WebServlet("/products")
public class ProductServlet extends HttpServlet {
    private ProductDAO productDAO = new ProductDAO();
    private BrowsingHistoryDAO browsingHistoryDAO = new BrowsingHistoryDAO();
    private SystemLogDAO systemLogDAO = new SystemLogDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("search".equals(action)) {
            handleSearch(request, response);
        } else if ("category".equals(action)) {
            handleCategory(request, response);
        } else if ("detail".equals(action)) {
            handleDetail(request, response);
        } else {
            handleList(request, response);
        }
    }

    /**
     * 显示商品列表
     */
    private void handleList(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Product> products = productDAO.getAllProducts();
        request.setAttribute("products", products);
        request.getRequestDispatcher("productList.jsp").forward(request, response);
    }

    /**
     * 搜索商品
     */
    private void handleSearch(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<Product> products = productDAO.searchProducts(keyword);
        request.setAttribute("products", products);
        request.setAttribute("keyword", keyword);
        request.getRequestDispatcher("productList.jsp").forward(request, response);
    }

    /**
     * 按分类筛选
     */
    private void handleCategory(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String category = request.getParameter("name");
        List<Product> products = productDAO.getProductsByCategory(category);
        request.setAttribute("products", products);
        request.setAttribute("category", category);
        request.getRequestDispatcher("productList.jsp").forward(request, response);
    }

    /**
     * 商品详情
     */
    private void handleDetail(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int productId = Integer.parseInt(request.getParameter("id"));
        Product product = productDAO.getProductById(productId);
        
        // 记录浏览历史（如果用户已登录）
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user != null && product != null) {
            browsingHistoryDAO.recordView(user.getId(), productId);
            // 记录系统日志
            systemLogDAO.log(user.getId(), user.getUsername(), "VIEW_PRODUCT", 
                "浏览商品: " + product.getName() + " (ID: " + productId + ")",
                request.getRemoteAddr(), request.getHeader("User-Agent"));
        }
        
        request.setAttribute("product", product);
        request.getRequestDispatcher("productDetail.jsp").forward(request, response);
    }
}
