import 'package:flutter/material.dart';

class DrawingPath {
  static const colors = [
    Colors.black,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.amber,
  ];

  static final paints = colors
      .map((color) => Paint()
        ..strokeCap = StrokeCap.round
        ..isAntiAlias = true
        ..color = color
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke)
      .toList(); // Initialize paints directly

  final int colorIndex;
  final Path path = Path();
  final List<Offset> points = [];

  DrawingPath(this.colorIndex);
  Paint get paint => paints[colorIndex]; // Simplified paint accessor

  void addPoint(Offset point) {
    if (points.isEmpty) {
      path.moveTo(point.dx, point.dy);
    } else {
      path.lineTo(point.dx, point.dy);
    }
    points.add(point);
  }
}
