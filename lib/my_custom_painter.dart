import 'dart:ui';
import 'package:draw_aksara/drawing_area.dart';
import 'package:flutter/material.dart';

class MyCustomPainter extends CustomPainter {
  List<DrawingArea> points = [];
  Color setColor;
  double strokeWidth;

  MyCustomPainter({this.points, this.setColor, this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    // disini tempat implementasi untuk custompainternya dari canvas, gambar dll

    Paint background = Paint()..color = Colors.white;

    // rect tempat kita untuk gambar (area white nya)
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // buat canvasnya
    canvas.drawRect(rect, background);

    // // config line/dot di draw
    // Paint paint = Paint()
    //   ..color = setColor
    //   ..strokeWidth = strokeWidth
    //   ..isAntiAlias = true
    //   ..strokeCap = StrokeCap.round;

      

    // for loop untuk looping buat draw linennya
    for (int x = 0; x < points.length - 1; x++) {
      if (points[x] != null && points[x + 1] != null) {
        // draw line
        Paint paint = points[x].areaPaint;
        canvas.drawLine(points[x].point, points[x + 1].point, paint);
      } else if (points[x] != null && points[x + 1] == null) {
        Paint paint = points[x].areaPaint;
        canvas.drawPoints(PointMode.points, [points[x].point], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
