// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'MediMind';

  @override
  String get myCalendar => 'My Calendar';

  @override
  String get myMedications => 'My Medications';

  @override
  String get settings => 'Settings';

  @override
  String get about => 'About';

  @override
  String get theme => 'Theme';

  @override
  String get language => 'Language';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get portuguese => 'Português (BR)';

  @override
  String get english => 'English';

  @override
  String get addMedication => 'Add Medication';

  @override
  String get editMedication => 'Edit Medication';

  @override
  String get medicationName => 'Medication Name';

  @override
  String get dosageValue => 'Dosage Value';

  @override
  String get dosageUnit => 'Dosage Unit';

  @override
  String get firstDoseTime => 'First Dose Time';

  @override
  String get enableNotifications => 'Enable Notifications & Alarm';

  @override
  String get intervalType => 'Interval Type';

  @override
  String get daily => 'Daily';

  @override
  String get everyXDays => 'Every X Days';

  @override
  String get weekly => 'Weekly';

  @override
  String get monthly => 'Monthly';

  @override
  String get custom => 'Custom';

  @override
  String get timesPerDay => 'Times per Day';

  @override
  String get intervalDays => 'Interval (Days)';

  @override
  String get startDate => 'Start Date';

  @override
  String get selectWeekdays => 'Select Weekdays';

  @override
  String get dayOfMonth => 'Day of Month';

  @override
  String get customInterval => 'Custom Interval (Hours)';

  @override
  String get notes => 'Notes (Optional)';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get taken => 'Taken';

  @override
  String get skip => 'Skip';

  @override
  String get scheduled => 'Scheduled';

  @override
  String get skipped => 'Skipped';

  @override
  String get noMedications => 'No medications registered';

  @override
  String get noMedicationsDescription => 'Tap + to add your first medication';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String get confirmDeleteMessage =>
      'Are you sure you want to delete this medication?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get timeToTake => 'Time to take';

  @override
  String get notificationTitle => 'Medication Reminder';

  @override
  String notificationBody(String medicationName, String dosage) {
    return 'Time to take $medicationName — $dosage';
  }

  @override
  String get enableSound => 'Enable Sound';

  @override
  String get enableVibration => 'Enable Vibration';

  @override
  String get backupData => 'Backup Data';

  @override
  String get importData => 'Import Data';

  @override
  String get exportSuccess => 'Data exported successfully';

  @override
  String get importSuccess => 'Data imported successfully';

  @override
  String get exportError => 'Error exporting data';

  @override
  String get importError => 'Error importing data';

  @override
  String get appVersion => 'Version';

  @override
  String get developer => 'Developer';

  @override
  String get license => 'License';

  @override
  String get aboutDescription =>
      'MediMind helps you remember to take your medications with offline reminders and local storage.';

  @override
  String get adherenceStats => 'Adherence Statistics';

  @override
  String get weeklyAdherence => 'Weekly Adherence';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get sunday => 'Sunday';

  @override
  String get mon => 'Mon';

  @override
  String get tue => 'Tue';

  @override
  String get wed => 'Wed';

  @override
  String get thu => 'Thu';

  @override
  String get fri => 'Fri';

  @override
  String get sat => 'Sat';

  @override
  String get sun => 'Sun';

  @override
  String get mcg => 'mcg';

  @override
  String get mg => 'mg';

  @override
  String get g => 'g';

  @override
  String get ml => 'ml';

  @override
  String get iu => 'IU';

  @override
  String get tablet => 'tablet(s)';

  @override
  String get capsule => 'capsule(s)';

  @override
  String get required => 'This field is required';

  @override
  String get invalidNumber => 'Please enter a valid number';

  @override
  String get selectAtLeastOneDay => 'Select at least one day';

  @override
  String get medicationColor => 'Medication Color';

  @override
  String get selectColor => 'Select Color';

  @override
  String get medicationSchedule => 'Medication Schedule';

  @override
  String get firstDose => 'First Dose';

  @override
  String get secondDose => 'Second Dose';

  @override
  String get thirdDose => 'Third Dose';

  @override
  String get fourthDose => 'Fourth Dose';

  @override
  String get fifthDose => 'Fifth Dose';

  @override
  String doseNumber(int number) {
    return 'Dose $number';
  }
}
