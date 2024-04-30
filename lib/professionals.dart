import 'package:flutter/material.dart';
import 'package:myapp/api_client.dart';

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
    try {
      final List<Professional> professionals =
          await APIService.fetchProfessionals(widget.professionId, $token);
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
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              for (final professional in allProfessionals)
                Text(
                  '${professional.firstName} ${professional.lastName}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ]),
      ),
    );
  }
}
