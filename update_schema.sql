-- 添加销售管理员用户
INSERT INTO users (username, password, email, full_name, role) 
VALUES ('manager', 'manager123', 'manager@example.com', 'Sales Manager', 'sales_manager');

-- 确保订单表有状态字段 (如果之前没有)
-- ALTER TABLE orders ADD COLUMN status VARCHAR(20) DEFAULT 'pending';
