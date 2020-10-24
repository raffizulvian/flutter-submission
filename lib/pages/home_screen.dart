import 'package:flutter/material.dart';
import 'package:submission/model/TodoModel.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  List<TodoModel> taskList;

  HomeScreen({this.taskList});

  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    if (widget.taskList != null) {
      widget.taskList = widget.taskList.isNotEmpty
          ? widget.taskList
          : ModalRoute.of(context).settings.arguments;
      print(widget.taskList);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 4,
        centerTitle: true,
        title: Text(
          "To-Do App",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.blue,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Text("Today date"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      DateTime.now().day.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
                    ),
                    Text(
                      "/",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
                    ),
                    Text(
                      DateTime.now().month.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
                    ),
                    Text(
                      "/",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
                    ),
                    Text(
                      DateTime.now().year.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 16.0,
                  ),
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(55),
                  topRight: Radius.circular(55),
                ),
              ),
              child: Container(
                margin: EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: ListView.builder(
                    itemCount: widget.taskList.length,
                    itemBuilder: (context, index) {
                      if (widget.taskList[0].title == "Nothing To Do Now") {
                        return Center(
                          child: Text(
                            widget.taskList[0].title,
                            style: TextStyle(fontSize: 32, color: Colors.blue),
                          ),
                        );
                      } else {
                        return Card(
                          child: TodoList(
                            title: widget.taskList[index].title,
                            desc: widget.taskList[index].desc,
                            dueDate: widget.taskList[index].due,
                          ),
                          margin:
                              EdgeInsets.only(bottom: 8, left: 16, right: 16),
                        );
                      }
                    }),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            dynamic result = await Navigator.pushNamed(
              context,
              "/input",
              arguments: {widget.taskList},
            );
            setState(() {
              widget.taskList = result;
            });
          }),
    );
  }
}

class TodoList extends StatefulWidget {
  final String title;
  final String desc;
  final String dueDate;

  TodoList({Key key, this.title, this.desc, this.dueDate}) : super(key: key);

  @override
  _TodoList createState() => _TodoList();
}

class _TodoList extends State<TodoList> {
  bool finished = false;
  TextDecoration decor = TextDecoration.none;
  Color colorTitle = Colors.blue;
  Color colorSubTitle = Colors.blue[300];
  Color colorDue = Colors.blueGrey[400];

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(top: 8, bottom: 8, left: 32, right: 32),
      title: Text(
        widget.dueDate,
        style: TextStyle(
          color: colorDue,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          decoration: decor,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.title,
            style: TextStyle(
              color: colorTitle,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              decoration: decor,
            ),
          ),
          Text(
            widget.desc,
            style: TextStyle(
              color: colorTitle,
              fontSize: 14,
              fontStyle: FontStyle.italic,
              decoration: decor,
            ),
          )
        ],
      ),
      trailing: Checkbox(
          value: finished,
          onChanged: (bool value) {
            setState(() {
              setState(() {
                finished = value;
                if (value == true) {
                  decor = TextDecoration.lineThrough;
                  colorTitle = Colors.blueGrey[200];
                  colorSubTitle = Colors.blueGrey[200];
                  colorDue = Colors.blueGrey[200];
                } else {
                  decor = TextDecoration.none;
                  colorTitle = Colors.blue;
                  colorSubTitle = Colors.blue[300];
                  colorDue = Colors.blueGrey[400];
                }
              });
            });
          }),
    );
  }
}
