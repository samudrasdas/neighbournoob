import 'package:flutter/material.dart';
import 'package:NeighbourPro/global_vars.dart';
import 'package:NeighbourPro/api_client.dart';
import 'package:NeighbourPro/address_page.dart';

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
  String username = "";
  String email = "";

  get changeProfileStatus => null;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      // Step 1: Retrieve token and token type
      final globalToken = await getGlobalToken();
      final token = globalToken['token'];
      final tokenType = globalToken['tokenType'];

      // Step 2: Call API to fetch user data
      final userData = await APIService.fetchUserDataFromApi(token, tokenType);

      // Step 3: Update state with fetched user data
      setState(() {
        username = userData['username'];
        email = userData['email'];
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
Widget build(BuildContext context) {
  return WillPopScope(
    onWillPop: () async {
      Navigator.pushReplacementNamed(context, '/home');
      return false; // Prevent the default back navigation
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              SizedBox(height: 10), // Adjust the space between title and logo
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
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ProfileTextBox(label: 'Username', icon: Icons.person, text: username),
              SizedBox(height: 10.0),
              ProfileTextBox(label: 'Email ID', icon: Icons.email, text: email),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 120, // Adjust the width as needed
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to the address page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddressPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Color.fromARGB(255, 145, 144, 144),
                      ),
                      child: const Text(
                        "Add Address",
                        style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 120, // Adjust the width as needed
                    child: ElevatedButton(
                      onPressed: changeProfileStatus,
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Color.fromARGB(255, 99, 60, 60),
                      ),
                      child: const Text(
                        "Change to Worker",
                        style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
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
