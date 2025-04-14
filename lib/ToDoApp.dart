import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


class ToDoTile extends StatelessWidget {
  final String text;
  final void Function()? delete;
  final bool value;
  final void Function(bool?)? change;
  
  const ToDoTile({super.key,
  required this.text,
  required this.value,
  required this.change,
  required this.delete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:20.0,right:20.0,top:20.0),
      child: Slidable(endActionPane: ActionPane(motion: StretchMotion(), children: [SlidableAction(
        onPressed: (context) => delete?.call(), // Proper deletion call
        icon: Icons.delete,
        backgroundColor: Colors.red,
      )]
      ),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(children: [
            Checkbox(value: value, onChanged: change),
            SizedBox(width: 5,),
            Text(text, style: TextStyle(fontSize: 20, decoration: value ? TextDecoration.lineThrough : null, decorationThickness: 2.5),)
            
          ],
          ),
        ),
      ),
    );
  }
}


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController text = TextEditingController();
  final List tasks = [["Hello", false],["World", false]];
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButton: Builder(
  builder: (context) => FloatingActionButton(
    onPressed: (){
      showDialog(context: context, builder: (context){
        return AlertDialog(
          title: Text("Add Task"),
          content: TextField(
            controller: text,
            decoration: InputDecoration(
              hintText: "Enter New Task",
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder()
            ),
          ),
        actions: [
          TextButton(onPressed: (){
            setState(() {
              text.text.isNotEmpty ? tasks.add([text.text,false]) : null;
              text.clear();
              Navigator.of(context).pop();
            });
          }, child: Text("Save")),
          TextButton(onPressed: (){
            Navigator.of(context).pop();
          }, child: Text("Cancel"))
        ],
        );
      });
    },
    child: Icon(Icons.add_circle_rounded),
  ),
),

        appBar: AppBar(
          centerTitle: true,
          title: Text("To Do", style: TextStyle(fontWeight: FontWeight.bold),),
          elevation: 0,),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(itemCount: tasks.length,
                itemBuilder: (context, index){
                  return ToDoTile(text: tasks[index][0], value: tasks[index][1], change: (val){
                    setState(() {
                      tasks[index][1] = !tasks[index][1];
                    });
                  },
                  delete: (){
                    Slidable.of(context)?.close();
                    setState(() {
                      tasks.removeAt(index);
                    });
                  },);
                }),
            )
          ],
        ),
      ),
    );
  }
}


