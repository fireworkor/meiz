@echo off
REM Beauty Shop Management System - Management Script

setlocal enabledelayedexpansion

:menu
cls
echo ========================================
echo    Beauty Shop Management System
echo ========================================
echo.
echo Please select an option:
echo.
echo   [1] Initialize Database
echo   [2] Add Test Data
echo   [3] Clean Test Data
echo   [4] Build Project
echo   [5] Start Backend
echo   [6] Start Frontend
echo   [7] Start All Services
echo   [8] Stop All Services
echo   [9] Deploy
echo.
echo   [0] Exit
echo.
set /p choice=Enter option [0-9]:

if "%choice%"=="1" goto init_db
if "%choice%"=="2" goto add_data
if "%choice%"=="3" goto clean_data
if "%choice%"=="4" goto build
if "%choice%"=="5" goto start_backend
if "%choice%"=="6" goto start_frontend
if "%choice%"=="7" goto start_all
if "%choice%"=="8" goto stop_all
if "%choice%"=="9" goto deploy
if "%choice%"=="0" goto end

echo Invalid input, please try again!
timeout /t 2 >nul
goto menu

:init_db
cls
echo ========================================
echo    Initialize Database
echo ========================================
echo.
set /p mysql_user=Enter MySQL username [default: root]:
if "%mysql_user%"=="" set mysql_user=root
set /p mysql_pass=Enter MySQL password:
if "%mysql_pass%"=="" set mysql_pass=root
set /p db_name=Enter database name [default: beauty_shop]:
if "%db_name%"=="" set db_name=beauty_shop

echo.
echo Executing database initialization script...
echo.

mysql -u%mysql_user% -p%mysql_pass% < "%~dp0init-database.sql"
if %errorlevel% neq 0 (
    echo.
    echo Database initialization failed!
    pause
    goto menu
)

echo.
echo Database initialized successfully!
echo.
pause
goto menu

:add_data
cls
echo ========================================
echo    Add Test Data
echo ========================================
echo.
set /p mysql_user=Enter MySQL username [default: root]:
if "%mysql_user%"=="" set mysql_user=root
set /p mysql_pass=Enter MySQL password:
if "%mysql_pass%"=="" set mysql_pass=root
set /p db_name=Enter database name [default: beauty_shop]:
if "%db_name%"=="" set db_name=beauty_shop

echo.
echo Executing test data script...
echo.

mysql -u%mysql_user% -p%mysql_pass% %db_name% < "%~dp0init-test-data.sql"
if %errorlevel% neq 0 (
    echo.
    echo Adding test data failed!
    pause
    goto menu
)

echo.
echo Test data added successfully!
echo.
pause
goto menu

:clean_data
cls
echo ========================================
echo    Clean Test Data
echo ========================================
echo.
echo WARNING: This will delete all business data!
echo.
set /p confirm=Confirm cleanup? (Type YES to confirm):
if "%confirm%" neq "YES" (
    echo Operation cancelled
    timeout /t 2 >nul
    goto menu
)

set /p mysql_user=Enter MySQL username [default: root]:
if "%mysql_user%"=="" set mysql_user=root
set /p mysql_pass=Enter MySQL password:
if "%mysql_pass%"=="" set mysql_pass=root
set /p db_name=Enter database name [default: beauty_shop]:
if "%db_name%"=="" set db_name=beauty_shop

echo.
echo Cleaning test data...
echo.

mysql -u%mysql_user% -p%mysql_pass% %db_name% < "%~dp0cleanup-test-data.sql"
if %errorlevel% neq 0 (
    echo.
    echo Data cleanup failed!
    pause
    goto menu
)

echo.
echo Test data cleaned successfully!
echo.
pause
goto menu

:build
cls
echo ========================================
echo    Build Project
echo ========================================
echo.
echo Calling build script...
call "%~dp0build.bat"
pause
goto menu

:start_backend
cls
echo ========================================
echo    Start Backend Service
echo ========================================
echo.
echo Starting backend service (port 8080)...

cd /d "%~dp0..\java-backend"
start "Backend" cmd /c "mvn spring-boot:run"

echo.
echo Backend service starting, please wait...
echo   Access URL: http://localhost:8080
echo.
pause
goto menu

:start_frontend
cls
echo ========================================
echo    Start Frontend Service
echo ========================================
echo.
echo Starting frontend service (port 8082)...

cd /d "%~dp0..\uniapp-frontend"
start "Frontend" cmd /c "npm run dev"

echo.
echo Frontend service starting, please wait...
echo   Access URL: http://localhost:8082
echo.
pause
goto menu

:start_all
cls
echo ========================================
echo    Start All Services
echo ========================================
echo.

echo [1/2] Starting backend service...
cd /d "%~dp0..\java-backend"
start "Backend" cmd /k "mvn spring-boot:run"

timeout /t 5 >nul

echo [2/2] Starting frontend service...
cd /d "%~dp0..\uniapp-frontend"
start "Frontend" cmd /k "npm run dev"

echo.
echo ========================================
echo    Services Starting
echo ========================================
echo.
echo   Backend API: http://localhost:8080
echo   Frontend: http://localhost:8082
echo.
echo Note: Windows will run in background
echo.
pause
goto menu

:stop_all
cls
echo ========================================
echo    Stop All Services
echo ========================================
echo.
echo Stopping all services...

taskkill /f /im java.exe 2>nul
taskkill /f /im node.exe 2>nul

echo.
echo All services stopped
echo.
pause
goto menu

:deploy
cls
echo ========================================
echo    Deploy
echo ========================================
echo.
echo Executing deployment process...

call "%~dp0deploy.bat"

pause
goto menu

:end
cls
echo ========================================
echo    Thank You!
echo ========================================
echo.
echo For help, please see project documentation.
echo.
