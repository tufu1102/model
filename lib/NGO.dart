import 'package:flutter/material.dart';

void main() => runApp(NGOApp());

class NGOApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NGO App',
      home: DonorPage(),
    );
  }
}

class DonorPage extends StatefulWidget {
  @override
  _DonorPageState createState() => _DonorPageState();
}

class _DonorPageState extends State<DonorPage> {
  List<String> donors = [];
  TextEditingController donorController = TextEditingController();
  List<String> receivedServices = [];

  void _navigateToServicePage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServicePage(donors: donors),
      ),
    );

    if (result != null && result is List<String>) {
      setState(() {
        receivedServices.addAll(result);
      });

      _showServiceNotifications();
    }
  }

  void _showServiceNotifications() async {
    for (var donor in receivedServices) {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Notification'),
          content: Text('User has received a service from $donor!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            )
          ],
        ),
      );
    }
    receivedServices.clear(); // Clear after showing
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donor Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: donorController,
              decoration: InputDecoration(labelText: 'Enter Donor Name'),
            ),
            ElevatedButton(
              onPressed: () {
                if (donorController.text.isNotEmpty) {
                  setState(() {
                    donors.add(donorController.text.trim());
                    donorController.clear();
                  });
                }
              },
              child: Text('Add Donor'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _navigateToServicePage,
              child: Text('Go to Services Page'),
            ),
            SizedBox(height: 20),
            Text('Donors:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...donors.map((donor) => Text(donor)).toList(),
          ],
        ),
      ),
    );
  }
}

class ServicePage extends StatefulWidget {
  final List<String> donors;

  ServicePage({required this.donors});

  @override
  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  List<String> servicesReceived = [];

  void _getService(String donor) {
    setState(() {
      servicesReceived.add(donor);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Service received from $donor')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, servicesReceived);
        return false; // Prevent default pop, we handled it
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Services Page'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, servicesReceived);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: widget.donors.isEmpty
              ? Center(child: Text('No donors available.'))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Available Donors:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.donors.length,
                        itemBuilder: (context, index) {
                          final donor = widget.donors[index];
                          return ListTile(
                            title: Text(donor),
                            trailing: ElevatedButton(
                              onPressed: () => _getService(donor),
                              child: Text('Get Service'),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}