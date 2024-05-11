import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:NeighbourPro/api_client.dart';
import 'package:NeighbourPro/storage_service.dart';
import 'package:NeighbourPro/professionals.dart';
import 'package:NeighbourPro/global_vars.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

final storage = StorageService();

class _HomePageState extends State<HomePage> {
  List<String> recommendedProfessions = [];
  List<Profession> allProfessions = [];
  String role = "";

  @override
  void initState() {
    super.initState();
    fetchRecommendedProfessions();
    fetchProfessions();
    fetchUserData();
  }

  Future<void> fetchProfessions() async {
    try {
      final List<Profession> professions = await APIService.fetchProfessions();
      setState(() {
        allProfessions = professions;
      });
    } catch (e) {
      print('Error fetching professions: $e');
    }
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
        role = userData['role'];
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> fetchRecommendedProfessions() async {
    try {
      Map<String, dynamic> globalToken = await getGlobalToken();
      final token = globalToken['token'];
      final tokenType = globalToken['tokenType'];
      final List<String> professions =
          await APIService.fetchRecommendedProfessions(token, tokenType);
      setState(() {
        recommendedProfessions = professions;
      });
    } catch (e) {
      print('Error fetching recommended professions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'NeighbourPro',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 18, // Elevation for shadow effect
        shadowColor: Colors.grey, // Shadow color
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                _showPopupMenu(context); // Show dropdown menu
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'What are you looking for today?',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          prefixIcon: Icon(Icons.search), // Using search icon
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 22),
                recommendedProfessions.isNotEmpty
                    ? CarouselSlider(
                        items: recommendedProfessions.map((profession) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(horizontal: 9.0),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 10, 10, 10),
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Center(
                                  child: Text(
                                    profession,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: const Color.fromARGB(
                                          255, 238, 237, 237),
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                        options: CarouselOptions(
                            height: 150,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            pauseAutoPlayOnTouch: true,
                            enlargeCenterPage: true,
                            scrollDirection: Axis.horizontal,
                            viewportFraction: 0.8),
                      )
                    : Text(
                        'You can search for friendly neighbourhood professionals',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: const Color.fromARGB(255, 238, 237, 237),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
              ],
            ),
          ),
          if (recommendedProfessions.isEmpty || allProfessions.isEmpty)
            Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else
            Expanded(
              child: Container(
                color: const Color.fromARGB(255, 255, 255, 255),
                padding: EdgeInsets.all(16.0),
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  children: [
                    for (final profession in allProfessions)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfessionDetailPage(
                                professionName: profession.name,
                                professionId: profession.id,
                              ),
                            ),
                          );
                        },
                        child: ProfessionCard(
                          id: profession.id,
                          title: profession.name,
                          icon: Icons.work,
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Material(
        elevation: 18, // Elevation for shadow effect
        shadowColor: Colors.grey, // Shadow color
        child: CustomBottomNavigationBar(role: role,),
      ),
    );
  }

  void _showPopupMenu(BuildContext context) {
    final RenderBox bar = context.findRenderObject() as RenderBox;
    final Offset position =
        bar.localToGlobal(Offset.zero) + Offset(0.0, kToolbarHeight);
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        position & Size(50, 50), // smaller rect, the popup itself
        Offset.zero & overlay.size, // Bigger rect, the entire screen
      ),
      items: [
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              storage.deleteToken();
              Fluttertoast.showToast(msg: "Logout Successful");
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ),
      ],
    );
  }
}

class ProfessionCard extends StatelessWidget {
  final int id;
  final String title;
  final IconData icon;

  const ProfessionCard(
      {required this.id, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.black,
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final String role;

  const CustomBottomNavigationBar({required this.role});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: const Color.fromARGB(255, 255, 255, 255),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications),
            color: Colors.black,
            onPressed: () {
              print('Notifications icon pressed');
            },
          ),
          IconButton(
            icon: Icon(Icons.history),
            color: Colors.black,
            onPressed: () {
              Navigator.pushNamed(context, '/history');
            },
          ),
          if (role == 'worker')
            IconButton(
              icon: Icon(Icons.work),
              color: Colors.black,
              onPressed: () {
                Navigator.pushNamed(context, '/worker');
              },
            ),
        ],
      ),
    );
  }
}
