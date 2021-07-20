import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:convert';

import 'package:draw_aksara/model/assets_image_base.dart';
import 'package:draw_aksara/utils/signature_lib.dart';
import 'package:draw_aksara/utils/utils.dart';
import 'package:draw_aksara/widget/image_slider.dart';
import 'package:draw_aksara/widget/pop_up_name.dart';
import 'package:draw_aksara/widget/shimmerLoading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart' show rootBundle;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future loadUp() async {
    String data = await rootBundle.loadString('assets/base/json/list.json');
    var jsonResult = jsonDecode(data);
    var list = AssetsImageBase.fromJson(jsonResult);

    createAlertDialog(context).then((value) {
      setState(() {
        nameDay = value;
      });
    });

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        imgAssets = list.listBase;
        isLoading = false;
      });
    });
  }

  // list asset image
  late List<String> imgAssets;

  late Color selectedColor;
  late double strokeWidth;
  bool isLoading = true;

  late String nameDay = "null-DayNull";

  @override
  void initState() {
    loadUp();
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
              child: (isLoading)
                  ? ShimmerLoading()
                  : ImageSlider(
                      imgAssets: imgAssets,
                    ),
            ),
            Flexible(
              flex: 4,
              fit: FlexFit.loose,
              child: Container(
                padding: EdgeInsets.only(top: 10),
                width: width * 0.95,
                child: SfSignaturePad(
                  key: signatureGlobalKey,
                  backgroundColor: Colors.white,
                  strokeColor: selectedColor,
                  minimumStrokeWidth: strokeWidth,
                  maximumStrokeWidth: 1.0 + strokeWidth,
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
    final name = '${nameDay}_AksaraBima_$time';

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

  Future createAlertDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => PopUpNameDialog(),
    );
  }
}
