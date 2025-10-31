import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080';
  
  // Admin user ID for learning content (flashcards, dictation, quiz)
  static const int adminUserId = 1;
  
  // Default user ID for personal data
  static const int defaultUserId = 2;
  
  static Future<dynamic> get(String endpoint, {int? userId}) async {
    // Auto-determine userId based on endpoint if not provided
    if (userId == null) {
      userId = _getDefaultUserIdForEndpoint(endpoint);
    }
    
    // Add userId parameter to endpoint if needed
    String finalEndpoint = _addUserIdParameter(endpoint, userId);
    
    final response = await http.get(
      Uri.parse('$baseUrl$finalEndpoint'),
      headers: {'Content-Type': 'application/json'},
    );
    
    if (response.statusCode == 200) {
      return json.decode(utf8.decode(response.bodyBytes));
    }
    throw Exception('API Error: ${response.statusCode}');
  }
  
  static int _getDefaultUserIdForEndpoint(String endpoint) {
    // Learning content endpoints use admin userId (1)
    if (endpoint.startsWith('/categories') ||
        endpoint.startsWith('/decks') ||
        endpoint.startsWith('/flashcards') ||
        endpoint.startsWith('/dictation') ||
        endpoint.startsWith('/quiz')) {
      return adminUserId;
    }
    
    // Personal data endpoints use default userId (2)
    if (endpoint.startsWith('/users/profile') ||
        endpoint.startsWith('/users/home') ||
        endpoint.startsWith('/progress')) {
      return defaultUserId;
    }
    
    return adminUserId; // Default to admin for learning content
  }
  
  static String _addUserIdParameter(String endpoint, int userId) {
    // Don't add userId to categories endpoint as it doesn't require it
    if (endpoint.startsWith('/categories')) {
      return endpoint;
    }
    
    // Add userId parameter
    String separator = endpoint.contains('?') ? '&' : '?';
    return '$endpoint${separator}userId=$userId';
  }
  
  static Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(utf8.decode(response.bodyBytes));
    }
    throw Exception('API Error: ${response.statusCode}');
  }
}