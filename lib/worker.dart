import 'dart:async';
import 'package:flutter/material.dart';
import 'package:NeighbourPro/api_client.dart';
import 'package:NeighbourPro/global_vars.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

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
      final List<Works> works =
          await APIService.fetchAssignedWorks(token, tokenType);
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
                    builder: (context) =>
                        WorkDetailsPage(work: assignedWorks[index]),
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
  final TextEditingController _costController = TextEditingController();

  WorkDetailsPage({required this.work});
  Future<bool> acceptWork() async {
    Map<String, String?> tokenData = await getGlobalToken();
    String token = tokenData['token'] as String;
    String tokenType = tokenData['tokenType'] as String;
    try {
      final bool accepted =
          await APIService.acceptWork(work.id, token, tokenType);
      return accepted;
    } catch (e) {
      print('error in accepting work: $e');
      return false;
    }
  }

  Future<bool> startWork() async {
    Map<String, String?> tokenData = await getGlobalToken();
    String token = tokenData['token'] as String;
    String tokenType = tokenData['tokenType'] as String;
    try {
      final bool started = await APIService.startWork(work.id, token, tokenType);
      return started;
    } catch (e) {
      print('error in starting work: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> fetchClientDetails() async {
    Map<String, String?> tokenData = await getGlobalToken();
    String token = tokenData['token'] as String;
    String tokenType = tokenData['tokenType'] as String;
    try {
      final Map<String, dynamic> clientDetails =
          await APIService.fetchClientDetails(work.id, token, tokenType);
      // final String latitude = clientDetails['latitude'];
      // final String longitude = clientDetails['longitude'];
      print(clientDetails);
      return clientDetails;
    } catch (e) {
      print('error in fetching client details: $e');
      throw e;
    }
  }

  Future<bool> finalCost(double cost) async {
    Map<String, String?> tokenData = await getGlobalToken();
    String token = tokenData['token'] as String;
    String tokenType = tokenData['tokenType'] as String;
    try {
      final bool costResult = await APIService.finalCost(work.id, cost, token, tokenType);
      return costResult;
    } catch (e) {
      print('error in final cost: $e');
      return false;
    } 
  }
   Future<void> _showCostInputDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Quote final cost'),
          content: TextField(
            controller: _costController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Cost'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Submit'),
              onPressed: () {
                double cost = double.tryParse(_costController.text) ?? 0.0;
                finalCost(cost);
                Fluttertoast.showToast(
                  msg: "Cost submitted successfully",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  fontSize: 16.0,
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> rejectWork() async {
    Map<String, String?> tokenData = await getGlobalToken();
    String token = tokenData['token'] as String;
    String tokenType = tokenData['tokenType'] as String;
    try {
      final bool rejected = await APIService.rejectWork(work.id, token, tokenType);
      return rejected;
    } catch (e) {
      print('error in rejecting work: $e');
      return false;
    }
  }

  static void launchGoogleMaps(latitude, longitude,
      {LaunchMode linkLaunchMode = LaunchMode.externalApplication}) async {
    // Construct the URL with the specified latitude and longitude
    var url = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=${latitude},${longitude}');

    // Check if the URL can be launched

    // Check if the URL can be launched
    if (await canLaunchUrl(url)) {
      // Launch the URL
      await launchUrl(url);
    } else {
      // Handle the case when the URL cannot be+ launched
      print('Could not launch $url');
    }
  }

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
            SizedBox(height: 16),
            if (work.status == 'pending') ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // Call acceptWork function from API
                      try {
                        final bool accepted = await acceptWork();
                        if (accepted) {
                          // Work accepted successfully
                          // You can perform further actions such as navigation or UI updates
                          print('Work accepted successfully');
                        } else {
                          // Handle case when work was not accepted
                          print('Work was not accepted');
                        }
                      } catch (e) {
                        // Handle API call error
                        print('Error accepting work: $e');
                      }
                    },
                    child: Text('Accept'),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        final Map<String, dynamic> clientDetails =
                            await fetchClientDetails();
                        final String latitude = clientDetails['latitude'];
                        final String longitude = clientDetails['longitude'];
                        launchGoogleMaps(latitude, longitude);
                      },
                    child: Text('Accept and Start Now'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Confirm cancellation"),
                            content:
                                Text("Do you need to cancel this booking?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: Text(
                                  "Go back",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async{
                                  // Call rejectWork function from API
                                  try {
                                    final bool rejected = await rejectWork();
                                    if (rejected) {
                                      // Work rejected successfully
                                      // You can perform further actions such as navigation or UI updates
                                      print('Work rejected successfully');
                                    } else {
                                      // Handle case when work was not rejected
                                      print('Work was not rejected');
                                    }
                                  } catch (e) {
                                    // Handle API call error
                                    print('Error rejecting work: $e');
                                  }
                                  // Implement cancel logic
                                  // This could involve calling a function to cancel the booking
                                  // and navigating back to the previous page
                                  
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.red),
                                ),
                                child: Text("Decline"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text('Decline'),
                  ),
                ],
              ),
            ],
            // Show Start Now button only if the work status is 'accepted'
            if (work.status == 'accepted') ...[
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .center, // Align buttons in the center horizontally
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final Map<String, dynamic> clientDetails =
                            await fetchClientDetails();
                        final String latitude = clientDetails['latitude'];
                        final String longitude = clientDetails['longitude'];
                        launchGoogleMaps(latitude, longitude);
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(150, 50), // Adjust size as needed
                      ),
                      child: Text(
                        'Navigate',
                        style: TextStyle(
                            fontSize: 18), // Adjust font size as needed
                      ),
                    ),
                    SizedBox(width: 16), // Add some space between buttons
                    ElevatedButton(
                      onPressed: () async{
                        // Implement start work logic
                        //startwork function call
                        final bool started = await startWork();
                        if (started) {
                          // Work started successfully
                          // You can perform further actions such as navigation or UI updates
                          print('Work started successfully');
                          
                        } else {
                          // Handle case when work was not started
                          print('Work was not started');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(150, 50), // Adjust size as needed
                      ),
                      child: Text(
                        'Start Work',
                        style: TextStyle(
                            fontSize: 18), // Adjust font size as needed
                      ),
                    ),
                  ],                  
                ),
              ),
            ],
            if (work.status == 'started') ...[
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Implement logic to show cost
                  ///take cost input
                  _showCostInputDialog(context);

                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(150, 50), // Adjust size as needed
                ),
                child: Text(
                  'Cost',
                  style: TextStyle(
                      fontSize: 18), // Adjust font size as needed
                ),
              ),
            ),
          ],
          ],
        ),
      ),
    );
  }
}
