import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

class HourlyForecast extends StatelessWidget {
  final IconData icon;
  final String time;
  final String temp;

  const HourlyForecast(
    {super.key,
    required this.time,
    required this.icon,
    required this.temp});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 108.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10)
      ),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(time, style: TextStyle(fontWeight: FontWeight.bold),),
              const SizedBox(height: 10,),
              Icon(icon),
            const SizedBox(height: 10,),
            Text(temp)
            ],
          ),
        ),
      ),
    );
  }
}

class AdditionalInfo extends StatelessWidget {
  final IconData icon;
  final String info;
  final String value;
  
  const AdditionalInfo(
    {super.key,
  required this.icon,
  required this.info,
  required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(height: 10,),
          Text(info),
          const SizedBox(height: 10,),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold),)
      
          
        ],
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

const String apiKey = "5060f351f390a77ab6bd71fbd140037d";

class _MyAppState extends State<MyApp> {
  late Future<Map<String, dynamic>> weather;

  Future<Map<String, dynamic>> getWeatherData() async{
    String cityName = "Chennai";
    var url = Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$apiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {

            return jsonDecode(response.body);

        } else {

            throw Exception('Failed to load weather data');

        }
    }

  @override
  void initState() {
    super.initState();
    weather = getWeatherData();
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Weather App"),
          centerTitle: true,
          actions: [
            IconButton(onPressed: (){
              setState(() {
                weather = getWeatherData();
              });
            }, 
            icon: const Icon(Icons.refresh_rounded))
          ],
        ),
        body: FutureBuilder(future: weather,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            else if (snapshot.hasError){
              return Center(child: const Text("Error fetching Weather Data", style: TextStyle(fontSize: 20,),));
            }

            final data = snapshot.data! as Map<String, dynamic>;
            final currentData = data["list"][0];
            final forecastData = data["list"];

            final currentTemp = currentData["main"]["temp"];
            final currentPressure = currentData["main"]["pressure"];
            final currentHumidity = currentData["main"]["humidity"];
            final currentWind = currentData["wind"]["speed"];
            final currentWeather = currentData["weather"][0]["main"];

            return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: double.infinity,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)
                          ),
                          elevation: 10,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                    
                                    Text("$currentTemp", 
                                    style: TextStyle(
                                      fontSize: 32, 
                                      fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 16,),
                                      Icon((currentWeather == "Clouds" || currentWeather == "Rain" ? Icons.cloud : Icons.sunny), size: 40,),
                                      const SizedBox(height: 16,),
                                      Text(currentWeather,style: TextStyle(
                                      fontSize: 20, )
                                      ),
                                      
                                      ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      const Text("Weather Forecast", 
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      const SizedBox(height: 10,),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(itemCount: 5, scrollDirection: Axis.horizontal,itemBuilder: (context, index){
                          return HourlyForecast(time: forecastData[index + 1]["dt_txt"].substring(11, 16), 
                          temp: forecastData[index + 1]["main"]["temp"].toString(), 
                          icon: (forecastData[index + 1]["weather"][0]["main"] == "Clouds" || forecastData[index + 1]["weather"][0]["main"] == "Rain"? Icons.cloud : Icons.sunny)
                          );
                        }),
                      ),
                      const SizedBox(height: 20,),
                      const Text("Additional Information", 
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      const SizedBox(height: 10,),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          AdditionalInfo(icon: Icons.water_drop, info: "Humidity", value: currentHumidity.toString()),
                          AdditionalInfo(icon: Icons.air, info: "Wind Speed", value: currentWind.toString()),
                          AdditionalInfo(icon: Icons.beach_access, info: "Pressure", value: currentPressure.toString()),
                          
                        ],
                      )
          
                  ],
              )
              ),
          );}
        )
        

      ),
    );
  }
}