import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:submission/model/TodoModel.dart';

class InputScreen extends StatelessWidget {
  final List<TodoModel> taskList;

  InputScreen({this.taskList});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, taskList);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "New Task",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        backgroundColor: Colors.blue,
        body: InputTodo(
          titleText: "Create financial report",
          subtitleText: "Submit the report imidiately to company cloud.",
          taskList: taskList,
        ),
      ),
    );
  }
}

class InputTodo extends StatefulWidget {
  final String titleText;
  final String subtitleText;

  final List<TodoModel> taskList;

  InputTodo({this.titleText, this.subtitleText, this.taskList});

  @override
  _InputTodo createState() => _InputTodo();
}

class _InputTodo extends State<InputTodo> {
  var _title;
  var _desc;
  var _due;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  final TextEditingController _dueController = TextEditingController();

  final FocusNode _titleFocus = FocusNode();
  final FocusNode _subtitleFocus = FocusNode();
  final FocusNode _dueFocus = FocusNode();

  final format = DateFormat("dd/MM/yyyy HH:mm");

  focusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 38.0, top: 16),
          child: Text("Task To-Do:"),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: TextFormField(
            minLines: 1,
            maxLines: 5,
            maxLength: 140,
            textInputAction: TextInputAction.next,
            focusNode: _titleFocus,
            onFieldSubmitted: (title) {
              focusChange(context, _titleFocus, _subtitleFocus);
            },
            decoration: InputDecoration(
                counterText: "",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                filled: true,
                fillColor: Colors.white,
                hintText: widget.titleText,
                floatingLabelBehavior: FloatingLabelBehavior.never),
            controller: _titleController,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 38.0, top: 16),
          child: Text("Short Description:"),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: TextFormField(
            minLines: 1,
            maxLines: 5,
            maxLength: 140,
            textInputAction: TextInputAction.next,
            focusNode: _subtitleFocus,
            onFieldSubmitted: (subtitle) {
              focusChange(context, _subtitleFocus, _dueFocus);
            },
            decoration: InputDecoration(
                counterText: "",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                filled: true,
                fillColor: Colors.white,
                hintText: widget.subtitleText,
                floatingLabelBehavior: FloatingLabelBehavior.never),
            controller: _subtitleController,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 38.0, top: 16),
          child: Text("Due Date:"),
        ),
        DueDateInputField(
          format: format,
          dueController: _dueController,
          dueFocus: _dueFocus,
        ),
        SizedBox(
          height: 20,
        ),
        Center(
          child: RaisedButton(
            textColor: Colors.white,
            color: Colors.lightBlue,
            splashColor: Colors.blueAccent,
            elevation: 4,
            child: Text("Add"),
            onPressed: () {
              addTask();
            },
          ),
        )
      ],
    );
  }

  void addTask() {
    return setState(() {
      _title = _titleController.text;
      _desc = _subtitleController.text;
      _due = _dueController.text;

      var newTask = TodoModel(
        title: _title,
        desc: _desc,
        due: _due,
      );

      if (widget.taskList[0].title == "Nothing To Do Now") {
        widget.taskList.clear();
        widget.taskList.add(newTask);
        print(widget.taskList);
      } else {
        widget.taskList.add(newTask);
        print(widget.taskList);
      }

      Navigator.pop(context, widget.taskList);
    });
  }
}

class DueDateInputField extends StatelessWidget {
  const DueDateInputField(
      {Key key,
      @required this.format,
      @required this.dueController,
      @required this.dueFocus})
      : super(key: key);

  final DateFormat format;
  final TextEditingController dueController;
  final FocusNode dueFocus;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: DateTimeField(
        focusNode: dueFocus,
        controller: dueController,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50))),
            filled: true,
            fillColor: Colors.white,
            hintText: "Tap here"),
        format: format,
        onShowPicker: (context, currentValue) async {
          final date = await showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
          if (date != null) {
            final time = await showTimePicker(
              context: context,
              initialTime:
                  TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            );
            return DateTimeField.combine(date, time);
          } else {
            return currentValue;
          }
        },
      ),
    );
  }
}
