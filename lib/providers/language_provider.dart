import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'language_code';
  Locale _locale = const Locale('pt', 'BR'); // Default to Portuguese

  Locale get locale => _locale;

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey) ?? 'pt';
    _locale = languageCode == 'en' ? const Locale('en', 'US') : const Locale('pt', 'BR');
    notifyListeners();
  }

  Future<void> setLanguage(Locale locale) async {
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, locale.languageCode);
    notifyListeners();
  }

  Future<void> toggleLanguage() async {
    if (_locale.languageCode == 'pt') {
      await setLanguage(const Locale('en', 'US'));
    } else {
      await setLanguage(const Locale('pt', 'BR'));
    }
  }
}
