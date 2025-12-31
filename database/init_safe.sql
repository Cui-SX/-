-- 安全初始化脚本 - 只创建不存在的表，不删除现有数据
-- 用于后续部署更新，避免数据丢失

CREATE DATABASE IF NOT EXISTS ecommerce DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE ecommerce;

-- 用户表
CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    full_name VARCHAR(100),
    phone VARCHAR(20),
    address TEXT,
    role ENUM('customer', 'admin', 'sales_manager') DEFAULT 'customer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 商品表
CREATE TABLE IF NOT EXISTS products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock INT DEFAULT 0,
    category VARCHAR(50),
    image_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 订单表
CREATE TABLE IF NOT EXISTS orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled', 'completed') DEFAULT 'pending',
    shipping_address TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 订单项表
CREATE TABLE IF NOT EXISTS order_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 购物车表
CREATE TABLE IF NOT EXISTS cart_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_product (user_id, product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 浏览历史表
CREATE TABLE IF NOT EXISTS browsing_history (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    view_count INT DEFAULT 1,
    last_viewed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_product_history (user_id, product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 系统日志表
CREATE TABLE IF NOT EXISTS system_logs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    username VARCHAR(50),
    action VARCHAR(100) NOT NULL,
    details TEXT,
    ip_address VARCHAR(50),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_user_id (user_id),
    INDEX idx_action (action),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 插入默认管理员账户（如果不存在）
INSERT IGNORE INTO users (username, password, email, full_name, role) VALUES 
('admin', 'admin123', 'admin@ecommerce.com', 'Administrator', 'admin'),
('sales', 'sales123', 'sales@ecommerce.com', 'Sales Manager', 'sales_manager');

-- 插入示例商品（如果商品表为空）
INSERT INTO products (name, description, price, stock, category, image_url)
SELECT * FROM (
    SELECT 'Laptop' AS name, 'High-performance business laptop with Intel i7 processor and 16GB RAM' AS description, 5999.00 AS price, 50 AS stock, 'Electronics' AS category, 'pictures/Laptop.jpg' AS image_url
) AS tmp
WHERE NOT EXISTS (SELECT 1 FROM products LIMIT 1);

INSERT IGNORE INTO products (name, description, price, stock, category, image_url) VALUES
('Wireless Mouse', 'Ergonomic wireless mouse with 6-month battery life', 99.00, 200, 'Accessories', 'pictures/Wireless Mouse.jpg'),
('Mechanical Keyboard', 'RGB backlit mechanical keyboard with blue switches', 399.00, 150, 'Accessories', 'pictures/Mechanical Keyboard.jpg'),
('Monitor', '27-inch 4K monitor with IPS panel and accurate color reproduction', 2999.00, 80, 'Electronics', 'pictures/Monitor.jpg'),
('USB Charger', 'Multi-port USB fast charger with PD support', 129.00, 300, 'Accessories', 'pictures/USB Charger.jpg'),
('Bluetooth Headphones', 'Active noise cancellation headphones with 30-hour battery', 899.00, 120, 'Audio', 'pictures/Bluetooth Headphones.jpg'),
('External Hard Drive', '1TB portable hard drive with USB 3.0 high-speed transfer', 399.00, 100, 'Storage', 'pictures/External Hard Drive.jpg'),
('Webcam', '1080P HD webcam suitable for video conferencing', 299.00, 90, 'Accessories', 'pictures/Webcam.jpg'),
('Router', 'Gigabit dual-band wireless router with strong signal coverage', 199.00, 150, 'Networking', 'pictures/Router.jpg'),
('Tablet', '10.1-inch tablet suitable for work and entertainment', 1999.00, 60, 'Electronics', 'pictures/Tablet.jpg');
