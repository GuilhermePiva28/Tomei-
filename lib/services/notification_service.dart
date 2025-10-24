import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/medication.dart';
import '../models/medication_log.dart';
import 'database_service.dart';
import 'package:uuid/uuid.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  
  static const String _soundEnabledKey = 'notification_sound_enabled';
  static const String _vibrationEnabledKey = 'notification_vibration_enabled';

  static Future<void> initialize() async {
    tz.initializeTimeZones();
    
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions for Android 13+
    await _requestPermissions();
  }

  static Future<void> _requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
      await androidImplementation.requestExactAlarmsPermission();
    }
  }

  static Future<void> _onNotificationTapped(
      NotificationResponse response) async {
    if (response.actionId == 'taken') {
      await _handleTaken(response.payload ?? '');
    } else if (response.actionId == 'skip') {
      await _handleSkipped(response.payload ?? '');
    }
  }

  static Future<void> _handleTaken(String logId) async {
    final log = DatabaseService.logsBoxInstance.get(logId);
    if (log != null) {
      log.status = 'taken';
      log.takenTime = DateTime.now();
      await DatabaseService.updateLog(log);
    }
  }

  static Future<void> _handleSkipped(String logId) async {
    final log = DatabaseService.logsBoxInstance.get(logId);
    if (log != null) {
      log.status = 'skipped';
      await DatabaseService.updateLog(log);
    }
  }

  static Future<bool> isSoundEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_soundEnabledKey) ?? true;
  }

  static Future<void> setSoundEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundEnabledKey, enabled);
  }

  static Future<bool> isVibrationEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_vibrationEnabledKey) ?? true;
  }

  static Future<void> setVibrationEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_vibrationEnabledKey, enabled);
  }

  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    required String payload,
    required String takenText,
    required String skipText,
  }) async {
    final soundEnabled = await isSoundEnabled();
    final vibrationEnabled = await isVibrationEnabled();

    final androidDetails = AndroidNotificationDetails(
      'medication_reminders',
      'Medication Reminders',
      channelDescription: 'Notifications for medication reminders',
      importance: Importance.max,
      priority: Priority.high,
      playSound: soundEnabled,
      enableVibration: vibrationEnabled,
      actions: [
        AndroidNotificationAction('taken', takenText),
        AndroidNotificationAction('skip', skipText),
      ],
      ongoing: false,
      autoCancel: false,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
    );

    final details = NotificationDetails(android: androidDetails);

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
  }

  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  static Future<void> scheduleMedicationNotifications(Medication medication) async {
    // Cancel existing notifications for this medication
    await cancelMedicationNotifications(medication.id);

    if (!medication.notificationsEnabled) return;

    final now = DateTime.now();
    final List<DateTime> scheduledTimes = [];

    // Calculate scheduled times based on interval type
    switch (medication.intervalType) {
      case 'daily':
        scheduledTimes.addAll(_calculateDailyTimes(medication, now));
        break;
      case 'everyXDays':
        scheduledTimes.addAll(_calculateEveryXDaysTimes(medication, now));
        break;
      case 'weekly':
        scheduledTimes.addAll(_calculateWeeklyTimes(medication, now));
        break;
      case 'monthly':
        scheduledTimes.addAll(_calculateMonthlyTimes(medication, now));
        break;
      case 'custom':
        scheduledTimes.addAll(_calculateCustomTimes(medication, now));
        break;
    }

    // Schedule notifications and create logs
    final uuid = const Uuid();
    for (var scheduledTime in scheduledTimes) {
      if (scheduledTime.isAfter(now)) {
        final logId = uuid.v4();
        final log = MedicationLog(
          id: logId,
          medicationId: medication.id,
          scheduledTime: scheduledTime,
          status: 'scheduled',
        );
        await DatabaseService.addLog(log);

        // Schedule notification
        await scheduleNotification(
          id: logId.hashCode,
          title: 'Medication Reminder', // Will be localized in UI
          body: 'Time to take ${medication.name} — ${medication.dosageValue}${medication.dosageUnit}',
          scheduledTime: scheduledTime,
          payload: logId,
          takenText: 'Taken',
          skipText: 'Skip',
        );
      }
    }
  }

  static List<DateTime> _calculateDailyTimes(Medication medication, DateTime now) {
    final times = <DateTime>[];
    
    // Use doseSchedule if available, otherwise use the old logic
    if (medication.doseSchedule != null && medication.doseSchedule!.isNotEmpty) {
      for (int day = 0; day < 365; day++) { // Schedule 1 year ahead
        for (String time in medication.doseSchedule!) {
          final timeParts = time.split(':');
          final hour = int.parse(timeParts[0]);
          final minute = int.parse(timeParts[1]);
          
          final scheduledTime = DateTime(
            now.year,
            now.month,
            now.day + day,
            hour,
            minute,
          );
          times.add(scheduledTime);
        }
      }
    } else {
      // Fallback to old logic
      final timeParts = medication.firstDoseTime.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      final timesPerDay = medication.timesPerDay ?? 1;
      final intervalHours = 24 / timesPerDay;

      for (int day = 0; day < 365; day++) { // Schedule 1 year ahead
        for (int i = 0; i < timesPerDay; i++) {
          final scheduledTime = DateTime(
            now.year,
            now.month,
            now.day + day,
            hour + (intervalHours * i).floor(),
            minute,
          );
          times.add(scheduledTime);
        }
      }
    }

    return times;
  }

  static List<DateTime> _calculateEveryXDaysTimes(Medication medication, DateTime now) {
    final times = <DateTime>[];
    final timeParts = medication.firstDoseTime.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    
    final intervalDays = medication.intervalDays ?? 1;
    final startDate = medication.startDate ?? now;

    for (int i = 0; i < 365; i += intervalDays) { // Schedule 1 year ahead
      final scheduledTime = DateTime(
        startDate.year,
        startDate.month,
        startDate.day + i,
        hour,
        minute,
      );
      times.add(scheduledTime);
    }

    return times;
  }

  static List<DateTime> _calculateWeeklyTimes(Medication medication, DateTime now) {
    final times = <DateTime>[];
    final timeParts = medication.firstDoseTime.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    
    final weekdays = medication.weekdays ?? [];

    for (int week = 0; week < 52; week++) { // Schedule 1 year ahead
      for (int weekday in weekdays) {
        final daysUntilWeekday = (weekday - now.weekday + 7) % 7;
        final scheduledTime = DateTime(
          now.year,
          now.month,
          now.day + daysUntilWeekday + (week * 7),
          hour,
          minute,
        );
        times.add(scheduledTime);
      }
    }

    return times;
  }

  static List<DateTime> _calculateMonthlyTimes(Medication medication, DateTime now) {
    final times = <DateTime>[];
    final timeParts = medication.firstDoseTime.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    
    final dayOfMonth = medication.dayOfMonth ?? 1;

    for (int month = 0; month < 12; month++) { // Schedule 1 year ahead
      final scheduledTime = DateTime(
        now.year,
        now.month + month,
        dayOfMonth,
        hour,
        minute,
      );
      times.add(scheduledTime);
    }

    return times;
  }

  static List<DateTime> _calculateCustomTimes(Medication medication, DateTime now) {
    final times = <DateTime>[];
    final timeParts = medication.firstDoseTime.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    
    final customHours = medication.customIntervalHours ?? 24;
    
    var currentTime = DateTime(now.year, now.month, now.day, hour, minute);
    
    for (int i = 0; i < 100; i++) { // Schedule 100 instances
      times.add(currentTime);
      currentTime = currentTime.add(Duration(hours: customHours));
    }

    return times;
  }

  static Future<void> cancelMedicationNotifications(String medicationId) async {
    final logs = DatabaseService.getLogsByMedicationId(medicationId);
    for (var log in logs) {
      if (log.status == 'scheduled') {
        await cancelNotification(log.id.hashCode);
        await DatabaseService.deleteLog(log.id);
      }
    }
  }
}
