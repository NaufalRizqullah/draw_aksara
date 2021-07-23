import 'dart:typed_data';

import 'package:draw_aksara/model/index.dart';
import 'package:draw_aksara/utils/utils.dart';
import 'package:draw_aksara/widget/image_slider.dart';
import 'package:draw_aksara/widget/pop_up_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:draw_your_image/draw_your_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color selectedColor = Colors.black;
  double strokeWidth = 8.0;
  String nameDay = "null-DayNull";

  @override
  void initState() {
    super.initState();

    createAlertDialog(context).then((value) {
      setState(() {
        nameDay = value;
      });
    });
  }

  final _controller = DrawController();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final instanceIndex = Provider.of<Index>(context, listen: false);

    return Scaffold(
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
      resizeToAvoidBottomInset: false,
      body: Builder(
        builder: (context) => Column(
          children: [
            Flexible(
              flex: 5,
              child: ImageSlider(),
            ),
            Flexible(
              flex: 4,
              fit: FlexFit.loose,
              child: Container(
                  padding: EdgeInsets.only(top: 10),
                  width: width * 0.95,
                  child: Draw(
                    controller: _controller,
                    backgroundColor: Colors.white,
                    strokeColor: selectedColor,
                    strokeWidth: strokeWidth,
                    isErasing: false,
                    onConvertImage: (value) {
                      _handleSaveButtonPressed(
                          value, instanceIndex.getNameAksaraByIndex());
                    },
                  )),
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
                        _handleToImageButtonPressed();
                      },
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.color_lens,
                        ),
                        onPressed: () {
                          selectColor();
                        }),
                    IconButton(
                        icon: Icon(
                          Icons.undo,
                        ),
                        onPressed: () {
                          _handleUndoButtonPressed();
                        }),
                    IconButton(
                        icon: Icon(
                          Icons.redo,
                        ),
                        onPressed: () {
                          _handleRedoButtonPressed();
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

  void _handleToImageButtonPressed() {
    _controller.convertToImage();
  }

  void _handleClearButtonPressed() {
    _controller.clear();
  }

  void _handleUndoButtonPressed() {
    _controller.undo();
  }

  void _handleRedoButtonPressed() {
    _controller.redo();
  }

  void _handleSaveButtonPressed(Uint8List bytes, String nAksara) async {
    // final data =
    //     await signatureGlobalKey.currentState!.toImage(pixelRatio: 3.0);

    // final bytes = await data.toByteData(format: ui.ImageByteFormat.png);

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Preview"),
              leading: BackButton(),
              actions: [
                IconButton(
                  onPressed: () async => storeSignature(
                      context, bytes.buffer.asUint8List(), nAksara),
                  icon: Icon(Icons.done),
                ),
              ],
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
            body: Center(
              child: Container(
                color: Colors.grey[300],
                child: Image.memory(
                  bytes.buffer.asUint8List(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future storeSignature(
      BuildContext context, Uint8List signature, String nAksara) async {
    final status = await Permission.storage.status;

    if (!status.isGranted) {
      await Permission.storage.request();
    }

    final time = DateTime.now().toIso8601String().replaceAll('.', ':');
    final name = '${nameDay}_${nAksara}_Aksara_$time';

    final result = await ImageGallerySaver.saveImage(
      signature,
      name: name,
      quality: 100,
    );

    final isSuccess = result['isSuccess'];

    if (isSuccess) {
      Navigator.pop(context);

      Utils.showSnackBar(context,
          text: 'Saved to Image Folder', color: Colors.green);
    } else {
      Utils.showSnackBar(context,
          text: 'Failed to save Image', color: Colors.red);
    }
  }

  createAlertDialog(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 50));
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => PopUpNameDialog(),
    );
  }
}
