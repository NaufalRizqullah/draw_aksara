import 'package:draw_aksara/my_custom_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // list yg nampung pointnya
  List<Offset> points = [];

  // savedDraw
  List savedDraw = List.filled(90, [], growable: false);

  Color selectedColor;
  double strokeWidth;

  // fungsi untuk load dataDraw berdasarkan index
  void loadDraw(int indexSaved) {
    points = List.from(savedDraw[indexSaved]);
  }

  // fungsi untuk save dataDraw berdasarkan index
  void saveDraw(int indexSaved) {
    savedDraw[indexSaved] = List.from(points);
  }

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
      body: Builder(
        builder: (context) => Stack(
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
                    height: height * 0.40,
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
                          points.add(details.localPosition);
                        });
                      },
                      onPanUpdate: (details) {
                        this.setState(() {
                          this.setState(() {
                            points.add(details.localPosition);
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
                            Icons.save,
                            color: selectedColor,
                          ),
                          onPressed: () {
                            showActionSnackBar(context, "Saved!");
                          },
                        ),
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
                              showActionSnackBar(context, "Clear!");
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// function snackbar
void showActionSnackBar(BuildContext context, String msg) {
  final snackBar = SnackBar(
    content: Text(msg.toString() ?? "Clicked!", style: TextStyle(fontSize: 16)),
    action: SnackBarAction(
      label: "Dismiss",
      onPressed: () {},
    ),
  );

  Scaffold.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(snackBar);
}

void showFloatingSnackBar(BuildContext context, String msg) {
  final snackBar = SnackBar(
    content: Text(
      msg.toString() ?? 'Clicked 2!',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 22),
    ),
    backgroundColor: Colors.amber,
    duration: Duration(seconds: 3),
    shape: StadiumBorder(),
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
    elevation: 0,
  );

  Scaffold.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

void showCustomSnackBar(BuildContext context, String msg) {
  final snackBar = SnackBar(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(Icons.info_outline, size: 30),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: Text(
            msg.toString() ?? "Clicked 3!",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ],
    ),
    backgroundColor: Colors.green,
    duration: Duration(seconds: 3),
    shape: StadiumBorder(),
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
    elevation: 0,
  );

  Scaffold.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(snackBar);
}

void showErrorSnackBar(BuildContext context, String msg) {
  final snackBar = SnackBar(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(Icons.error_outline, size: 30),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            msg.toString() ?? "Clicked 4!",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ],
    ),
    backgroundColor: Colors.red,
    duration: Duration(seconds: 3),
    behavior: SnackBarBehavior.fixed,
  );

  Scaffold.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(snackBar);
}
