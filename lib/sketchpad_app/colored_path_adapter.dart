import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'colored_path.dart';

// Consider renaming to reflect its function more clearly, e.g., ColoredPathHiveAdapter
class ColoredPathAdapter extends TypeAdapter<DrawingPath> {
  @override
  final int typeId = 1;

  @override
  DrawingPath read(BinaryReader reader) {
    final colorIndex = reader.readByte();
    final path = DrawingPath(colorIndex); // Initialize with colorIndex directly
    final len = reader.readUint32();
    for (int i = 0; i < len; i++) {
      final x = reader.readDouble();
      final y = reader.readDouble();
      path.addPoint(
          Offset(x, y)); // Improved readability by separating coordinates
    }
    return path;
  }

  @override
  void write(BinaryWriter writer, DrawingPath obj) {
    writer.writeByte(obj.colorIndex);
    writer.writeUint32(obj.points.length);
    for (final point in obj.points) {
      writer.writeDouble(point.dx);
      writer.writeDouble(point.dy);
    }
  }
}
