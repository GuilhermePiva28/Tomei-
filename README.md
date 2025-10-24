# MediMind 💊

**MediMind** is a complete medication reminder app built with Flutter. It helps users remember to take their medications with offline reminders, stores all data locally, and works without any backend or internet connection.

## 🌟 Features

### Core Features
- ✅ **Medication Registration** - Add medications with detailed information
- 🔔 **Offline Notifications & Alarms** - Background notifications that work even when the app is closed
- 📅 **Interactive Calendar** - Visual calendar showing medication status with translated month names
- 🎨 **Custom Colors** - Assign unique colors to each medication for easy identification
- ⏰ **Multiple Daily Doses** - Configure up to 5 doses per day with individual times
- 🗂️ **Medication Management** - Edit and delete medications easily
- 🌐 **Multi-language Support** - Portuguese (Brazil) default, with English option
- � **Light/Dark Mode** - Theme toggle with immersive full-screen mode (hidden Android navigation bar)
- 💾 **Local Storage** - All data stored locally using Hive database
- 📊 **Adherence Statistics** - Track weekly medication adherence
- 📤 **Backup & Restore** - Export and import your medication data
- 🔍 **Date Filtering** - View only medications scheduled for selected calendar dates
- 💰 **AdMob Integration** - Banner and interstitial ads

### Medication Details
Each medication includes:
- Name
- Dosage value and unit (mcg, mg, g, ml, IU, tablet(s), capsule(s))
- **Custom color picker** with 12 predefined colors
- **Multiple dose times** for daily medications
- First dose time for other intervals
- Notification toggle
- Interval types:
  - **Daily** - 1 to 5 times per day with custom schedules
  - **Every X Days** - Custom day intervals (up to 1 year)
  - **Weekly** - Select specific weekdays (up to 52 weeks)
  - **Monthly** - Select day of month (up to 12 months)
  - **Custom** - Custom hour intervals
- Optional notes field

### Calendar View
- 🟢 **Green dots** - Medication taken
- 🔴 **Red dots** - Medication skipped
- 🔵 **Blue dots** - Medication scheduled
- **Tap any date** to see only medications scheduled for that specific day
- Month-only view with localized month names
- Color-coded medication indicators
- Quick action buttons (Taken/Skip) for pending doses

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Android Studio or VS Code
- Android device or emulator (API 26+)

### Installation

1. **Clone or download this project**

2. **Install dependencies**
```bash
flutter pub get
```

3. **Generate Hive adapters**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **Generate localization files**
```bash
flutter gen-l10n
```

5. **Run the app**
```bash
flutter run
```

## 📱 Building for Release

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

The built files will be in:
- APK: `build/app/outputs/flutter-apk/app-release.apk`
- AAB: `build/app/outputs/bundle/release/app-release.aab`

## 🏗️ Project Structure

```
lib/
├── l10n/                      # Localization files
│   ├── intl_en.arb           # English translations
│   └── intl_pt.arb           # Portuguese translations
├── models/                    # Data models
│   ├── medication.dart       # Medication model
│   └── medication_log.dart   # Log model
├── providers/                 # State management
│   ├── medication_provider.dart
│   ├── theme_provider.dart
│   └── language_provider.dart
├── screens/                   # UI screens
│   ├── calendar_screen.dart
│   ├── medication_list_screen.dart
│   ├── add_medication_screen.dart
│   ├── settings_screen.dart
│   └── about_screen.dart
├── services/                  # Business logic
│   ├── database_service.dart
│   └── notification_service.dart
└── main.dart                  # App entry point
```

## 🔧 Configuration

### AdMob Setup
Replace test ad unit IDs in:
- `calendar_screen.dart` - Banner ad
- `add_medication_screen.dart` - Interstitial ad
- `AndroidManifest.xml` - App ID

### Notification Customization
Edit notification settings in `notification_service.dart`:
- Sound
- Vibration
- Priority
- Channel settings

## 📦 Dependencies

### Core
- `flutter` & `flutter_localizations` - Framework
- `provider` - State management
- `hive` & `hive_flutter` - Local database
- `shared_preferences` - Simple storage

### Features
- `flutter_local_notifications` - Notifications
- `timezone` - Timezone handling
- `table_calendar` - Calendar widget
- `google_mobile_ads` - Ad integration

### UI
- `google_fonts` - Custom fonts
- `intl` - Internationalization

### Utils
- `uuid` - Unique ID generation
- `path_provider` - File paths
- `permission_handler` - Permissions

## 🌐 Localization

### Supported Languages
- 🇧🇷 Portuguese (Brazil) - Default
- 🇺🇸 English

### Adding New Languages
1. Create `lib/l10n/intl_<language>.arb`
2. Add locale to `supportedLocales` in `main.dart`
3. Run `flutter gen-l10n`

## ⚙️ Android Configuration

### Minimum Requirements
- **minSdk**: 26 (Android 8.0)
- **targetSdk**: 34 (Android 14)
- **compileSdk**: 34

### Permissions
- `POST_NOTIFICATIONS` - Show notifications
- `SCHEDULE_EXACT_ALARM` - Schedule exact alarms
- `USE_EXACT_ALARM` - Use exact alarms (Android 13+)
- `VIBRATE` - Vibration
- `RECEIVE_BOOT_COMPLETED` - Restart notifications after reboot
- `WAKE_LOCK` - Wake device for notifications
- `WRITE_EXTERNAL_STORAGE` - Backup data
- `READ_EXTERNAL_STORAGE` - Import data

## 🎯 Usage

### Adding a Medication
1. Tap the **+** button
2. Fill in medication details
3. Select interval type
4. Configure interval settings
5. Tap **Save**

### Viewing Calendar
1. Main screen shows calendar
2. Colored dots indicate status
3. Tap any date to see details
4. Mark medications as taken/skipped

### Managing Medications
1. Open hamburger menu
2. Select "My Medications"
3. Tap ⋮ menu on any medication
4. Choose Edit or Delete

### Backup & Restore
1. Open Settings
2. Tap "Backup Data" to export
3. File saved to external storage
4. Tap "Import Data" to restore

## 🔔 Notification Features

- **Background Operation** - Works when app is closed
- **Action Buttons** - "Taken" and "Skip" in notification
- **Persistent** - Stays until confirmed
- **Sound & Vibration** - Customizable
- **Boot Restart** - Automatically restores after device restart

## 🎨 Customization

### Theme Colors
Edit in `main.dart`:
```dart
seedColor: const Color(0xFF4CAF50), // Change this
```

### Notification Sound
Add custom sound to `android/app/src/main/res/raw/notification.mp3`

## 🐛 Troubleshooting

### Notifications Not Working
1. Check app has notification permission
2. Verify exact alarm permission (Android 13+)
3. Disable battery optimization for the app
4. Check notification sound/vibration settings

### Build Errors
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter gen-l10n
flutter run
```

### Database Issues
```bash
# Clear app data on device/emulator
adb shell pm clear com.medimind.app
```

## 📄 License

MIT License - Feel free to use this project for learning or commercial purposes.

## 👨‍💻 Developer

**MediMind Team**

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

## 📞 Support

For questions or issues, please create an issue in the repository.

## 🎓 Learning Resources

This app demonstrates:
- Flutter state management with Provider
- Local database with Hive
- Background notifications
- Internationalization (i18n)
- Material 3 design
- AdMob integration
- Clean architecture

## ⚠️ Important Notes

1. **First Run**: Grant all requested permissions for full functionality
2. **Battery Optimization**: Disable for reliable notifications
3. **Ad IDs**: Replace test ad units before publishing
4. **Backup**: Regular backups recommended
5. **Testing**: Test thoroughly on physical devices, not just emulators

## 🚀 Roadmap

Potential future features:
- [ ] Home screen widget
- [ ] PIN lock for privacy
- [ ] Medication images
- [ ] Refill reminders
- [ ] Doctor appointments
- [ ] Medication interactions
- [ ] Cloud backup (optional)
- [ ] Family sharing
- [ ] iOS support

## ✨ Recent Updates (v1.0.0)

### New Features
- 🎨 **Color Picker** - Choose from 12 colors to identify medications visually
- ⏰ **Multiple Daily Times** - Set up to 5 different times for daily medications
- 🌍 **Localized Calendar** - Month names now display in selected language
- 📱 **Immersive Mode** - Hidden Android navigation bar for full-screen experience
- 🔍 **Smart Filtering** - Calendar date selection shows only relevant medications
- 📅 **Extended Scheduling** - Schedule medications for up to 1 year in advance

### Improvements
- Reorganized medication form with time selection after frequency configuration
- Removed duplicate notification subtitle
- Enhanced medication list with color indicators
- Improved calendar medication cards with color-coded circles
- Better visual hierarchy in medication details

---

**Happy Coding! 💊📱**
