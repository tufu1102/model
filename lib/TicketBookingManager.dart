import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(TicketBookingApp());
}

class TicketBookingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ticket Booking',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TicketListScreen(),
    );
  }
}

class Ticket {
  String name;
  String destination;
  DateTime journeyDate;

  Ticket({required this.name, required this.destination, required this.journeyDate});
}

class TicketListScreen extends StatefulWidget {
  @override
  _TicketListScreenState createState() => _TicketListScreenState();
}

class _TicketListScreenState extends State<TicketListScreen> {
  List<Ticket> tickets = [];

  void _addOrEditTicket({Ticket? ticket, int? index}) async {
    final result = await showDialog<Ticket>(
      context: context,
      builder: (context) => TicketDialog(ticket: ticket),
    );
    if (result != null) {
      setState(() {
        if (index != null) {
          tickets[index] = result;
        } else {
          tickets.add(result);
        }
      });
    }
  }

  void _deleteTicket(int index) {
    setState(() {
      tickets.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ticket Booking')),
      body: tickets.isEmpty
          ? Center(child: Text('No tickets booked'))
          : ListView.builder(
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                final ticket = tickets[index];
                return Card(
                  child: ListTile(
                    title: Text(ticket.name),
                    subtitle: Text('${ticket.destination}\n${DateFormat('yyyy-MM-dd').format(ticket.journeyDate)}'),
                    onTap: () => _addOrEditTicket(ticket: ticket, index: index),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteTicket(index),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _addOrEditTicket(),
      ),
    );
  }
}

class TicketDialog extends StatefulWidget {
  final Ticket? ticket;
  TicketDialog({this.ticket});

  @override
  _TicketDialogState createState() => _TicketDialogState();
}

class _TicketDialogState extends State<TicketDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _destinationController;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.ticket?.name ?? '');
    _destinationController = TextEditingController(text: widget.ticket?.destination ?? '');
    _selectedDate = widget.ticket?.journeyDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _saveTicket() {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      final newTicket = Ticket(
        name: _nameController.text,
        destination: _destinationController.text,
        journeyDate: _selectedDate!,
      );
      Navigator.pop(context, newTicket);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.ticket == null ? 'Book Ticket' : 'Edit Ticket'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Passenger Name'),
              validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
            ),
            TextFormField(
              controller: _destinationController,
              decoration: InputDecoration(labelText: 'Destination'),
              validator: (value) => value!.isEmpty ? 'Please enter a destination' : null,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDate == null
                        ? 'Select Journey Date'
                        : 'Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}',
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: _pickDate,
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveTicket,
          child: Text('Save'),
        ),
      ],
    );
  }
}