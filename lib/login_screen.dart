import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myapp/api_client.dart';
// Import home_page.dart

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  LoginPage({super.key});
  
  get access_token => null;
  
  get token_type => null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _header(context),
              _inputField(context),
              _signup(context),
            ],
          ),
        ),
      ),
    );
  }

  _header(context) {
    return const Column(
      children: [
        Text(
          "NeighbourPro",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Text("Say hello to friendly neighbourhood professionals"),
      ],
    );
  }

  _inputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: usernameController,
          decoration: InputDecoration(
              hintText: "Username",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none
              ),
              fillColor: Color.fromARGB(255, 36, 30, 30).withOpacity(0.1),
              filled: true,
              prefixIcon: const Icon(Icons.person)),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: Color.fromARGB(255, 36, 30, 30).withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.password),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
          // Send credentials to the API class for authentication
          final String username = usernameController.text.trim();
          final String password = passwordController.text.trim();
          final token = await APIService.login(username, password);

          // Save the token in Flutter Secure Storage
          if (token['access_token'] != null && token['token_type'] != null) {
              final String accessToken = token['access_token'];
              final String tokenType = token['token_type'];
              // print('Access Token: $accessToken');
              // print('Token type : $tokenType');

              // Save the access token and its type in Flutter Secure Storage
              final storage = FlutterSecureStorage();
              await storage.write(key: 'access_token', value: accessToken);
              await storage.write(key: 'token_type', value: tokenType);
              Fluttertoast.showToast(msg: "Login Successful");

              // Navigate to the home page ("/home") on successful login
              Navigator.pushReplacementNamed(context, '/home');
            } else {
              // Handle login failure
              // Show error message to the user
            }
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Color.fromARGB(255, 36, 30, 30),
          ),
          child: const Text(
            "Login",
            style: TextStyle(fontSize: 20,color: Color.fromARGB(255, 230, 220, 220)),
          ),
        )
      ],
    );
  }

  

  _signup(context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text("Don't have an account? "),
      TextButton(
        onPressed: () {
          // Navigate to signup screen ("/signup") when "Sign Up" button is pressed
          Navigator.pushReplacementNamed(context, '/signup');
        },
        child: const Text(
          "Register",
          style: TextStyle(color: Color.fromARGB(255, 36, 30, 30)),
        ),
      )
    ],
  );
}
}