#!/bin/bash

# ==========================================
# 自动部署脚本 (Auto Deploy Script)
# ==========================================

# 1. 安装必要软件
echo "[1/5] 正在安装 Java, Tomcat, MySQL..."
sudo apt-get update
sudo apt-get install -y openjdk-8-jdk tomcat9 mysql-server

# 2. 配置数据库
echo "[2/5] 正在配置 MySQL..."
# 尝试设置 root 密码 (如果已经设置过可能会失败，我们忽略错误继续尝试连接)
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Root123456'; FLUSH PRIVILEGES;" || echo "注意: MySQL 密码修改失败，可能已经设置过密码，尝试继续..."

# 导入数据
echo "正在导入数据库结构..."

DB_USER="root"
DB_PASS="Root123456"
DB_NAME="ecommerce"

# 检查并导入 schema.sql
if [ -f "schema.sql" ]; then
    echo "导入 schema.sql..."
    sudo mysql -u $DB_USER -p$DB_PASS < schema.sql
elif [ -f "database/schema.sql" ]; then
    echo "导入 database/schema.sql..."
    sudo mysql -u $DB_USER -p$DB_PASS < database/schema.sql
else
    echo "警告: 找不到 schema.sql 文件，跳过基础表结构导入。"
fi

# 检查并导入 new_features.sql
if [ -f "new_features.sql" ]; then
    echo "导入 new_features.sql..."
    sudo mysql -u $DB_USER -p$DB_PASS $DB_NAME < new_features.sql
elif [ -f "database/new_features.sql" ]; then
    echo "导入 database/new_features.sql..."
    sudo mysql -u $DB_USER -p$DB_PASS $DB_NAME < database/new_features.sql
else
    echo "警告: 找不到 new_features.sql 文件，跳过新功能表导入。"
fi

# 检查并导入 add_sales_manager.sql
if [ -f "add_sales_manager.sql" ]; then
    echo "导入 add_sales_manager.sql..."
    sudo mysql -u $DB_USER -p$DB_PASS $DB_NAME < add_sales_manager.sql
elif [ -f "database/add_sales_manager.sql" ]; then
    echo "导入 database/add_sales_manager.sql..."
    sudo mysql -u $DB_USER -p$DB_PASS $DB_NAME < database/add_sales_manager.sql
fi

# 3. 部署 WAR 包
echo "[3/5] 正在部署 WAR 包..."
if [ -f "e-commerce.war" ]; then
    # 删除旧版本
    sudo rm -rf /var/lib/tomcat9/webapps/e-commerce
    sudo rm -f /var/lib/tomcat9/webapps/e-commerce.war
    # 复制新版本
    sudo cp e-commerce.war /var/lib/tomcat9/webapps/
else
    echo "错误: 找不到 e-commerce.war 文件！"
    exit 1
fi

# 4. 修改配置文件
echo "[4/5] 正在修改数据库连接配置..."
echo "等待 Tomcat 解压 WAR 包..."

CONFIG_FILE="/var/lib/tomcat9/webapps/e-commerce/WEB-INF/classes/config.properties"

# 循环检查文件是否存在，最多等待 30 秒
for i in {1..30}; do
    if [ -f "$CONFIG_FILE" ]; then
        echo "找到配置文件，开始修改..."
        break
    fi
    echo "等待解压中... ($i/30)"
    sleep 1
done

if [ -f "$CONFIG_FILE" ]; then
    # 使用 sed 命令自动替换密码和用户名
    sudo sed -i 's/db.password=.*/db.password=Root123456/' $CONFIG_FILE
    sudo sed -i 's/db.username=.*/db.username=root/' $CONFIG_FILE
    echo "配置文件修改成功！"
else
    echo "错误: 30秒后仍未找到配置文件。Tomcat 可能启动失败或解压过慢。"
    echo "请手动检查 /var/lib/tomcat9/webapps/e-commerce 目录。"
fi

# 5. 重启服务
echo "[5/5] 重启 Tomcat..."
sudo systemctl restart tomcat9

echo "=========================================="
echo "部署完成！"
echo "请访问: http://你的服务器IP:8080/e-commerce"
echo "=========================================="
