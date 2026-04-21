# 美妆店智慧管理系统 - 部署指南

## 1. 环境要求

### 1.1 硬件要求

**开发环境：**
| 组件 | 最低配置 | 推荐配置 |
|------|----------|----------|
| CPU | 2核 | 4核 |
| 内存 | 4GB | 8GB |
| 硬盘 | 20GB | 50GB |

**生产环境（单节点）：**
| 组件 | 最低配置 | 推荐配置 |
|------|----------|----------|
| CPU | 4核 | 8核 |
| 内存 | 8GB | 16GB |
| 硬盘 | 100GB SSD | 200GB SSD |

**生产环境（集群）：**
| 组件 | 配置 | 数量 |
|------|------|------|
| 应用服务器 | 2核4G | 2-4台 |
| 数据库服务器 | 4核8G | 2台（主从） |
| 缓存服务器 | 2核4G | 2台 |
| 负载均衡器 | - | 1台 |

### 1.2 软件要求

| 软件 | 版本要求 | 说明 |
|------|----------|------|
| JDK | 1.8+ | 推荐使用JDK 8u311及以上 |
| Maven | 3.6+ | 后端项目构建工具 |
| MySQL | 8.0+ | 推荐8.0.28及以上 |
| Node.js | 14+ | 推荐14.19.0及以上 |
| npm | 6+ | Node.js自带的包管理器 |
| Redis | 4.0+ | 可选，用于缓存会话 |

### 1.3 网络要求

- 后端服务端口：8080
- 前端服务端口：8081
- MySQL端口：3306
- Redis端口：6379

---

## 2. 开发环境部署

### 2.1 数据库安装与配置

**Windows环境：**

1. 下载并安装 [MySQL 8.0](https://dev.mysql.com/downloads/mysql/)
2. 安装过程中设置root密码
3. 使用MySQL Workbench或命令行连接数据库

**创建数据库：**
```sql
CREATE DATABASE IF NOT EXISTS beauty_shop
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;
```

**导入数据库脚本：**
```bash
mysql -u root -p beauty_shop < database.sql
```

### 2.2 后端部署

1. **配置数据库连接：**
   编辑 `java-backend/src/main/resources/application.properties`：
   ```properties
   spring.datasource.url=jdbc:mysql://localhost:3306/beauty_shop?useUnicode=true&characterEncoding=utf-8&serverTimezone=Asia/Shanghai
   spring.datasource.username=root
   spring.datasource.password=your_password
   ```

2. **构建项目：**
   ```bash
   cd java-backend
   mvn clean package
   ```

3. **运行应用：**
   ```bash
   java -jar target/beautyshop-1.0.0.jar
   ```

   或者开发模式运行：
   ```bash
   mvn spring-boot:run
   ```

4. **验证后端服务：**
   访问 `http://localhost:8080/api/users/login`，返回JSON即表示成功。

### 2.3 前端部署

1. **安装依赖：**
   ```bash
   cd uniapp-frontend
   npm install
   ```

2. **启动开发服务器：**
   ```bash
   npm run dev
   ```

3. **验证前端服务：**
   访问 `http://localhost:8081`，显示登录页面即表示成功。

---

## 3. 生产环境部署

### 3.1 服务器准备

1. **购买/配置云服务器**
2. **安装操作系统**（推荐CentOS 7.9或Ubuntu 20.04）
3. **配置安全组**，开放必要端口

### 3.2 安装软件

**安装JDK：**
```bash
# CentOS
sudo yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel

# Ubuntu
sudo apt update
sudo apt install -y openjdk-8-jdk

# 验证安装
java -version
```

**安装MySQL：**
```bash
# CentOS 7
sudo yum localinstall https://dev.mysql.com/get/mysql80-community-release-el7-1.noarch.rpm
sudo yum install -y mysql-community-server
sudo systemctl start mysqld
sudo systemctl enable mysqld

# Ubuntu
sudo apt update
sudo apt install -y mysql-server
sudo systemctl start mysql
sudo systemctl enable mysql
```

**安装Node.js：**
```bash
# 使用nvm安装
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
source ~/.bashrc
nvm install 14
nvm use 14
node -v
npm -v
```

**安装Nginx：**
```bash
# CentOS
sudo yum install -y nginx

# Ubuntu
sudo apt install -y nginx
```

**安装Redis（可选）：**
```bash
# CentOS
sudo yum install -y redis
sudo systemctl start redis
sudo systemctl enable redis
```

### 3.3 数据库配置

1. **初始化数据库：**
   ```bash
   mysql -u root -p < database.sql
   ```

2. **创建数据库用户：**
   ```sql
   CREATE USER 'beautyshop'@'%' IDENTIFIED BY 'StrongPassword123!';
   GRANT ALL PRIVILEGES ON beauty_shop.* TO 'beautyshop'@'%';
   FLUSH PRIVILEGES;
   ```

3. **优化MySQL配置：**
   编辑 `/etc/my.cnf` 或 `/etc/mysql/mysql.conf.d/mysqld.cnf`：
   ```ini
   [mysqld]
   max_connections = 500
   innodb_buffer_pool_size = 2G
   innodb_log_file_size = 512M
   character-set-server = utf8mb4
   collation-server = utf8mb4_unicode_ci
   ```

### 3.4 后端部署

1. **上传构建包：**
   ```bash
   scp target/beautyshop-1.0.0.jar user@server:/opt/beautyshop/
   ```

2. **创建启动脚本：**
   ```bash
   #!/bin/bash
   # start.sh
   APP_NAME="beautyshop-1.0.0.jar"
   APP_HOME="/opt/beautyshop"
   LOG_FILE="$APP_HOME/logs/app.log"

   mkdir -p $APP_HOME/logs

   nohup java -jar $APP_HOME/$APP_NAME \
     --spring.profiles.active=prod \
     --server.port=8080 \
     > $LOG_FILE 2>&1 &

   echo $! > $APP_HOME/app.pid
   ```

3. **创建停止脚本：**
   ```bash
   #!/bin/bash
   # stop.sh
   APP_HOME="/opt/beautyshop"
   kill $(cat $APP_HOME/app.pid)
   rm $APP_HOME/app.pid
   ```

4. **配置systemd服务：**
   创建 `/etc/systemd/system/beautyshop.service`：
   ```ini
   [Unit]
   Description=BeautyShop Application
   After=network.target mysql.service

   [Service]
   Type=simple
   User=root
   WorkingDirectory=/opt/beautyshop
   ExecStart=/usr/bin/java -jar /opt/beautyshop/beautyshop-1.0.0.jar
   ExecStop=/bin/kill -s QUIT $MAINPID
   Restart=sec 10
   RestartSec 5

   [Install]
   WantedBy=multi-user.target
   ```

5. **启动服务：**
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl enable beautyshop
   sudo systemctl start beautyshop
   sudo systemctl status beautyshop
   ```

### 3.5 前端部署

1. **构建生产版本：**
   ```bash
   cd uniapp-frontend
   npm run build
   ```

2. **配置Nginx：**
   编辑 `/etc/nginx/nginx.conf`：
   ```nginx
   server {
       listen 80;
       server_name your-domain.com;

       root /opt/beautyshop-ui/dist;
       index index.html;

       location / {
           try_files $uri $uri/ /index.html;
       }

       location /api {
           proxy_pass http://127.0.0.1:8080;
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
       }
   }
   ```

3. **启动Nginx：**
   ```bash
   sudo systemctl restart nginx
   sudo systemctl enable nginx
   ```

---

## 4. Docker部署（可选）

### 4.1 Docker环境安装

```bash
# CentOS
sudo yum install -y docker-ce
sudo systemctl start docker
sudo systemctl enable docker

# 添加当前用户到docker组
sudo usermod -aG docker $USER
```

### 4.2 Docker Compose配置

创建 `docker-compose.yml`：
```yaml
version: '3.8'

services:
  mysql:
    image: mysql:8.0
    container_name: beautyshop-mysql
    environment:
      MYSQL_ROOT_PASSWORD: root_password
      MYSQL_DATABASE: beauty_shop
      MYSQL_USER: beautyshop
      MYSQL_PASSWORD: beautyshop_password
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql
      - ./database.sql:/docker-entrypoint-initdb.d/database.sql
    command: --default-authentication-plugin=mysql_native_password

  redis:
    image: redis:6.2
    container_name: beautyshop-redis
    ports:
      - "6379:6379"

  backend:
    image: openjdk:8-jdk
    container_name: beautyshop-backend
    working_dir: /app
    volumes:
      - ./beautyshop.jar:/app/beautyshop.jar
    ports:
      - "8080:8080"
    depends_on:
      - mysql
      - redis
    command: java -jar beautyshop.jar

  frontend:
    image: nginx:alpine
    container_name: beautyshop-frontend
    volumes:
      - ./dist:/usr/share/nginx/html
      - ./nginx.conf:/etc/nginx/conf.d/default.conf
    ports:
      - "80:80"
    depends_on:
      - backend

volumes:
  mysql_data:
```

### 4.3 启动Docker服务

```bash
docker-compose up -d
docker-compose ps
```

---

## 5. 集群部署

### 5.1 高可用架构

```
                    ┌─────────────────┐
                    │   负载均衡器     │
                    │  (SLB/ Nginx)   │
                    └────────┬────────┘
                             │
          ┌──────────────────┼──────────────────┐
          │                  │                  │
          ▼                  ▼                  ▼
   ┌────────────┐     ┌────────────┐     ┌────────────┐
   │  应用节点1  │     │  应用节点2  │     │  应用节点3  │
   │  (Tomcat)  │     │  (Tomcat)  │     │  (Tomcat)  │
   └────────────┘     └────────────┘     └────────────┘
          │                  │                  │
          └──────────────────┼──────────────────┘
                             │
          ┌──────────────────┼──────────────────┐
          │                  │                  │
          ▼                  ▼                  ▼
   ┌────────────┐     ┌────────────┐     ┌────────────┐
   │   MySQL    │     │   Redis    │     │    OSS     │
   │   主从     │     │   集群     │     │   文件存储  │
   └────────────┘     └────────────┘     └────────────┘
```

### 5.2 Session共享配置

如果使用多节点部署，需要配置Session共享。使用Redis实现Session共享：

1. 添加Redis依赖到 `pom.xml`：
   ```xml
   <dependency>
       <groupId>org.springframework.session</groupId>
       <artifactId>spring-session-data-redis</artifactId>
   </dependency>
   ```

2. 配置Redis：
   ```properties
   spring.redis.host=localhost
   spring.redis.port=6379
   spring.session.store-type=redis
   ```

### 5.3 Nginx负载均衡配置

```nginx
upstream beautyshop {
    least_conn;
    server 192.168.1.101:8080 weight=1;
    server 192.168.1.102:8080 weight=1;
    server 192.168.1.103:8080 weight=1;
}

server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://beautyshop;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /api {
        proxy_pass http://beautyshop/api;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

---

## 6. 部署检查清单

### 6.1 部署前检查

- [ ] 服务器硬件配置满足要求
- [ ] 操作系统已正确安装
- [ ] 所有依赖软件已安装并验证
- [ ] 数据库已创建并导入数据
- [ ] 防火墙端口已开放
- [ ] 域名已解析（如需要HTTPS）

### 6.2 部署后验证

- [ ] 后端服务正常启动（端口8080）
- [ ] 前端页面正常访问（端口80）
- [ ] 数据库连接正常
- [ ] 用户登录功能正常
- [ ] 核心业务功能测试通过

### 6.3 监控配置

- [ ] 配置服务器监控（CPU、内存、磁盘）
- [ ] 配置应用健康检查
- [ ] 配置日志收集
- [ ] 配置告警规则

---

## 7. 常见问题

### 7.1 后端启动失败

**问题：** Java应用启动失败

**解决方案：**
1. 检查JDK版本是否正确
2. 检查数据库连接配置
3. 检查端口是否被占用
4. 查看日志文件定位问题

### 7.2 前端无法访问后端API

**问题：** 前端请求API失败

**解决方案：**
1. 检查后端服务是否运行
2. 检查Nginx反向代理配置
3. 检查跨域配置
4. 检查防火墙规则

### 7.3 数据库连接失败

**问题：** 无法连接到MySQL

**解决方案：**
1. 检查MySQL服务状态
2. 检查用户名密码是否正确
3. 检查用户权限
4. 检查防火墙规则

### 7.4 性能问题

**问题：** 系统响应慢

**解决方案：**
1. 检查服务器资源使用情况
2. 检查数据库查询效率
3. 配置Redis缓存
4. 优化SQL查询
5. 增加服务器资源

---

## 8. 回滚方案

### 8.1 回滚步骤

1. **停止当前服务：**
   ```bash
   sudo systemctl stop beautyshop
   ```

2. **备份当前版本：**
   ```bash
   mv /opt/beautyshop/beautyshop-1.0.0.jar /opt/beautyshop/backup/
   ```

3. **恢复上一版本：**
   ```bash
   mv /opt/beautyshop/backup/beautyshop-old.jar /opt/beautyshop/beautyshop-1.0.0.jar
   ```

4. **重启服务：**
   ```bash
   sudo systemctl start beautyshop
   ```

### 8.2 数据回滚

如需回滚数据库：
```bash
mysql -u root -p beauty_shop < backup/database_backup.sql
```
