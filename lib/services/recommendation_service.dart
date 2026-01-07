// lib/services/recommendation_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class RecommendationService {
  // If using Android emulator use 10.0.2.2
  // If using physical phone use your laptop IP (example below)
  // static const String baseUrl = 'http://10.0.2.2:5000';
  static const String baseUrl = 'http://192.168.29.181:5000';

  Future<int?> classifyCaption(String text) async {
    try {
      final uri = Uri.parse('$baseUrl/predict');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': text}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['prediction'] as int?;
      } else {
        print('API error: ${response.statusCode}  ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error calling recommendation API: $e');
      return null;
    }
  }
}
