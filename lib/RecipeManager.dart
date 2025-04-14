import 'package:flutter/material.dart';

void main() {
  runApp(RecipeApp());
}

class RecipeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipe Manager',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: RecipeScreen(),
    );
  }
}

class RecipeScreen extends StatefulWidget {
  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final List<Map<String, String>> recipes = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ingredientsController = TextEditingController();
  final TextEditingController directionsController = TextEditingController();

  void _addRecipe() {
    if (nameController.text.isNotEmpty &&
        ingredientsController.text.isNotEmpty &&
        directionsController.text.isNotEmpty) {
      setState(() {
        recipes.add({
          'name': nameController.text,
          'ingredients': ingredientsController.text,
          'directions': directionsController.text,
        });
        nameController.clear();
        ingredientsController.clear();
        directionsController.clear();
      });
    }
  }

  void _editRecipe(int index) {
    nameController.text = recipes[index]['name']!;
    ingredientsController.text = recipes[index]['ingredients']!;
    directionsController.text = recipes[index]['directions']!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Recipe'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Recipe Name'),
            ),
            TextField(
              controller: ingredientsController,
              decoration: InputDecoration(labelText: 'Ingredients'),
            ),
            TextField(
              controller: directionsController,
              decoration: InputDecoration(labelText: 'Directions'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                recipes[index] = {
                  'name': nameController.text,
                  'ingredients': ingredientsController.text,
                  'directions': directionsController.text,
                };
              });
              nameController.clear();
              ingredientsController.clear();
              directionsController.clear();
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recipe Manager')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Recipe Name'),
            ),
            TextField(
              controller: ingredientsController,
              decoration: InputDecoration(labelText: 'Ingredients'),
            ),
            TextField(
              controller: directionsController,
              decoration: InputDecoration(labelText: 'Directions'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addRecipe,
              child: Text('Add Recipe'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(recipes[index]['name']!),
                    subtitle: Text('Ingredients: ${recipes[index]['ingredients']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _editRecipe(index),
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