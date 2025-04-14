import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(LocationApp());
}

class LocationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Location Navigator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LocationScreen(),
    );
  }
}

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  void _openGoogleMaps() async {
  final pickup = Uri.encodeComponent(_pickupController.text);
  final destination = Uri.encodeComponent(_destinationController.text);
  final googleMapsUri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&origin=$pickup&destination=$destination');

  if (await canLaunchUrl(googleMapsUri)) {
    await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Could not launch Google Maps')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Google Maps Navigator')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _pickupController,
              decoration: InputDecoration(labelText: 'Pickup Location'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _destinationController,
              decoration: InputDecoration(labelText: 'Destination Location'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _openGoogleMaps,
              child: Text('Get Directions'),
            ),
          ],
        ),
      ),
    );
  }
}