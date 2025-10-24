import 'package:hive/hive.dart';

part 'medication_log.g.dart';

@HiveType(typeId: 1)
class MedicationLog extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String medicationId;

  @HiveField(2)
  DateTime scheduledTime;

  @HiveField(3)
  DateTime? takenTime;

  @HiveField(4)
  String status; // scheduled, taken, skipped

  MedicationLog({
    required this.id,
    required this.medicationId,
    required this.scheduledTime,
    this.takenTime,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medicationId': medicationId,
      'scheduledTime': scheduledTime.toIso8601String(),
      'takenTime': takenTime?.toIso8601String(),
      'status': status,
    };
  }

  factory MedicationLog.fromJson(Map<String, dynamic> json) {
    return MedicationLog(
      id: json['id'],
      medicationId: json['medicationId'],
      scheduledTime: DateTime.parse(json['scheduledTime']),
      takenTime: json['takenTime'] != null ? DateTime.parse(json['takenTime']) : null,
      status: json['status'],
    );
  }
}
