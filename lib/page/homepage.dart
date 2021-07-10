import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:draw_aksara/helper/crossSquared.dart';
import 'package:draw_aksara/helper/myCustomPainter.dart';
import 'package:draw_aksara/page/aboutpage.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

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

  late Color selectedColor;

  late double strokeWidth;

  // global key untuk dapat mengakses Repaint Boundary Widget
  GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    selectedColor = Colors.black;
    strokeWidth = 5.0;
    super.initState();
  }

  // fungsi untuk pilih color, dari lib flutter_colorpicker

  @override
  Widget build(BuildContext context) {
    // get size layar
    final double width = MediaQuery.of(context).size.width;

    void selectColor(BuildContext context) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
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
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Keluar'),
                )
              ],
            );
          });
    }

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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AboutPage(),
                  ),
                );
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
            buttonController(
                context: context,
                buttonCarouselController: buttonCarouselController,
                currentIndex: currentIndex),
            imageCarouselSlider(
                imgAssets: imgAssets,
                buttonCarouselController: buttonCarouselController,
                context: context),
            drawCanvas(
                points: points,
                selectedColor: selectedColor,
                strokeWidth: strokeWidth,
                width: width),
            controllerCanvas(
                points: points,
                selectColor: selectColor,
                selectedColor: selectedColor,
                width: width),
          ],
        ),
      ),
    );
  }

  // function snackbar
  void showActionSnackBar(BuildContext context, String msg) {
    final snackBar = SnackBar(
      content: Text(msg.toString(), style: TextStyle(fontSize: 16)),
      action: SnackBarAction(
        label: "Dismiss",
        onPressed: () {},
      ),
    );

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  // fungsi untuk load dataDraw berdasarkan index
  void loadDraw(int indexSaved) {
    points = List.from(savedDraw[indexSaved]);
  }

  // fungsi untuk save dataDraw berdasarkan index
  void saveDraw(int indexSaved) {
    savedDraw[indexSaved] = List.from(points);
  }

  // button controller widget
  Widget buttonController(
          {required BuildContext context,
          required CarouselController buttonCarouselController,
          required int currentIndex}) =>
      Flexible(
        flex: 1,
        fit: FlexFit.tight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              flex: 2,
              fit: FlexFit.loose,
              child: ElevatedButton(
                child: Icon(Icons.arrow_back),
                onPressed: () {
                  buttonCarouselController.previousPage(
                    duration: Duration(seconds: 1),
                    curve: Curves.linear,
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
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
              child: ElevatedButton(
                child: Icon(Icons.arrow_forward),
                onPressed: () {
                  buttonCarouselController.nextPage(
                    duration: Duration(seconds: 1),
                    curve: Curves.linear,
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  // image slider carousel widget
  Widget imageCarouselSlider(
          {required List<String> imgAssets,
          required CarouselController buttonCarouselController,
          required BuildContext context}) =>
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
      );

  // canvas widget
  Widget drawCanvas(
          {required double width,
          required List<Offset> points,
          required Color selectedColor,
          required double strokeWidth}) =>
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
          child: RepaintBoundary(
            key: _globalKey,
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
                  points.add(Offset(0, 0));
                });
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: CustomPaint(
                  foregroundPainter: CrossSquared(),
                  painter: MyCustomPainter(
                      points: points,
                      setColor: selectedColor,
                      strokeWidth: strokeWidth),
                ),
              ),
            ),
          ),
        ),
      );

  // controller canvas widget
  Widget controllerCanvas(
          {required double width,
          required Color selectedColor,
          required List<Offset> points,
          required selectColor}) =>
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
                icon: Icon(Icons.cloud_download_outlined),
                onPressed: () {
                  exportDrawToImage();
                },
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
                    selectColor(context);
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
      );

  Future<void> exportDrawToImage() async {
    final status = await Permission.storage.status;
    final time = DateTime.now().toIso8601String().replaceAll('.', ':');
    final name = '${(currentIndex + 1)}_aksaraBima_$time.png';

    // render image to bytes from widget
    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    ui.Image image = await boundary.toImage();

    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    // request permission, if not granted
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    final result = await ImageGallerySaver.saveImage(
      Uint8List.fromList(pngBytes),
      quality: 100,
      name: name,
    );

    // kalo sukese pop notifikasi
    final isSuccess = result['isSuccess'];

    if (isSuccess) {
      showActionSnackBar(context, "Image Successfully Saved!");
    } else {
      showActionSnackBar(context, "Image Failed to Saved!");
    }
  }
}
