import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;
  String? _token;

  ApiService({required this.baseUrl});

  void setToken(String? token) {
    _token = token;
  }

  Map<String, String> _getHeaders({bool includeAuth = false}) {
    final headers = {
      'Content-Type': 'application/json',
    };
    
    if (includeAuth && _token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    
    return headers;
  }

  // ... (register, login, logout, getCurrentUser methods remain the same) ...
  // ... (keep them here in your actual file) ...

  // Experiences
  Future<Map<String, dynamic>> getExperiences({
    int page = 1,
    int perPage = 10,
    String? difficulty,
    bool? offerReceived,
    String? search,
    String sortBy = 'date_desc',
    String? company, // <-- 1. ADD THIS NEW PARAMETER
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'per_page': perPage.toString(),
      'sort_by': sortBy,
    };

    if (difficulty != null) {
      queryParams['difficulty'] = difficulty;
    }
    if (offerReceived != null) {
      queryParams['offer_received'] = offerReceived.toString();
    }
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }
    // <-- 2. ADD THIS LOGIC TO INCLUDE THE COMPANY IN THE REQUEST -->
    if (company != null && company.isNotEmpty) {
      queryParams['company'] = company;
    }

    final uri = Uri.parse('$baseUrl/api/experiences').replace(
      queryParameters: queryParams,
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load experiences');
    }
  }

  // ... (getExperience, createExperience, updateExperience, deleteExperience methods remain the same) ...
  // ... (keep them here in your actual file) ...

  // <-- 3. ADD THIS ENTIRE NEW METHOD -->
  /// Fetches a list of unique company names from the backend.
  /// You'll need to create an endpoint like `GET /api/companies` in your backend
  /// that returns a JSON array of strings, e.g., `["Google", "Microsoft", "Amazon"]`.
  Future<List<String>> getCompanyNames() async {
    final uri = Uri.parse('$baseUrl/api/companies');

    // This request likely doesn't need authentication, similar to getExperiences
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      // Convert the dynamic list to a list of strings
      return data.map((item) => item.toString()).toList();
    } else {
      throw Exception('Failed to load company names');
    }
  }
}