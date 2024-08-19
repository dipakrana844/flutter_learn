import 'package:flutter/rendering.dart';

import 'colored_path.dart';

class PathPainter extends CustomPainter {
  final DrawingPath path;

  PathPainter(this.path);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(path.path, path.paint);
  }

  @override
  bool shouldRepaint(PathPainter oldDelegate) => true;
}
