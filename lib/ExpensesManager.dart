import 'package:flutter/material.dart';

void main() {
  runApp(ExpenseManagerApp());
}

class ExpenseManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Manager',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: ExpenseListScreen(),
    );
  }
}

class ExpenseListScreen extends StatefulWidget {
  @override
  _ExpenseListScreenState createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  final List<Map<String, String>> expenses = [];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  void _addExpense() {
    if (titleController.text.isNotEmpty && amountController.text.isNotEmpty) {
      setState(() {
        expenses.add({
          'title': titleController.text,
          'amount': amountController.text,
        });
      });
      titleController.clear();
      amountController.clear();
      Navigator.of(context).pop();
    }
  }

  void _showAddExpenseDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Expense Title'),
            ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _addExpense,
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Expense Manager')),
      body: expenses.isEmpty
          ? Center(child: Text('No expenses added yet.'))
          : ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(expenses[index]['title']!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Text('Amount: \$${expenses[index]['amount']!}', style: TextStyle(fontSize: 16)),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddExpenseDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
