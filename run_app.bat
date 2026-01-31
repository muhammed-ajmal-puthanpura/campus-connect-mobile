@echo off
REM Campus Connect Mobile App - Quick Setup Script for Windows
REM This script helps you set up and run the Flutter mobile app

echo ===============================================================
echo    Campus Connect Mobile App - Quick Setup and Run
echo ===============================================================
echo.

REM Check if Flutter is installed
echo [INFO] Checking Flutter installation...
where flutter >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Flutter is not installed!
    echo.
    echo Please install Flutter first:
    echo   Visit: https://flutter.dev/docs/get-started/install
    echo.
    pause
    exit /b 1
)

for /f "tokens=*" %%i in ('flutter --version 2^>^&1 ^| findstr /C:"Flutter"') do set FLUTTER_VERSION=%%i
echo [SUCCESS] Flutter found: %FLUTTER_VERSION%
echo.

REM Navigate to mobile_app directory
echo [INFO] Navigating to mobile_app directory...
cd /d "%~dp0mobile_app"
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] mobile_app directory not found!
    pause
    exit /b 1
)
echo [SUCCESS] In mobile_app directory
echo.

REM Install dependencies
echo [INFO] Installing dependencies (flutter pub get)...
flutter pub get
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to install dependencies
    pause
    exit /b 1
)
echo [SUCCESS] Dependencies installed
echo.

REM Enable web support
echo [INFO] Enabling web support...
flutter config --enable-web >nul 2>&1
echo [SUCCESS] Web support enabled
echo.

REM Check for available devices
echo [INFO] Checking for available devices...
flutter devices
echo.

REM Ask user how they want to run the app
echo ===============================================================
echo                    How to Run the App
echo ===============================================================
echo.
echo Choose how you want to run the app:
echo.
echo   1) Chrome Browser (Easiest - Recommended for first run)
echo   2) Android Emulator
echo   3) First available device
echo   4) List all devices and let me choose
echo   5) Exit
echo.
set /p choice="Enter your choice (1-5): "

if "%choice%"=="1" goto chrome
if "%choice%"=="2" goto android
if "%choice%"=="3" goto first
if "%choice%"=="4" goto list
if "%choice%"=="5" goto exit
goto invalid

:chrome
echo [INFO] Running app in Chrome browser...
echo [WARNING] Make sure your backend is running at http://localhost:5000
echo.
echo [INFO] The app will open in Chrome. You can login with:
echo    Email: student@example.com
echo    Password: password123
echo.
timeout /t 2 /nobreak >nul
flutter run -d chrome
goto end

:android
echo [INFO] Running app on Android emulator...
echo [WARNING] Make sure an Android emulator is running
echo.
flutter run -d android
goto end

:first
echo [INFO] Running app on first available device...
flutter run
goto end

:list
echo [INFO] Available devices:
flutter devices
echo.
set /p device_id="Enter device ID: "
echo [INFO] Running app on device: %device_id%
flutter run -d %device_id%
goto end

:invalid
echo [ERROR] Invalid choice
pause
exit /b 1

:exit
echo [INFO] Exiting...
exit /b 0

:end
echo.
echo ===============================================================
echo                    App is Running!
echo ===============================================================
echo.
echo Hot reload tips:
echo   - Press 'r' to hot reload
echo   - Press 'R' to hot restart
echo   - Press 'q' to quit
echo.
echo Demo accounts:
echo   Student:   student@example.com / password123
echo   Organizer: organizer@example.com / password123
echo   HOD:       hod@example.com / password123
echo   Principal: principal@example.com / password123
echo   Admin:     admin@example.com / password123
echo.
pause
