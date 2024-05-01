import 'package:flutter/material.dart';
import 'package:myapp/api_client.dart';
import 'package:myapp/global_vars.dart';

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
            return Icon(Icons.star_border, color: Colors.grey, size: starSize);
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
          return Container(
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
          );
        },
      ),
    );
  }
}
