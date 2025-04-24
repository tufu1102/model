import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(PlantCareApp());

class PlantCareApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plant Care',
      theme: ThemeData(primarySwatch: Colors.green),
      home: PlantCareHome(),
    );
  }
}

class PlantNote {
  final String name;
  final int waterFrequency;
  final String sunRequirement;
  Timer? timer;

  PlantNote(this.name, this.waterFrequency, this.sunRequirement);
}

class PlantCareHome extends StatefulWidget {
  @override
  _PlantCareHomeState createState() => _PlantCareHomeState();
}

class _PlantCareHomeState extends State<PlantCareHome> {
  final _nameController = TextEditingController();
  final _freqController = TextEditingController();
  final _sunController = TextEditingController();

  final List<PlantNote> _plantNotes = [];
  final List<String> _alertQueue = [];
  bool _isDialogShowing = false;

  @override
  void dispose() {
    _nameController.dispose();
    _freqController.dispose();
    _sunController.dispose();
    _plantNotes.forEach((note) => note.timer?.cancel());
    super.dispose();
  }

  void _addPlantNote() {
    final name = _nameController.text.trim();
    final freqStr = _freqController.text.trim();
    final sun = _sunController.text.trim();

    if (name.isEmpty || freqStr.isEmpty || sun.isEmpty) return;

    final frequency = int.tryParse(freqStr);
    if (frequency == null || frequency <= 0) return;

    final newNote = PlantNote(name, frequency, sun);
    newNote.timer = Timer.periodic(Duration(seconds: frequency), (timer) {
      _queueAlert("You should water your plant \"$name\"");
    });

    setState(() {
      _plantNotes.add(newNote);
      _nameController.clear();
      _freqController.clear();
      _sunController.clear();
    });
  }

  void _queueAlert(String message) {
    _alertQueue.add(message);
    if (!_isDialogShowing) _showNextAlert();
  }

  void _showNextAlert() {
    if (_alertQueue.isEmpty) {
      _isDialogShowing = false;
      return;
    }

    _isDialogShowing = true;
    String message = _alertQueue.removeAt(0);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text("Reminder"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showNextAlert();
            },
            child: Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Plant Care System")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Plant Name'),
            ),
            TextField(
              controller: _freqController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Water Frequency (seconds)'),
            ),
            TextField(
              controller: _sunController,
              decoration: InputDecoration(labelText: 'Sun Requirement'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addPlantNote,
              child: Text("Add Plant"),
            ),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: _plantNotes.length,
                itemBuilder: (context, index) {
                  final plant = _plantNotes[index];
                  return ListTile(
                    title: Text(plant.name),
                    subtitle: Text(
                      'Water every ${plant.waterFrequency}s, Sun: ${plant.sunRequirement}',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
