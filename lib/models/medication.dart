import 'package:hive/hive.dart';

part 'medication.g.dart';

@HiveType(typeId: 0)
class Medication extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  double dosageValue;

  @HiveField(3)
  String dosageUnit; // mcg, mg, g, ml, IU, tablet(s), capsule(s)

  @HiveField(4)
  String firstDoseTime; // HH:mm format

  @HiveField(5)
  bool notificationsEnabled;

  @HiveField(6)
  String intervalType; // daily, everyXDays, weekly, monthly, custom

  @HiveField(7)
  int? timesPerDay; // for daily

  @HiveField(8)
  int? intervalDays; // for everyXDays

  @HiveField(9)
  DateTime? startDate; // for everyXDays

  @HiveField(10)
  List<int>? weekdays; // 1-7 for Monday-Sunday (weekly)

  @HiveField(11)
  int? dayOfMonth; // 1-31 (monthly)

  @HiveField(12)
  int? customIntervalHours; // for custom

  @HiveField(13)
  String? notes;

  @HiveField(14)
  DateTime createdAt;

  @HiveField(15)
  int? color; // Color value as int

  @HiveField(16)
  List<String>? doseSchedule; // List of HH:mm times for each dose

  Medication({
    required this.id,
    required this.name,
    required this.dosageValue,
    required this.dosageUnit,
    required this.firstDoseTime,
    required this.notificationsEnabled,
    required this.intervalType,
    this.timesPerDay,
    this.intervalDays,
    this.startDate,
    this.weekdays,
    this.dayOfMonth,
    this.customIntervalHours,
    this.notes,
    required this.createdAt,
    this.color,
    this.doseSchedule,
  });

  String get dosageString => '$dosageValue$dosageUnit';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dosageValue': dosageValue,
      'dosageUnit': dosageUnit,
      'firstDoseTime': firstDoseTime,
      'notificationsEnabled': notificationsEnabled,
      'intervalType': intervalType,
      'timesPerDay': timesPerDay,
      'intervalDays': intervalDays,
      'startDate': startDate?.toIso8601String(),
      'weekdays': weekdays,
      'dayOfMonth': dayOfMonth,
      'customIntervalHours': customIntervalHours,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'color': color,
      'doseSchedule': doseSchedule,
    };
  }

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id'],
      name: json['name'],
      dosageValue: json['dosageValue'].toDouble(),
      dosageUnit: json['dosageUnit'],
      firstDoseTime: json['firstDoseTime'],
      notificationsEnabled: json['notificationsEnabled'],
      intervalType: json['intervalType'],
      timesPerDay: json['timesPerDay'],
      intervalDays: json['intervalDays'],
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      weekdays: json['weekdays'] != null ? List<int>.from(json['weekdays']) : null,
      dayOfMonth: json['dayOfMonth'],
      customIntervalHours: json['customIntervalHours'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
      color: json['color'],
      doseSchedule: json['doseSchedule'] != null ? List<String>.from(json['doseSchedule']) : null,
    );
  }
}
