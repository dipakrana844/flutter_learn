import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_learn_app/todo_app/new_todo_dialog.dart';
import 'package:flutter_learn_app/todo_app/todo.dart';
import 'package:flutter_learn_app/todo_app/todo_list.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(TodoAdapter());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hive To-Do App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'OpenSans',
      ),
      home: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: FutureBuilder(
            future: Future.wait([
              Hive.openBox('settings'),
              Hive.openBox<Todo>('todos'),
            ]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.error != null) {
                  print(snapshot.error);
                  return const Scaffold(
                    body: Center(
                      child: Text('Something went wrong :/'),
                    ),
                  );
                } else {
                  return TodoMainScreen();
                }
              } else {
                return const Scaffold(
                  body: Center(
                    child: Text('Opening Hive...'),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class TodoMainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ValueListenableBuilder(
            valueListenable: Hive.box('settings').listenable(),
            builder: (context, Box<dynamic> settings, _) {
              return _buildWithBox(context, settings);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return NewTodoDialog();
            },
          );
        },
      ),
    );
  }

  _buildWithBox(BuildContext context, Box settings) {
    var reversed = settings.get('reversed', defaultValue: true) as bool;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Hive To-Do',
              style: TextStyle(fontSize: 40),
            ),
            const SizedBox(width: 20),
            IconButton(
              icon: Icon(
                reversed ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                size: 32,
              ),
              onPressed: () {
                settings.put('reversed', !reversed);
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Text(
          kIsWeb
              ? 'Refresh this tab to test persistence.'
              : 'Restart the app to test persistence.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        Expanded(
          child: ValueListenableBuilder<Box<Todo>>(
            valueListenable: Hive.box<Todo>('todos').listenable(),
            builder: (context, box, _) {
              var todos = box.values.toList().cast<Todo>();
              if (reversed) {
                todos = todos.reversed.toList();
              }
              return TodoList(todos);
            },
          ),
        ),
      ],
    );
  }
}
