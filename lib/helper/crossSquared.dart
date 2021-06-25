import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CrossSquared extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3.0;

    /// draw line (x, y)
    double wIDTH = size.width;
    double hEIGHT = size.height;

    // garis horizontal atas
    canvas.drawLine(
      Offset(wIDTH * 0, hEIGHT * 0.25),
      Offset(wIDTH * 1, hEIGHT * 0.25),
      paint,
    );

    // garis horizontal bawah
    canvas.drawLine(
      Offset(wIDTH * 0, hEIGHT * 0.75),
      Offset(wIDTH * 1, hEIGHT * 0.75),
      paint,
    );

    // garis vertical kanan
    canvas.drawLine(
      Offset(wIDTH * 0.2, hEIGHT * 0),
      Offset(wIDTH * 0.2, hEIGHT * 1),
      paint,
    );

    // garis vertical kiri
    canvas.drawLine(
      Offset(wIDTH * 0.8, hEIGHT * 0),
      Offset(wIDTH * 0.8, hEIGHT * 1),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
