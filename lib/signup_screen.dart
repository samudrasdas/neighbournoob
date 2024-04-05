import 'package:flutter/material.dart';
import 'package:myapp/api_client.dart'; // Import the API service

class SignupPage extends StatefulWidget {
  SignupPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignupPageState createState() => _SignupPageState();
}
class _SignupPageState extends State<SignupPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isEmailValid = true;
  bool isPasswordValid = true; // Track password validity

  Future<void> _signup(BuildContext context) async {
    String username = usernameController.text; 
    String first_name = firstNameController.text; 
    String last_name = lastNameController.text; 
    String email = emailController.text; 
    String phone_number = phoneNumberController.text; 
    String password_hash = passwordController.text; 
    try {
      // Call the signup method from the API service
      final response = await APIService.signup(
        username: username,
        first_name: first_name,
        last_name: last_name,
        email: email,
        phone_number: phone_number,
        password_hash: password_hash,
      );
      print(response.runtimeType);
      // Handle the response here, for example, navigate to a new page
      print('Signup successful! Response: $response');
      // Navigate to the login page after successful signup
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      // Handle errors, for example, show an error message
      // print('Signup failed: $e');
      print('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            height: MediaQuery.of(context).size.height - 50,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const SizedBox(height: 60.0),

                    const Text(
                      "Sign up",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Create your account",
                      style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                          hintText: "Username",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          fillColor: const Color.fromARGB(255, 96, 92, 97).withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(Icons.person)),
                    ),

                    const SizedBox(height: 15),
                    TextField(
                      controller: firstNameController,
                      decoration: InputDecoration(
                          hintText: "First name",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          fillColor: const Color.fromARGB(255, 96, 92, 97).withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(Icons.person)),
                    ),

                    const SizedBox(height: 15),
                    TextField(
                      controller: lastNameController,
                      decoration: InputDecoration(
                          hintText: "Last name",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          fillColor: const Color.fromARGB(255, 96, 92, 97).withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(Icons.person)),
                    ),
                    
                    const SizedBox(height: 15),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: isEmailValid
                            ? const Color.fromARGB(255, 96, 92, 97).withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        filled: true,
                        prefixIcon: const Icon(Icons.email),
                      ),
                      onChanged: (value) {
                        // Validate email using regex
                        bool isValid = RegExp(
                                r"^[^@]+@[^@]+\.[^@]+$")
                            .hasMatch(value);
                        setState(() {
                          isEmailValid = isValid;
                        });
                      },
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                          hintText: "Phone number",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          fillColor: const Color.fromARGB(255, 96, 92, 97).withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(Icons.phone)),
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: isPasswordValid
                            ? const Color.fromARGB(255, 96, 92, 97).withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        filled: true,
                        prefixIcon: const Icon(Icons.password),
                      ),
                      obscureText: true,
                      onChanged: (value) {
                        bool isValid = RegExp(
                                r"^(?=.*[a-zA-Z])(?=.*\d).{8,}$")
                            .hasMatch(value);
                        setState(() {
                          isPasswordValid = isValid;
                        });
                      },
                    ),
                  ],
                ),
                 Container(
                  padding: const EdgeInsets.only(top: 3, left: 3),
                  child: ElevatedButton(
                    onPressed: isEmailValid && isPasswordValid 
                    ? () => _signup(context) : null,
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color.fromARGB(255, 36, 30, 30),
                    ),
                    child: const Text(
                      "Sign up",
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 230, 220, 220),
                      ),
                    ),
                  ),
                ),

                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Already have an account?"),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: const Text("Login", style: TextStyle(color: Color.fromARGB(255, 17, 15, 15)),)
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}