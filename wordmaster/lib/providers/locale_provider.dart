// lib/providers/locale_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('vi'); // Default language

  Locale get locale => _locale;

  // Danh sách ngôn ngữ hỗ trợ
  static const List<Locale> supportedLocales = [
    Locale('vi'), // Vietnamese
    Locale('en'), // English
    Locale('zh'), // Chinese
    Locale('ja'), // Japanese
    Locale('ko'), // Korean
  ];

  // Map tên ngôn ngữ
  static const Map<String, Map<String, String>> languageNames = {
    'vi': {'name': 'Tiếng Việt', 'nativeName': 'Tiếng Việt', 'flag': '🇻🇳'},
    'en': {'name': 'English', 'nativeName': 'English', 'flag': '🇺🇸'},
    'zh': {'name': 'Chinese', 'nativeName': '中文', 'flag': '🇨🇳'},
    'ja': {'name': 'Japanese', 'nativeName': '日本語', 'flag': '🇯🇵'},
    'ko': {'name': 'Korean', 'nativeName': '한국어', 'flag': '🇰🇷'},
  };

  LocaleProvider() {
    _loadLocale();
  }

  // Load ngôn ngữ đã lưu từ SharedPreferences
  Future<void> _loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString('selected_language');
      
      if (languageCode != null && 
          supportedLocales.any((locale) => locale.languageCode == languageCode)) {
        _locale = Locale(languageCode);
        notifyListeners();
      }
    } catch (e) {
      print('Error loading locale: $e');
    }
  }

  // Thay đổi ngôn ngữ
  Future<void> setLocale(Locale locale) async {
    if (!supportedLocales.contains(locale)) return;
    
    _locale = locale;
    notifyListeners();
    
    // Lưu vào SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selected_language', locale.languageCode);
    } catch (e) {
      print('Error saving locale: $e');
    }
  }

  // Lấy tên ngôn ngữ
  String getLanguageName(String languageCode) {
    return languageNames[languageCode]?['name'] ?? languageCode;
  }

  // Lấy tên native
  String getNativeName(String languageCode) {
    return languageNames[languageCode]?['nativeName'] ?? languageCode;
  }

  // Lấy cờ
  String getFlag(String languageCode) {
    return languageNames[languageCode]?['flag'] ?? '🌐';
  }

  // Clear locale (reset về default)
  Future<void> clearLocale() async {
    _locale = const Locale('vi');
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('selected_language');
    } catch (e) {
      print('Error clearing locale: $e');
    }
  }
}