import 'package:flutter/material.dart';
import 'package:submission/pages/home_screen.dart';
import 'package:submission/pages/input_screen.dart';
import 'package:submission/model/TodoModel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final List<TodoModel> taskList = [
    TodoModel(title: "Nothing To Do Now", desc: "", due: "")
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/home",
      routes: {
        "/home": (context) => HomeScreen(
              taskList: taskList,
            ),
        "/input": (context) => InputScreen(
              taskList: taskList,
            ),
      },
      title: "Simple To-Do App",
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
