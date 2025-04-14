//Real Time Weather Report Fetching System
//Replace the  YOUR_API_KEY in the statement String apiKey = "YOUR_API_KEY";  with  a valid API key from OpenWeatherMap


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        textTheme: TextTheme(bodyLarge: TextStyle(fontFamily: 'Montserrat')),
      ),
      darkTheme: ThemeData.dark().copyWith(
        textTheme: TextTheme(bodyLarge: TextStyle(fontFamily: 'Montserrat')),
      ),
      themeMode: ThemeMode.system,
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String location = "New York";
  double? temperature;
  String description = "Fetching weather...";
  String apiKey = "YOUR_API_KEY";

  Future<void> fetchWeather() async {
    final response = await http.get(
      Uri.parse("https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$apiKey&units=metric"),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        temperature = data['main']['temp'];
        description = data['weather'][0]['description'];
      });
    } else {
      setState(() {
        description = "Error fetching weather";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Weather App")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              location,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              temperature != null ? "${temperature!.toStringAsFixed(1)}°C" : "Loading...",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchWeather,
              child: Text("Refresh"),
            ),
          ],
        ),
      ),
    );
  }
}