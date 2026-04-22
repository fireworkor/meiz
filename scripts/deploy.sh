#!/bin/bash

# 美妆店管理系统 - 一键部署脚本
# 功能：停止服务、备份、解压部署、启动服务
# 支持SSH远程部署

# ============================================
# 配置
# ============================================
BACKUP_DIR="/opt/beautyshop/backup"
APP_DIR="/opt/beautyshop/app"
LOG_DIR="/opt/beautyshop/logs"
SERVICE_NAME="beautyshop"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ============================================
# 函数定义
# ============================================

show_banner() {
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}   美妆店管理系统 - 一键部署脚本${NC}"
    echo -e "${GREEN}========================================${NC}"
}

show_usage() {
    echo "用法: $0 [选项]"
    echo ""
    echo "选项:"
    echo "  -l, --local          本地部署"
    echo "  -r, --remote HOST    远程部署 (需要SSH)"
    echo "  -h, --help           显示帮助"
    echo ""
    echo "示例:"
    echo "  $0 -l                           # 本地部署"
    echo "  $0 -r 192.168.1.100             # 远程部署"
}

check_requirements() {
    echo -e "\n${YELLOW}[检查环境]${NC}"

    # 检查目录
    if [ ! -d "$APP_DIR" ]; then
        echo -e "${YELLOW}创建应用目录...${NC}"
        sudo mkdir -p "$APP_DIR"
        sudo mkdir -p "$BACKUP_DIR"
        sudo mkdir -p "$LOG_DIR"
    fi

    # 检查Java
    if command -v java &> /dev/null; then
        JAVA_VERSION=$(java -version 2>&1 | head -1)
        echo -e "${GREEN}✓ Java已安装: $JAVA_VERSION${NC}"
    else
        echo -e "${RED}✗ Java未安装${NC}"
        exit 1
    fi

    # 检查MySQL客户端
    if command -v mysql &> /dev/null; then
        echo -e "${GREEN}✓ MySQL客户端已安装${NC}"
    else
        echo -e "${YELLOW}⚠ MySQL客户端未安装${NC}"
    fi

    echo ""
}

stop_service() {
    echo -e "\n${YELLOW}[停止服务]${NC}"

    # 查找并停止Java进程
    PID=$(ps aux | grep "$SERVICE_NAME" | grep -v grep | awk '{print $2}')
    if [ -n "$PID" ]; then
        echo -e "停止进程 PID: $PID"
        kill -15 $PID
        sleep 3

        # 强制停止
        PID=$(ps aux | grep "$SERVICE_NAME" | grep -v grep | awk '{print $2}')
        if [ -n "$PID" ]; then
            kill -9 $PID 2>/dev/null
        fi
        echo -e "${GREEN}✓ 服务已停止${NC}"
    else
        echo -e "${BLUE}服务未运行${NC}"
    fi
}

backup() {
    echo -e "\n${YELLOW}[备份当前版本]${NC}"

    if [ -d "$APP_DIR" ] && [ "$(ls -A $APP_DIR 2>/dev/null)" ]; then
        BACKUP_NAME="backup-$(date +%Y%m%d%H%M%S).tar.gz"
        echo -e "创建备份: $BACKUP_DIR/$BACKUP_NAME"
        tar -czf "$BACKUP_DIR/$BACKUP_NAME" -C "$APP_DIR" .
        echo -e "${GREEN}✓ 备份完成${NC}"
    else
        echo -e "${BLUE}无需备份（应用目录为空）${NC}"
    fi
}

deploy() {
    echo -e "\n${YELLOW}[部署新版本]${NC}"

    # 清理旧文件
    rm -rf "$APP_DIR"/*
    echo "清理旧文件完成"

    # 解压部署包（如果是通过压缩包部署）
    if [ -f "beautyshop-latest.tar.gz" ]; then
        echo "解压部署包..."
        tar -xzf beautyshop-latest.tar.gz -C "$APP_DIR"
    fi

    # 设置权限
    chmod +x "$APP_DIR"/*.jar 2>/dev/null
    chmod +x "$APP_DIR"/*.sh 2>/dev/null

    echo -e "${GREEN}✓ 部署完成${NC}"
}

start_service() {
    echo -e "\n${YELLOW}[启动服务]${NC}"

    # 查找JAR文件
    JAR_FILE=$(ls "$APP_DIR"/*.jar 2>/dev/null | head -1)

    if [ -n "$JAR_FILE" ]; then
        echo -e "启动应用: $(basename $JAR_FILE)"

        # 后台启动
        nohup java -jar "$JAR_FILE" \
            --spring.profiles.active=prod \
            --server.port=8080 \
            > "$LOG_DIR/stdout.log" 2>&1 &

        echo $! > "$APP_DIR/app.pid"

        # 等待启动
        echo -e "等待服务启动..."
        sleep 10

        # 检查启动状态
        if ps -p $(cat "$APP_DIR/app.pid" 2>/dev/null) > /dev/null 2>&1; then
            echo -e "${GREEN}✓ 服务启动成功${NC}"
            echo -e "PID: $(cat $APP_DIR/app.pid)"
        else
            echo -e "${RED}✗ 服务启动失败，请检查日志${NC}"
            tail -50 "$LOG_DIR/stdout.log"
        fi
    else
        echo -e "${RED}✗ 未找到JAR文件${NC}"
    fi
}

check_health() {
    echo -e "\n${YELLOW}[健康检查]${NC}"

    # 等待服务完全启动
    echo "等待服务就绪..."
    for i in {1..30}; do
        if curl -s http://localhost:8080/api/health > /dev/null 2>&1; then
            echo -e "${GREEN}✓ 服务健康检查通过${NC}"
            return 0
        fi
        sleep 2
    done

    echo -e "${YELLOW}⚠ 健康检查超时，服务可能还在启动中${NC}"
    return 1
}

rollback() {
    echo -e "\n${YELLOW}[回滚版本]${NC}"

    LATEST_BACKUP=$(ls -t "$BACKUP_DIR"/backup-*.tar.gz 2>/dev/null | head -1)

    if [ -n "$LATEST_BACKUP" ]; then
        echo -e "找到备份: $LATEST_BACKUP"
        stop_service

        rm -rf "$APP_DIR"/*
        tar -xzf "$LATEST_BACKUP" -C "$APP_DIR"

        start_service
        echo -e "${GREEN}✓ 回滚完成${NC}"
    else
        echo -e "${RED}✗ 未找到可用的备份${NC}"
    fi
}

# ============================================
# 主流程
# ============================================

MODE="local"

# 解析参数
while [[ $# -gt 0 ]]; do
    case $1 in
        -l|--local)
            MODE="local"
            shift
            ;;
        -r|--remote)
            MODE="remote"
            REMOTE_HOST="$2"
            shift 2
            ;;
        -h|--help)
            show_banner
            show_usage
            exit 0
            ;;
        *)
            echo -e "${RED}未知参数: $1${NC}"
            show_usage
            exit 1
            ;;
    esac
done

show_banner

if [ "$MODE" = "local" ]; then
    echo -e "${BLUE}部署模式: 本地部署${NC}"
    check_requirements
    stop_service
    backup
    deploy
    start_service
    check_health
else
    echo -e "${BLUE}部署模式: 远程部署到 $REMOTE_HOST${NC}"

    echo -e "${YELLOW}正在上传部署包到远程服务器...${NC}"
    scp beautyshop-latest.tar.gz root@"$REMOTE_HOST":/tmp/

    echo -e "${YELLOW}正在在远程服务器执行部署...${NC}"
    ssh root@"$REMOTE_HOST" "
        cd /opt/beautyshop
        bash /tmp/deploy-local.sh
    "
fi

echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}   部署完成！${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "\n服务地址:"
echo -e "  后端API: http://localhost:8080/api"
echo -e "  前端页面: http://localhost:8082"
echo -e "\n日志文件: $LOG_DIR/stdout.log"
echo ""
