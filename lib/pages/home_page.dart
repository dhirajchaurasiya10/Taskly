import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskly/models/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double _deviceheight, _devicewidth;

  String? _newtaskcontent;
  Box? _box;

  @override
  Widget build(BuildContext context) {
    _deviceheight = MediaQuery.of(context).size.height;
    _devicewidth = MediaQuery.of(context).size.width;
    // print("INput value: $_newtaskcontent");
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: _deviceheight * 0.15,
        title: const Text(
          "Taskly",
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: _tasksView(),
      floatingActionButton:
          _addTaskButton(), //a bar that gives title just like facebook
    );
  }

  Widget _tasksView() {
    return FutureBuilder(
      future: Hive.openBox('tasks'),
      builder: (BuildContext _context, AsyncSnapshot _snapshot) {
        if (_snapshot.hasData) {
          _box = _snapshot.data;
          return _taskslist();
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _taskslist() {
    List tasks = _box!.values.toList();
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (BuildContext _context, int _index) {
        var task = Tassk.fromMap(tasks[_index]);
        return ListTile(
          title: Text(
            task.content,
            style: TextStyle(
              decoration: task.done ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Text(
            task.timestamp.toString(),
          ),
          trailing: Icon(
            task.done
                ? Icons.check_box_outlined
                : Icons.check_box_outline_blank,
            color: Colors.red,
          ),
          onTap: () {
            task.done = !task.done;
            _box!.putAt(
              _index,
              task.toMap(),
            );
            setState(() {});
          },
          onLongPress: () {
            _box!.deleteAt(_index);
            setState(() {});
          },
        );
      },
    );
  }

  Widget _addTaskButton() {
    return FloatingActionButton(
      onPressed: _displayTaskpopup,
      child: Icon(
        Icons.add,
      ),
    );
  }

  void _displayTaskpopup() {
    showDialog(
      context: context,
      builder: (BuildContext _context) {
        return AlertDialog(
          title: const Text("Add new Task"),
          content: TextField(
            onSubmitted: (_) {
              if (_newtaskcontent != null) {
                var _task = Tassk(
                  content: _newtaskcontent!,
                  done: false,
                  timestamp: DateTime.now(),
                );
                _box!.add(_task.toMap());
                setState(() {
                  _newtaskcontent = null;
                  Navigator.pop(context);
                });
              }
            },
            onChanged: (_value) {
              setState(() {
                _newtaskcontent = _value;
              });
            },
          ),
        );
      },
    );
  }
}
