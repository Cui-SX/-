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

# 优先使用安全初始化脚本（不删除现有数据）
if [ -f "database/init_safe.sql" ]; then
    echo "使用安全初始化脚本 (不删除现有数据)..."
    sudo mysql -u $DB_USER -p$DB_PASS < database/init_safe.sql
elif [ -f "init_safe.sql" ]; then
    echo "使用安全初始化脚本 (不删除现有数据)..."
    sudo mysql -u $DB_USER -p$DB_PASS < init_safe.sql
elif [ -f "database/schema.sql" ]; then
    echo "警告: 使用 schema.sql 会删除所有现有数据！"
    echo "导入 database/schema.sql..."
    sudo mysql -u $DB_USER -p$DB_PASS < database/schema.sql
    # 导入新功能表
    if [ -f "database/new_features.sql" ]; then
        echo "导入 database/new_features.sql..."
        sudo mysql -u $DB_USER -p$DB_PASS $DB_NAME < database/new_features.sql
    fi
elif [ -f "schema.sql" ]; then
    echo "警告: 使用 schema.sql 会删除所有现有数据！"
    sudo mysql -u $DB_USER -p$DB_PASS < schema.sql
else
    echo "警告: 找不到数据库初始化文件，跳过数据库导入。"
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
