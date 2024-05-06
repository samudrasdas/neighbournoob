import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

// API Service class for handling HTTP requests

class Profession {
  final int id;
  final String name;

  Profession(this.name, this.id);

  factory Profession.fromJson(Map<String, dynamic> json) {
    return Profession(json['name'] as String, json['id'] as int);
  }
}

class Professional {
  final int id;
  final String firstName;
  final String lastName;

  final double avgRating;
  final String workerBio;
  final double distance;
  final double hourlyRate;

  Professional(this.id, this.firstName, this.lastName, this.avgRating,
      this.workerBio, this.distance, this.hourlyRate);

  factory Professional.fromJson(Map<String, dynamic> json) {
    return Professional(
      json['id'] as int,
      json['first_name'] as String,
      json['last_name'] as String,
      json['worker'][0]['avg_rating'] as double,
      json['worker'][0]['worker_bio'] as String,
      json['distance_to_user_in_km'] as double,
      json['worker'][0]['hourly_rate'] as double,
    );
  }
}

class APIService {
  static const String baseURL =
      'https://neighbourpro.live'; // Update with your API base URL

  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseURL/auth/login'),
      body: {'username': username, 'password': password},
    );

    if (response.statusCode == 200) {
      // Decode the JSON response body into a Map<String, dynamic>
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      return responseBody;
    } else {
      Fluttertoast.showToast(
          msg: 'Failed to login: ${response.statusCode}',
          toastLength: Toast.LENGTH_SHORT);
      throw Exception('Failed to login');
    }
  }

  // Function to perform signup
  static Future<Map<String, dynamic>> signup(
      {required String username,
      required String first_name,
      required String last_name,
      required String email,
      required String password}) async {
    // Making a POST request to the signup endpoint
    final response = await http.post(
      Uri.parse(
          '$baseURL/auth/register'), // Adjust the endpoint according to your API
      headers: <String, String>{
        'Content-Type':
            'application/json; charset=UTF-8', // Specifying request headers
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
      throw Exception(
          'Failed to sign up (status code: ${response.statusCode}): ${response.body}');
    }
  }

  static Future<List<Profession>> fetchProfessions() async {
    final response = await http.get(Uri.parse('$baseURL/users/professions'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((item) => Profession.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load professions');
    }
  }

  static Future<List<Professional>> fetchProfessionals(
      int id, String token, String tokenType) async {
    final response = await http.get(
      Uri.parse('$baseURL/work/professionals/$id/filter'),
      headers: <String, String>{
        'Authorization': '$tokenType $token',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((item) => Professional.fromJson(item)).toList();
    } else {
      print(response.statusCode);
      throw Exception('Failed to load professionals.. oops!');
    }
  }

  static Future<List<String>> fetchRecommendedProfessions() async {
    try {
      final response = await http.get(Uri.parse('$baseURL/users/recommend'));
      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);
        final List<dynamic> recommendations = data['recommendations'];

        // Extract names from recommendations
        final List<String> professionNames = [];
        for (final recommendation in recommendations) {
          final String name = recommendation['name'] as String;
          professionNames.add(name);
        }

        return professionNames;
      } else {
        throw Exception('Failed to fetch recommended professions');
      }
    } catch (e) {
      throw Exception('Error fetching recommended professions: $e');
    }
  }

  static Future<bool> checkUsernameAvailability(String value) async {
    // Implement username availability check logic
    // Return true if the username is available, false otherwise
    return true;
  }

  static Future<bool> checkTokenValidity(String token) async {
    // return true if the token is valid, false otherwise
    try {
      final response = await http.get(
        Uri.parse('$baseURL/auth/me'),
        headers: {'Authorization': 'Bearer $token'},
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> scheduleWork(
      String userDesc,
      String schedDate,
      String schedTime,
      int assignedTo,
      int professionID,
      String tokenType,
      String token) async {
    try {
      await http.post(
        Uri.parse('$baseURL/work/book-a-work'),
        headers: <String, String>{
          'Authorization': '$tokenType $token',
        },
        body: {
          "tags": "string",
          'user_description': userDesc,
          'scheduled_date': schedDate,
          'scheduled_time': schedTime,
          'assigned_to_id': assignedTo,
          'profession_id': professionID,
        },
      );
      return true;
    } catch (e) {
      throw Exception('Failed to schedule work: ok $e');
    }
  }
  static Future<Map<String, dynamic>> fetchUserData(String token, String tokenType) async {
  try {
    final response = await http.get(
      Uri.parse('$baseURL/auth/me'),
      headers: {'Authorization': '$tokenType $token'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch user data');
    }
  } catch (e) {
    throw Exception('Error fetching user data: $e');
  }
}

}
