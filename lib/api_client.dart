import 'dart:convert';
import 'package:http/http.dart' as http;

// API Service class for handling HTTP requests
class APIService {
  static const String baseURL = 'https://neighbourpro.live'; // Update with your API base URL


  static Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseURL/auth/login'),
      body: {'username': username, 'password': password},
    );

    if (response.statusCode == 200) {
      // Decode the JSON response body into a Map<String, dynamic>
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      return responseBody;
    } else {
      throw Exception('Failed to login');
    }
  }

  // Function to perform signup
  static Future<Map<String, dynamic>> signup({
    required String username,
    required String first_name,
    required String last_name,
    required String email,
    required String password
  }) async {
    // Making a POST request to the signup endpoint
    final response = await http.post(
      Uri.parse('$baseURL/auth/register'), // Adjust the endpoint according to your API
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',// Specifying request headers
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'first_name': first_name,
        'last_name': last_name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      // If the server returns a 201 OK response, parse the JSON
      
      return jsonDecode(response.body);
    } else {
      // If the server did not return a 200 OK response, throw an exception.
        throw Exception('Failed to sign up (status code: ${response.statusCode}): ${response.body}');
    }
  }

static Future<List<String>> fetchRecommendedProfessions() async {
  try {
    final response = await http.get(Uri.parse('$baseURL/users/recommend'));
    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      if (data is List) {
        final List<String> recommendedProfessions = data.map((item) => item['name'] as String).toList();
        return recommendedProfessions;
      } else if (data is Map<String, dynamic>) {
        // Handle if the response is a map
        final List<String> recommendedProfessions = [];
        data.forEach((key, value) {
          recommendedProfessions.add(value.toString());
        });
        return recommendedProfessions;
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to fetch recommended professions');
    }
  } catch (e) {
    throw Exception('Error fetching recommended professions: $e');
  }
}
  static checkUsernameAvailability(String value) {}

}