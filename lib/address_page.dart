import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AddressPage(),
    );
  }
}

class AddressPage extends StatefulWidget {
  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  // Define text controllers for each text field
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController houseNameController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed
    phoneNumberController.dispose();
    houseNameController.dispose();
    streetController.dispose();
    cityController.dispose();
    stateController.dispose();
    pincodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Address'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextBox(
              label: 'Phone Number',
              keyboardType: TextInputType.phone,
              controller: phoneNumberController,
            ),
            SizedBox(height: 20.0),
            TextBox(
              label: 'House Name',
              controller: houseNameController,
            ),
            SizedBox(height: 20.0),
            TextBox(
              label: 'Street',
              controller: streetController,
            ),
            SizedBox(height: 20.0),
            TextBox(
              label: 'City',
              controller: cityController,
            ),
            SizedBox(height: 20.0),
            TextBox(
              label: 'State',
              controller: stateController,
            ),
            SizedBox(height: 20.0),
            TextBox(
              label: 'Pincode',
              keyboardType: TextInputType.number,
              controller: pincodeController,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Access text from controllers
                final phoneNumber = phoneNumberController.text;
                final houseName = houseNameController.text;
                final street = streetController.text;
                final city = cityController.text;
                final state = stateController.text;
                final pincode = pincodeController.text;

                // Add functionality to save address
                // You can use the text obtained from the controllers here to make API calls or perform any other actions.
              },
              child: Text('Save Address'),
            ),
          ],
        ),
      ),
    );
  }
}

class TextBox extends StatelessWidget {
  final String label;
  final TextInputType keyboardType;
  final TextEditingController controller; // Add controller property

  const TextBox({
    Key? key,
    required this.label,
    this.keyboardType = TextInputType.text,
    required this.controller, // Required controller parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      controller: controller, // Assign the provided controller
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }
}
