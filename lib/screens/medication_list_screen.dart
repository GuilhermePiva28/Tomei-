import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medimind/l10n/app_localizations.dart';

import '../providers/medication_provider.dart';
import '../models/medication.dart';
import 'add_medication_screen.dart';

class MedicationListScreen extends StatelessWidget {
  const MedicationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final medicationProvider = Provider.of<MedicationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myMedications),
      ),
      body: medicationProvider.medications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.medication_liquid,
                    size: 64,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noMedications,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.noMedicationsDescription,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: medicationProvider.medications.length,
              itemBuilder: (context, index) {
                final medication = medicationProvider.medications[index];
                return _buildMedicationCard(context, l10n, medication, medicationProvider);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddMedicationScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMedicationCard(
    BuildContext context,
    AppLocalizations l10n,
    Medication medication,
    MedicationProvider provider,
  ) {
    final medicationColor = medication.color != null 
        ? Color(medication.color!) 
        : Theme.of(context).colorScheme.primaryContainer;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: medicationColor.withOpacity(0.3),
          child: Icon(
            Icons.medication,
            color: medicationColor,
          ),
        ),
        title: Text(
          medication.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${medication.dosageValue}${medication.dosageUnit}'),
            Text('${l10n.firstDoseTime}: ${medication.firstDoseTime}'),
            if (medication.notes != null && medication.notes!.isNotEmpty)
              Text(medication.notes!, style: const TextStyle(fontStyle: FontStyle.italic)),
          ],
        ),
        isThreeLine: true,
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  const Icon(Icons.edit),
                  const SizedBox(width: 8),
                  Text(l10n.edit),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  const Icon(Icons.delete, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(l10n.delete, style: const TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'edit') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddMedicationScreen(medication: medication),
                ),
              );
            } else if (value == 'delete') {
              _showDeleteDialog(context, l10n, medication, provider);
            }
          },
        ),
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    AppLocalizations l10n,
    Medication medication,
    MedicationProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDelete),
        content: Text(l10n.confirmDeleteMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.no),
          ),
          ElevatedButton(
            onPressed: () async {
              await provider.deleteMedication(medication.id);
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.yes),
          ),
        ],
      ),
    );
  }
}
