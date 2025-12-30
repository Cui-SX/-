<%@ page import="java.sql.*" %>
<%@ page import="com.ecommerce.util.DBUtil" %>
<%@ page import="java.io.File" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Update Image Paths</title>
</head>
<body>
    <h1>Updating Image Paths...</h1>
    <pre>
    <%
        Connection conn = null;
        PreparedStatement stmt = null;
        PreparedStatement updateStmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            
            // 获取所有商品
            String sql = "SELECT id, name FROM products";
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            String updateSql = "UPDATE products SET image_url = ? WHERE id = ?";
            updateStmt = conn.prepareStatement(updateSql);
            
            String webappPath = application.getRealPath("/");
            File webappDir = new File(webappPath);
            File picturesDir = new File(webappDir, "pictures");
            String picturesPath = picturesDir.getAbsolutePath();
            
            out.println("Scanning directory: " + picturesPath);
            
            if (picturesDir.exists() && picturesDir.isDirectory()) {
                int count = 0;
                while (rs.next()) {
                    int id = rs.getInt("id");
                    String name = rs.getString("name");
                    
                    // 尝试匹配文件 (支持 jpg, png, jpeg)
                    String[] extensions = {".jpg", ".png", ".jpeg", ".gif"};
                    String foundFile = null;
                    
                    for (String ext : extensions) {
                        File f = new File(picturesDir, name + ext);
                        if (f.exists()) {
                            foundFile = "pictures/" + name + ext;
                            break;
                        }
                    }
                    
                    if (foundFile != null) {
                        updateStmt.setString(1, foundFile);
                        updateStmt.setInt(2, id);
                        updateStmt.executeUpdate();
                        out.println("Updated Product [" + name + "] -> " + foundFile);
                        count++;
                    } else {
                        out.println("Skipped Product [" + name + "] - No matching image found in pictures folder.");
                    }
                }
                out.println("\nTotal updated: " + count);
            } else {
                out.println("Error: pictures directory not found!");
            }
            
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
            e.printStackTrace(new java.io.PrintWriter(out));
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) {}
            if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
            if (updateStmt != null) try { updateStmt.close(); } catch (SQLException e) {}
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }
    %>
    </pre>
    <a href="index.jsp">Go Home</a>
</body>
</html>