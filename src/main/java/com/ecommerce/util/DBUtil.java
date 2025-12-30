package com.ecommerce.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * 数据库连接工具类 (简化版)
 */
public class DBUtil {
    // 数据库配置
    private static String URL;
    private static String USERNAME;
    private static String PASSWORD;

    static {
        try {
            // 加载驱动
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // 加载配置文件
            java.util.Properties props = new java.util.Properties();
            try (java.io.InputStream in = DBUtil.class.getClassLoader().getResourceAsStream("config.properties")) {
                if (in != null) {
                    props.load(in);
                    URL = props.getProperty("db.url");
                    USERNAME = props.getProperty("db.username");
                    PASSWORD = props.getProperty("db.password");
                } else {
                    // 如果找不到配置文件，使用默认值或抛出异常
                    System.err.println("警告: 找不到 config.properties，将尝试使用环境变量或默认值");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("数据库初始化失败: " + e.getMessage());
        }
    }

    /**
     * 获取数据库连接
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }

    /**
     * 关闭数据库资源
     */
    public static void close(AutoCloseable... closeables) {
        for (AutoCloseable closeable : closeables) {
            if (closeable != null) {
                try {
                    closeable.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
