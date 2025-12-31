package com.ecommerce.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.ecommerce.model.BrowsingHistory;
import com.ecommerce.model.Product;
import com.ecommerce.util.DBUtil;

/**
 * 浏览历史数据访问对象
 */
public class BrowsingHistoryDAO {
    private ProductDAO productDAO = new ProductDAO();

    /**
     * 记录浏览历史（如存在则更新浏览次数和时间）
     */
    public void recordView(int userId, int productId) {
        String sql = "INSERT INTO browsing_history (user_id, product_id, view_count, last_viewed_at) " +
                     "VALUES (?, ?, 1, NOW()) " +
                     "ON DUPLICATE KEY UPDATE view_count = view_count + 1, last_viewed_at = NOW()";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            pstmt.setInt(2, productId);
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * 获取用户的浏览历史
     */
    public List<BrowsingHistory> getUserHistory(int userId, int limit) {
        List<BrowsingHistory> historyList = new ArrayList<>();
        String sql = "SELECT bh.*, p.name as product_name FROM browsing_history bh " +
                     "JOIN products p ON bh.product_id = p.id " +
                     "WHERE bh.user_id = ? ORDER BY bh.last_viewed_at DESC LIMIT ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            pstmt.setInt(2, limit);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                BrowsingHistory history = extractHistoryFromResultSet(rs);
                // 加载完整的商品信息
                Product product = productDAO.getProductById(history.getProductId());
                history.setProduct(product);
                historyList.add(history);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return historyList;
    }

    /**
     * 获取所有用户的浏览历史（管理员用）
     */
    public List<BrowsingHistory> getAllHistory(int limit) {
        List<BrowsingHistory> historyList = new ArrayList<>();
        String sql = "SELECT bh.*, u.username, p.name as product_name FROM browsing_history bh " +
                     "JOIN users u ON bh.user_id = u.id " +
                     "JOIN products p ON bh.product_id = p.id " +
                     "ORDER BY bh.last_viewed_at DESC LIMIT ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, limit);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                BrowsingHistory history = extractHistoryFromResultSet(rs);
                history.setUsername(rs.getString("username"));
                Product product = productDAO.getProductById(history.getProductId());
                history.setProduct(product);
                historyList.add(history);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return historyList;
    }

    /**
     * 按用户名搜索浏览历史（管理员用）
     */
    public List<BrowsingHistory> getHistoryByUsername(String username, int limit) {
        List<BrowsingHistory> historyList = new ArrayList<>();
        String sql = "SELECT bh.*, u.username, p.name as product_name FROM browsing_history bh " +
                     "JOIN users u ON bh.user_id = u.id " +
                     "JOIN products p ON bh.product_id = p.id " +
                     "WHERE u.username LIKE ? ORDER BY bh.last_viewed_at DESC LIMIT ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, "%" + username + "%");
            pstmt.setInt(2, limit);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                BrowsingHistory history = extractHistoryFromResultSet(rs);
                history.setUsername(rs.getString("username"));
                Product product = productDAO.getProductById(history.getProductId());
                history.setProduct(product);
                historyList.add(history);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return historyList;
    }

    /**
     * 删除用户的浏览历史
     */
    public boolean clearUserHistory(int userId) {
        String sql = "DELETE FROM browsing_history WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 从ResultSet提取BrowsingHistory对象
     */
    private BrowsingHistory extractHistoryFromResultSet(ResultSet rs) throws SQLException {
        BrowsingHistory history = new BrowsingHistory();
        history.setId(rs.getInt("id"));
        history.setUserId(rs.getInt("user_id"));
        history.setProductId(rs.getInt("product_id"));
        history.setViewCount(rs.getInt("view_count"));
        history.setLastViewedAt(rs.getTimestamp("last_viewed_at"));
        history.setCreatedAt(rs.getTimestamp("created_at"));
        return history;
    }
}
