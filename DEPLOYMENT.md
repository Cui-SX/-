# 部署指南

## 本地开发环境部署

### 1. 环境准备

#### 安装 MySQL
1. 下载并安装 MySQL 8.0
2. 创建数据库：
```sql
CREATE DATABASE ecommerce DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```
3. 导入数据库脚本：
```bash
mysql -u root -p ecommerce < database/schema.sql
```

#### 安装 Tomcat
1. 下载 Tomcat 9.0+ from https://tomcat.apache.org/
2. 解压到目录，例如 `C:\tomcat` 或 `/usr/local/tomcat`
3. 设置环境变量 `CATALINA_HOME`

#### 安装 Maven
1. 下载 Maven from https://maven.apache.org/
2. 解压并配置环境变量

### 2. 配置项目

1. 修改 `src/main/resources/db.properties`：
```properties
db.url=jdbc:mysql://localhost:3306/ecommerce?useSSL=false&serverTimezone=UTC&characterEncoding=utf8
db.username=root
db.password=你的MySQL密码
```

2. 邮件配置（可选）：
```properties
mail.smtp.host=smtp.gmail.com
mail.smtp.port=587
mail.username=your-email@gmail.com
mail.password=your-app-password
mail.from=your-email@gmail.com
```

### 3. 编译和部署

```bash
# 编译项目
mvn clean package

# 复制 WAR 到 Tomcat
cp target/e-commerce.war $CATALINA_HOME/webapps/

# 启动 Tomcat
$CATALINA_HOME/bin/startup.sh    # Linux/Mac
$CATALINA_HOME/bin/startup.bat   # Windows

# 访问应用
# http://localhost:8080/e-commerce
```

## 在线服务器部署

### 选项 1: 使用云服务器（推荐 AWS / 阿里云 / 腾讯云）

#### Step 1: 购买并配置服务器
1. 购买云服务器（推荐配置：2核4G，Ubuntu 20.04）
2. 配置安全组，开放端口：
   - 22 (SSH)
   - 8080 (Tomcat)
   - 3306 (MySQL，仅限内网访问)

#### Step 2: 安装必要软件

```bash
# 连接到服务器
ssh username@your-server-ip

# 更新系统
sudo apt update && sudo apt upgrade -y

# 安装 Java
sudo apt install openjdk-8-jdk -y
java -version

# 安装 MySQL
sudo apt install mysql-server -y
sudo mysql_secure_installation

# 安装 Tomcat
cd /opt
sudo wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.80/bin/apache-tomcat-9.0.80.tar.gz
sudo tar -xzf apache-tomcat-9.0.80.tar.gz
sudo mv apache-tomcat-9.0.80 tomcat
sudo chmod +x /opt/tomcat/bin/*.sh

# 安装 Maven
sudo apt install maven -y
```

#### Step 3: 配置数据库

```bash
# 登录 MySQL
sudo mysql -u root -p

# 创建数据库和用户
CREATE DATABASE ecommerce DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'ecommerce_user'@'localhost' IDENTIFIED BY 'strong_password';
GRANT ALL PRIVILEGES ON ecommerce.* TO 'ecommerce_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;

# 导入数据
mysql -u ecommerce_user -p ecommerce < database/schema.sql
```

#### Step 4: 上传和部署项目

```bash
# 在本地编译项目
mvn clean package

# 上传 WAR 文件到服务器
scp target/e-commerce.war username@your-server-ip:/opt/tomcat/webapps/

# 在服务器上启动 Tomcat
sudo /opt/tomcat/bin/startup.sh

# 查看日志
tail -f /opt/tomcat/logs/catalina.out
```

#### Step 5: 配置开机自启（可选）

创建 systemd 服务文件：
```bash
sudo nano /etc/systemd/system/tomcat.service
```

添加内容：
```ini
[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking
Environment=JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat
ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh
User=root
Group=root

[Install]
WantedBy=multi-user.target
```

启用服务：
```bash
sudo systemctl daemon-reload
sudo systemctl enable tomcat
sudo systemctl start tomcat
sudo systemctl status tomcat
```

### 选项 2: 使用 Docker 部署

#### Step 1: 创建 Dockerfile

```dockerfile
FROM tomcat:9.0-jdk8
COPY target/e-commerce.war /usr/local/tomcat/webapps/
EXPOSE 8080
CMD ["catalina.sh", "run"]
```

#### Step 2: 构建和运行

```bash
# 构建镜像
docker build -t e-commerce:latest .

# 运行容器
docker run -d -p 8080:8080 --name e-commerce-app e-commerce:latest

# 查看日志
docker logs -f e-commerce-app
```

#### Step 3: 使用 Docker Compose（推荐）

创建 `docker-compose.yml`:
```yaml
version: '3.8'
services:
  mysql:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: ecommerce
      MYSQL_USER: ecommerce_user
      MYSQL_PASSWORD: ecommerce_password
    volumes:
      - mysql-data:/var/lib/mysql
      - ./database/schema.sql:/docker-entrypoint-initdb.d/schema.sql
    ports:
      - "3306:3306"
    networks:
      - ecommerce-network

  tomcat:
    build: .
    ports:
      - "8080:8080"
    depends_on:
      - mysql
    environment:
      DB_URL: jdbc:mysql://mysql:3306/ecommerce?useSSL=false&serverTimezone=UTC&characterEncoding=utf8
      DB_USERNAME: ecommerce_user
      DB_PASSWORD: ecommerce_password
    networks:
      - ecommerce-network

volumes:
  mysql-data:

networks:
  ecommerce-network:
```

运行：
```bash
docker-compose up -d
```

### 选项 3: 使用 Heroku 部署

1. 注册 Heroku 账号
2. 安装 Heroku CLI
3. 创建 Heroku 应用
4. 配置数据库插件（ClearDB MySQL）
5. 推送代码并部署

```bash
heroku login
heroku create your-app-name
heroku addons:create cleardb:ignite
git push heroku main
```

## 配置域名和 HTTPS（可选）

### 使用 Nginx 反向代理

1. 安装 Nginx：
```bash
sudo apt install nginx -y
```

2. 配置 Nginx：
```bash
sudo nano /etc/nginx/sites-available/ecommerce
```

添加配置：
```nginx
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://localhost:8080/e-commerce/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

3. 启用配置：
```bash
sudo ln -s /etc/nginx/sites-available/ecommerce /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

4. 配置 SSL（使用 Let's Encrypt）：
```bash
sudo apt install certbot python3-certbot-nginx -y
sudo certbot --nginx -d your-domain.com
```

## 监控和维护

### 日志位置
- Tomcat 日志: `/opt/tomcat/logs/catalina.out`
- Nginx 日志: `/var/log/nginx/access.log` 和 `/var/log/nginx/error.log`

### 备份数据库
```bash
# 备份
mysqldump -u root -p ecommerce > backup_$(date +%Y%m%d).sql

# 恢复
mysql -u root -p ecommerce < backup_20251218.sql
```

### 性能优化建议
1. 配置数据库连接池
2. 启用 Tomcat 压缩
3. 使用 CDN 加速静态资源
4. 配置缓存策略
5. 数据库索引优化

## 故障排查

### 常见问题

1. **无法连接数据库**
   - 检查 MySQL 是否运行
   - 验证 db.properties 配置
   - 确认防火墙设置

2. **页面 404 错误**
   - 检查 WAR 是否正确部署
   - 验证 Tomcat 是否启动
   - 查看 catalina.out 日志

3. **内存不足**
   - 增加 Tomcat 内存配置：
   ```bash
   export CATALINA_OPTS="-Xms512m -Xmx1024m"
   ```

## 联系支持

如遇到部署问题，请查看项目 GitHub Issues 或联系开发团队。
