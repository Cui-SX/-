-- 添加销售经理测试账号
-- 请在MySQL中执行以下SQL语句

-- 1. 首先访问 http://localhost:8080/e-commerce/fix_db.jsp 更新数据库结构

-- 2. 然后执行以下语句添加销售经理账号
INSERT INTO users (username, password, email, full_name, role) VALUES 
('sales', 'sales123', 'sales@ecommerce.com', 'Sales Manager', 'sales_manager');

-- 销售经理登录信息：
-- 用户名: sales
-- 密码: sales123
