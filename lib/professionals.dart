import 'package:flutter/material.dart';
import 'package:NeighbourPro/api_client.dart';
import 'package:NeighbourPro/global_vars.dart';
import 'package:NeighbourPro/shedule_work.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final double starSize;

  RatingStars({required this.rating, this.starSize = 24.0});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (index) {
          if (index < rating) {
            return Icon(Icons.star, color: Colors.yellow, size: starSize);
          } else {
            return Icon(Icons.star_border,
                color: Color.fromARGB(255, 131, 131, 131), size: starSize);
          }
        },
      ),
    );
  }
}

class ProfessionDetailPage extends StatefulWidget {
  final String professionName;
  final int professionId;

  ProfessionDetailPage(
      {required this.professionId, required this.professionName});

  @override
  _ProfessionDetailPageState createState() => _ProfessionDetailPageState();
}

class _ProfessionDetailPageState extends State<ProfessionDetailPage> {
  List<Professional> allProfessionals = [];

  @override
  void initState() {
    super.initState();
    fetchProfessionals();
  }

  Future<void> fetchProfessionals() async {
    Map<String, String?> tokenData = await getGlobalToken();
    String token = tokenData['token'] as String;
    String tokenType = tokenData['tokenType'] as String;
    try {
      final List<Professional> professionals =
          await APIService.fetchProfessionals(
              widget.professionId, token, tokenType);
      setState(() {
        allProfessionals = professionals;
      });
    } catch (e) {
      print('Error fetching professionals: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Look for ${widget.professionName}s near you'),
      ),
      body: ListView.builder(
        itemCount: allProfessionals.length,
        itemBuilder: (BuildContext context, int index) {
          final professional = allProfessionals[index];
          String formattedDistance = professional.distance.toStringAsFixed(1);
          return GestureDetector(
            onTap: () {
              print(professional.avgRating);
              // Navigate to another screen when a worker widget is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkerDetailPage(
                    professional: professional,
                    professionID: widget.professionId,
                  ),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 252, 255),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 231, 231, 231),
                    blurRadius: 4,
                    offset: Offset(4, 5), // Shadow position
                  ),
                ],
              ),
              child: ListTile(
                leading: Icon(Icons.account_circle, size: 64),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${professional.firstName} ${professional.lastName}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    RatingStars(rating: professional.avgRating),
                    Text(
                      '$formattedDistance Km(s) away',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class WorkerDetailPage extends StatelessWidget {
  final Professional professional;
  final int professionID;

  WorkerDetailPage({required this.professional, required this.professionID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Worker Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile photo section
          Container(
            height: MediaQuery.of(context).size.height / 3,
            child: Center(
              child: Icon(
                Icons.account_circle,
                size: 300,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ),
          // Separator with drop shadow
          Container(
            height: 1,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 204, 204, 204).withOpacity(.2),
                  spreadRadius: 5,
                  blurRadius: 4,
                  offset: Offset(2, 10),
                ),
              ],
            ),
          ),
          // Bio part (scrollable)
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${professional.firstName} ${professional.lastName}',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 56, 56, 56),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Hourly Rate: ₹${professional.hourlyRate}',
                        style: TextStyle(fontSize: 20, color: Colors.green),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  RatingStars(rating: professional.avgRating),
                  SizedBox(height: 10),
                  Text('About me',
                      style: TextStyle(
                          fontSize: 22,
                          color: const Color.fromARGB(255, 102, 102, 102))),
                  Text(
                    professional.workerBio,
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          // Hire button
          HireButton(professional: professional, professionID: professionID),
        ],
      ),
    );
  }
}

class HireButton extends StatelessWidget {
  final Professional professional;
  final int professionID;

  HireButton({required this.professional, required this.professionID});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      // color: Colors.white,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              Colors.green), // Set the background color to green
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(8), // Adjust the radius as needed
            ),
          ),
        ),
        onPressed: () {
          // Navigate to the confirmation page when the button is pressed
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ScheduleWorkPage(
                      professionalID: professional.id,
                      professionID: professionID,
                    )), // Instantiate the confirmation page
          );
        },
        child: Text(
          'Hire for work',
          style: TextStyle(
              fontSize: 18, color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
    );
  }
}
