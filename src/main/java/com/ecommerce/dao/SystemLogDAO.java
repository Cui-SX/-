package com.ecommerce.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.ecommerce.model.SystemLog;
import com.ecommerce.util.DBUtil;

/**
 * 系统日志数据访问对象
 */
public class SystemLogDAO {

    /**
     * 记录系统日志
     */
    public void log(Integer userId, String username, String action, String details, String ipAddress, String userAgent) {
        String sql = "INSERT INTO system_logs (user_id, username, action, details, ip_address, user_agent) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            if (userId != null) {
                pstmt.setInt(1, userId);
            } else {
                pstmt.setNull(1, java.sql.Types.INTEGER);
            }
            pstmt.setString(2, username);
            pstmt.setString(3, action);
            pstmt.setString(4, details);
            pstmt.setString(5, ipAddress);
            pstmt.setString(6, userAgent);
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * 记录系统日志（简化版）
     */
    public void log(SystemLog logEntry) {
        log(logEntry.getUserId(), logEntry.getUsername(), logEntry.getAction(), 
            logEntry.getDetails(), logEntry.getIpAddress(), logEntry.getUserAgent());
    }

    /**
     * 获取所有日志
     */
    public List<SystemLog> getAllLogs(int limit) {
        List<SystemLog> logs = new ArrayList<>();
        String sql = "SELECT * FROM system_logs ORDER BY created_at DESC LIMIT ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, limit);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                logs.add(extractLogFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return logs;
    }

    /**
     * 按操作类型筛选日志
     */
    public List<SystemLog> getLogsByAction(String action, int limit) {
        List<SystemLog> logs = new ArrayList<>();
        String sql = "SELECT * FROM system_logs WHERE action LIKE ? ORDER BY created_at DESC LIMIT ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, "%" + action + "%");
            pstmt.setInt(2, limit);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                logs.add(extractLogFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return logs;
    }

    /**
     * 按用户名筛选日志
     */
    public List<SystemLog> getLogsByUsername(String username, int limit) {
        List<SystemLog> logs = new ArrayList<>();
        String sql = "SELECT * FROM system_logs WHERE username LIKE ? ORDER BY created_at DESC LIMIT ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, "%" + username + "%");
            pstmt.setInt(2, limit);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                logs.add(extractLogFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return logs;
    }

    /**
     * 按时间范围筛选日志
     */
    public List<SystemLog> getLogsByDateRange(String startDate, String endDate, int limit) {
        List<SystemLog> logs = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM system_logs WHERE 1=1");
        List<Object> params = new ArrayList<>();
        
        if (startDate != null && !startDate.isEmpty()) {
            sql.append(" AND created_at >= ?");
            params.add(startDate + " 00:00:00");
        }
        if (endDate != null && !endDate.isEmpty()) {
            sql.append(" AND created_at <= ?");
            params.add(endDate + " 23:59:59");
        }
        sql.append(" ORDER BY created_at DESC LIMIT ?");
        params.add(limit);
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                logs.add(extractLogFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return logs;
    }

    /**
     * 从ResultSet提取SystemLog对象
     */
    private SystemLog extractLogFromResultSet(ResultSet rs) throws SQLException {
        SystemLog log = new SystemLog();
        log.setId(rs.getInt("id"));
        int userId = rs.getInt("user_id");
        log.setUserId(rs.wasNull() ? null : userId);
        log.setUsername(rs.getString("username"));
        log.setAction(rs.getString("action"));
        log.setDetails(rs.getString("details"));
        log.setIpAddress(rs.getString("ip_address"));
        log.setUserAgent(rs.getString("user_agent"));
        log.setCreatedAt(rs.getTimestamp("created_at"));
        return log;
    }
}
