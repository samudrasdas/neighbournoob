import 'package:flutter/material.dart';
import 'package:NeighbourPro/global_vars.dart';
import 'package:NeighbourPro/api_client.dart';
import 'package:NeighbourPro/address_page.dart';
import 'package:NeighbourPro/storage_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

final storage = StorageService();

class _ProfileBodyState extends State<ProfileBody> {
  String username = "";
  String email = "";
  String role = "";

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
        role = userData['role'];
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 20),
        Stack(
          children: [
            CircleAvatar(
              radius: 70,
              backgroundColor: Colors.black,
              child: Text(
                "NP",
                style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              ProfileTextBox(
                  label: 'Username', icon: Icons.person, text: username),
              SizedBox(height: 10.0),
              ProfileTextBox(label: 'Email ID', icon: Icons.email, text: email),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the address page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddressPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Add Address",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  if (role == 'user') // Check if role is 'user'
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to the worker page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SwitchToWorkerPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        // primary: Colors.white,
                      ),
                      child: Text(
                        "Change to Worker",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ProfileTextBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String text;

  const ProfileTextBox(
      {Key? key, required this.label, required this.icon, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
          padding: EdgeInsets.all(16),
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
    );
  }
}

class SwitchToWorkerPage extends StatefulWidget {
  @override
  _SwitchToWorkerPageState createState() => _SwitchToWorkerPageState();
}

class _SwitchToWorkerPageState extends State<SwitchToWorkerPage> {
  List<Profession> allProfessions = [];
  Profession? selectedProfession;
  String workerBio = '';
  double hourlyRate = 0.0;
  String token = '';
  String tokenType = '';

  Future<void> fetchProfessions() async {
    Map<String, String?> tokenData = await getGlobalToken();
    token = tokenData['token'] as String;
    tokenType = tokenData['tokenType'] as String;
    try {
      final List<Profession> professions = await APIService.fetchProfessions();
      setState(() {
        allProfessions = professions;
      });
    } catch (e) {
      print('Error fetching professions: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProfessions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Worker Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.black),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: SingleChildScrollView(
                child: DropdownButton<Profession>(
                  value: selectedProfession,
                  items: allProfessions.map((Profession profession) {
                    return DropdownMenuItem<Profession>(
                      value: profession,
                      child: Padding(
                        padding: EdgeInsets.all(8.0), // Add padding here
                        child: Text(
                          profession.name,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (Profession? newValue) {
                    setState(() {
                      selectedProfession = newValue;
                    });
                  },
                  hint: Padding(
                    padding: EdgeInsets.all(8.0), // Add padding here
                    child: Text(
                      'Select a profession',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  isExpanded: true,
                  elevation: 2,
                  underline: Container(
                    height: 0,
                  ),
                  // Limit the height of the dropdown
                  itemHeight: 50,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                setState(() {
                  workerBio = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Worker Bio',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                setState(() {
                  hourlyRate = double.tryParse(value) ?? 0.0;
                });
              },
              decoration: InputDecoration(
                labelText: 'Hourly Rate',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await APIService.switchToProfessional(token, tokenType,
                        selectedProfession!.id, workerBio, hourlyRate);
                    Fluttertoast.showToast(msg: 'Switched to worker, please log back in');
                    storage.deleteToken();
                    Navigator.pushReplacementNamed(context, '/login');
                  } catch (e) {
                    Fluttertoast.showToast(msg: '$e');
                  }
                },
                child: Text(
                  'Apply',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
