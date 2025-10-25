import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../models/quote_model.dart';

class QuoteService {
  List<Quote> _quotes = [];

  Future<void> loadQuotes(String language) async {
    final String assetPath = language == 'es' 
        ? 'assets/quotes_es.json' 
        : 'assets/quotes_en.json';
    
    final String jsonString = await rootBundle.loadString(assetPath);
    final Map<String, dynamic> jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
    final List<dynamic> quotesJson = jsonData['quotes'] as List<dynamic>;
    
    _quotes = quotesJson
        .map((json) => Quote.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Quote getDailyQuote() {
    if (_quotes.isEmpty) {
      throw Exception('Quotes not loaded');
    }
    
    // Use the current day of year to get a consistent quote per day
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    final index = dayOfYear % _quotes.length;
    return _quotes[index];
  }

  Quote getRandomQuote() {
    if (_quotes.isEmpty) {
      throw Exception('Quotes not loaded');
    }
    
    final random = Random();
    return _quotes[random.nextInt(_quotes.length)];
  }

  List<Quote> getQuotesByCategory(String category) {
    return _quotes.where((quote) => quote.category == category).toList();
  }

  List<String> getAllCategories() {
    final categories = _quotes.map((quote) => quote.category).toSet().toList();
    categories.sort();
    return categories;
  }

  List<Quote> getAllQuotes() {
    return List.from(_quotes);
  }
}
