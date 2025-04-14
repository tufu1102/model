import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather Animation',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String _selectedWeather = 'sunny';

  Map<String, String> weatherAnimations = {
    'sunny': 'assets/sunny.json',
    'cloudy': 'assets/cloudy.json',
    'rainy': 'assets/rainy.json',
    'snowy': 'assets/snowy.json',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weather Animation')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Lottie.asset(
              weatherAnimations[_selectedWeather]!,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 20),
          Wrap(
            spacing: 10,
            children: weatherAnimations.keys.map((weather) {
              return ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedWeather = weather;
                  });
                },
                child: Text(weather.toUpperCase()),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}