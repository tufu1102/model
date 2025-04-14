import 'package:flutter/material.dart';

void main() {
  runApp(StudentManagementApp());
}

class StudentManagementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StudentListScreen(),
    );
  }
}

class StudentListScreen extends StatefulWidget {
  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final List<Map<String, String>> students = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController gradeController = TextEditingController();

  void _addStudent() {
    if (nameController.text.isNotEmpty && idController.text.isNotEmpty && gradeController.text.isNotEmpty) {
      setState(() {
        students.add({
          'name': nameController.text,
          'id': idController.text,
          'grade': gradeController.text,
        });
      });
      nameController.clear();
      idController.clear();
      gradeController.clear();
      Navigator.of(context).pop();
    }
  }

  void _showAddStudentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Student'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Student Name'),
            ),
            TextField(
              controller: idController,
              decoration: InputDecoration(labelText: 'Student ID'),
            ),
            TextField(
              controller: gradeController,
              decoration: InputDecoration(labelText: 'Grade'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _addStudent,
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _updateStudent(int index) {
    nameController.text = students[index]['name']!;
    idController.text = students[index]['id']!;
    gradeController.text = students[index]['grade']!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Student'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Student Name'),
            ),
            TextField(
              controller: idController,
              decoration: InputDecoration(labelText: 'Student ID'),
            ),
            TextField(
              controller: gradeController,
              decoration: InputDecoration(labelText: 'Grade'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                students[index] = {
                  'name': nameController.text,
                  'id': idController.text,
                  'grade': gradeController.text,
                };
              });
              nameController.clear();
              idController.clear();
              gradeController.clear();
              Navigator.of(context).pop();
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Student Management')),
      body: students.isEmpty
          ? Center(child: Text('No students added yet.'))
          : ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(students[index]['name']!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Text('ID: ${students[index]['id']} | Grade: ${students[index]['grade']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _updateStudent(index),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddStudentDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}