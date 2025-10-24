# 📝 MediMind - Development Notes

## Project Overview

**MediMind** is a medication reminder app that works completely offline. All data is stored locally using Hive database, and notifications work in the background using flutter_local_notifications.

## Architecture

### State Management
- **Provider pattern** for state management
- Three main providers:
  - `MedicationProvider` - Handles medication and log data
  - `ThemeProvider` - Manages light/dark theme
  - `LanguageProvider` - Handles language switching

### Data Layer
- **Hive** for local NoSQL database
- Two main boxes:
  - `medications` - Stores Medication objects
  - `medication_logs` - Stores MedicationLog objects
- Type adapters generated with `build_runner`

### Service Layer
- `DatabaseService` - CRUD operations for Hive
- `NotificationService` - Handles all notification scheduling

### UI Layer
- Material 3 design
- Responsive layouts
- Google Fonts (Roboto)
- Table Calendar for calendar view

## Key Features Implementation

### 1. Medication Scheduling

Different interval types calculate scheduled times differently:

- **Daily**: Calculates multiple times per day based on interval
- **Every X Days**: Uses start date + interval
- **Weekly**: Schedules on specific weekdays
- **Monthly**: Schedules on specific day of month
- **Custom**: Uses custom hour intervals

### 2. Background Notifications

- Uses `AndroidScheduleMode.exactAllowWhileIdle` for exact timing
- Persists after device reboot via `RECEIVE_BOOT_COMPLETED`
- Action buttons in notifications for quick "Taken"/"Skip"
- Notifications trigger even when app is closed

### 3. Calendar Integration

- `TableCalendar` widget for calendar display
- Colored dots indicate status:
  - Green = Taken
  - Red = Skipped
  - Blue = Scheduled
- Logs stored per date for history tracking

### 4. Localization

- Two languages: Portuguese (BR) and English (US)
- ARB files for translations
- `flutter_localizations` for date/time formatting
- Language preference stored in SharedPreferences

### 5. AdMob Integration

- Banner ads on main screen (bottom)
- Interstitial ads after saving medication
- Test ad units configured by default
- Must be replaced for production

## Code Organization

```
lib/
├── l10n/                  # Localization ARB files
├── models/                # Data models with Hive annotations
├── providers/             # State management providers
├── screens/               # UI screens
├── services/              # Business logic services
└── main.dart             # App entry point
```

## Important Notes

### Permissions
- Notification permission required (Android 13+)
- Exact alarm permission required (Android 12+)
- Storage permission for backup/restore
- Must request at runtime

### Performance
- Hive is very fast for local storage
- Notifications scheduled in batches (30 days for daily, etc.)
- Provider pattern prevents unnecessary rebuilds

### Testing
- Test on physical device for notifications
- Emulators may not handle notifications correctly
- Test with battery optimization disabled

### Limitations
- Maximum 100 custom interval instances scheduled at once
- Notifications may not fire if device is in deep sleep
- Backup/import requires storage permission

## Future Improvements

Potential enhancements:
1. **Home Screen Widget** - Show next medication on home screen
2. **PIN Lock** - Privacy feature for sensitive data
3. **Medication Images** - Take/attach photos of medications
4. **Doctor Notes** - Store doctor information and prescriptions
5. **Refill Reminders** - Alert when running low on medication
6. **Interaction Checker** - Warn about drug interactions
7. **Cloud Backup** - Optional cloud sync (Firebase/Supabase)
8. **Family Mode** - Manage medications for family members
9. **Statistics Dashboard** - More detailed adherence analytics
10. **Voice Reminders** - Text-to-speech for medication names

## Debugging Tips

### View Database Contents
```dart
print(Hive.box<Medication>('medications').values);
print(Hive.box<MedicationLog>('medication_logs').values);
```

### Test Notifications
Set medication time to 1-2 minutes in future, then wait and check.

### Check Notification Permissions
```dart
final status = await Permission.notification.status;
print('Notification permission: $status');
```

### View Scheduled Notifications
```dart
final pending = await flutterLocalNotificationsPlugin.pendingNotificationRequests();
print('Pending notifications: ${pending.length}');
```

## Common Patterns

### Adding a New Screen
1. Create file in `lib/screens/`
2. Import necessary providers
3. Add navigation in hamburger menu or button
4. Add localization strings to ARB files

### Adding a New Field to Medication
1. Update `Medication` model
2. Increment `@HiveField` number
3. Run `build_runner build`
4. Update form in `add_medication_screen.dart`
5. Update display in list/calendar screens

### Adding a New Language
1. Create `lib/l10n/intl_<code>.arb`
2. Add locale to `supportedLocales` in `main.dart`
3. Run `flutter gen-l10n`
4. Add language option in settings

## Known Issues

1. **Notifications may delay on some devices** - Due to battery optimization
2. **Calendar may show wrong month on first load** - Need to call setState
3. **Interstitial ad may not show every time** - Expected AdMob behavior
4. **Import feature incomplete** - Needs file_picker implementation

## Dependencies Explained

| Package | Purpose |
|---------|---------|
| provider | State management |
| hive, hive_flutter | Local NoSQL database |
| flutter_local_notifications | Background notifications |
| timezone | Timezone support for notifications |
| table_calendar | Calendar UI widget |
| google_fonts | Custom fonts (Roboto) |
| google_mobile_ads | AdMob integration |
| shared_preferences | Simple key-value storage |
| uuid | Generate unique IDs |
| path_provider | Get file system paths |
| permission_handler | Handle runtime permissions |
| intl | Internationalization |

## Build Variants

### Debug Build
```bash
flutter run
```
- Hot reload enabled
- Debug banner shown
- Slower performance
- Larger APK size

### Profile Build
```bash
flutter run --profile
```
- Performance profiling enabled
- Good for testing performance
- No debug banner

### Release Build
```bash
flutter build apk --release
```
- Optimized code
- Smaller APK size
- No debug features
- Ready for distribution

## Version Control

### Git Workflow
```bash
git init
git add .
git commit -m "Initial commit: MediMind medication reminder app"
git branch -M main
git remote add origin <your-repo-url>
git push -u origin main
```

### .gitignore
Already configured to exclude:
- Generated files (*.g.dart)
- Build artifacts
- IDE files
- Sensitive files (keys, credentials)

## Publishing Checklist

Before publishing to Google Play Store:

**Code:**
- [ ] Replace test AdMob IDs with production IDs
- [ ] Remove all debug prints
- [ ] Update version in pubspec.yaml
- [ ] Test on multiple devices/Android versions
- [ ] Test all features thoroughly
- [ ] Run `flutter analyze` (no errors)
- [ ] Run `flutter test` (all pass)

**Assets:**
- [ ] Create app icon (512x512 PNG)
- [ ] Create feature graphic (1024x500 PNG)
- [ ] Take screenshots (phone and tablet)
- [ ] Create promotional video (optional)

**Legal:**
- [ ] Write privacy policy
- [ ] Create terms of service
- [ ] Prepare app description (PT-BR and EN)
- [ ] List all permissions used

**Store Listing:**
- [ ] Choose appropriate category (Medical)
- [ ] Set content rating (Everyone)
- [ ] Add keywords for SEO
- [ ] Set pricing (free/paid)
- [ ] Configure in-app purchases if any

**Build:**
- [ ] Generate signed release build
- [ ] Test signed build on device
- [ ] Verify APK size reasonable
- [ ] Check for crashes with Crashlytics

## Support Contacts

For development questions or issues:
- Create GitHub issue
- Check Flutter documentation
- Ask on Flutter Discord
- Check Stack Overflow

## License

MIT License - See LICENSE file for details

---

**Last Updated:** October 24, 2025
**Version:** 1.0.0
**Developed by:** MediMind Team
