import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(FitnessTrackerApp());
}

class FitnessTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.latoTextTheme(),
      ),
      home: FitnessTrackerScreen(),
    );
  }
}

class FitnessTrackerScreen extends StatefulWidget {
  @override
  _FitnessTrackerScreenState createState() => _FitnessTrackerScreenState();
}

class _FitnessTrackerScreenState extends State<FitnessTrackerScreen> {
  int steps = 5000;
  double caloriesBurned = 200.5;
  List<FlSpot> workoutProgress = [
    FlSpot(1, 2),
    FlSpot(2, 3),
    FlSpot(3, 5),
    FlSpot(4, 7),
    FlSpot(5, 8),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Fitness Tracker")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Daily Steps:", style: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.bold)),
            Text("$steps steps", style: GoogleFonts.lato(fontSize: 20)),
            SizedBox(height: 10),
            Text("Calories Burned:", style: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.bold)),
            Text("$caloriesBurned kcal", style: GoogleFonts.lato(fontSize: 20)),
            SizedBox(height: 20),
            Text("Workout Progress:", style: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: workoutProgress,
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 4,
                      isStrokeCapRound: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}