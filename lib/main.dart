import 'package:flutter/material.dart';
import 'package:myapp/worker.dart';
import 'login_screen.dart';
import 'home_page.dart'; // Assuming you have a home page implementation
import 'signup_screen.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeighbourPro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login', // Set initial route to login page
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/home': (context) => HomePage(),
        '/worker': (context) => WorkerPage(),// Define route for home page
      },
    );
  }
}
