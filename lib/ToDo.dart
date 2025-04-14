import 'package:flutter/material.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TodoListScreen(),
    );
  }
}

class Todo {
  String title;
  bool isCompleted;

  Todo({required this.title, this.isCompleted = false});
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Todo> todos = [];

  void _addOrEditTask({Todo? todo, int? index}) async {
    final result = await showDialog<Todo>(
      context: context,
      builder: (context) => TaskDialog(todo: todo),
    );
    if (result != null) {
      setState(() {
        if (index != null) {
          todos[index] = result;
        } else {
          todos.add(result);
        }
      });
    }
  }

  void _deleteTask(int index) {
    setState(() {
      todos.removeAt(index);
    });
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      todos[index].isCompleted = !todos[index].isCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Todo List')),
      body: todos.isEmpty
          ? Center(child: Text('No tasks available'))
          : ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return Card(
                  child: ListTile(
                    title: Text(
                      todo.title,
                      style: TextStyle(
                        decoration:
                            todo.isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    leading: Checkbox(
                      value: todo.isCompleted,
                      onChanged: (_) => _toggleTaskCompletion(index),
                    ),
                    onTap: () => _addOrEditTask(todo: todo, index: index),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteTask(index),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _addOrEditTask(),
      ),
    );
  }
}

class TaskDialog extends StatefulWidget {
  final Todo? todo;
  TaskDialog({this.todo});

  @override
  _TaskDialogState createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo?.title ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final newTask = Todo(title: _titleController.text);
      Navigator.pop(context, newTask);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.todo == null ? 'Add Task' : 'Edit Task'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _titleController,
          decoration: InputDecoration(labelText: 'Task Title'),
          validator: (value) => value!.isEmpty ? 'Please enter a task' : null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveTask,
          child: Text('Save'),
        ),
      ],
    );
  }
}