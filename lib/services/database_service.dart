import 'package:hive_flutter/hive_flutter.dart';
import '../models/medication.dart';
import '../models/medication_log.dart';

class DatabaseService {
  static const String medicationsBox = 'medications';
  static const String logsBox = 'medication_logs';

  static Future<void> initialize() async {
    await Hive.initFlutter();
    
    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(MedicationAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(MedicationLogAdapter());
    }

    // Open boxes
    await Hive.openBox<Medication>(medicationsBox);
    await Hive.openBox<MedicationLog>(logsBox);
  }

  // Medication operations
  static Box<Medication> get medicationsBoxInstance => Hive.box<Medication>(medicationsBox);
  
  static Future<void> addMedication(Medication medication) async {
    await medicationsBoxInstance.put(medication.id, medication);
  }

  static Future<void> updateMedication(Medication medication) async {
    await medicationsBoxInstance.put(medication.id, medication);
  }

  static Future<void> deleteMedication(String id) async {
    await medicationsBoxInstance.delete(id);
    // Also delete related logs
    final logs = getLogsByMedicationId(id);
    for (var log in logs) {
      await deleteLog(log.id);
    }
  }

  static List<Medication> getAllMedications() {
    return medicationsBoxInstance.values.toList();
  }

  static Medication? getMedicationById(String id) {
    return medicationsBoxInstance.get(id);
  }

  // Log operations
  static Box<MedicationLog> get logsBoxInstance => Hive.box<MedicationLog>(logsBox);

  static Future<void> addLog(MedicationLog log) async {
    await logsBoxInstance.put(log.id, log);
  }

  static Future<void> updateLog(MedicationLog log) async {
    await logsBoxInstance.put(log.id, log);
  }

  static Future<void> deleteLog(String id) async {
    await logsBoxInstance.delete(id);
  }

  static List<MedicationLog> getAllLogs() {
    return logsBoxInstance.values.toList();
  }

  static List<MedicationLog> getLogsByMedicationId(String medicationId) {
    return logsBoxInstance.values
        .where((log) => log.medicationId == medicationId)
        .toList();
  }

  static List<MedicationLog> getLogsByDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
    
    return logsBoxInstance.values
        .where((log) =>
            log.scheduledTime.isAfter(startOfDay) &&
            log.scheduledTime.isBefore(endOfDay))
        .toList();
  }

  static List<MedicationLog> getLogsByDateRange(DateTime start, DateTime end) {
    return logsBoxInstance.values
        .where((log) =>
            log.scheduledTime.isAfter(start) &&
            log.scheduledTime.isBefore(end))
        .toList();
  }

  // Backup and restore
  static Future<Map<String, dynamic>> exportData() async {
    final medications = getAllMedications();
    final logs = getAllLogs();

    return {
      'medications': medications.map((m) => m.toJson()).toList(),
      'logs': logs.map((l) => l.toJson()).toList(),
      'exportDate': DateTime.now().toIso8601String(),
    };
  }

  static Future<void> importData(Map<String, dynamic> data) async {
    // Clear existing data
    await medicationsBoxInstance.clear();
    await logsBoxInstance.clear();

    // Import medications
    final medicationsList = data['medications'] as List;
    for (var medJson in medicationsList) {
      final medication = Medication.fromJson(medJson);
      await addMedication(medication);
    }

    // Import logs
    final logsList = data['logs'] as List;
    for (var logJson in logsList) {
      final log = MedicationLog.fromJson(logJson);
      await addLog(log);
    }
  }

  static Future<void> close() async {
    await Hive.close();
  }
}
