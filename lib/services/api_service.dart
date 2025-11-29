import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/analysis_response.dart';

class ApiService {
  static const String _baseUrl = 'https://backend.truthcourt.online';
  static const String _analyzeEndpoint = '/analyze';

  /// Analyzes a message by sending it to the backend API
  /// Returns an AnalysisResponse if successful
  /// Throws an exception if the request fails
  Future<AnalysisResponse> analyzeMessage(String message) async {
    try {
      final url = Uri.parse('$_baseUrl$_analyzeEndpoint');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'message': message,
        }),
      ).timeout(
        const Duration(minutes: 3), // Allow up to 3 minutes for the response
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        return AnalysisResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to analyze message. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error analyzing message: $e');
    }
  }
}
