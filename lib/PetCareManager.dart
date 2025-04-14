import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() => runApp(PetCareApp());

class PetCareApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Care Manager',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: PetListScreen(),
    );
  }
}

class Pet {
  String name;
  String breed;
  String medicalRecord;
  DateTime vaccinationDate;

  Pet({required this.name, required this.breed, required this.medicalRecord, required this.vaccinationDate});

  Map<String, dynamic> toJson() => {
        'name': name,
        'breed': breed,
        'medicalRecord': medicalRecord,
        'vaccinationDate': vaccinationDate.toIso8601String(),
      };

  static Pet fromJson(Map<String, dynamic> json) => Pet(
        name: json['name'],
        breed: json['breed'],
        medicalRecord: json['medicalRecord'],
        vaccinationDate: DateTime.parse(json['vaccinationDate']),
      );
}

class PetListScreen extends StatefulWidget {
  @override
  _PetListScreenState createState() => _PetListScreenState();
}

class _PetListScreenState extends State<PetListScreen> {
  List<Pet> pets = [];

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  Future<void> _loadPets() async {
    final prefs = await SharedPreferences.getInstance();
    final petData = prefs.getStringList('pets') ?? [];
    setState(() {
      pets = petData.map((e) => Pet.fromJson(json.decode(e))).toList();
    });
  }

  Future<void> _savePets() async {
    final prefs = await SharedPreferences.getInstance();
    final petData = pets.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('pets', petData);
  }

  void _addPet() async {
    final newPet = await Navigator.push<Pet>(
      context,
      MaterialPageRoute(builder: (context) => AddPetScreen()),
    );
    if (newPet != null) {
      setState(() {
        pets.add(newPet);
      });
      _savePets();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Care Manager'),
      ),
      body: ListView.builder(
        itemCount: pets.length,
        itemBuilder: (context, index) {
          final pet = pets[index];
          return ListTile(
            title: Text(pet.name),
            subtitle: Text('${pet.breed} - Vaccination: ${DateFormat.yMMMd().format(pet.vaccinationDate)}'),
            trailing: Icon(Icons.pets),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPet,
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddPetScreen extends StatefulWidget {
  @override
  _AddPetScreenState createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _medicalController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
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
      final pet = Pet(
        name: _nameController.text,
        breed: _breedController.text,
        medicalRecord: _medicalController.text,
        vaccinationDate: _selectedDate,
      );
      Navigator.pop(context, pet);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Pet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Pet Name'),
                validator: (value) => value!.isEmpty ? 'Enter pet name' : null,
              ),
              TextFormField(
                controller: _breedController,
                decoration: InputDecoration(labelText: 'Breed'),
                validator: (value) => value!.isEmpty ? 'Enter breed' : null,
              ),
              TextFormField(
                controller: _medicalController,
                decoration: InputDecoration(labelText: 'Medical Record'),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text('Vaccination Date: ${DateFormat.yMMMd().format(_selectedDate)}'),
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
                child: Text('Save Pet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}