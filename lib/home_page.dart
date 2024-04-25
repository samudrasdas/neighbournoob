import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:myapp/api_client.dart'; // Import the API service

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  List<String> recommendedProfessions = [];

  @override
  void initState() {
    super.initState();
    fetchRecommendedProfessions();
  }

  Future<void> fetchRecommendedProfessions() async {
    try {
      final List<String> professions = await APIService.fetchRecommendedProfessions();
      // print('Recommended Professions: $professions');
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
              Navigator.pushReplacementNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
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
                SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    height: 150,
                    width: MediaQuery.of(context).size.width * 1,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 10, 10, 10),
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: recommendedProfessions.isNotEmpty
                          ? Marquee(
                              text: recommendedProfessions.join('    •    '),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: const Color.fromARGB(255, 238, 237, 237),
                                fontStyle: FontStyle.italic,
                              ),
                              scrollAxis: Axis.horizontal,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              blankSpace: 20.0,
                              velocity: 30.0,
                              pauseAfterRound: Duration(seconds: 1),
                              startPadding: 10.0,
                              accelerationDuration: Duration(seconds: 1),
                              accelerationCurve: Curves.linear,
                              decelerationDuration: Duration(milliseconds: 500),
                              decelerationCurve: Curves.easeOut,
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
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: const Color.fromARGB(255, 255, 255, 255),
              padding: EdgeInsets.all(16.0),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                children: [
                  ProfessionCard(
                    title: 'Plumber',
                    icon: Icons.plumbing,
                  ),
                  ProfessionCard(
                    title: 'Electrician',
                    icon: Icons.lightbulb,
                  ),
                  ProfessionCard(
                    title: 'Climber',
                    icon: Icons.nature,
                  ),
                  ProfessionCard(
                    title: 'Babysitter',
                    icon: Icons.child_care,
                  ),
                  ProfessionCard(
                    title: 'Mechanic',
                    icon: Icons.build,
                  ),
                  ProfessionCard(
                    title: 'Gardener',
                    icon: Icons.eco,
                  ),
                ],
              ),
            ),
          ),
          // Recommended professions section
        ],
      ),
      bottomNavigationBar: Material(
        elevation: 18, // Elevation for shadow effect
        shadowColor: Colors.grey, // Shadow color
        child: CustomBottomNavigationBar(),
      ),
    );
  }

  void _showPopupMenu(BuildContext context) {
    final RenderBox bar = context.findRenderObject() as RenderBox;
    final Offset position = bar.localToGlobal(Offset.zero) + Offset(0.0, kToolbarHeight);
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
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
              // Handle logout here
            },
          ),
        ),
      ],
    );
  }
}

class ProfessionCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const ProfessionCard({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.all(8),
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
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: const Color.fromARGB(255, 255, 255, 255),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            color: Colors.black,
            onPressed: () {
              print('List icon pressed');
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            color: Colors.black,
            onPressed: () {
              print('Notifications icon pressed');
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            color: Colors.black,
            onPressed: () {
              print('Settings icon pressed');
            },
          ),
          IconButton(
            icon: Icon(Icons.work),
            color: Colors.black,
            onPressed: () {
              print('Worker icon pressed');
            },
          ),
        ],
      ),
    );
  }
}