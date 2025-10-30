import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/quote_model.dart';

class QuoteParserDatabase {
  static const String _boxName = 'quotes_box';
  static const String _settingsBoxName = 'quote_settings';
  late Box<Map> _quotesBox;
  late Box _settingsBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    _quotesBox = await Hive.openBox<Map>(_boxName);
    _settingsBox = await Hive.openBox(_settingsBoxName);
  }

  // Save quotes to local database
  Future<void> saveQuotes(List<Quote> quotes) async {
    for (var quote in quotes) {
      await _quotesBox.put(quote.id, quote.toJson());
    }
  }

  // Get all quotes from database
  Future<List<Quote>> getAllQuotes() async {
    final quotes = <Quote>[];
    for (var key in _quotesBox.keys) {
      final quoteData = _quotesBox.get(key);
      if (quoteData != null) {
        quotes.add(Quote.fromJson(Map<String, dynamic>.from(quoteData)));
      }
    }
    return quotes;
  }

  // Get quote by ID
  Future<Quote?> getQuoteById(int id) async {
    final quoteData = _quotesBox.get(id);
    if (quoteData != null) {
      return Quote.fromJson(Map<String, dynamic>.from(quoteData));
    }
    return null;
  }

  // Get quotes by category
  Future<List<Quote>> getQuotesByCategory(String category) async {
    final allQuotes = await getAllQuotes();
    return allQuotes.where((q) => q.category == category).toList();
  }

  // Get random quote
  Future<Quote?> getRandomQuote() async {
    final quotes = await getAllQuotes();
    if (quotes.isEmpty) return null;
    quotes.shuffle();
    return quotes.first;
  }

  // Get daily quote (consistent for the day)
  Future<Quote?> getDailyQuote() async {
    final quotes = await getAllQuotes();
    if (quotes.isEmpty) return null;

    final dayOfYear = DateTime.now().difference(
      DateTime(DateTime.now().year, 1, 1)
    ).inDays;
    
    final index = dayOfYear % quotes.length;
    return quotes[index];
  }

  // Save last shown quote ID
  Future<void> saveLastShownQuoteId(int id) async {
    await _settingsBox.put('last_shown_quote_id', id);
  }

  // Get last shown quote ID
  int? getLastShownQuoteId() {
    return _settingsBox.get('last_shown_quote_id') as int?;
  }

  // Save notification time
  Future<void> saveNotificationTime(int hour, int minute) async {
    await _settingsBox.put('notification_hour', hour);
    await _settingsBox.put('notification_minute', minute);
  }

  // Get notification time
  Map<String, int> getNotificationTime() {
    return {
      'hour': _settingsBox.get('notification_hour', defaultValue: 9) as int,
      'minute': _settingsBox.get('notification_minute', defaultValue: 0) as int,
    };
  }

  // Check if quotes are already loaded
  bool hasQuotes() {
    return _quotesBox.isNotEmpty;
  }

  // Clear all quotes
  Future<void> clearQuotes() async {
    await _quotesBox.clear();
  }

  // Get quote statistics
  Future<Map<String, dynamic>> getStatistics() async {
    final quotes = await getAllQuotes();
    final categories = <String, int>{};
    
    for (var quote in quotes) {
      categories[quote.category] = (categories[quote.category] ?? 0) + 1;
    }

    return {
      'total_quotes': quotes.length,
      'categories': categories,
      'last_updated': _settingsBox.get('last_updated'),
    };
  }

  // Save last updated timestamp
  Future<void> updateLastUpdated() async {
    await _settingsBox.put('last_updated', DateTime.now().toIso8601String());
  }

  // Close database
  Future<void> close() async {
    await _quotesBox.close();
    await _settingsBox.close();
  }
}
