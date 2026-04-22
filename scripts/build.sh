#!/bin/bash

# 美妆店管理系统 - 一键打包脚本
# 功能：编译后端项目、打包前端项目、生成部署包

# ============================================
# 配置
# ============================================
PROJECT_ROOT="/c/work/project1"
BACKEND_DIR="$PROJECT_ROOT/java-backend"
FRONTEND_DIR="$PROJECT_ROOT/uniapp-frontend"
OUTPUT_DIR="$PROJECT_ROOT/dist"
TIMESTAMP=$(date +%Y%m%d%H%M%S)
PACKAGE_NAME="beautyshop-${TIMESTAMP}.tar.gz"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   美妆店管理系统 - 一键打包脚本${NC}"
echo -e "${GREEN}========================================${NC}"

# ============================================
# 步骤1：清理旧文件
# ============================================
echo -e "\n${YELLOW}[1/5] 清理旧构建文件...${NC}"

cd "$PROJECT_ROOT"
rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"
rm -rf "$BACKEND_DIR/target"
rm -rf "$FRONTEND_DIR/dist"

echo -e "${GREEN}✓ 清理完成${NC}"

# ============================================
# 步骤2：构建后端
# ============================================
echo -e "\n${YELLOW}[2/5] 构建后端项目 (Spring Boot)...${NC}"

cd "$BACKEND_DIR"

# 使用Maven编译打包
if command -v mvn &> /dev/null; then
    mvn clean package -DskipTests
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ 后端构建成功${NC}"
    else
        echo -e "${RED}✗ 后端构建失败${NC}"
        exit 1
    fi
else
    echo -e "${RED}✗ Maven 未安装，请先安装 Maven${NC}"
    exit 1
fi

# ============================================
# 步骤3：构建前端
# ============================================
echo -e "\n${YELLOW}[3/5] 构建前端项目 (Vue)...${NC}"

cd "$FRONTEND_DIR"

# 安装依赖并构建
if [ -f "package.json" ]; then
    npm install
    npm run build
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ 前端构建成功${NC}"
    else
        echo -e "${RED}✗ 前端构建失败${NC}"
        exit 1
    fi
else
    echo -e "${RED}✗ package.json 不存在${NC}"
    exit 1
fi

# ============================================
# 步骤4：复制文件
# ============================================
echo -e "\n${YELLOW}[4/5] 复制构建文件...${NC}"

# 复制后端JAR
cp "$BACKEND_DIR/target/"*.jar "$OUTPUT_DIR/"
echo "  - 后端JAR文件已复制"

# 复制前端dist
cp -r "$FRONTEND_DIR/dist" "$OUTPUT_DIR/"
echo "  - 前端dist已复制"

# 复制脚本
cp -r "$PROJECT_ROOT/scripts" "$OUTPUT_DIR/"
echo "  - 脚本文件已复制"

# 复制配置模板
if [ -f "$PROJECT_ROOT/config/application.properties" ]; then
    cp "$PROJECT_ROOT/config/application.properties" "$OUTPUT_DIR/"
    echo "  - 配置文件已复制"
fi

# ============================================
# 步骤5：生成部署包
# ============================================
echo -e "\n${YELLOW}[5/5] 生成部署包...${NC}"

cd "$PROJECT_ROOT"
tar -czf "$OUTPUT_DIR/$PACKAGE_NAME" -C "$OUTPUT_DIR" --exclude="$PACKAGE_NAME" .
echo -e "${GREEN}✓ 部署包已生成: $PACKAGE_NAME${NC}"

# ============================================
# 完成
# ============================================
echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}   打包完成！${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "\n输出目录: $OUTPUT_DIR"
echo -e "部署包名: $PACKAGE_NAME"
echo -e "\n部署包内容:"
ls -lh "$OUTPUT_DIR"

echo -e "\n${YELLOW}下一步操作:${NC}"
echo -e "1. 上传部署包到服务器: scp $OUTPUT_DIR/$PACKAGE_NAME user@server:/path/to/deploy"
echo -e "2. 使用部署脚本进行部署: ./deploy.sh"
echo -e ""
