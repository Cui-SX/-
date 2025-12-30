package com.ecommerce.util;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

public class SchemaUpdater {
    public static void main(String[] args) {
        updateSchema();
    }

    public static void updateSchema() {
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement()) {
            
            System.out.println("Updating database schema...");

            // 1. Update users table to allow 'sales_manager' role
            try {
                stmt.executeUpdate("ALTER TABLE users MODIFY COLUMN role ENUM('customer', 'admin', 'sales_manager') DEFAULT 'customer'");
                System.out.println("Updated users table role ENUM.");
            } catch (SQLException e) {
                System.out.println("Error updating users table: " + e.getMessage());
            }

            // 2. Update orders table to allow 'completed' status (optional, but good for flexibility)
            try {
                stmt.executeUpdate("ALTER TABLE orders MODIFY COLUMN status ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled', 'completed') DEFAULT 'pending'");
                System.out.println("Updated orders table status ENUM.");
            } catch (SQLException e) {
                System.out.println("Error updating orders table: " + e.getMessage());
            }

            System.out.println("Schema update finished.");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
