# ⚠️ SETUP REQUIRED: Flutter Not Found

## Issue
Flutter SDK is not installed or not in your system PATH.

## Solution: Install Flutter

### Option 1: Download Flutter SDK (Recommended)

1. **Download Flutter SDK**
   - Go to: https://docs.flutter.dev/get-started/install/windows
   - Download the latest stable release
   - Extract to: `C:\src\flutter` (or your preferred location)

2. **Add Flutter to PATH**
   - Open System Environment Variables:
     - Press `Win + X` → System → Advanced system settings
     - Click "Environment Variables"
   - Under "User variables", find "Path"
   - Click "Edit" → "New"
   - Add: `C:\src\flutter\bin` (or wherever you extracted Flutter)
   - Click "OK" on all dialogs

3. **Verify Installation**
   ```powershell
   # Restart PowerShell, then run:
   flutter --version
   flutter doctor
   ```

### Option 2: Use Flutter from Android Studio

If you have Android Studio installed:

1. Open Android Studio
2. Go to: File → Settings → Plugins
3. Install "Flutter" plugin
4. Restart Android Studio
5. Use Android Studio's terminal (bottom panel)

### Option 3: Use Scoop Package Manager

```powershell
# Install Scoop if you don't have it
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex

# Install Flutter
scoop bucket add extras
scoop install flutter
```

## After Installing Flutter

Once Flutter is installed and in PATH:

### Quick Setup (Run these commands in order):

```powershell
# 1. Navigate to project
cd "C:\Users\guilh\Flutter\projeto_flutter\MediMind"

# 2. Install dependencies
flutter pub get

# 3. Generate Hive adapters
flutter pub run build_runner build --delete-conflicting-outputs

# 4. Generate localizations
flutter gen-l10n

# 5. Check setup
flutter doctor

# 6. Connect device/emulator and run
flutter run
```

## Requirements Checklist

Before running the MediMind app, you need:

- ✅ **Flutter SDK** (3.0.0 or higher)
  - Download: https://flutter.dev/docs/get-started/install/windows
  - Add to PATH

- ✅ **Android Studio** (for Android SDK)
  - Download: https://developer.android.com/studio
  - During installation, select "Android SDK"
  - Install Android SDK (API 26-34)

- ✅ **Android SDK Command-line Tools**
  - Installed automatically with Android Studio
  - Or download from SDK Manager

- ✅ **Android Device or Emulator**
  - Physical device with USB debugging enabled
  - OR Android emulator (create in Android Studio)

- ✅ **Visual Studio Code** (Optional but recommended)
  - Download: https://code.visualstudio.com/
  - Install Flutter extension
  - Install Dart extension

## Detailed Installation Steps

### Step 1: Install Flutter SDK

1. Download: https://docs.flutter.dev/get-started/install/windows
2. Extract to `C:\src\flutter`
3. Add `C:\src\flutter\bin` to PATH
4. Restart terminal

### Step 2: Install Android Studio

1. Download: https://developer.android.com/studio
2. Run installer
3. Follow wizard:
   - Choose "Standard" installation
   - Accept licenses
   - Wait for SDK downloads

### Step 3: Configure Android SDK

1. Open Android Studio
2. Click "More Actions" → "SDK Manager"
3. Install:
   - Android SDK Platform 34
   - Android SDK Platform 26-33
   - Android SDK Build-Tools
   - Android SDK Command-line Tools
   - Android SDK Platform-Tools
   - Android Emulator

### Step 4: Accept Android Licenses

```powershell
flutter doctor --android-licenses
# Press 'y' to accept all licenses
```

### Step 5: Verify Setup

```powershell
flutter doctor -v
```

Should show:
```
✓ Flutter (Channel stable)
✓ Android toolchain
✓ Chrome - develop for the web
✓ Android Studio
✓ VS Code
✓ Connected device
```

### Step 6: Create Android Emulator (Optional)

```powershell
# List available emulators
flutter emulators

# Or create in Android Studio:
# Tools → Device Manager → Create Device → Pixel 6 Pro → Download system image → Finish
```

### Step 7: Run MediMind Setup

```powershell
cd "C:\Users\guilh\Flutter\projeto_flutter\MediMind"
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter gen-l10n
flutter run
```

## Common Issues & Solutions

### Issue: "flutter: command not found"
**Solution:** Flutter not in PATH. Add Flutter's bin folder to PATH and restart terminal.

### Issue: "Android SDK not found"
**Solution:** Install Android Studio and configure Android SDK.

### Issue: "No devices found"
**Solution:** 
- Connect Android device with USB debugging enabled
- OR start an Android emulator
- Run: `flutter devices` to verify

### Issue: "License not accepted"
**Solution:** Run `flutter doctor --android-licenses` and accept all.

### Issue: Build errors with Gradle
**Solution:**
```powershell
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

## Alternative: Use Existing Flutter Installation

If you have Flutter installed elsewhere, just navigate to the project and run:

```powershell
# Set the Flutter path for this session (adjust path)
$env:PATH = "C:\path\to\flutter\bin;" + $env:PATH

# Or add to profile permanently
# Add to: $PROFILE (PowerShell profile)
```

## Getting Help

### Check Installation Status
```powershell
flutter doctor -v
```

### Flutter Documentation
- Windows Install: https://docs.flutter.dev/get-started/install/windows
- Flutter Basics: https://docs.flutter.dev/get-started/codelab
- Android Setup: https://docs.flutter.dev/get-started/install/windows#android-setup

### Community Help
- Flutter Discord: https://discord.gg/flutter
- Stack Overflow: Tag [flutter]
- Reddit: r/FlutterDev

## Quick Reference

Once Flutter is set up:

| Task | Command |
|------|---------|
| Install dependencies | `flutter pub get` |
| Generate code | `flutter pub run build_runner build --delete-conflicting-outputs` |
| Generate i18n | `flutter gen-l10n` |
| Run app | `flutter run` |
| Build APK | `flutter build apk --release` |
| Check setup | `flutter doctor` |
| List devices | `flutter devices` |

## Next Steps

After installing Flutter:

1. ✅ Verify with `flutter doctor`
2. ✅ Navigate to MediMind project
3. ✅ Run `flutter pub get`
4. ✅ Run `flutter pub run build_runner build --delete-conflicting-outputs`
5. ✅ Run `flutter gen-l10n`
6. ✅ Connect device/emulator
7. ✅ Run `flutter run`

---

## Summary

**You need to install Flutter SDK first before running the MediMind app!**

1. Download Flutter: https://flutter.dev/docs/get-started/install/windows
2. Extract and add to PATH
3. Install Android Studio
4. Run `flutter doctor`
5. Come back to MediMind project and run setup commands

**The app is 100% ready to run once Flutter is installed!** 🚀

---

Need help? Check SETUP.md for detailed instructions or README.md for troubleshooting.
