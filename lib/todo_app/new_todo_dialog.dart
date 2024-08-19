import 'package:flutter/material.dart';
import 'package:flutter_learn_app/todo_app/todo.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NewTodoDialog extends StatefulWidget {
  @override
  _NewTodoDialogState createState() => _NewTodoDialogState();
}

class _NewTodoDialogState extends State<NewTodoDialog> {
  TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create To-Do Entry'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 10),
          TextField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              hintText: 'Enter a task',
            ),
            controller: controller,
          ),
          const SizedBox(height: 10),
        ],
      ),
      actions: <Widget>[
        MaterialButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        MaterialButton(
          child: const Text('Add'),
          onPressed: () {
            if (controller.text.isNotEmpty) {
              Todo todo = Todo()
                ..name = controller.text
                ..created = DateTime.now();
              Hive.box<Todo>('todos').add(todo);
            }
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
