package com.ecommerce.servlet;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import com.ecommerce.dao.OrderDAO;
import com.ecommerce.dao.ProductDAO;
import com.ecommerce.model.Order;
import com.ecommerce.model.Product;
import com.ecommerce.model.User;

/**
 * 管理员Servlet - 处理商品和订单管理
 */
@WebServlet("/admin/*")
@MultipartConfig
public class AdminServlet extends HttpServlet {
    private ProductDAO productDAO = new ProductDAO();
    private OrderDAO orderDAO = new OrderDAO();

    private boolean isAdminOrSalesManager(User user) {
        return user != null && (user.isAdmin() || "sales_manager".equals(user.getRole()));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        String pathInfo = request.getPathInfo();
        System.out.println("AdminServlet - doGet: " + pathInfo);
        
        // 验证管理员权限
        if (!isAdminOrSalesManager(user)) {
            System.out.println("AdminServlet - 权限不足或未登录");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        if (pathInfo == null || "/dashboard".equals(pathInfo) || "/dashboard.jsp".equals(pathInfo)) {
            handleDashboard(request, response);
        } else if ("/products".equals(pathInfo)) {
            handleProductList(request, response);
        } else if ("/orders".equals(pathInfo)) {
            handleOrderList(request, response);
        } else if ("/product/edit".equals(pathInfo)) {
            handleProductEdit(request, response);
        } else if ("/stats".equals(pathInfo) || "/salesStats.jsp".equals(pathInfo)) {
            handleStats(request, response);
        } else {
            System.out.println("AdminServlet - 未知路径: " + pathInfo);
        }
    }

    private void handleStats(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Map<String, Object> stats = orderDAO.getSalesStatistics();
        request.setAttribute("stats", stats);
        request.getRequestDispatcher("/WEB-INF/admin/salesStats.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (!isAdminOrSalesManager(user)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        
        if ("/product/add".equals(pathInfo)) {
            handleProductAdd(request, response);
        } else if ("/product/update".equals(pathInfo)) {
            handleProductUpdate(request, response);
        } else if ("/product/delete".equals(pathInfo)) {
            handleProductDelete(request, response);
        } else if ("/order/updateStatus".equals(pathInfo)) {
            handleOrderStatusUpdate(request, response);
        }
    }

    /**
     * 仪表板
     */
    private void handleDashboard(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Map<String, Object> stats = orderDAO.getSalesStatistics();
        request.setAttribute("stats", stats);
        request.getRequestDispatcher("/WEB-INF/admin/dashboard.jsp").forward(request, response);
    }

    /**
     * 商品列表
     */
    private void handleProductList(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        System.out.println("AdminServlet - handleProductList");
        List<Product> products = productDAO.getAllProducts();
        System.out.println("AdminServlet - 获取到 " + (products != null ? products.size() : "null") + " 个商品");
        request.setAttribute("products", products);
        request.getRequestDispatcher("/WEB-INF/admin/products.jsp").forward(request, response);
    }

    /**
     * 订单列表
     */
    private void handleOrderList(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String minPriceStr = request.getParameter("minPrice");
        String maxPriceStr = request.getParameter("maxPrice");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        Double minPrice = null;
        if (minPriceStr != null && !minPriceStr.trim().isEmpty()) {
            try { minPrice = Double.parseDouble(minPriceStr); } catch (NumberFormatException e) {}
        }

        Double maxPrice = null;
        if (maxPriceStr != null && !maxPriceStr.trim().isEmpty()) {
            try { maxPrice = Double.parseDouble(maxPriceStr); } catch (NumberFormatException e) {}
        }

        List<Order> orders = orderDAO.getOrdersByFilters(username, minPrice, maxPrice, startDate, endDate);
        
        request.setAttribute("orders", orders);
        request.setAttribute("username", username);
        request.setAttribute("minPrice", minPriceStr);
        request.setAttribute("maxPrice", maxPriceStr);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        
        request.getRequestDispatcher("/WEB-INF/admin/orders.jsp").forward(request, response);
    }

    /**
     * 编辑商品页面
     */
    private void handleProductEdit(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            int productId = Integer.parseInt(idParam);
            Product product = productDAO.getProductById(productId);
            request.setAttribute("product", product);
        }
        request.getRequestDispatcher("/WEB-INF/admin/productForm.jsp").forward(request, response);
    }

    /**
     * 添加商品
     */
    private void handleProductAdd(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
        Product product = extractProductFromRequest(request);
        
        if (productDAO.addProduct(product)) {
            response.sendRedirect(request.getContextPath() + "/admin/products");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/product/edit?error=添加失败");
        }
    }

    /**
     * 更新商品
     */
    private void handleProductUpdate(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
        Product product = extractProductFromRequest(request);
        product.setId(Integer.parseInt(request.getParameter("id")));
        
        if (productDAO.updateProduct(product)) {
            response.sendRedirect(request.getContextPath() + "/admin/products");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/product/edit?id=" + 
                    product.getId() + "&error=更新失败");
        }
    }

    /**
     * 删除商品
     */
    private void handleProductDelete(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int productId = Integer.parseInt(request.getParameter("id"));
        productDAO.deleteProduct(productId);
        response.sendRedirect(request.getContextPath() + "/admin/products");
    }

    /**
     * 更新订单状态
     */
    private void handleOrderStatusUpdate(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        String status = request.getParameter("status");
        
        orderDAO.updateOrderStatus(orderId, status);
        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }

    /**
     * 从请求中提取商品对象
     */
    private Product extractProductFromRequest(HttpServletRequest request) throws IOException, ServletException {
        Product product = new Product();
        product.setName(request.getParameter("name"));
        product.setDescription(request.getParameter("description"));
        product.setPrice(Double.parseDouble(request.getParameter("price")));
        product.setStock(Integer.parseInt(request.getParameter("stock")));
        product.setCategory(request.getParameter("category"));
        
        // 处理图片上传
        String imageUrl = request.getParameter("currentImageUrl");
        Part filePart = request.getPart("imageFile");
        
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = getSubmittedFileName(filePart);
            String extension = "";
            int i = fileName.lastIndexOf('.');
            if (i > 0) {
                extension = fileName.substring(i);
            }
            
            // 使用商品名称作为文件名（清理非法字符）
            String safeName = product.getName().replaceAll("[^a-zA-Z0-9\\u4e00-\\u9fa5]", "_");
            String newFileName = safeName + extension;
            
            // 保存文件
            String uploadPath = request.getServletContext().getRealPath("/pictures");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            filePart.write(uploadPath + File.separator + newFileName);
            imageUrl = "pictures/" + newFileName;
        }
        
        // 如果没有上传新图片且没有旧图片，设置默认值
        if (imageUrl == null || imageUrl.trim().isEmpty()) {
            imageUrl = "https://placehold.co/300x200?text=No+Image";
        }
        
        product.setImageUrl(imageUrl);
        return product;
    }

    private String getSubmittedFileName(Part part) {
        for (String cd : part.getHeader("content-disposition").split(";")) {
            if (cd.trim().startsWith("filename")) {
                return cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
    }
}
