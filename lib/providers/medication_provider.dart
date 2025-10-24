import 'package:flutter/material.dart';
import '../models/medication.dart';
import '../models/medication_log.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';

class MedicationProvider extends ChangeNotifier {
  List<Medication> _medications = [];
  List<MedicationLog> _logs = [];

  List<Medication> get medications => _medications;
  List<MedicationLog> get logs => _logs;

  Future<void> loadMedications() async {
    _medications = DatabaseService.getAllMedications();
    notifyListeners();
  }

  Future<void> loadLogs() async {
    _logs = DatabaseService.getAllLogs();
    notifyListeners();
  }

  Future<void> addMedication(Medication medication) async {
    await DatabaseService.addMedication(medication);
    await NotificationService.scheduleMedicationNotifications(medication);
    await loadMedications();
  }

  Future<void> updateMedication(Medication medication) async {
    await DatabaseService.updateMedication(medication);
    await NotificationService.scheduleMedicationNotifications(medication);
    await loadMedications();
  }

  Future<void> deleteMedication(String id) async {
    await NotificationService.cancelMedicationNotifications(id);
    await DatabaseService.deleteMedication(id);
    await loadMedications();
    await loadLogs();
  }

  List<MedicationLog> getLogsByDate(DateTime date) {
    return DatabaseService.getLogsByDate(date);
  }

  List<MedicationLog> getLogsByMedicationId(String medicationId) {
    return DatabaseService.getLogsByMedicationId(medicationId);
  }

  Future<void> markAsTaken(String logId) async {
    final log = DatabaseService.logsBoxInstance.get(logId);
    if (log != null) {
      log.status = 'taken';
      log.takenTime = DateTime.now();
      await DatabaseService.updateLog(log);
      await loadLogs();
    }
  }

  Future<void> markAsSkipped(String logId) async {
    final log = DatabaseService.logsBoxInstance.get(logId);
    if (log != null) {
      log.status = 'skipped';
      await DatabaseService.updateLog(log);
      await loadLogs();
    }
  }

  double getWeeklyAdherence() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: 7));
    final weekLogs = DatabaseService.getLogsByDateRange(weekStart, now);
    
    if (weekLogs.isEmpty) return 0.0;
    
    final takenCount = weekLogs.where((log) => log.status == 'taken').length;
    return (takenCount / weekLogs.length) * 100;
  }

  Map<String, dynamic> getDayStatus(DateTime date) {
    final logs = getLogsByDate(date);
    if (logs.isEmpty) return {'status': 'none', 'count': 0};

    final taken = logs.where((log) => log.status == 'taken').length;
    final skipped = logs.where((log) => log.status == 'skipped').length;
    final scheduled = logs.where((log) => log.status == 'scheduled').length;

    if (taken > 0 && skipped == 0) {
      return {'status': 'taken', 'count': logs.length};
    } else if (skipped > 0) {
      return {'status': 'skipped', 'count': logs.length};
    } else if (scheduled > 0) {
      return {'status': 'scheduled', 'count': logs.length};
    }
    
    return {'status': 'none', 'count': 0};
  }
}
