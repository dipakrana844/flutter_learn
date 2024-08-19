import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ClearSketchButton extends StatelessWidget {
  const ClearSketchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('sketch').listenable(),
      builder: (context, box, _) {
        return IconButton(
          icon: Icon(Icons.delete),
          onPressed: box.length == 0
              ? null
              : () {
                  box.clear();
                },
          tooltip: 'Clear Sketches', // Added tooltip
        );
      },
    );
  }
}
