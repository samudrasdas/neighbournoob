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

class Works {
  final int id;
  final String userDescription;
  final String scheduledDate;
  final String scheduledTime;
  final int professionID;
  late final String status;
  final double? final_cost;

  Works(this.id, this.userDescription, this.scheduledDate, this.scheduledTime,
      this.professionID, this.status,this.final_cost);

  factory Works.fromJson(Map<String, dynamic> json) {
    return Works(
      json['id'] as int,
      json['user_description'] as String,
      json['scheduled_date'] as String,
      json['scheduled_time'] as String,
      json['profession_id'] as int,
      json['status'] as String,
      json['final_cost'] as double?,
    );
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

  static Future<List<Works>> fetchAssignedWorks(
      String token, String tokenType) async {
    try {
      final response = await http.get(
        Uri.parse('$baseURL/work/assigned-works'),
        headers: <String, String>{
          'Authorization': '$tokenType $token',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        return data.map((item) => Works.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch assigned works: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching assigned works: $e');
    }
  }

  static Future<List<Works>> fetchBookedWorks(
      String token, String tokenType) async {
    try {
      final response = await http.get(
        Uri.parse('$baseURL/work/booked-works'),
        headers: <String, String>{
          'Authorization': '$tokenType $token',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        return data.map((item) => Works.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch assigned works: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching assigned works: $e');
    }
  }

  static Future<bool> writeReview(
      int workID, String review, double rating, String token, String tokenType) async {
    try {
      final response = await http.post(
        Uri.parse('$baseURL/work/review-work/$workID'),
        headers: <String, String>{
          'Authorization': '$tokenType $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'review': review,
          'rating': rating,
        }),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to write review: ${response.body}');
      }
      return true;
    } catch (e) {
      throw Exception('$e');
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

      
  static Future<List<String>> fetchRecommendedProfessions(String token, String tokenType) async {
    try {
      final response = await http.get(Uri.parse('$baseURL/users/recommend'),
        headers: <String, String>{
          'Authorization': '$tokenType $token',
        },);
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

  static Future<bool> sentPayment(int workID, String token, String tokenType) async {
    try {
      final response = await http.post(
        Uri.parse('$baseURL/work/sent-payment/$workID'),
        headers: <String, String>{
          'Authorization': '$tokenType $token',
        },
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to send payment: ${response.body}');
      }
      return true;
    } catch (e) {
      throw Exception('Failed to send payment: $e');
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
      final response = await http.post(
        Uri.parse('$baseURL/work/book-a-work'),
        headers: <String, String>{
          'Authorization': '$tokenType $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          "tags": [],
          'user_description': userDesc,
          'scheduled_date': schedDate,
          'scheduled_time': schedTime,
          'assigned_to_id': assignedTo,
          'profession_id': professionID,
        }),
      );
      if (response.statusCode != 201) {
        throw Exception(response.body);
      }
      return true;
    } catch (e) {
      throw Exception('$e');
    }
  }

  static Future<Map<String, dynamic>> fetchUserDataFromApi(
      String? token, String? tokenType) async {
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

  static Future<bool> switchToProfessional(String token, String tokenType,
      int professionID, String workerBio, double hourlyRate) async {
    try {
      final response = await http.put(
        Uri.parse('$baseURL/users/switch-to-professional'),
        headers: <String, String>{
          'Authorization': '$tokenType $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'profession_id': professionID,
          'worker_bio': workerBio,
          'hourly_rate': hourlyRate,
        }),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to switch to professional ${response.body}');
      }
      return true;
    } catch (e) {
      throw Exception('Error switching to professional: $e');
    }
  }

  static Future<bool> addAddress(
      String phoneNumber,
      String houseName,
      String street,
      String city,
      String state,
      String pinCode,
      String latitude,
      String longitude,
      String token,
      String tokenType) async {
    try {
      final response = await http.post(
        Uri.parse('$baseURL/users/address'),
        headers: <String, String>{
          'Authorization': '$tokenType $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(<String, dynamic>{
          'house_name': houseName,
          'street': street,
          'city': city,
          'state': state,
          'pincode': pinCode,
          'phone_number': phoneNumber,
          'latitude': latitude,
          'longitude': longitude,
        }),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to add address: ${json.decode(response.body)}');
      }
      return true;
    } catch (e) {
      throw Exception('Error adding address: $e');
    }
  }

  static Future<bool> acceptWork(int id, String token,String tokenType) async {
    try {
    final response = await http.post(
      Uri.parse('$baseURL/work/accept-work/$id'),
      headers: <String, String>{
        'Authorization': '$tokenType $token',
      },
    );
    if (response.statusCode != 200) {
    throw Exception('Failed to accept work: ${json.decode(response.body)}');
    }
      return true; // Work accepted successfully
    } catch (e) {
      throw Exception('Failed to accept work: $e');
    }
  }

  static Future<Map<String, dynamic>> fetchClientDetails(int id, String token, String tokenType)async{
    try {
      final response = await http.get(
        Uri.parse('$baseURL/work/client-contact-details/$id'),
        headers: <String, String>{
          'Authorization': '$tokenType $token',
          },
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

  static Future<bool> startWork(int id, String token, String tokenType) async {
    try {
      final response = await http.post(
        Uri.parse('$baseURL/work/start-work/$id'),
        headers: <String, String>{
          'Authorization': '$tokenType $token',
        },
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to start work: ${json.decode(response.body)}');
      }
      return true;
    } catch (e) {
      throw Exception('Failed to complete work: $e');
    }
  }

  static Future<bool> finalCost(int id, double cost, String token, String tokenType) async {
    print(cost);
    try {
      final response = await http.post(
        Uri.parse('$baseURL/work/quote-final-cost/$id?final_cost=$cost'),
        headers: <String, String>{
          'Authorization': '$tokenType $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to finalize cost: ${json.decode(response.body)}');
      }
      return true;
    } catch (e) {
      throw Exception('Failed to finalize cost: $e');
    }
  }

  static Future<bool> rejectWork(int id, String token, String tokenType) async {
    try {
      final response = await http.post(
        Uri.parse('$baseURL/work/reject-work/$id'),
        headers: <String, String>{
          'Authorization': '$tokenType $token',
        },
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to cancel work: ${json.decode(response.body)}');
      }
      return true;
    } catch (e) {
      throw Exception('Failed to cancel work: $e');
    }
  }


  static Future<bool> recievePayment(int id, String token, String tokenType) async {
    try {
      final response = await http.post(
        Uri.parse('$baseURL/work/recieved-payment/$id'),
        headers: <String, String>{
          'Authorization': '$tokenType $token',
        },
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to receive payment: ${json.decode(response.body)}');
      }
      return true;
    } catch (e) {
      throw Exception('Failed to receive payment: $e');
    }
  }
}