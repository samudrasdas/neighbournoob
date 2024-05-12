import 'package:flutter/material.dart';
import 'package:NeighbourPro/api_client.dart';
import 'package:NeighbourPro/global_vars.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BookedWorksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booked Works'),
      ),
      body: BookedWorksBody(),
    );
  }
}

class BookedWorksBody extends StatefulWidget {
  @override
  _BookedWorksBodyState createState() => _BookedWorksBodyState();
}

class _BookedWorksBodyState extends State<BookedWorksBody> {
  List<Works> bookedWorks = [];

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
          await APIService.fetchBookedWorks(token, tokenType);
      setState(() {
        bookedWorks = works;
      });
    } catch (e) {
      print('Error fetching booked works: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: bookedWorks.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Card(
            elevation: 3,
            child: ListTile(
              title: Text(
                bookedWorks[index].userDescription.trim(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Scheduled: ${bookedWorks[index].scheduledTime.substring(0, 5)} | Status: ${bookedWorks[index].status}',
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
                        BookedWorksDetailsPage(work: bookedWorks[index]),
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

class BookedWorksDetailsPage extends StatelessWidget {
  final Works work;

  const BookedWorksDetailsPage({required this.work});

  Future<void> writeReview(int workID, String review, double rating ) async {
    Map<String, String?> tokenData = await getGlobalToken();
    String token = tokenData['token'] as String;
    String tokenType = tokenData['tokenType'] as String;
    try {
      await APIService.writeReview(workID, review, rating, token, tokenType);
    } catch (e) {
      print('$e');
    }
  }

  Future<void> sentPayment(int workID) async {
    Map<String, String?> tokenData = await getGlobalToken();
    String token = tokenData['token'] as String;
    String tokenType = tokenData['tokenType'] as String;
    try {
      await APIService.sentPayment(workID, token, tokenType);
    } catch (e) {
      print('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isClosed = work.status == "closed";
    bool hasStarted = work.status == "started";
    double? rating;
    String? review;

    return Scaffold(
      appBar: AppBar(
        title: Text('Work Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(work.userDescription),
                    SizedBox(height: 16),
                    Text(
                      'Scheduled Time',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(work.scheduledTime.substring(0, 5)),
                    SizedBox(height: 16),
                    Text(
                      'Status',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(work.status),
                  ],
                ),
              ),
            ),
          ),
          if (isClosed)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () {
                  _showReviewDialog(context, (selectedRating, enteredReview) {
                    rating = selectedRating;
                    review = enteredReview;
                  });
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  minimumSize: MaterialStateProperty.all(
                      Size(double.infinity, 50.0)), // Button takes whole width
                ),
                child: Text('Write Review'),
              ),
            ),
          if (hasStarted)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () {
                  sentPayment(work.id);
                  Fluttertoast.showToast(
                    msg: 'Payment sent',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                  Navigator.popUntil(context, ModalRoute.withName('/home'));
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  minimumSize: MaterialStateProperty.all(
                      Size(double.infinity, 50.0)), // Button takes whole width
                ),
                child: Text('Sent Payment'),
              ),
            ),
        ],
      ),
    );
  }

  void _showReviewDialog(
      BuildContext context, Function(double, String) callback) {
    double? rating;
    String? review;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Write Review'),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    review = value;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your review',
                  ),
                  maxLines: null,
                ),
                SizedBox(height: 16),
                Text('Rating'),
                RatingBar.builder(
                  initialRating: 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemSize: 40,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (newRating) {
                    rating = newRating;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Perform action on review submission
                if (rating != null && review != null) {
                  callback(rating!, review!);
                  writeReview(work.id, review!, rating!);
                  Fluttertoast.showToast(
                    msg: 'Review submitted successfully',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                }
                Navigator.of(context).pop();
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
