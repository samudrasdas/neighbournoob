import 'package:flutter/material.dart';

// Define a class to represent a notification
class NotificationItem {
  final String title;
  final String message;
  final DateTime time;

  NotificationItem({required this.title, required this.message, required this.time});
}

// Define a class to represent a work booking
class WorkBooking {
  final String clientName;
  final DateTime startTime;
  final DateTime endTime;

  WorkBooking({required this.clientName, required this.startTime, required this.endTime});
}

// Sample data of notifications
List<NotificationItem> notifications = [
  NotificationItem(
    title: 'New Booking',
    message: 'You have a new appointment at 10:00 AM tomorrow.',
    time: DateTime.now().subtract(Duration(hours: 2)),
  ),
  NotificationItem(
    title: 'Reminder',
    message: 'Reminder: Your appointment is in 1 hour.',
    time: DateTime.now().subtract(Duration(minutes: 30)),
  ),
  NotificationItem(
    title: 'Cancelled Appointment',
    message: 'Your appointment at 3:00 PM has been cancelled.',
    time: DateTime.now().subtract(Duration(days: 1)),
  ),
];

// Sample data of work bookings
List<WorkBooking> workBookings = [
  WorkBooking(
    clientName: 'John Doe',
    startTime: DateTime.now().add(Duration(hours: 1)),
    endTime: DateTime.now().add(Duration(hours: 3)),
  ),
  WorkBooking(
    clientName: 'Alice Smith',
    startTime: DateTime.now().add(Duration(days: 1)),
    endTime: DateTime.now().add(Duration(days: 1, hours: 2)),
  ),
];

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Worker Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WorkerPage(),
    );
  }
}

class WorkerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Worker Page'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Notifications',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                var notification = notifications[index];
                return ListTile(
                  title: Text(notification.title),
                  subtitle: Text(notification.message),
                  trailing: Text(
                    '${notification.time.hour.toString().padLeft(2, '0')}:${notification.time.minute.toString().padLeft(2, '0')}',
                  ),
                );
              },
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Work Bookings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: workBookings.length,
              itemBuilder: (context, index) {
                var booking = workBookings[index];
                return ListTile(
                  title: Text('Client: ${booking.clientName}'),
                  subtitle: Text('Time: ${booking.startTime.hour.toString().padLeft(2, '0')}:${booking.startTime.minute.toString().padLeft(2, '0')} - ${booking.endTime.hour.toString().padLeft(2, '0')}:${booking.endTime.minute.toString().padLeft(2, '0')}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
