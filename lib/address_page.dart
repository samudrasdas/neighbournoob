import 'package:flutter/material.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:NeighbourPro/api_client.dart'; // Import the API service
import 'package:NeighbourPro/global_vars.dart';

class AddressPage extends StatefulWidget {
  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController houseController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();

  Future<void> _addAddress() async {
    Map<String, String?> tokenData = await getGlobalToken();
    String token = tokenData['token'] as String;
    String tokenType = tokenData['tokenType'] as String;
    try {
      await APIService.addAddress(
        phoneController.text,
        houseController.text,
        streetController.text,
        cityController.text,
        stateController.text,
        pinCodeController.text,
        latitudeController.text,
        longitudeController.text,
        token,
        tokenType,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: '$e',
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Address Page'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.0),
                TextFormField(
                  controller: houseController,
                  decoration: InputDecoration(
                    labelText: 'House Name',
                    prefixIcon: Icon(Icons.home),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'House Name is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: streetController,
                  decoration: InputDecoration(
                    labelText: 'Street Name',
                    prefixIcon: Icon(Icons.location_city),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Street Name is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.0),
                Row(
                  children: [
                    Flexible(
                      child: TextFormField(
                        controller: cityController,
                        decoration: InputDecoration(
                          labelText: 'City',
                          prefixIcon: Icon(Icons.location_city),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'City is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Flexible(
                      child: TextFormField(
                        controller: stateController,
                        decoration: InputDecoration(
                          labelText: 'State',
                          prefixIcon: Icon(Icons.location_city),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'State is required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  children: [
                    Flexible(
                      child: TextFormField(
                        controller: pinCodeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Pin Code',
                          prefixIcon: Icon(Icons.location_city),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Pin Code is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Flexible(
                      child: TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          prefixIcon: Icon(Icons.phone),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Phone Number is required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  children: [
                    Flexible(
                      child: TextFormField(
                        controller: latitudeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Latitude',
                          prefixIcon: Icon(Icons.location_on),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Latitude is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Flexible(
                      child: TextFormField(
                        controller: longitudeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Longitude',
                          prefixIcon: Icon(Icons.location_on),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Longitude is required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await _addAddress();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text('Add address'),
                    ),
                    SizedBox(width: 10.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AnotherPage(
                              latitudeController: latitudeController,
                              longitudeController: longitudeController,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text('Select on Map'),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AnotherPage extends StatefulWidget {
  final TextEditingController latitudeController;
  final TextEditingController longitudeController;

  const AnotherPage({
    Key? key,
    required this.latitudeController,
    required this.longitudeController,
  }) : super(key: key);

  @override
  _AnotherPageState createState() => _AnotherPageState();
}

class _AnotherPageState extends State<AnotherPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick location on map'),
      ),
      body: Center(
        child: OpenStreetMapSearchAndPick(
          locationPinIconColor: Color.fromARGB(255, 255, 62, 62),
          buttonTextStyle: const TextStyle(
            fontSize: 18,
            fontStyle: FontStyle.normal,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          buttonColor: Color.fromARGB(255, 0, 0, 0),
          buttonText: 'Set Current Location',
          onPicked: (pickedData) {
            setState(() {
              widget.latitudeController.text =
                  pickedData.latLong.latitude.toString();
              widget.longitudeController.text =
                  pickedData.latLong.longitude.toString();
            });
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
    );
  }
}
