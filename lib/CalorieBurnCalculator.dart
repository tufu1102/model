import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(CalorieBurnCalculatorApp());
}

class CalorieBurnCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: CalorieBurnCalculatorScreen(),
    );
  }
}

class CalorieBurnCalculatorScreen extends StatefulWidget {
  @override
  _CalorieBurnCalculatorScreenState createState() => _CalorieBurnCalculatorScreenState();
}

class _CalorieBurnCalculatorScreenState extends State<CalorieBurnCalculatorScreen> {
  double weight = 60.0;
  String selectedActivity = 'Running';
  double duration = 30.0;
  double caloriesBurned = 0.0;

  final Map<String, double> activityMETs = {
    'Running': 8.0,
    'Walking': 3.5,
    'Cycling': 6.0,
    'Swimming': 7.0,
  };

  void calculateCalories() {
    double metValue = activityMETs[selectedActivity] ?? 3.5;
    setState(() {
      caloriesBurned = (metValue * 3.5 * weight / 200) * duration;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calorie Burn Calculator")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Enter your weight (kg):", style: GoogleFonts.poppins(fontSize: 18)),
            Slider(
              value: weight,
              min: 30,
              max: 150,
              divisions: 120,
              label: weight.toStringAsFixed(1),
              onChanged: (value) {
                setState(() {
                  weight = value;
                });
              },
            ),
            SizedBox(height: 10),
            Text("Select Activity Type:", style: GoogleFonts.poppins(fontSize: 18)),
            DropdownButton<String>(
              value: selectedActivity,
              items: activityMETs.keys.map((activity) {
                return DropdownMenuItem(value: activity, child: Text(activity));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedActivity = value!;
                });
              },
            ),
            SizedBox(height: 10),
            Text("Enter duration (minutes):", style: GoogleFonts.poppins(fontSize: 18)),
            Slider(
              value: duration,
              min: 5,
              max: 120,
              divisions: 23,
              label: duration.toStringAsFixed(0),
              onChanged: (value) {
                setState(() {
                  duration = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: calculateCalories,
              child: Text("Calculate"),
            ),
            SizedBox(height: 20),
            Text("Calories Burned: ${caloriesBurned.toStringAsFixed(2)} kcal",
                style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange)),
          ],
        ),
      ),
    );
  }
}