# 电商网站项目
学号 202330452691
姓名 崔少旭
班级 计算机科学与技术二班


基于 Servlet 和 JSP 的完整电商网站，包含用户管理、商品管理、购物车和订单系统。

## 项目功能

### 用户功能
- ✅ 用户注册/登录/注销
- ✅ 商品浏览和搜索
- ✅ 购物车管理（添加、修改、删除）
- ✅ 订单创建和查看
- ✅ 邮件订单确认

### 管理员功能
- ✅ 商品管理（添加、编辑、删除）
- ✅ 订单管理和状态更新
- ✅ 销售统计报表

## 技术栈

- **后端框架**: Servlet 4.0 + JSP 2.3
- **数据库**: MySQL 8.0
- **构建工具**: Maven
- **密码加密**: BCrypt
- **邮件服务**: JavaMail API
- **连接池**: Apache Commons DBCP2
- **标签库**: JSTL

## 项目结构

```
e-commerce/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/ecommerce/
│   │   │       ├── model/          # 实体类
│   │   │       │   ├── User.java
│   │   │       │   ├── Product.java
│   │   │       │   ├── Order.java
│   │   │       │   ├── OrderItem.java
│   │   │       │   └── CartItem.java
│   │   │       ├── dao/            # 数据访问层
│   │   │       │   ├── UserDAO.java
│   │   │       │   ├── ProductDAO.java
│   │   │       │   ├── CartDAO.java
│   │   │       │   └── OrderDAO.java
│   │   │       ├── servlet/        # 控制器
│   │   │       │   ├── AuthServlet.java
│   │   │       │   ├── ProductServlet.java
│   │   │       │   ├── CartServlet.java
│   │   │       │   ├── OrderServlet.java
│   │   │       │   └── AdminServlet.java
│   │   │       └── util/           # 工具类
│   │   │           ├── DBUtil.java
│   │   │           └── EmailUtil.java
│   │   ├── resources/
│   │   │   └── db.properties       # 数据库配置
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   └── web.xml
│   │       ├── css/
│   │       │   └── style.css
│   │       ├── admin/              # 管理员页面
│   │       │   ├── dashboard.jsp
│   │       │   ├── products.jsp
│   │       │   ├── productForm.jsp
│   │       │   └── orders.jsp
│   │       ├── index.jsp
│   │       ├── login.jsp
│   │       ├── register.jsp
│   │       ├── productList.jsp
│   │       ├── cart.jsp
│   │       ├── checkout.jsp
│   │       ├── orderSuccess.jsp
│   │       └── orderList.jsp
│   └── database/
│       └── schema.sql              # 数据库初始化脚本
├── pom.xml
└── README.md
```

## 快速开始

### 1. 环境要求

- JDK 8 或更高版本
- Maven 3.6+
- MySQL 8.0+
- Tomcat 9.0+ 或其他 Servlet 容器

### 2. 数据库配置

1. 创建 MySQL 数据库：
```sql
CREATE DATABASE ecommerce DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

2. 执行初始化脚本：
```bash
mysql -u root -p ecommerce < database/schema.sql
```

3. 修改数据库配置文件 `src/main/resources/db.properties`：
```properties
db.url=jdbc:mysql://localhost:3306/ecommerce?useSSL=false&serverTimezone=UTC&characterEncoding=utf8
db.username=你的数据库用户名
db.password=你的数据库密码
```

### 3. 邮件配置（可选）

如需使用邮件功能，修改 `db.properties` 中的邮件配置：
```properties
mail.smtp.host=smtp.gmail.com
mail.smtp.port=587
mail.username=your-email@gmail.com
mail.password=your-app-password
mail.from=your-email@gmail.com
```

### 4. 编译和运行

#### 使用 Maven 编译

```bash
cd e-commerce
mvn clean package
```

#### 部署到 Tomcat

1. 将生成的 `target/e-commerce.war` 复制到 Tomcat 的 `webapps` 目录
2. 启动 Tomcat
3. 访问 `http://localhost:8080/e-commerce`

#### 使用 IDE（如 IntelliJ IDEA）

1. 导入项目为 Maven 项目
2. 配置 Tomcat 服务器
3. 运行项目

### 5. 默认账户

- **管理员账户**
  - 用户名: `admin`
  - 密码: `admin123`

## 核心功能说明

### 用户购物流程

1. **注册/登录** → 访问 `/login.jsp` 或 `/register.jsp`
2. **浏览商品** → 访问 `/products`
3. **加入购物车** → 在商品列表点击"加入购物车"
4. **查看购物车** → 访问 `/cart`
5. **结算订单** → 点击"去结算"，填写收货地址
6. **提交订单** → 确认订单信息并提交
7. **查看订单** → 访问 `/order` 查看订单历史

### 管理员功能

1. **登录后台** → 使用管理员账户登录
2. **商品管理** → 访问 `/admin/products`
   - 添加商品
   - 编辑商品信息
   - 删除商品
3. **订单管理** → 访问 `/admin/orders`
   - 查看所有订单
   - 更新订单状态（待处理、处理中、已发货、已送达、已取消）
4. **销售统计** → 访问 `/admin/dashboard.jsp`

## 数据库表结构

- **users** - 用户表
- **products** - 商品表
- **orders** - 订单表
- **order_items** - 订单项表
- **cart_items** - 购物车表

## 部署到生产环境

### 本地 Tomcat 部署

1. 编译项目生成 WAR 包
2. 将 WAR 包部署到 Tomcat
3. 配置数据库连接
4. 启动服务

### 云服务器部署

1. 准备云服务器（推荐 Ubuntu/CentOS）
2. 安装 Java、MySQL、Tomcat
3. 配置防火墙开放端口 8080
4. 上传并部署项目
5. 配置域名和反向代理（可选）

### Docker 部署（推荐）

创建 `Dockerfile`:
```dockerfile
FROM tomcat:9.0-jdk8
COPY target/e-commerce.war /usr/local/tomcat/webapps/
EXPOSE 8080
CMD ["catalina.sh", "run"]
```

构建和运行：
```bash
docker build -t e-commerce .
docker run -p 8080:8080 e-commerce
```

## GitHub 部署步骤

1. **初始化 Git 仓库**
```bash
cd e-commerce
git init
git add .
git commit -m "Initial commit"
```

2. **推送到 GitHub**
```bash
git remote add origin https://github.com/你的用户名/e-commerce.git
git branch -M main
git push -u origin main
```

3. **添加 .gitignore**（已包含）

## 常见问题

### Q: 数据库连接失败
A: 检查 `db.properties` 配置是否正确，确保 MySQL 服务已启动

### Q: 邮件发送失败
A: 检查邮件服务器配置，如使用 Gmail 需要开启"允许不够安全的应用"

### Q: 页面乱码
A: 确保所有文件使用 UTF-8 编码，检查 Tomcat 配置

## 安全说明

- 密码使用 BCrypt 加密存储
- 防止 SQL 注入（使用 PreparedStatement）
- Session 管理和权限控制
- 建议在生产环境启用 HTTPS

## 扩展功能建议

- [ ] 商品图片上传
- [ ] 支付接口集成
- [ ] 用户评论和评分
- [ ] 优惠券系统
- [ ] 物流追踪
- [ ] 数据导出功能

## 许可证

MIT License

## 联系方式

如有问题，欢迎提交 Issue 或 Pull Request。

---

**开发者**: 电商平台开发团队  
**最后更新**: 2025-12-18
