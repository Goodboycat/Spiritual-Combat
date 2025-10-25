import 'package:flutter/material.dart';
import '../models/app_settings.dart';
import '../models/quote_model.dart';
import 'storage_service.dart';
import 'quote_service.dart';
import 'notification_service.dart';

class AppState extends ChangeNotifier {
  final StorageService _storageService = StorageService();
  final QuoteService _quoteService = QuoteService();
  late final NotificationService _notificationService;

  AppSettings _settings = AppSettings();
  bool _isFirstLaunch = true;
  Quote? _dailyQuote;
  bool _isLoading = true;

  AppState() {
    _notificationService = NotificationService(_quoteService);
    _initialize();
  }

  AppSettings get settings => _settings;
  bool get isFirstLaunch => _isFirstLaunch;
  Quote? get dailyQuote => _dailyQuote;
  bool get isLoading => _isLoading;
  QuoteService get quoteService => _quoteService;

  Future<void> _initialize() async {
    _isLoading = true;
    notifyListeners();

    _isFirstLaunch = await _storageService.isFirstLaunch();
    _settings = await _storageService.loadSettings();
    
    await _quoteService.loadQuotes(_settings.language);
    await _notificationService.initialize();
    
    _dailyQuote = _quoteService.getDailyQuote();
    
    if (_settings.notificationsEnabled) {
      await _scheduleNotifications();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> setLanguage(String language) async {
    _settings = _settings.copyWith(language: language);
    await _storageService.saveSettings(_settings);
    await _quoteService.loadQuotes(language);
    _dailyQuote = _quoteService.getDailyQuote();
    notifyListeners();
  }

  Future<void> setDarkMode(bool enabled) async {
    _settings = _settings.copyWith(isDarkMode: enabled);
    await _storageService.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    _settings = _settings.copyWith(notificationsEnabled: enabled);
    await _storageService.saveSettings(_settings);
    
    if (enabled) {
      final granted = await _notificationService.requestPermissions();
      if (granted) {
        await _scheduleNotifications();
      }
    } else {
      await _notificationService.cancelAllNotifications();
    }
    
    notifyListeners();
  }

  Future<void> setNotificationTime(int hour, int minute) async {
    _settings = _settings.copyWith(
      notificationHour: hour,
      notificationMinute: minute,
    );
    await _storageService.saveSettings(_settings);
    
    if (_settings.notificationsEnabled) {
      await _scheduleNotifications();
    }
    
    notifyListeners();
  }

  Future<void> setNotificationSound(bool enabled) async {
    _settings = _settings.copyWith(notificationSound: enabled);
    await _storageService.saveSettings(_settings);
    
    if (_settings.notificationsEnabled) {
      await _scheduleNotifications();
    }
    
    notifyListeners();
  }

  Future<void> _scheduleNotifications() async {
    await _notificationService.scheduleDailyNotification(
      hour: _settings.notificationHour,
      minute: _settings.notificationMinute,
      withSound: _settings.notificationSound,
    );
  }

  Future<void> completeFirstLaunch() async {
    await _storageService.setFirstLaunchComplete();
    _isFirstLaunch = false;
    notifyListeners();
  }

  Future<bool> requestNotificationPermission() async {
    return await _notificationService.requestPermissions();
  }

  void refreshDailyQuote() {
    _dailyQuote = _quoteService.getDailyQuote();
    notifyListeners();
  }
}
