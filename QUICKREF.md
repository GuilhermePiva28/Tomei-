# 🚀 MediMind - Quick Reference Card

## 📋 Essential Commands

### Setup (First Time)
```powershell
cd "c:\Users\guilh\Flutter\projeto_flutter\MediMind"
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter gen-l10n
flutter run
```

### Development
```powershell
flutter run                    # Run in debug mode
flutter run --release         # Run in release mode
r                             # Hot reload (in terminal)
R                             # Hot restart (in terminal)
q                             # Quit (in terminal)
```

### Building
```powershell
flutter build apk --release                              # Build release APK
flutter build apk --split-per-abi                       # Build split APKs
flutter build appbundle --release                        # Build App Bundle
```

### Code Generation
```powershell
flutter pub run build_runner build                       # Generate once
flutter pub run build_runner build --delete-conflicting-outputs  # Clean build
flutter pub run build_runner watch                       # Watch mode
flutter gen-l10n                                        # Generate localization
```

### Maintenance
```powershell
flutter clean                 # Clean build files
flutter pub get              # Install dependencies
flutter pub upgrade          # Upgrade dependencies
flutter doctor -v            # Check setup
flutter analyze              # Analyze code
flutter test                 # Run tests
```

## 📂 Project Structure

```
MediMind/
├── lib/
│   ├── l10n/                    # Translations (PT-BR, EN)
│   ├── models/                  # Medication, MedicationLog
│   ├── providers/               # State management
│   ├── screens/                 # UI screens
│   ├── services/                # Database, Notifications
│   └── main.dart               # Entry point
├── android/                     # Android config
├── assets/                      # Images, icons
├── test/                        # Unit tests
├── pubspec.yaml                # Dependencies
├── README.md                   # Main documentation
├── SETUP.md                    # Setup guide
├── NOTES.md                    # Dev notes
├── FEATURES.md                 # Feature checklist
└── setup.ps1                   # Setup script
```

## 🎯 Key Files to Edit

| Task | File(s) |
|------|---------|
| Add new screen | `lib/screens/` + navigation |
| Add translation | `lib/l10n/intl_*.arb` |
| Change theme | `lib/main.dart` |
| Add model field | `lib/models/*.dart` + run build_runner |
| Configure Android | `android/app/src/main/AndroidManifest.xml` |
| Change app name | `pubspec.yaml` + AndroidManifest |
| Add dependency | `pubspec.yaml` + `flutter pub get` |
| Configure ads | Calendar/Add screens + AndroidManifest |

## 🔧 Common Tasks

### Add New Medication Field
1. Edit `lib/models/medication.dart`
2. Add `@HiveField(nextNumber)`
3. Run: `flutter pub run build_runner build --delete-conflicting-outputs`
4. Update form in `add_medication_screen.dart`
5. Update displays in other screens

### Add New Language
1. Create `lib/l10n/intl_<code>.arb`
2. Add to `supportedLocales` in `lib/main.dart`
3. Run: `flutter gen-l10n`
4. Add option in settings screen

### Change App Theme
Edit in `lib/main.dart`:
```dart
seedColor: const Color(0xFFYOURCOLOR),
```

### Replace AdMob IDs
1. **AndroidManifest.xml**: `ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX`
2. **calendar_screen.dart**: Banner ad unit
3. **add_medication_screen.dart**: Interstitial ad unit

## 🐛 Quick Troubleshooting

| Problem | Solution |
|---------|----------|
| "Target of URI doesn't exist" | `flutter pub get` |
| Hive adapter not found | `flutter pub run build_runner build --delete-conflicting-outputs` |
| Localization error | `flutter gen-l10n` then `flutter clean` |
| Gradle build fails | `cd android && ./gradlew clean && cd .. && flutter clean` |
| Notifications not working | Check permissions, test on physical device |
| Hot reload fails | Press `R` for hot restart |

## 📱 Testing Checklist

### Before Each Run
- ✅ Device/emulator connected
- ✅ USB debugging enabled
- ✅ Run `flutter devices` to verify

### First Run on Device
- ✅ Grant notification permission
- ✅ Grant exact alarm permission (Android 12+)
- ✅ Grant storage permission
- ✅ Disable battery optimization (Settings > Battery)

### Feature Testing
- ✅ Create medication
- ✅ Set time 2 minutes ahead
- ✅ Wait for notification
- ✅ Check notification actions work
- ✅ Verify calendar updates
- ✅ Test theme toggle
- ✅ Test language switch

## 🎨 Customization Quick Guide

### App Name
```yaml
# pubspec.yaml
name: your_app_name
```
```xml
<!-- AndroidManifest.xml -->
android:label="Your App Name"
```

### Theme Color
```dart
// lib/main.dart
seedColor: const Color(0xFF4CAF50), // Change this
```

### App Icon
1. Place 512x512 PNG in `assets/icons/app_icon.png`
2. Run: `flutter pub run flutter_launcher_icons`

### Notification Sound
Add file to: `android/app/src/main/res/raw/notification.mp3`

## 📊 File Locations

| Item | Location |
|------|----------|
| Release APK | `build/app/outputs/flutter-apk/app-release.apk` |
| App Bundle | `build/app/outputs/bundle/release/app-release.aab` |
| Backup files | Device: `/storage/emulated/0/Android/data/com.medimind.app/files/` |
| Hive database | App data directory (managed by Hive) |
| Shared prefs | App data directory (managed by Android) |

## 🔑 Important Permissions

```xml
<!-- AndroidManifest.xml -->
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
```

## 🌐 Localization Keys

### Most Used Keys
```dart
l10n.myCalendar
l10n.myMedications
l10n.addMedication
l10n.medicationName
l10n.dosageValue
l10n.save
l10n.cancel
l10n.taken
l10n.skip
l10n.settings
```

## 📦 Dependencies Overview

| Package | Purpose |
|---------|---------|
| provider | State management |
| hive/hive_flutter | Local database |
| flutter_local_notifications | Notifications |
| table_calendar | Calendar widget |
| google_mobile_ads | Ads |
| google_fonts | Fonts |
| shared_preferences | Settings storage |
| intl | Internationalization |

## 🚀 Deployment Checklist

### Pre-Release
- [ ] Replace AdMob test IDs
- [ ] Update version in pubspec.yaml
- [ ] Run `flutter analyze` (no errors)
- [ ] Run `flutter test` (all pass)
- [ ] Test on physical device
- [ ] Test all features
- [ ] Generate signed release build

### Build Commands
```powershell
# Release APK
flutter build apk --release

# Release Bundle (for Play Store)
flutter build appbundle --release

# With obfuscation
flutter build apk --release --obfuscate --split-debug-info=./debug-info
```

## 📞 Help & Resources

### Documentation
- **README.md** - Overview and features
- **SETUP.md** - Detailed setup instructions
- **NOTES.md** - Developer notes
- **FEATURES.md** - Feature checklist

### External Links
- Flutter Docs: https://flutter.dev/docs
- Hive Docs: https://docs.hivedb.dev
- Provider Docs: https://pub.dev/packages/provider
- Notifications: https://pub.dev/packages/flutter_local_notifications

### Commands Help
```powershell
flutter --help
flutter run --help
flutter build --help
flutter doctor --help
```

## 💡 Pro Tips

1. **Use Hot Reload** - Press `r` instead of restarting
2. **VS Code Extensions** - Flutter, Dart, Flutter Intl
3. **DevTools** - Run `flutter pub global activate devtools`
4. **Analyze Often** - Run `flutter analyze` regularly
5. **Test on Device** - Emulators don't handle notifications well
6. **Battery Optimization** - Disable for reliable notifications
7. **Version Control** - Commit often with clear messages
8. **Backup Database** - Test export/import regularly

## 🎯 Quick Start Script

Run this PowerShell script for automatic setup:
```powershell
.\setup.ps1
```

This will:
- Check Flutter installation
- Install dependencies
- Generate Hive adapters
- Generate localizations
- Check for connected devices

---

**💊 MediMind - Your Offline Medication Reminder** 

**Need more help?** Check the full documentation files! 📚
