import 'package:flutter/material.dart';
import '../models/quote_model.dart';
import '../services/api_service.dart';

class QuoteProvider extends ChangeNotifier {
  final ApiService _apiService;
  QuoteModel? _quote;
  bool _isLoading = false;
  String? _error;

  QuoteProvider(this._apiService) {
    fetchQuote();
  }

  QuoteModel? get quote => _quote;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchQuote() async {
    _isLoading = true;
    notifyListeners();
    try {
      _quote = await _apiService.fetchRandomQuote();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
