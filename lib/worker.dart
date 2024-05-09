import 'package:flutter/material.dart';
import 'package:NeighbourPro/api_client.dart';
import 'package:NeighbourPro/global_vars.dart';

class AssignedWorksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assigned Works'),
      ),
      body: AssignedWorksBody(),
    );
  }
}

class AssignedWorksBody extends StatefulWidget {
  @override
  _AssignedWorksBodyState createState() => _AssignedWorksBodyState();
}

class _AssignedWorksBodyState extends State<AssignedWorksBody> {
  List<Works> assignedWorks = [];

  @override
  void initState() {
    super.initState();
    fetchAssignedWorks();
  }

  Future<void> fetchAssignedWorks() async {
    Map<String, String?> tokenData = await getGlobalToken();
    String token = tokenData['token'] as String;
    String tokenType = tokenData['tokenType'] as String;
    try {
      final List<Works> works = await APIService.fetchAssignedWorks(token, tokenType);
      setState(() {
        assignedWorks = works;
      });
    } catch (e) {
      print('Error fetching assigned works: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: assignedWorks.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Card(
            elevation: 3,
            child: ListTile(
              title: Text(
                assignedWorks[index].userDescription.trim(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Scheduled: ${assignedWorks[index].scheduledTime.substring(0, 5)} | Status: ${assignedWorks[index].status}',
                style: TextStyle(color: Colors.grey),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkDetailsPage(work: assignedWorks[index]),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class WorkDetailsPage extends StatelessWidget {
  final Works work;

  WorkDetailsPage({required this.work});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Work Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Description:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Text(
              work.userDescription,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Scheduled Date:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '${work.scheduledDate} ${work.scheduledTime.substring(0, 5)}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Status:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Text(
              work.status,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
