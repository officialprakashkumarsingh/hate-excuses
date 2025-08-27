import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/web_search_result_model.dart';
import 'api_service.dart'; // To reuse the headers

class WebSearchService {
  static Future<WebSearchResult> search(String query) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/v1/web'),
        headers: ApiService.headers, // Reuse headers from ApiService
        body: jsonEncode({
          'query': query,
          'max_results': 30, // As requested by user
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return WebSearchResult.fromJson(data);
      } else {
        throw Exception('Failed to perform web search: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error during web search: $e');
      throw Exception('Error performing web search: $e');
    }
  }
}
