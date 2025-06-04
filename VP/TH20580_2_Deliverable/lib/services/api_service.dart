// services/api_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static Future<String> getRandomQuote() async {
    try {
      final response = await http.get(Uri.parse('https://api.adviceslip.com/advice'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['slip']['advice'];
      }
      return 'Failed to load quote';
    } catch (e) {
      return 'Failed to load quote';
    }
  }
}