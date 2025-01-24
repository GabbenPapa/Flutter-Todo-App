import 'package:hive_flutter/hive_flutter.dart';

class TodoDataBase {
  List toDoList = [];

  final _mayBox = Hive.box('mybox');

  //firstStart
  void createInitialData() {
    toDoList = [];
  }

  void loadData() {
    toDoList = _mayBox.get("TODOLIST");
  }

  void updateDataBase() {
    _mayBox.put("TODOLIST", toDoList);
  }
}
