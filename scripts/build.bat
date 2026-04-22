@echo off
chcp 65001 > nul
REM 美妆店管理系统 - Windows一键打包脚本

echo ========================================
echo    美妆店管理系统 - 一键打包脚本
echo ========================================
echo.

set PROJECT_ROOT=%~dp0..
set BACKEND_DIR=%PROJECT_ROOT%\java-backend
set FRONTEND_DIR=%PROJECT_ROOT%\uniapp-frontend
set OUTPUT_DIR=%PROJECT_ROOT%\dist
set TIMESTAMP=%date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%
set TIMESTAMP=%TIMESTAMP: =0%
set PACKAGE_NAME=beautyshop-%TIMESTAMP%.zip

echo [1/5] 清理旧构建文件...
if exist "%OUTPUT_DIR%" rmdir /s /q "%OUTPUT_DIR%"
mkdir "%OUTPUT_DIR%"
if exist "%BACKEND_DIR%\target" rmdir /s /q "%BACKEND_DIR%\target"
if exist "%FRONTEND_DIR%\dist" rmdir /s /q "%FRONTEND_DIR%\dist"
echo ✓ 清理完成
echo.

echo [2/5] 构建后端项目 (Spring Boot)...
cd /d "%BACKEND_DIR%"

where mvn >nul 2>nul
if %errorlevel% neq 0 (
    echo ✗ Maven 未安装，请先安装 Maven
    echo 下载地址: https://maven.apache.org/download.cgi
    pause
    exit /b 1
)

call mvn clean package -DskipTests
if %errorlevel% neq 0 (
    echo ✗ 后端构建失败
    pause
    exit /b 1
)
echo ✓ 后端构建成功
echo.

echo [3/5] 构建前端项目 (Vue)...
cd /d "%FRONTEND_DIR%"

if not exist "package.json" (
    echo ✗ package.json 不存在
    pause
    exit /b 1
)

call npm install
if %errorlevel% neq 0 (
    echo ✗ npm依赖安装失败
    pause
    exit /b 1
)

call npm run build
if %errorlevel% neq 0 (
    echo ✗ 前端构建失败
    pause
    exit /b 1
)
echo ✓ 前端构建成功
echo.

echo [4/5] 复制构建文件...
cd /d "%PROJECT_ROOT%"

REM 复制后端JAR
for /r "%BACKEND_DIR%\target" %%i in (*.jar) do (
    copy "%%i" "%OUTPUT_DIR%" >nul
    echo   - 后端JAR文件: %%~nxi
)

REM 复制前端dist
xcopy /s /e /y "%FRONTEND_DIR%\dist" "%OUTPUT_DIR%\dist\" >nul
echo   - 前端dist已复制

REM 复制脚本
xcopy /s /e /y "%PROJECT_ROOT%\scripts" "%OUTPUT_DIR%\scripts\" >nul
echo   - 脚本文件已复制

echo ✓ 文件复制完成
echo.

echo [5/5] 生成部署包...
powershell -command "Compress-Archive -Path '%OUTPUT_DIR%\*' -DestinationPath '%OUTPUT_DIR%\%PACKAGE_NAME%' -Force"
echo ✓ 部署包已生成: %PACKAGE_NAME%
echo.

echo ========================================
echo    打包完成！
echo ========================================
echo.
echo 输出目录: %OUTPUT_DIR%
echo 部署包名: %PACKAGE_NAME%
echo.
echo 下一步操作:
echo 1. 上传部署包到服务器
echo 2. 使用部署脚本进行部署
echo.
pause
