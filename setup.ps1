# MediMind Quick Start Script for PowerShell
# Run this script to set up the project

Write-Host "🏥 MediMind Setup Script" -ForegroundColor Green
Write-Host "========================`n" -ForegroundColor Green

# Check Flutter installation
Write-Host "📋 Checking Flutter installation..." -ForegroundColor Yellow
if (Get-Command flutter -ErrorAction SilentlyContinue) {
    flutter --version
    Write-Host "✅ Flutter is installed`n" -ForegroundColor Green
} else {
    Write-Host "❌ Flutter is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Flutter from: https://flutter.dev/docs/get-started/install" -ForegroundColor Red
    exit 1
}

# Get dependencies
Write-Host "📦 Installing dependencies..." -ForegroundColor Yellow
flutter pub get
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Dependencies installed`n" -ForegroundColor Green
} else {
    Write-Host "❌ Failed to install dependencies" -ForegroundColor Red
    exit 1
}

# Generate Hive adapters
Write-Host "🔧 Generating Hive type adapters..." -ForegroundColor Yellow
flutter pub run build_runner build --delete-conflicting-outputs
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Hive adapters generated`n" -ForegroundColor Green
} else {
    Write-Host "❌ Failed to generate Hive adapters" -ForegroundColor Red
    exit 1
}

# Generate localization files
Write-Host "🌐 Generating localization files..." -ForegroundColor Yellow
flutter gen-l10n
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Localization files generated`n" -ForegroundColor Green
} else {
    Write-Host "❌ Failed to generate localization files" -ForegroundColor Red
    exit 1
}

# Check for connected devices
Write-Host "📱 Checking for connected devices..." -ForegroundColor Yellow
flutter devices
Write-Host ""

# Summary
Write-Host "✅ Setup Complete!" -ForegroundColor Green
Write-Host "==================`n" -ForegroundColor Green
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Connect an Android device or start an emulator" -ForegroundColor White
Write-Host "2. Run: flutter run" -ForegroundColor White
Write-Host "3. Or build release: flutter build apk --release`n" -ForegroundColor White

Write-Host "For detailed instructions, see SETUP.md" -ForegroundColor Cyan
Write-Host "For troubleshooting, see README.md`n" -ForegroundColor Cyan

Write-Host "Happy coding!" -ForegroundColor Green
