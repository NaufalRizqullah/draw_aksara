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
    "assets/base/a.png",
    "assets/base/e.png",
    "assets/base/i.png",
    "assets/base/o.png",
    "assets/base/u.png",
    "assets/base/ba.png",
    "assets/base/be.png",
    "assets/base/bi.png",
    "assets/base/bo.png",
    "assets/base/bu.png",
    "assets/base/ca.png",
    "assets/base/ce.png",
    "assets/base/ci.png",
    "assets/base/co.png",
    "assets/base/cu.png",
    "assets/base/da.png",
    "assets/base/de.png",
    "assets/base/di.png",
    "assets/base/do.png",
    "assets/base/du.png",
    "assets/base/fa.png",
    "assets/base/fe.png",
    "assets/base/fi.png",
    "assets/base/fo.png",
    "assets/base/fu.png",
    "assets/base/ga.png",
    "assets/base/ge.png",
    "assets/base/gi.png",
    "assets/base/go.png",
    "assets/base/gu.png",
    "assets/base/ha.png",
    "assets/base/he.png",
    "assets/base/hi.png",
    "assets/base/ho.png",
    "assets/base/hu.png",
    "assets/base/ja.png",
    "assets/base/je.png",
    "assets/base/ji.png",
    "assets/base/jo.png",
    "assets/base/ju.png",
    "assets/base/ka.png",
    "assets/base/ke.png",
    "assets/base/ki.png",
    "assets/base/ko.png",
    "assets/base/ku.png",
    "assets/base/la.png",
    "assets/base/le.png",
    "assets/base/li.png",
    "assets/base/lo.png",
    "assets/base/lu.png",
    "assets/base/ma.png",
    "assets/base/me.png",
    "assets/base/mi.png",
    "assets/base/mo.png",
    "assets/base/mu.png",
    "assets/base/na.png",
    "assets/base/ne.png",
    "assets/base/ni.png",
    "assets/base/no.png",
    "assets/base/nu.png",
    "assets/base/pa.png",
    "assets/base/pe.png",
    "assets/base/pi.png",
    "assets/base/po.png",
    "assets/base/pu.png",
    "assets/base/ra.png",
    "assets/base/re.png",
    "assets/base/ri.png",
    "assets/base/ro.png",
    "assets/base/ru.png",
    "assets/base/sa.png",
    "assets/base/se.png",
    "assets/base/si.png",
    "assets/base/so.png",
    "assets/base/su.png",
    "assets/base/ta.png",
    "assets/base/te.png",
    "assets/base/ti.png",
    "assets/base/to.png",
    "assets/base/tu.png",
    "assets/base/wa.png",
    "assets/base/we.png",
    "assets/base/wi.png",
    "assets/base/wo.png",
    "assets/base/wu.png",
    "assets/base/ya.png",
    "assets/base/ye.png",
    "assets/base/yi.png",
    "assets/base/yo.png",
    "assets/base/yu.png"
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
            Container(
              padding: EdgeInsets.only(top: 10),
              width: 256.0,
              height: 256.0,
              child: SfSignaturePad(
                key: signatureGlobalKey,
                backgroundColor: Colors.white,
                strokeColor: selectedColor,
                minimumStrokeWidth: strokeWidth,
                maximumStrokeWidth: 1.0 + strokeWidth,
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
