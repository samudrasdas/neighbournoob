import 'dart:convert';
import 'package:http/http.dart' as http;

class APIService {
  static const String baseURL = 'https://neighbourpro.live'; // Update with your API base URL

  static Future<Map<String, dynamic>> signup({
    required String username,
    required String first_name,
    required String last_name,
    required String email,
    required String phone_number,
    required String password_hash
  }) async {
    final response = await http.post(
      Uri.parse('$baseURL/auth/register'), // Adjust the endpoint according to your API
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'first_name': first_name,
        'last_name': last_name,
        'email': email,
        'phone_number': phone_number,
        'password_hash': password_hash,
      }),
    );

    if (response.statusCode == 201) {
      // If the server returns a 200 OK response, parse the JSON
      
      return jsonDecode(response.body);
    } else {
      // If the server did not return a 200 OK response, throw an exception.
        throw Exception('Failed to sign up (status code: ${response.statusCode}): ${response.body}');
    }
  }
}
