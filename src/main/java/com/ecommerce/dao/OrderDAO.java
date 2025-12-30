package com.ecommerce.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.ecommerce.model.Order;
import com.ecommerce.model.OrderItem;
import com.ecommerce.model.Product;
import com.ecommerce.util.DBUtil;

/**
 * 订单数据访问对象
 */
public class OrderDAO {
    private ProductDAO productDAO = new ProductDAO();

    /**
     * 创建订单
     */
    public int createOrder(Order order) {
        String orderSql = "INSERT INTO orders (user_id, total_amount, status, shipping_address) VALUES (?, ?, ?, ?)";
        String itemSql = "INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
        
        Connection conn = null;
        PreparedStatement orderStmt = null;
        PreparedStatement itemStmt = null;
        
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);
            
            // 插入订单
            orderStmt = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS);
            orderStmt.setInt(1, order.getUserId());
            orderStmt.setDouble(2, order.getTotalAmount());
            orderStmt.setString(3, "pending");
            orderStmt.setString(4, order.getShippingAddress());
            orderStmt.executeUpdate();
            
            // 获取生成的订单ID
            ResultSet rs = orderStmt.getGeneratedKeys();
            int orderId = 0;
            if (rs.next()) {
                orderId = rs.getInt(1);
            }
            
            // 插入订单项
            itemStmt = conn.prepareStatement(itemSql);
            for (OrderItem item : order.getOrderItems()) {
                itemStmt.setInt(1, orderId);
                itemStmt.setInt(2, item.getProductId());
                itemStmt.setInt(3, item.getQuantity());
                itemStmt.setDouble(4, item.getPrice());
                itemStmt.addBatch();
                
                // 更新库存
                productDAO.updateStock(item.getProductId(), item.getQuantity());
            }
            itemStmt.executeBatch();
            
            conn.commit();
            return orderId;
            
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return 0;
        } finally {
            DBUtil.close(itemStmt, orderStmt, conn);
        }
    }

    /**
     * 获取用户订单列表
     */
    public List<Order> getOrdersByUserId(int userId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Order order = extractOrderFromResultSet(rs);
                // 加载订单项
                order.setOrderItems(getOrderItems(order.getId()));
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    /**
     * 获取所有订单（管理员用）
     */
    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.username FROM orders o JOIN users u ON o.user_id = u.id ORDER BY o.created_at DESC";
        
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Order order = extractOrderFromResultSet(rs);
                order.setOrderItems(getOrderItems(order.getId()));
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    /**
     * 根据条件查询订单
     */
    public List<Order> getOrdersByFilters(String username, Double minPrice, Double maxPrice, String startDate, String endDate) {
        List<Order> orders = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT o.*, u.username FROM orders o JOIN users u ON o.user_id = u.id WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (username != null && !username.trim().isEmpty()) {
            sql.append(" AND u.username LIKE ?");
            params.add("%" + username.trim() + "%");
        }
        if (minPrice != null) {
            sql.append(" AND o.total_amount >= ?");
            params.add(minPrice);
        }
        if (maxPrice != null) {
            sql.append(" AND o.total_amount <= ?");
            params.add(maxPrice);
        }
        if (startDate != null && !startDate.trim().isEmpty()) {
            sql.append(" AND o.created_at >= ?");
            params.add(startDate + " 00:00:00");
        }
        if (endDate != null && !endDate.trim().isEmpty()) {
            sql.append(" AND o.created_at <= ?");
            params.add(endDate + " 23:59:59");
        }
        
        sql.append(" ORDER BY o.created_at DESC");

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Order order = extractOrderFromResultSet(rs);
                order.setOrderItems(getOrderItems(order.getId()));
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    /**
     * 根据ID获取订单
     */
    public Order getOrderById(int orderId) {
        String sql = "SELECT * FROM orders WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, orderId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Order order = extractOrderFromResultSet(rs);
                order.setOrderItems(getOrderItems(orderId));
                return order;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 获取订单项
     */
    private List<OrderItem> getOrderItems(int orderId) {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT * FROM order_items WHERE order_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, orderId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                OrderItem item = extractOrderItemFromResultSet(rs);
                // 加载商品信息
                Product product = productDAO.getProductById(item.getProductId());
                item.setProduct(product);
                items.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    /**
     * 更新订单状态
     */
    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            pstmt.setInt(2, orderId);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 获取销售统计
     */
    public Map<String, Object> getSalesStatistics() {
        Map<String, Object> stats = new HashMap<>();
        
        try (Connection conn = DBUtil.getConnection()) {
            // 总订单数
            String countSql = "SELECT COUNT(*) as total FROM orders";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(countSql);
            if (rs.next()) {
                stats.put("totalOrders", rs.getInt("total"));
            }
            
            // 总销售额
            String revenueSql = "SELECT SUM(total_amount) as revenue FROM orders WHERE status != 'cancelled'";
            rs = stmt.executeQuery(revenueSql);
            if (rs.next()) {
                stats.put("totalRevenue", rs.getDouble("revenue"));
            }
            
            // 各状态订单数
            String statusSql = "SELECT status, COUNT(*) as count FROM orders GROUP BY status";
            rs = stmt.executeQuery(statusSql);
            Map<String, Integer> statusCounts = new HashMap<>();
            while (rs.next()) {
                statusCounts.put(rs.getString("status"), rs.getInt("count"));
            }
            stats.put("statusCounts", statusCounts);
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    /**
     * 从ResultSet提取Order对象
     */
    private Order extractOrderFromResultSet(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getInt("id"));
        order.setUserId(rs.getInt("user_id"));
        
        // 尝试获取用户名（如果查询中包含）
        try {
            order.setUsername(rs.getString("username"));
        } catch (SQLException e) {
            // 忽略，说明查询中没有包含username字段
        }
        
        order.setTotalAmount(rs.getDouble("total_amount"));
        order.setStatus(rs.getString("status"));
        order.setShippingAddress(rs.getString("shipping_address"));
        order.setCreatedAt(rs.getTimestamp("created_at"));
        order.setUpdatedAt(rs.getTimestamp("updated_at"));
        return order;
    }

    /**
     * 从ResultSet提取OrderItem对象
     */
    private OrderItem extractOrderItemFromResultSet(ResultSet rs) throws SQLException {
        OrderItem item = new OrderItem();
        item.setId(rs.getInt("id"));
        item.setOrderId(rs.getInt("order_id"));
        item.setProductId(rs.getInt("product_id"));
        item.setQuantity(rs.getInt("quantity"));
        item.setPrice(rs.getDouble("price"));
        return item;
    }
}
