import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medimind/l10n/app_localizations.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../providers/theme_provider.dart';
import '../providers/language_provider.dart';
import '../services/notification_service.dart';
import '../services/database_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final sound = await NotificationService.isSoundEnabled();
    final vibration = await NotificationService.isVibrationEnabled();
    setState(() {
      _soundEnabled = sound;
      _vibrationEnabled = vibration;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        children: [
          // Theme Section
          ListTile(
            leading: const Icon(Icons.palette),
            title: Text(l10n.theme),
            subtitle: Text(themeProvider.isDarkMode ? l10n.darkMode : l10n.lightMode),
            trailing: Switch(
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
            ),
          ),
          const Divider(),

          // Language Section
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            subtitle: Text(languageProvider.locale.languageCode == 'pt' ? l10n.portuguese : l10n.english),
            trailing: IconButton(
              icon: const Icon(Icons.swap_horiz),
              onPressed: () {
                languageProvider.toggleLanguage();
              },
            ),
          ),
          const Divider(),

          // Sound Section
          SwitchListTile(
            secondary: const Icon(Icons.volume_up),
            title: Text(l10n.enableSound),
            value: _soundEnabled,
            onChanged: (value) async {
              await NotificationService.setSoundEnabled(value);
              setState(() {
                _soundEnabled = value;
              });
            },
          ),

          // Vibration Section
          SwitchListTile(
            secondary: const Icon(Icons.vibration),
            title: Text(l10n.enableVibration),
            value: _vibrationEnabled,
            onChanged: (value) async {
              await NotificationService.setVibrationEnabled(value);
              setState(() {
                _vibrationEnabled = value;
              });
            },
          ),
          const Divider(),

          // Backup Section
          ListTile(
            leading: const Icon(Icons.backup),
            title: Text(l10n.backupData),
            onTap: () => _exportData(context, l10n),
          ),

          // Import Section
          ListTile(
            leading: const Icon(Icons.restore),
            title: Text(l10n.importData),
            onTap: () => _importData(context, l10n),
          ),
        ],
      ),
    );
  }

  Future<void> _exportData(BuildContext context, AppLocalizations l10n) async {
    try {
      final data = await DatabaseService.exportData();
      final jsonString = jsonEncode(data);
      
      final directory = await getExternalStorageDirectory();
      final file = File('${directory!.path}/medimind_backup_${DateTime.now().millisecondsSinceEpoch}.json');
      await file.writeAsString(jsonString);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.exportSuccess}\n${file.path}')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.exportError}: $e')),
        );
      }
    }
  }

  Future<void> _importData(BuildContext context, AppLocalizations l10n) async {
    // In a real app, you would use file_picker package
    // For now, this is a placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Import feature: Use file picker to select backup file')),
    );
  }
}
