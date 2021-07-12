import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:draw_aksara/utils/signature_lib.dart';
import 'package:draw_aksara/utils/utils.dart';
import 'package:draw_aksara/widget/image_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  late Color selectedColor;
  late double strokeWidth;

  @override
  void initState() {
    selectedColor = Colors.black;
    strokeWidth = 5.0;
    super.initState();
  }

  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();

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
              flex: 5,
              child: ImageSlider(
                imgAssets: imgAssets,
              ),
            ),
            Flexible(
              flex: 4,
              fit: FlexFit.tight,
              child: Container(
                width: width * 0.95,
                child: SfSignaturePad(
                  key: signatureGlobalKey,
                  backgroundColor: Colors.white,
                  strokeColor: selectedColor,
                  minimumStrokeWidth: 1.0 + strokeWidth,
                  maximumStrokeWidth: 2.0 + strokeWidth,
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
                      icon: Icon(Icons.download),
                      onPressed: () {
                        _handleSaveButtonPressed();
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
                            _handleClearButtonPressed();
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

  void selectColor() {
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
      },
    );
  }

  void _handleClearButtonPressed() {
    signatureGlobalKey.currentState!.clear();
  }

  void _handleSaveButtonPressed() async {
    final data =
        await signatureGlobalKey.currentState!.toImage(pixelRatio: 3.0);

    final bytes = await data.toByteData(format: ui.ImageByteFormat.png);

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Preview"),
              leading: BackButton(),
              actions: [
                IconButton(
                  onPressed: () async =>
                      storeSignature(context, bytes!.buffer.asUint8List()),
                  icon: Icon(Icons.done),
                ),
              ],
            ),
            body: Center(
              child: Container(
                color: Colors.grey[300],
                child: Image.memory(
                  bytes!.buffer.asUint8List(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future storeSignature(BuildContext context, Uint8List signature) async {
    final status = await Permission.storage.status;

    if (!status.isGranted) {
      await Permission.storage.request();
    }

    final time = DateTime.now().toIso8601String().replaceAll('.', ':');
    final name = 'signature_$time';

    final result = await ImageGallerySaver.saveImage(
      signature,
      name: name,
      quality: 100,
    );

    final isSuccess = result['isSuccess'];

    if (isSuccess) {
      signatureGlobalKey.currentState!.clear();

      Navigator.pop(context);

      Utils.showSnackBar(context,
          text: 'Saved to Signature Folder', color: Colors.green);
    } else {
      Utils.showSnackBar(context,
          text: 'Failed to save Signature', color: Colors.red);
    }
  }
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
