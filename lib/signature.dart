import 'dart:ui';
import 'package:flutter/material.dart';

class Signature extends CustomPainter {
  List<Offset> points;

  Signature({this.points});

  @override
  void paint(Canvas canvas, Size size) {
    // set paintnya, dari warna, size sm bentuk linennya
    Paint paint = new Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 7.0;

    for (int i = 0; i < points.length - 1; i++) {
      // cek dulu, untuk titik awal sm titik akhir tidak boleh null
      if (points[i] != null && points[i + 1] != null) {
        // kalo terpenuhin maka diambil point i dan point i+1 untuk di gambar line-nya;
        canvas.drawLine(points[i], points[i + 1], paint);
      } else if(points[i] != null && points[i + 1] == null){
        // kalo terpenuhin maka diambil point i untuk di gambar dot-nya;
        canvas.drawPoints(PointMode.points, [points[i]], paint);
      }
    }
  }

  @override
  bool shouldRepaint(Signature oldDelegate) => oldDelegate.points != points;
}