import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(DailyJournalApp());
}

class DailyJournalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daily Journal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: JournalScreen(),
    );
  }
}

class JournalScreen extends StatefulWidget {
  @override
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final TextEditingController _controller = TextEditingController();
  List<String> _entries = [];

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _entries = prefs.getStringList('journalEntries') ?? [];
    });
  }

  Future<void> _saveEntry() async {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _entries.insert(0, _controller.text);
        _controller.clear();
      });
      final prefs = await SharedPreferences.getInstance();
      prefs.setStringList('journalEntries', _entries);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daily Journal')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Write your thoughts...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _saveEntry,
              child: Text('Save Entry'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _entries.isEmpty
                  ? Center(child: Text('No journal entries yet.'))
                  : ListView.builder(
                      itemCount: _entries.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(_entries[index],
                                style: TextStyle(fontSize: 16)),
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
