import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UndoButton extends StatelessWidget {
  const UndoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('sketch').listenable(),
      builder: (context, drawingHistory, _) {
        return IconButton(
          icon: Icon(Icons.undo),
          onPressed: drawingHistory.isEmpty
              ? null // Disable button if no drawing history
              : () {
                  drawingHistory.deleteAt(drawingHistory.length - 1);
                },
          tooltip: 'Undo', // Add a tooltip for accessibility
        );
      },
    );
  }
}
