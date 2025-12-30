<%@ page import="java.sql.*" %>
<%@ page import="com.ecommerce.util.DBUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Database Schema Fixer</title>
</head>
<body>
    <h1>Database Schema Fixer</h1>
    <pre>
    <%
        Connection conn = null;
        Statement stmt = null;
        try {
            conn = DBUtil.getConnection();
            stmt = conn.createStatement();
            
            out.println("Connected to database.");

            // 1. Update users table
            try {
                stmt.executeUpdate("ALTER TABLE users MODIFY COLUMN role ENUM('customer', 'admin', 'sales_manager') DEFAULT 'customer'");
                out.println("SUCCESS: Updated users table role ENUM.");
            } catch (SQLException e) {
                out.println("ERROR updating users table: " + e.getMessage());
            }

            // 2. Update orders table
            try {
                stmt.executeUpdate("ALTER TABLE orders MODIFY COLUMN status ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled', 'completed') DEFAULT 'pending'");
                out.println("SUCCESS: Updated orders table status ENUM.");
            } catch (SQLException e) {
                out.println("ERROR updating orders table: " + e.getMessage());
            }

            // 3. Fix image URLs
            try {
                int count = stmt.executeUpdate("UPDATE products SET image_url = REPLACE(image_url, 'via.placeholder.com', 'placehold.co') WHERE image_url LIKE '%via.placeholder.com%'");
                out.println("SUCCESS: Updated " + count + " product image URLs to use placehold.co");
            } catch (SQLException e) {
                out.println("ERROR updating product images: " + e.getMessage());
            }

        } catch (Exception e) {
            out.println("FATAL ERROR: " + e.getMessage());
            e.printStackTrace(new java.io.PrintWriter(out));
        } finally {
            if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }
    %>
    </pre>
    <p>If you see SUCCESS messages, the database is updated. You can delete this file now.</p>
    <a href="index.jsp">Go Home</a>
</body>
</html>
