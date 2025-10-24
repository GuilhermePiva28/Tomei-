# 🚀 MediMind - Setup Instructions

## Step-by-Step Setup Guide

### 1. Prerequisites Check ✅

Before starting, ensure you have:
- **Flutter SDK** (3.0.0+): Run `flutter --version` to check
- **Android Studio** or **VS Code** with Flutter extensions
- **Android SDK** (API 26-34)
- **Git** (optional, for version control)

### 2. Initial Setup 📦

```powershell
# Navigate to project directory
cd "c:\Users\guilh\Flutter\projeto_flutter\MediMind"

# Get all dependencies
flutter pub get

# Verify Flutter installation
flutter doctor -v
```

### 3. Generate Required Files 🔧

```powershell
# Generate Hive type adapters
flutter pub run build_runner build --delete-conflicting-outputs

# Generate localization files
flutter gen-l10n
```

**Expected output:**
- `lib/models/medication.g.dart`
- `lib/models/medication_log.g.dart`
- `.dart_tool/flutter_gen/gen_l10n/app_localizations.dart`

### 4. Configure Android 🤖

The Android configuration is already set up, but verify:

**AndroidManifest.xml** should include:
- ✅ Notification permissions
- ✅ Exact alarm permissions
- ✅ Boot receiver
- ✅ AdMob app ID

**build.gradle** should have:
- ✅ minSdk: 26
- ✅ targetSdk: 34
- ✅ compileSdk: 34
- ✅ MultiDex enabled

### 5. Connect Device/Emulator 📱

**Option A: Physical Device**
```powershell
# Enable USB debugging on your Android device
# Connect via USB
# Check if device is recognized
flutter devices
```

**Option B: Android Emulator**
```powershell
# List available emulators
flutter emulators

# Launch an emulator
flutter emulators --launch <emulator_id>
```

### 6. Run the App ▶️

```powershell
# Run in debug mode
flutter run

# Run in release mode
flutter run --release

# Run with verbose logging
flutter run -v
```

### 7. First Run Checklist 📋

When the app launches for the first time:

1. ✅ Grant **Notification Permission**
2. ✅ Grant **Exact Alarm Permission** (Android 12+)
3. ✅ Grant **Storage Permission** (for backup/restore)
4. ✅ Disable **Battery Optimization** for the app (recommended)

### 8. Testing Features 🧪

**Test Medication Creation:**
1. Tap the **+** button
2. Fill in medication details:
   - Name: "Test Medicine"
   - Dosage: 500mg
   - Time: Current time + 2 minutes
   - Interval: Daily
   - Enable notifications ✓
3. Save and wait for notification

**Test Calendar:**
1. View calendar on main screen
2. Tap today's date
3. Verify scheduled medication appears
4. Mark as "Taken" or "Skip"
5. Check calendar dot color changes

**Test Settings:**
1. Open hamburger menu → Settings
2. Toggle Light/Dark mode
3. Switch language (PT-BR ↔ EN)
4. Toggle sound/vibration
5. Test backup export

### 9. Build Release APK 📦

```powershell
# Build release APK
flutter build apk --release

# Build split APKs (smaller size)
flutter build apk --split-per-abi

# Build App Bundle (for Google Play)
flutter build appbundle --release
```

**Output locations:**
- APK: `build\app\outputs\flutter-apk\app-release.apk`
- AAB: `build\app\outputs\bundle\release\app-release.aab`

### 10. Common Issues & Solutions 🔧

#### Issue: "Target of URI doesn't exist" errors

**Solution:**
```powershell
flutter pub get
flutter clean
flutter pub get
```

#### Issue: Hive adapter not found

**Solution:**
```powershell
flutter pub run build_runner build --delete-conflicting-outputs
```

#### Issue: Localization files not generated

**Solution:**
```powershell
flutter gen-l10n
flutter clean
flutter run
```

#### Issue: Gradle build failure

**Solution:**
```powershell
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

#### Issue: Notifications not working

**Solutions:**
1. Check notification permission granted
2. Check exact alarm permission (Android 13+)
3. Disable battery optimization
4. Test on physical device (not emulator)
5. Check Android version >= 8.0 (API 26)

### 11. Development Tips 💡

**Hot Reload:**
```powershell
# After making changes, press:
r    # Hot reload
R    # Hot restart
q    # Quit
```

**View Logs:**
```powershell
flutter logs

# Or in VS Code: Debug Console tab
# Or in Android Studio: Logcat tab
```

**Run Tests:**
```powershell
flutter test
flutter test test/medication_test.dart
```

**Format Code:**
```powershell
flutter format .
```

**Analyze Code:**
```powershell
flutter analyze
```

### 12. AdMob Configuration 💰

**For Testing (Already configured):**
- Uses Google test ad units
- No setup needed

**For Production:**
1. Create AdMob account: https://admob.google.com
2. Register your app
3. Create ad units (Banner + Interstitial)
4. Replace test IDs:

**In `android/app/src/main/AndroidManifest.xml`:**
```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="YOUR-ADMOB-APP-ID"/>
```

**In `lib/screens/calendar_screen.dart`:**
```dart
adUnitId: 'YOUR-BANNER-AD-UNIT-ID',
```

**In `lib/screens/add_medication_screen.dart`:**
```dart
adUnitId: 'YOUR-INTERSTITIAL-AD-UNIT-ID',
```

### 13. Customization Options 🎨

**Change App Name:**
- Edit `pubspec.yaml`: `name: your_app_name`
- Edit `AndroidManifest.xml`: `android:label="Your App Name"`

**Change App Icon:**
1. Place icon in `assets/icons/app_icon.png` (512x512)
2. Run: `flutter pub run flutter_launcher_icons`

**Change Theme Color:**
- Edit `lib/main.dart`:
```dart
seedColor: const Color(0xFFYOURCOLOR),
```

**Add New Language:**
1. Create `lib/l10n/intl_<lang>.arb`
2. Add to `supportedLocales` in `main.dart`
3. Run `flutter gen-l10n`

### 14. Database Management 🗄️

**View Database (Debug):**
```dart
// In your code:
print(DatabaseService.getAllMedications());
print(DatabaseService.getAllLogs());
```

**Clear Database (Testing):**
```powershell
# On device/emulator:
adb shell pm clear com.medimind.app
```

**Backup Location:**
- Path: `/storage/emulated/0/Android/data/com.medimind.app/files/`
- File: `medimind_backup_<timestamp>.json`

### 15. Performance Optimization ⚡

**Enable release optimizations:**
```powershell
flutter build apk --release --obfuscate --split-debug-info=./debug-info
```

**Reduce APK size:**
```powershell
flutter build apk --split-per-abi --target-platform android-arm64
```

**Profile performance:**
```powershell
flutter run --profile
# Then use DevTools for analysis
```

### 16. Publishing Checklist ✅

Before publishing to Google Play:

- [ ] Replace AdMob test IDs with production IDs
- [ ] Update version in `pubspec.yaml`
- [ ] Create app icon (512x512)
- [ ] Create feature graphic (1024x500)
- [ ] Write app description (PT-BR and EN)
- [ ] Take screenshots (phone and tablet)
- [ ] Test on multiple devices
- [ ] Test all permissions
- [ ] Test notifications thoroughly
- [ ] Test backup/restore
- [ ] Generate signed release build
- [ ] Test release build on device
- [ ] Prepare privacy policy
- [ ] Complete Google Play listing

### 17. Useful Commands Reference 📝

```powershell
# Dependencies
flutter pub get              # Install dependencies
flutter pub upgrade          # Upgrade dependencies
flutter pub outdated         # Check outdated packages

# Building
flutter build apk           # Build debug APK
flutter build apk --release # Build release APK
flutter build appbundle     # Build App Bundle

# Code Generation
flutter pub run build_runner build              # Generate once
flutter pub run build_runner watch              # Watch for changes
flutter pub run build_runner build --delete-conflicting-outputs  # Clean build

# Cleaning
flutter clean               # Clean build files
flutter pub cache repair    # Repair pub cache

# Device Management
flutter devices             # List devices
flutter emulators           # List emulators
adb devices                 # List connected devices
adb logcat                  # View device logs

# Analysis
flutter analyze             # Analyze code
flutter test                # Run tests
flutter doctor              # Check setup
```

### 18. Support & Resources 📚

**Official Documentation:**
- Flutter: https://flutter.dev/docs
- Provider: https://pub.dev/packages/provider
- Hive: https://docs.hivedb.dev
- Local Notifications: https://pub.dev/packages/flutter_local_notifications

**Community:**
- Flutter Discord: https://discord.gg/flutter
- Stack Overflow: [flutter] tag
- Reddit: r/FlutterDev

**Troubleshooting:**
- Check logs: `flutter logs`
- Check permissions: Settings → Apps → MediMind → Permissions
- Check battery: Settings → Battery → Battery Optimization → MediMind → Don't optimize

---

## Quick Start Summary 🚀

```powershell
# 1. Install dependencies
flutter pub get

# 2. Generate code
flutter pub run build_runner build --delete-conflicting-outputs
flutter gen-l10n

# 3. Run app
flutter run

# 4. Build release
flutter build apk --release
```

**That's it! Your MediMind app is ready to go! 💊✨**

Need help? Check the README.md or create an issue!
