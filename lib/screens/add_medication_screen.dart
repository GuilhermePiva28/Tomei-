import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tomei/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../providers/medication_provider.dart';
import '../models/medication.dart';

class AddMedicationScreen extends StatefulWidget {
  final Medication? medication;

  const AddMedicationScreen({super.key, this.medication});

  @override
  State<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _notesController = TextEditingController();

  String _dosageUnit = 'mg';
  TimeOfDay _firstDoseTime = TimeOfDay.now();
  List<TimeOfDay> _doseSchedule = [TimeOfDay.now()];
  bool _notificationsEnabled = true;
  String _intervalType = 'daily';
  int _timesPerDay = 1;
  int _intervalDays = 1;
  DateTime _startDate = DateTime.now();
  Set<int> _selectedWeekdays = {DateTime.now().weekday};
  int _dayOfMonth = DateTime.now().day;
  int _customIntervalHours = 24;
  Color _selectedColor = Colors.blue;

  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    super.initState();
    if (widget.medication != null) {
      _loadMedicationData();
    }
    _loadInterstitialAd();
  }

  void _loadMedicationData() {
    final med = widget.medication!;
    _nameController.text = med.name;
    _dosageController.text = med.dosageValue.toString();
    _dosageUnit = med.dosageUnit;
    final timeParts = med.firstDoseTime.split(':');
    _firstDoseTime = TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
    );
    _notificationsEnabled = med.notificationsEnabled;
    _intervalType = med.intervalType;
    _timesPerDay = med.timesPerDay ?? 1;
    _intervalDays = med.intervalDays ?? 1;
    _startDate = med.startDate ?? DateTime.now();
    _selectedWeekdays = med.weekdays?.toSet() ?? {DateTime.now().weekday};
    _dayOfMonth = med.dayOfMonth ?? DateTime.now().day;
    _customIntervalHours = med.customIntervalHours ?? 24;
    _notesController.text = med.notes ?? '';
    
    // Load color
    if (med.color != null) {
      _selectedColor = Color(med.color!);
    }
    
    // Load dose schedule
    if (med.doseSchedule != null && med.doseSchedule!.isNotEmpty) {
      _doseSchedule = med.doseSchedule!.map((timeStr) {
        final parts = timeStr.split(':');
        return TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }).toList();
    } else {
      // Initialize with default times based on timesPerDay
      _doseSchedule = List.generate(_timesPerDay, (index) => TimeOfDay.now());
    }
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712', // Test ad unit
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          // Fail silently
        },
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _notesController.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEditing = widget.medication != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? l10n.editMedication : l10n.addMedication),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Medication Name
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.medicationName,
                prefixIcon: const Icon(Icons.medication),
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.required;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Dosage Value and Unit
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _dosageController,
                    decoration: InputDecoration(
                      labelText: l10n.dosageValue,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.required;
                      }
                      if (double.tryParse(value) == null) {
                        return l10n.invalidNumber;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<String>(
                    value: _dosageUnit,
                    decoration: InputDecoration(
                      labelText: l10n.dosageUnit,
                      border: const OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem(value: 'mcg', child: Text(l10n.mcg)),
                      DropdownMenuItem(value: 'mg', child: Text(l10n.mg)),
                      DropdownMenuItem(value: 'g', child: Text(l10n.g)),
                      DropdownMenuItem(value: 'ml', child: Text(l10n.ml)),
                      DropdownMenuItem(value: 'IU', child: Text(l10n.iu)),
                      DropdownMenuItem(value: 'tablet(s)', child: Text(l10n.tablet)),
                      DropdownMenuItem(value: 'capsule(s)', child: Text(l10n.capsule)),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _dosageUnit = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Color Picker
            ListTile(
              title: Text(l10n.medicationColor),
              subtitle: Text(l10n.selectColor),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _selectedColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey, width: 2),
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Theme.of(context).colorScheme.outline),
              ),
              onTap: () {
                _showColorPicker();
              },
            ),
            const SizedBox(height: 16),

            // Enable Notifications
            SwitchListTile(
              title: Text(l10n.enableNotifications),
              value: _notificationsEnabled,
              secondary: const Icon(Icons.notifications_active),
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Interval Type
            DropdownButtonFormField<String>(
              value: _intervalType,
              decoration: InputDecoration(
                labelText: l10n.intervalType,
                prefixIcon: const Icon(Icons.repeat),
                border: const OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(value: 'daily', child: Text(l10n.daily)),
                DropdownMenuItem(value: 'everyXDays', child: Text(l10n.everyXDays)),
                DropdownMenuItem(value: 'weekly', child: Text(l10n.weekly)),
                DropdownMenuItem(value: 'monthly', child: Text(l10n.monthly)),
                DropdownMenuItem(value: 'custom', child: Text(l10n.custom)),
              ],
              onChanged: (value) {
                setState(() {
                  _intervalType = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            // Interval-specific fields
            _buildIntervalFields(l10n),

            const SizedBox(height: 16),

            // Notes
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: l10n.notes,
                prefixIcon: const Icon(Icons.note),
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            // Save Button
            ElevatedButton(
              onPressed: _saveMedication,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                l10n.save,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntervalFields(AppLocalizations l10n) {
    switch (_intervalType) {
      case 'daily':
        return Column(
          children: [
            TextFormField(
              initialValue: _timesPerDay.toString(),
              decoration: InputDecoration(
                labelText: l10n.timesPerDay,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  final newTimesPerDay = int.tryParse(value) ?? 1;
                  _timesPerDay = newTimesPerDay.clamp(1, 5);
                  
                  // Adjust dose schedule list
                  if (_doseSchedule.length < _timesPerDay) {
                    while (_doseSchedule.length < _timesPerDay) {
                      _doseSchedule.add(TimeOfDay.now());
                    }
                  } else if (_doseSchedule.length > _timesPerDay) {
                    _doseSchedule = _doseSchedule.sublist(0, _timesPerDay);
                  }
                });
              },
            ),
            const SizedBox(height: 16),
            if (_timesPerDay == 1)
              ListTile(
                title: Text(l10n.firstDoseTime),
                subtitle: Text(_firstDoseTime.format(context)),
                leading: const Icon(Icons.access_time),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Theme.of(context).colorScheme.outline),
                ),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: _firstDoseTime,
                  );
                  if (time != null) {
                    setState(() {
                      _firstDoseTime = time;
                    });
                  }
                },
              ),
            if (_timesPerDay > 1) ..._buildDoseTimeFields(l10n),
          ],
        );

      case 'everyXDays':
        return Column(
          children: [
            TextFormField(
              initialValue: _intervalDays.toString(),
              decoration: InputDecoration(
                labelText: l10n.intervalDays,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _intervalDays = int.tryParse(value) ?? 1;
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(l10n.startDate),
              subtitle: Text('${_startDate.day}/${_startDate.month}/${_startDate.year}'),
              leading: const Icon(Icons.calendar_today),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Theme.of(context).colorScheme.outline),
              ),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _startDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                  setState(() {
                    _startDate = date;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(l10n.firstDoseTime),
              subtitle: Text(_firstDoseTime.format(context)),
              leading: const Icon(Icons.access_time),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Theme.of(context).colorScheme.outline),
              ),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: _firstDoseTime,
                );
                if (time != null) {
                  setState(() {
                    _firstDoseTime = time;
                  });
                }
              },
            ),
          ],
        );

      case 'weekly':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.selectWeekdays, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildWeekdayChip(l10n.mon, 1),
                _buildWeekdayChip(l10n.tue, 2),
                _buildWeekdayChip(l10n.wed, 3),
                _buildWeekdayChip(l10n.thu, 4),
                _buildWeekdayChip(l10n.fri, 5),
                _buildWeekdayChip(l10n.sat, 6),
                _buildWeekdayChip(l10n.sun, 7),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(l10n.firstDoseTime),
              subtitle: Text(_firstDoseTime.format(context)),
              leading: const Icon(Icons.access_time),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Theme.of(context).colorScheme.outline),
              ),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: _firstDoseTime,
                );
                if (time != null) {
                  setState(() {
                    _firstDoseTime = time;
                  });
                }
              },
            ),
          ],
        );

      case 'monthly':
        return Column(
          children: [
            TextFormField(
              initialValue: _dayOfMonth.toString(),
              decoration: InputDecoration(
                labelText: l10n.dayOfMonth,
                border: const OutlineInputBorder(),
                helperText: '1-31',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final day = int.tryParse(value) ?? 1;
                _dayOfMonth = day.clamp(1, 31);
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(l10n.firstDoseTime),
              subtitle: Text(_firstDoseTime.format(context)),
              leading: const Icon(Icons.access_time),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Theme.of(context).colorScheme.outline),
              ),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: _firstDoseTime,
                );
                if (time != null) {
                  setState(() {
                    _firstDoseTime = time;
                  });
                }
              },
            ),
          ],
        );

      case 'custom':
        return Column(
          children: [
            TextFormField(
              initialValue: _customIntervalHours.toString(),
              decoration: InputDecoration(
                labelText: l10n.customInterval,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _customIntervalHours = int.tryParse(value) ?? 24;
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(l10n.firstDoseTime),
              subtitle: Text(_firstDoseTime.format(context)),
              leading: const Icon(Icons.access_time),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Theme.of(context).colorScheme.outline),
              ),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: _firstDoseTime,
                );
                if (time != null) {
                  setState(() {
                    _firstDoseTime = time;
                  });
                }
              },
            ),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildWeekdayChip(String label, int weekday) {
    final isSelected = _selectedWeekdays.contains(weekday);
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _selectedWeekdays.add(weekday);
          } else {
            if (_selectedWeekdays.length > 1) {
              _selectedWeekdays.remove(weekday);
            }
          }
        });
      },
    );
  }

  List<Widget> _buildDoseTimeFields(AppLocalizations l10n) {
    final doseLabels = [
      l10n.firstDose,
      l10n.secondDose,
      l10n.thirdDose,
      l10n.fourthDose,
      l10n.fifthDose,
    ];

    return List.generate(_timesPerDay, (index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: ListTile(
          title: Text(index < doseLabels.length ? doseLabels[index] : l10n.doseNumber(index + 1)),
          subtitle: Text(_doseSchedule[index].format(context)),
          leading: const Icon(Icons.access_time),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Theme.of(context).colorScheme.outline),
          ),
          onTap: () async {
            final time = await showTimePicker(
              context: context,
              initialTime: _doseSchedule[index],
            );
            if (time != null) {
              setState(() {
                _doseSchedule[index] = time;
              });
            }
          },
        ),
      );
    });
  }

  void _showColorPicker() {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.teal,
      Colors.amber,
      Colors.indigo,
      Colors.cyan,
      Colors.lime,
      Colors.deepOrange,
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.selectColor),
        content: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: colors.map((color) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = color;
                });
                Navigator.pop(context);
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _selectedColor == color ? Colors.black : Colors.grey,
                    width: _selectedColor == color ? 3 : 2,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _saveMedication() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_intervalType == 'weekly' && _selectedWeekdays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.selectAtLeastOneDay)),
      );
      return;
    }

    final provider = Provider.of<MedicationProvider>(context, listen: false);
    final isEditing = widget.medication != null;

    // Prepare dose schedule for daily medications with multiple doses
    List<String>? doseSchedule;
    if (_intervalType == 'daily' && _timesPerDay > 1) {
      doseSchedule = _doseSchedule.map((time) {
        return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      }).toList();
    }

    final medication = Medication(
      id: isEditing ? widget.medication!.id : const Uuid().v4(),
      name: _nameController.text,
      dosageValue: double.parse(_dosageController.text),
      dosageUnit: _dosageUnit,
      firstDoseTime: '${_firstDoseTime.hour.toString().padLeft(2, '0')}:${_firstDoseTime.minute.toString().padLeft(2, '0')}',
      notificationsEnabled: _notificationsEnabled,
      intervalType: _intervalType,
      timesPerDay: _intervalType == 'daily' ? _timesPerDay : null,
      intervalDays: _intervalType == 'everyXDays' ? _intervalDays : null,
      startDate: _intervalType == 'everyXDays' ? _startDate : null,
      weekdays: _intervalType == 'weekly' ? _selectedWeekdays.toList() : null,
      dayOfMonth: _intervalType == 'monthly' ? _dayOfMonth : null,
      customIntervalHours: _intervalType == 'custom' ? _customIntervalHours : null,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
      createdAt: isEditing ? widget.medication!.createdAt : DateTime.now(),
      color: _selectedColor.value,
      doseSchedule: doseSchedule,
    );

    if (isEditing) {
      await provider.updateMedication(medication);
    } else {
      await provider.addMedication(medication);
    }

    // Show interstitial ad
    _interstitialAd?.show();

    if (mounted) {
      Navigator.pop(context);
    }
  }
}
