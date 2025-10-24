import 'package:flutter_test/flutter_test.dart';
import 'package:medimind/models/medication.dart';

void main() {
  group('Medication Model Tests', () {
    test('Medication should be created with required fields', () {
      final medication = Medication(
        id: 'test-id',
        name: 'Paracetamol',
        dosageValue: 500,
        dosageUnit: 'mg',
        firstDoseTime: '08:00',
        notificationsEnabled: true,
        intervalType: 'daily',
        createdAt: DateTime.now(),
      );

      expect(medication.name, 'Paracetamol');
      expect(medication.dosageValue, 500);
      expect(medication.dosageUnit, 'mg');
      expect(medication.dosageString, '500.0mg');
    });

    test('Medication toJson and fromJson should work correctly', () {
      final medication = Medication(
        id: 'test-id',
        name: 'Aspirin',
        dosageValue: 100,
        dosageUnit: 'mg',
        firstDoseTime: '09:00',
        notificationsEnabled: true,
        intervalType: 'daily',
        timesPerDay: 2,
        notes: 'Take with food',
        createdAt: DateTime.now(),
      );

      final json = medication.toJson();
      final reconstructed = Medication.fromJson(json);

      expect(reconstructed.name, medication.name);
      expect(reconstructed.dosageValue, medication.dosageValue);
      expect(reconstructed.dosageUnit, medication.dosageUnit);
      expect(reconstructed.notes, medication.notes);
    });
  });
}
