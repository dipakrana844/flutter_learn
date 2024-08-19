import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'colored_path.dart';
import 'path_painter.dart';

class DrawingArea extends StatefulWidget {
  final int selectedColorIndex;

  const DrawingArea(this.selectedColorIndex, {super.key});

  @override
  _DrawingAreaState createState() => _DrawingAreaState();
}

class _DrawingAreaState extends State<DrawingArea> {
  late DrawingPath currentPath;

  @override
  void initState() {
    super.initState();
    currentPath = DrawingPath(0); // Initialize in initState
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        _addPoint(details.localPosition);
      },
      onPanStart: (details) {
        currentPath = DrawingPath(widget.selectedColorIndex);
        _addPoint(details.localPosition);
      },
      onPanEnd: (details) {
        Hive.box('sketch').add(currentPath);
        setState(() {
          currentPath = DrawingPath(0);
        });
      },
      child: CustomPaint(
        size: Size.infinite,
        painter: PathPainter(currentPath),
      ),
    );
  }

  void _addPoint(Offset point) {
    setState(() {
      currentPath.addPoint(point);
    });
  }
}
