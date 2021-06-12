import 'package:draw_aksara/drawing_area.dart';
import 'package:draw_aksara/my_custom_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // list yg nampung pointnya
  List<DrawingArea> points = [];

  Color selectedColor;
  double strokeWidth;

  @override
  void initState() {
    selectedColor = Colors.black;
    strokeWidth = 5.0;
    super.initState();
  }

  // fungsi untuk pilih color, dari lib flutter_colorpicker
  void selectColor() {
    showDialog(
        context: context,
        child: AlertDialog(
          title: const Text('Pilih Warna'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                this.setState(() {
                  selectedColor = color;
                });
              },
            ),
          ),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Keluar'),
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    // get size layar
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromRGBO(130, 35, 135, 1.0),
                    Color.fromRGBO(233, 64, 87, 1.0),
                    Color.fromRGBO(242, 113, 33, 1.0)
                  ]),
            ),
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: width * 0.80,
                  height: height * 0.50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 5.0,
                          spreadRadius: 1.0,
                        ),
                      ]),
                  child: GestureDetector(
                    onPanDown: (details) {
                      this.setState(() {
                        points.add(DrawingArea(
                          point: details.localPosition,
                          areaPaint: Paint()
                            ..color = selectedColor
                            ..strokeWidth = strokeWidth
                            ..isAntiAlias = true
                            ..strokeCap = StrokeCap.round,
                        ));
                      });
                    },
                    onPanUpdate: (details) {
                      this.setState(() {
                        this.setState(() {
                        points.add(DrawingArea(
                          point: details.localPosition,
                          areaPaint: Paint()
                            ..color = selectedColor
                            ..strokeWidth = strokeWidth
                            ..isAntiAlias = true
                            ..strokeCap = StrokeCap.round,
                        ));
                      });
                      });
                    },
                    onPanEnd: (details) {
                      this.setState(() {
                        points.add(null);
                      });
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      child: CustomPaint(
                        painter: MyCustomPainter(
                            points: points,
                            setColor: selectedColor,
                            strokeWidth: strokeWidth),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  width: width * 0.80,
                  child: Row(
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.color_lens,
                            color: selectedColor,
                          ),
                          onPressed: () {
                            selectColor();
                          }),
                      Expanded(
                          child: Slider(
                        min: 1.0,
                        max: 10.0,
                        activeColor: selectedColor,
                        value: strokeWidth,
                        onChanged: (newValue) {
                          this.setState(() {
                            strokeWidth = newValue;
                          });
                        },
                      )),
                      IconButton(
                          icon: Icon(Icons.layers_clear),
                          onPressed: () {
                            this.setState(() {
                              points.clear();
                            });
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
