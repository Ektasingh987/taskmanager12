import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote_model.dart';

class ApiService {
  static const String _baseUrl = 'https://api.quotable.io/random';

  Future<QuoteModel> fetchRandomQuote() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        return QuoteModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load quote');
      }
    } catch (e) {
      return QuoteModel(
        content: "Believe you can and you're halfway there.",
        author: "Theodore Roosevelt",
      );
    }
  }
}
