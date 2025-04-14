import 'package:flutter/material.dart';

void main() {
  runApp(ShapeDrawerApp());
}

class ShapeDrawerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shape Drawer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ShapeDrawerScreen(),
    );
  }
}

class ShapeDrawerScreen extends StatefulWidget {
  @override
  _ShapeDrawerScreenState createState() => _ShapeDrawerScreenState();
}

class _ShapeDrawerScreenState extends State<ShapeDrawerScreen> {
  String selectedShape = 'Circle';
  final List<Shape> shapes = [];

  void _addShape(Offset position) {
    setState(() {
      shapes.add(Shape(type: selectedShape, position: position));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shape Drawer')),
      body: GestureDetector(
        onTapDown: (details) => _addShape(details.localPosition),
        child: Container(
          color: Colors.white,
          child: CustomPaint(
            painter: ShapePainter(shapes),
            child: Container(),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            DropdownButton<String>(
              value: selectedShape,
              onChanged: (value) {
                setState(() {
                  selectedShape = value!;
                });
              },
              items: ['Circle', 'Rectangle'].map((String shape) {
                return DropdownMenuItem<String>(
                  value: shape,
                  child: Text(shape),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  shapes.clear();
                });
              },
              child: Text('Clear'),
            ),
          ],
        ),
      ),
    );
  }
}

class ShapePainter extends CustomPainter {
  final List<Shape> shapes;

  ShapePainter(this.shapes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    for (var shape in shapes) {
      if (shape.type == 'Circle') {
        canvas.drawCircle(shape.position, 30, paint);
      } else if (shape.type == 'Rectangle') {
        canvas.drawRect(
          Rect.fromCenter(center: shape.position, width: 60, height: 60),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class Shape {
  final String type;
  final Offset position;

  Shape({required this.type, required this.position});
}