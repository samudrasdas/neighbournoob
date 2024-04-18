import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: ProfilePage(),
  ));
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
          ),
        ),
        centerTitle: true,
      ),
      body: ProfileBody(),
    );
  }
}

class ProfileBody extends StatefulWidget {
  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  String username = "john_doe";
  String firstName = "John";
  String lastName = "Doe";
  String emailId = "john.doe@example.com";
  String profileStatus = "Worker";

  void changeProfileStatus() {
    setState(() {
      if (profileStatus == "Worker") {
        profileStatus = "Worker";
      } else {
        profileStatus = "Worker";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/home');
        return false; // Prevent the default back navigation
      },
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 30.0), // Adjust the value as needed
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 140,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "NP",
                                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              ProfileTextBox(label: 'Username', icon: Icons.person, text: username),
              SizedBox(height: 10.0),
              ProfileTextBox(label: 'First Name', icon: Icons.person, text: firstName),
              SizedBox(height: 10.0),
              ProfileTextBox(label: 'Last Name', icon: Icons.person, text: lastName),
              SizedBox(height: 10.0),
              ProfileTextBox(label: 'Email ID', icon: Icons.email, text: emailId),
              SizedBox(height: 10.0),
              Center(
                child: SizedBox(
                  width: 250, // Adjust the width as needed
                  child: ElevatedButton(
                    onPressed: changeProfileStatus,
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Color.fromARGB(255, 36, 30, 30),
                    ),
                    child: const Text(
                      "Change to worker",
                      style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 230, 220, 220)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileTextBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String text;

  const ProfileTextBox({Key? key, required this.label, required this.icon, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon),
              SizedBox(width: 10.0),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 5.0),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.grey[200],
            ),
            child: Text(
              text,
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
    );
  }
}
