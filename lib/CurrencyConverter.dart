import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void convert() {
            if(textController.text.isEmpty){
              result = 0;
            }
            else{
             result = double.parse(textController.text) * 87;}
             setState(() {
             });
  }

  final border = OutlineInputBorder(borderSide: const BorderSide(width :2, style : BorderStyle.solid),borderRadius: BorderRadius.circular(10));
  final TextEditingController textController = TextEditingController();
  double result = 0;

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(title: const Text("Currency Converter", style: TextStyle(
          fontSize: 20
        ),),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        ),
        body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("INR ${(textController.text.isEmpty || textController.text == "0") ? "0" : "$result"}", 
          style: const TextStyle(fontSize: 30, 
          fontWeight: FontWeight.bold)),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField( keyboardType: const TextInputType.numberWithOptions(decimal: true) ,
                  decoration: InputDecoration(hintText: "Please enter amount in USD",
                  prefixIcon: const Icon(Icons.monetization_on_rounded),
                      filled: true,
                      fillColor: Colors.white,
                      border: border,
                      focusedBorder: border,
                      enabledBorder: border,
                ),
                controller: textController,
                  ),
          ),
          TextButton(onPressed: convert, style: const 
          ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.white), 
          minimumSize: WidgetStatePropertyAll(Size(200,50))),
          child: const Text("Convert"))
            ],
            )
          )
        )
      );
  }
}
