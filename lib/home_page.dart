import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/components/dialog_box.dart';
import 'package:todo_app/components/todo_tile.dart';
import 'package:todo_app/data/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Box<dynamic> _myBox;
  TodoDataBase db = TodoDataBase();

  @override
  void initState() {
    super.initState();
    openHiveBox();
  }

  Future<void> openHiveBox() async {
    _myBox = await Hive.openBox('myBox');
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    setState(() {});
  }

  final _controller = TextEditingController();

  void checkboxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
      db.updateDataBase();
    });
  }

  void addNewTaskToList() {
    setState(() {
      if (_controller.text != "") {
        db.toDoList.add([_controller.text, false]);
        db.updateDataBase();
        _controller.clear();
        Navigator.of(context).pop();
      }
    });
  }

  addNewTask() {
    _controller.clear();
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            text: "Add",
            controller: _controller,
            onAction: addNewTaskToList,
            onCancel: () => Navigator.of(context).pop(),
          );
        });
  }

  editTask(int index) {
    _controller.text = db.toDoList[index][0];

    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          text: "Save",
          controller: _controller,
          onAction: () {
            saveTask(index);
            Navigator.of(context).pop();
          },
          onCancel: () {
            _controller.clear();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  saveTask(int index) {
    db.toDoList[index][0] = _controller.text;
    db.updateDataBase();
    setState(() {
      _controller.clear();
    });
  }

  deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Center(
          child: Text(
            'Taskify',
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ),
        elevation: 0,
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              addNewTask();
              setState(() {});
            },
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Icon(
              Icons.add,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : null,
            ),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () {
              _myBox.clear();
              db.toDoList.clear();
              setState(() {});
            },
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Icon(
              Icons.delete,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : null,
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context, index) {
          return ToDoTile(
            taskName: db.toDoList[index][0],
            taskCompleted: db.toDoList[index][1],
            onChanged: (value) => checkboxChanged(value, index),
            deleteTask: (context) => deleteTask(index),
            editTask: (context) => editTask(index),
          );
        },
      ),
    );
  }
}
