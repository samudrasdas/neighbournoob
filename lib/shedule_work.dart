import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:NeighbourPro/api_client.dart';
import 'package:NeighbourPro/global_vars.dart';

class ScheduleWorkPage extends StatefulWidget {
  final int professionalID;
  final int professionID;

  ScheduleWorkPage({
    required this.professionalID,
    required this.professionID,
  });

  @override
  _ScheduleWorkPageState createState() => _ScheduleWorkPageState();
}

class _ScheduleWorkPageState extends State<ScheduleWorkPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _dateController.text = pickedDate.toString().split(' ')[0];
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        // Convert the picked time to 24-hour format
        final String formattedTime =
            _formatTimeTo24Hours(pickedTime.hour, pickedTime.minute);
        _timeController.text = formattedTime;
      });
    }
  }

  String _formatTimeTo24Hours(int hour, int minute) {
    String period = 'AM';
    if (hour >= 12) {
      period = 'PM';
      hour = hour - 12;
    }
    if (hour == 0) {
      hour = 12;
    }
    String hourStr = hour < 10 ? '0$hour' : '$hour';
    String minuteStr = minute < 10 ? '0$minute' : '$minute';
    return '$hourStr:$minuteStr $period';
  }

  String _convertTo24Hour(String time) {
    final List<String> parts = time.split(' ');
    final String hourMinute = parts[0];
    final String period = parts[1];
    final List<String> hourMinuteParts = hourMinute.split(':');
    int hour = int.parse(hourMinuteParts[0]);
    final int minute = int.parse(hourMinuteParts[1]);
    
    if (period.toUpperCase() == 'PM' && hour != 12) {
      hour += 12;
    } else if (period.toUpperCase() == 'AM' && hour == 12) {
      hour = 0;
    }

    final String hourStr = hour < 10 ? '0$hour' : '$hour';
    final String minuteStr = minute < 10 ? '0$minute' : '$minute';
    return '$hourStr:$minuteStr';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Work'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _dateController,
                readOnly: true, // Make the field read-only
                decoration: InputDecoration(
                  labelText: 'Date',
                  suffixIcon: IconButton(
                    onPressed: () => _selectDate(context),
                    icon: Icon(Icons.calendar_today),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _timeController,
                readOnly: true, // Make the field read-only
                decoration: InputDecoration(
                  labelText: 'Time',
                  suffixIcon: IconButton(
                    onPressed: () => _selectTime(context),
                    icon: Icon(Icons.access_time),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a time';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Map<String, String?> tokenData = await getGlobalToken();
                    String token = tokenData['token'] as String;
                    String tokenType = tokenData['tokenType'] as String;

                    final String date = _dateController.text;
                    final String time = _convertTo24Hour(_timeController.text); // Convert time to 24-hour format
                    final String description = _descriptionController.text;
                    final int professionID = widget.professionID;

                    try {
                      await APIService.scheduleWork(
                        description,
                        date,
                        time,
                        widget.professionalID,
                        professionID,
                        tokenType,
                        token,
                      );
                      Fluttertoast.showToast(
                        msg: 'Work scheduled successfully',
                      );
                      Navigator.of(context).pop();
                    } catch (e) {
                      Fluttertoast.showToast(
                        msg: 'Failed to schedule work: $e',
                      );
                    }
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.green), // Set button color to green
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          8), // Adjust the radius as needed
                    ),
                  ),
                ),
                child: Text('Schedule Work',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
