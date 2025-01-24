import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/theme/theme.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('mybox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo Application',
      home: const ReorderableExample(),
      theme: lightMode,
      darkTheme: darkMode,
    );
  }
}

class ReorderableExample extends StatefulWidget {
  const ReorderableExample({super.key});

  @override
  State<ReorderableExample> createState() => _ReorderableListViewExampleState();
}

class _ReorderableListViewExampleState extends State<ReorderableExample> {
  final List toDoList = [
    'A',
    'B',
    'C',
    'D',
  ];

  void upDateToDoTile(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex--;
      }

      final tile = toDoList.removeAt(oldIndex);
      toDoList.insert(newIndex, tile);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reorder List'),
      ),
      body: ReorderableListView(
        children: [
          for (final tile in toDoList)
            ListTile(
              key: ValueKey(tile),
              title: Text(tile.toString()),
            ),
        ],
        onReorder: (int oldIndex, int newIndex) =>
            upDateToDoTile(oldIndex, newIndex),
      ),
    );
  }
}
