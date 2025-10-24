@echo off
REM MediMind Setup Script for Windows
REM Run this to set up the project

echo.
echo ========================================
echo   MediMind Setup Script
echo ========================================
echo.

REM Check Flutter installation
echo [1/5] Checking Flutter installation...
where flutter >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Flutter is not installed or not in PATH
    echo Please install Flutter from: https://flutter.dev/docs/get-started/install
    pause
    exit /b 1
)
echo [OK] Flutter is installed
echo.

REM Get dependencies
echo [2/5] Installing dependencies...
call flutter pub get
if %errorlevel% neq 0 (
    echo [ERROR] Failed to install dependencies
    pause
    exit /b 1
)
echo [OK] Dependencies installed
echo.

REM Generate Hive adapters
echo [3/5] Generating Hive type adapters...
call flutter pub run build_runner build --delete-conflicting-outputs
if %errorlevel% neq 0 (
    echo [ERROR] Failed to generate Hive adapters
    pause
    exit /b 1
)
echo [OK] Hive adapters generated
echo.

REM Generate localization files
echo [4/5] Generating localization files...
call flutter gen-l10n
if %errorlevel% neq 0 (
    echo [ERROR] Failed to generate localization files
    pause
    exit /b 1
)
echo [OK] Localization files generated
echo.

REM Check for connected devices
echo [5/5] Checking for connected devices...
call flutter devices
echo.

REM Summary
echo ========================================
echo   Setup Complete!
echo ========================================
echo.
echo Next steps:
echo 1. Connect an Android device or start an emulator
echo 2. Run: flutter run
echo 3. Or build release: flutter build apk --release
echo.
echo For detailed instructions, see SETUP.md
echo For troubleshooting, see README.md
echo.
echo Happy coding!
echo.
pause
