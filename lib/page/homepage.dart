import 'dart:ui';

import 'package:draw_aksara/helper/myCustomPainter.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // var index
  int currentIndex = 0;

  // list asset image
  final List<String> imgAssets = [
    'assets/1.jpg',
    'assets/2.png',
    'assets/3.png',
    'assets/4.png',
    'assets/5.jpg',
    'assets/6.jpg',
    'assets/7.jpg',
  ];

  // carousel controller
  CarouselController buttonCarouselController = CarouselController();

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

    return new Scaffold(
      appBar: AppBar(
        title: Text(
          "Draw Aksara",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: InkResponse(
              child: Icon(Icons.info_outline),
              onTap: () {
                debugPrint("Hit info");
              },
            ),
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color(0xff65799b),
                  Color(0xff5e2563),
                ],
                begin: FractionalOffset.topLeft,
                end: FractionalOffset.bottomRight),
            image: DecorationImage(
              image: AssetImage("assets/pattern.png"),
              fit: BoxFit.none,
              repeat: ImageRepeat.repeat,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.blueAccent[100],
      body: Builder(
        builder: (context) => Column(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    flex: 2,
                    fit: FlexFit.loose,
                    child: RaisedButton(
                      child: Icon(Icons.arrow_back),
                      onPressed: () {
                        buttonCarouselController.previousPage(
                          duration: Duration(seconds: 1),
                          curve: Curves.linear,
                        );
                      },
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.loose,
                    child: Center(
                      child: Text(
                        "${(currentIndex + 1).toString()}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.loose,
                    child: RaisedButton(
                      child: Icon(Icons.arrow_forward),
                      onPressed: () {
                        buttonCarouselController.nextPage(
                          duration: Duration(seconds: 1),
                          curve: Curves.linear,
                        );
                      },
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 4,
              fit: FlexFit.tight,
              child: Container(
                child: CarouselSlider(
                  carouselController: buttonCarouselController,
                  items: imgAssets
                      .map(
                        (e) => Container(
                          width: MediaQuery.of(context).size.width,
                          child: Image.asset(
                            e,
                            fit: BoxFit.contain,
                          ),
                        ),
                      )
                      .toList(),
                  options: CarouselOptions(
                    initialPage: 0,
                    enlargeCenterPage: true,
                    aspectRatio: 16 / 9,
                    height: MediaQuery.of(context).size.width * 0.8,
                    viewportFraction: 1.0,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      this.setState(() {
                        currentIndex = index;
                        loadDraw(currentIndex);
                      });
                    },
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 4,
              fit: FlexFit.tight,
              child: Container(
                width: width * 0.95,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 5.0,
                        spreadRadius: 5.0,
                      ),
                    ]),
                margin: EdgeInsets.only(top: 10, bottom: 10),
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
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: CustomPaint(
                      painter: MyCustomPainter(
                          points: points,
                          setColor: selectedColor,
                          strokeWidth: strokeWidth),
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                width: width * 0.95,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.cloud_download_outlined
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.save,
                      ),
                      onPressed: () {
                        showActionSnackBar(context, "Draw Saved!");
                        this.setState(() {
                          saveDraw(currentIndex);
                        });
                      },
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.color_lens,
                        ),
                        onPressed: () {
                          selectColor();
                        }),
                    Expanded(
                        child: Slider(
                      min: 1.0,
                      max: 20.0,
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
