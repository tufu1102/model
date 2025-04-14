import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(TicketBookingApp());

class TicketBookingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ticket Booking',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: TicketListScreen(),
    );
  }
}

class Ticket {
  String destination;
  String passenger;
  DateTime journeyDate;

  Ticket({required this.destination, required this.passenger, required this.journeyDate});

  Map<String, dynamic> toJson() => {
        'destination': destination,
        'passenger': passenger,
        'journeyDate': journeyDate.toIso8601String(),
      };

  static Ticket fromJson(Map<String, dynamic> json) => Ticket(
        destination: json['destination'],
        passenger: json['passenger'],
        journeyDate: DateTime.parse(json['journeyDate']),
      );
}

class TicketListScreen extends StatefulWidget {
  @override
  _TicketListScreenState createState() => _TicketListScreenState();
}

class _TicketListScreenState extends State<TicketListScreen> {
  List<Ticket> tickets = [];

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  Future<void> _loadTickets() async {
    final prefs = await SharedPreferences.getInstance();
    final ticketData = prefs.getStringList('tickets') ?? [];
    setState(() {
      tickets = ticketData.map((e) => Ticket.fromJson(json.decode(e))).toList();
    });
  }

  Future<void> _saveTickets() async {
    final prefs = await SharedPreferences.getInstance();
    final ticketData = tickets.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('tickets', ticketData);
  }

  void _addOrEditTicket({Ticket? ticket, int? index}) async {
    final result = await Navigator.push<Ticket>(
      context,
      MaterialPageRoute(
        builder: (context) => TicketFormScreen(ticket: ticket),
      ),
    );

    if (result != null) {
      setState(() {
        if (index != null) {
          tickets[index] = result;
        } else {
          tickets.add(result);
        }
      });
      _saveTickets();
    }
  }

  void _deleteTicket(int index) {
    setState(() {
      tickets.removeAt(index);
    });
    _saveTickets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tickets'),
      ),
      body: ListView.builder(
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          final ticket = tickets[index];
          return ListTile(
            title: Text('${ticket.passenger} - ${ticket.destination}'),
            subtitle: Text('Journey: ${DateFormat.yMMMd().format(ticket.journeyDate)}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _addOrEditTicket(ticket: ticket, index: index),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteTicket(index),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditTicket(),
        child: Icon(Icons.add),
      ),
    );
  }
}

class TicketFormScreen extends StatefulWidget {
  final Ticket? ticket;
  TicketFormScreen({this.ticket});

  @override
  _TicketFormScreenState createState() => _TicketFormScreenState();
}

class _TicketFormScreenState extends State<TicketFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _destinationController;
  late TextEditingController _passengerController;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _destinationController = TextEditingController(text: widget.ticket?.destination ?? '');
    _passengerController = TextEditingController(text: widget.ticket?.passenger ?? '');
    _selectedDate = widget.ticket?.journeyDate ?? DateTime.now();
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final newTicket = Ticket(
        destination: _destinationController.text,
        passenger: _passengerController.text,
        journeyDate: _selectedDate,
      );
      Navigator.pop(context, newTicket);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ticket == null ? 'Add Ticket' : 'Edit Ticket'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _destinationController,
                decoration: InputDecoration(labelText: 'Destination'),
                validator: (value) => value!.isEmpty ? 'Enter destination' : null,
              ),
              TextFormField(
                controller: _passengerController,
                decoration: InputDecoration(labelText: 'Passenger Name'),
                validator: (value) => value!.isEmpty ? 'Enter passenger name' : null,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text('Journey Date: ${DateFormat.yMMMd().format(_selectedDate)}'),
                  ),
                  TextButton(
                    onPressed: _pickDate,
                    child: Text('Select Date'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Save Ticket'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}