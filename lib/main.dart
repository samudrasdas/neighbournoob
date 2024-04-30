import 'package:flutter/material.dart';
import 'package:myapp/storage_service.dart';
import 'package:myapp/api_client.dart';
import 'package:myapp/home_page.dart'; // Assuming you have a home page implementation
import 'package:myapp/login_screen.dart';
import 'package:myapp/profilepage.dart';
import 'package:myapp/signup_screen.dart';
import 'package:myapp/worker.dart'; // Assuming you have a worker page implementation
// import 'package:myapp/professionals_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Wait for widgets to initialize

  final storage = StorageService();
  final token = await storage.getToken();
  final tokenType = await storage.getTokenType();

  bool isValidToken = false;
  if (token != null) {
    try {
      isValidToken = await APIService.checkTokenValidity(token);
    } catch (e) {
      print('Error checking token validity: $e');
    }
  }

  runApp(MyApp(initialRoute: isValidToken ? '/home' : '/login'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeighbourPro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: initialRoute, // Set initial route based on token presence
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/home': (context) => HomePage(),
        '/worker': (context) => WorkerPage(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}
