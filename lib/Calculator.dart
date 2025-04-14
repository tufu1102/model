import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart'; // Import math expression evaluator


void main(){
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String text = "0";
  final List buttons = ["C","DEL","%","/", "1","2","3","+","4","5","6","-","7","8","9","x","0",".","="];
  final List colors = [0,0,0,0,1,1,1,0,1,1,1,0,1,1,1,0,1,1,1];
  void buttonPressed(String val){
    if(val == "C"){
      text = "0";
    }
    else if(val == "DEL"){
      text = (text.length >= 2) ? text.substring(0,text.length - 1) : "0";
    }
    else if(val == "="){
      text = text.replaceAll("x", "*");
      text = text.replaceAll("%", "/100");
      try{
      GrammarParser p = GrammarParser();
      Expression expression = p.parse(text);
      ContextModel cm = ContextModel();
      double result = expression.evaluate(EvaluationType.REAL, cm);
      if (result == result.toInt()) {
        text = result.toInt().toString();
      } else {
        text = result.toString();
      }
      }
      catch(e){
        text = "Error: Invalid expression";
      }
    }
    else{
      if(text == "0"){
        text = val;
      }
      else{
      text += val;
    }
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.white,),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [Flexible(flex: 1,fit: FlexFit.tight,child: Padding(
                padding: const EdgeInsets.only(top: 90),
                child: Text(text, style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),),
              )),
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: GridView.builder(itemCount: buttons.length, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4), itemBuilder: (context, index){
                  return Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: ElevatedButton(onPressed: (){
                      setState(() {
                        buttonPressed(buttons[index]);
                      });
                    }, 
                    style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      backgroundColor: (colors[index] == 0 ? Colors.black : Colors.grey)
                    ),
                    child: Text(buttons[index], style: TextStyle(fontWeight: FontWeight.bold,color: colors[index] == 0 ? Colors.white : Colors.black),)),
                  );
                }),
              )
              ],
            ),
          ),
        ),
      )
    );
  }
}




