import 'dart:ui';
import 'package:flutter/material.dart';

class MyCustomPainter extends CustomPainter {
  List<Offset> points = [];
  Color setColor;
  double strokeWidth;

  MyCustomPainter({required this.points, required this.setColor, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    Paint background = Paint()..color = Colors.white;

    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawRect(rect, background);

    Paint paint = Paint()
      ..color = setColor
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round;

    for (int x = 0; x < points.length - 1; x++) {
      if (points[x] != Offset(0,0) && points[x + 1] != Offset(0,0)) {
        canvas.drawLine(points[x], points[x + 1], paint);
      } else if (points[x] != Offset(0,0) && points[x + 1] == Offset(0,0)) {
        canvas.drawPoints(PointMode.points, [points[x]], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
