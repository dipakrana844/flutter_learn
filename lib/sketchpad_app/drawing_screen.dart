import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'clear_button.dart';
import 'colored_path.dart';
import 'drawing_area.dart';
import 'path_painter.dart';
import 'undo_button.dart';

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({super.key});

  @override
  DrawingScreenState createState() => DrawingScreenState();
}

class DrawingScreenState extends State<DrawingScreen> {
  var selectedColorIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          // Use Expanded to make the drawing area take up available space
          Expanded(
            child: Stack(
              children: <Widget>[
                // Use ValueListenableBuilder to rebuild only when paths change
                ValueListenableBuilder(
                  valueListenable: Hive.box('sketch').listenable(),
                  builder: (context, box, _) {
                    return buildPathsFromBox(context, box);
                  },
                ),
                DrawingArea(selectedColorIndex),
                // Position the "powered by Hive" text more appropriately
                const Positioned(
                  top: 10,
                  right: 10,
                  child: Text('powered by Hive'),
                ),
              ],
            ),
          ),
          // Simplify the layout of color circles and buttons
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (var i = 0; i < DrawingPath.colors.length; i++)
                  _buildColorCircle(i),
                const ClearSketchButton(),
                const UndoButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Extract the color circle building logic into a separate method
  Widget _buildColorCircle(int colorIndex) {
    final isSelected = selectedColorIndex == colorIndex;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColorIndex = colorIndex;
        });
      },
      child: ClipOval(
        child: Container(
          padding: const EdgeInsets.only(bottom: 16.0),
          height: isSelected ? 50 : 36,
          width: isSelected ? 50 : 36,
          color: DrawingPath.colors[colorIndex],
        ),
      ),
    );
  }

  Widget buildPathsFromBox(BuildContext context, Box box) {
    var paths = box.values.whereType<DrawingPath>();
    return Stack(
      children: <Widget>[
        for (var path in paths)
          CustomPaint(
            size: Size.infinite,
            painter: PathPainter(path),
          ),
      ],
    );
  }
}
