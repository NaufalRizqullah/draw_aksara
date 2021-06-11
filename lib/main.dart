import 'dart:ui';

import 'package:flutter/material.dart';

void main() => runApp(new MaterialApp(
      home: new HomePage(),
      debugShowCheckedModeBanner: false,
    ));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Offset> _points = <Offset>[];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Draw Aksara"),
        backgroundColor: Colors.green,
      ),
      body: Container(
        child: new GestureDetector(
          onPanUpdate: (DragUpdateDetails details) {
            setState(() {
              RenderBox object = context.findRenderObject();
              Offset _localPosition =
                  object.globalToLocal(details.localPosition);
              _points = new List.from(_points)..add(_localPosition);
            });
          },
          onPanEnd: (DragEndDetails details) => _points.add(null),
          child: new CustomPaint(
            painter: new Signature(points: _points),
            size: Size.infinite,
          ),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.clear),
        onPressed: () => _points.clear(),
      ),
    );
  }
}

// class untuk draw nya
class Signature extends CustomPainter {
  List<Offset> points;

  Signature({this.points});

  @override
  void paint(Canvas canvas, Size size) {
    // set paintnya, dari warna, size sm bentuk linennya
    Paint paint = new Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

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
