import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_settings.dart';

class StorageService {
  static const String _settingsKey = 'app_settings';
  static const String _firstLaunchKey = 'first_launch';
  static const String _lastQuoteIdKey = 'last_quote_id';
  static const String _lastQuoteDateKey = 'last_quote_date';

  Future<void> saveSettings(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, jsonEncode(settings.toJson()));
  }

  Future<AppSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString(_settingsKey);
    
    if (settingsJson != null) {
      return AppSettings.fromJson(jsonDecode(settingsJson) as Map<String, dynamic>);
    }
    
    return AppSettings();
  }

  Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_firstLaunchKey) ?? true;
  }

  Future<void> setFirstLaunchComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstLaunchKey, false);
  }

  Future<void> saveLastQuote(int quoteId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastQuoteIdKey, quoteId);
    await prefs.setString(_lastQuoteDateKey, DateTime.now().toIso8601String());
  }

  Future<int?> getLastQuoteId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_lastQuoteIdKey);
  }

  Future<DateTime?> getLastQuoteDate() async {
    final prefs = await SharedPreferences.getInstance();
    final dateString = prefs.getString(_lastQuoteDateKey);
    if (dateString != null) {
      return DateTime.parse(dateString);
    }
    return null;
  }
}
