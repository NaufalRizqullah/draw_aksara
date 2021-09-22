import 'dart:typed_data';

import 'package:draw_aksara/model/index.dart';
import 'package:draw_aksara/model/menu_item.dart';
import 'package:draw_aksara/model/menu_items.dart';
import 'package:draw_aksara/page/aboutpage.dart';
import 'package:draw_aksara/utils/draw_your_image/draw_your_image.dart';
import 'package:draw_aksara/utils/utils.dart';
import 'package:draw_aksara/widget/image_slider.dart';
import 'package:draw_aksara/widget/pop_up_name.dart';
import 'package:draw_aksara/widget/pop_up_stroke.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color selectedColor = Colors.black;
  double strokeWidth = 10.0;
  String nameDay = "null_DayNull";

  @override
  void initState() {
    super.initState();

    createAlertDialog(context, PopUpNameDialog()).then((value) {
      setState(() {
        if (value != null) {
          nameDay = value;
        }
      });
    });
  }

  final _controller = DrawController();

  // Datettime for will popscope
  DateTime timeBackPressed = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final instanceIndex = Provider.of<Index>(context, listen: false);

    return WillPopScope(
      onWillPop: () async {
        final diff = DateTime.now()
            .difference(timeBackPressed); // cek perbedaan teken tombol keluar
        final isExitWarning = diff >= Duration(seconds: 2);

        timeBackPressed = DateTime.now();

        if (isExitWarning) {
          Fluttertoast.showToast(
            msg: "Press Back Again to Exit!",
            fontSize: 18,
          );
          return false;
        } else {
          Fluttertoast.cancel();
          return true;
        }
      },
      child: Scaffold(
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
          actions: [
            PopupMenuButton<MenuItem>(
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) => [
                ...MenuItems.itemsFirst.map(buildItem).toList(),
                PopupMenuDivider(),
                ...MenuItems.itemSecond.map(buildItem).toList(),
              ],
            ),
          ],
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton.icon(
                        icon: Icon(Icons.download),
                        label: Text(
                          "Save",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        onPressed: () {
                          _handleToImageButtonPressed();
                        },
                      ),
                      TextButton.icon(
                          icon: Icon(Icons.undo),
                          label: Text(
                            "Undo",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          onPressed: () {
                            _handleUndoButtonPressed();
                          }),
                      TextButton.icon(
                          icon: Icon(Icons.redo),
                          label: Text(
                            "Redo",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          onPressed: () {
                            _handleRedoButtonPressed();
                          }),
                      TextButton.icon(
                          icon: Icon(Icons.layers_clear),
                          label: Text(
                            "Clear",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
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
                color: Colors.black,
                child: Image.memory(
                  bytes.buffer.asUint8List(),
                  filterQuality: FilterQuality.high,
                  scale: 1.0,
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

    final time = DateTime.now().toIso8601String().replaceAll(':', '.');
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

  createAlertDialog(BuildContext context, final alertDialog,
      {bool dismiss = false}) async {
    await Future.delayed(Duration(milliseconds: 50));
    return showDialog(
      barrierDismissible: dismiss,
      context: context,
      builder: (context) => alertDialog,
    );
  }

  PopupMenuItem<MenuItem> buildItem(MenuItem item) {
    return PopupMenuItem<MenuItem>(
        value: item,
        child: Row(
          children: [
            Icon(
              item.icon,
              color: Colors.black,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(item.text),
          ],
        ));
  }

  void onSelected(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.itemSettingStroke:
        // pop up settting value stroke
        createAlertDialog(context, PopUpStroke(), dismiss: true).then((value) {
          setState(() {
            if (value != null) {
              strokeWidth = double.parse(value);
            } else {
              strokeWidth = 10.0;
            }
          });
        });

        break;

      case MenuItems.itemAboutPage:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AboutPage(),
          ),
        );
        break;

      case MenuItems.itemSignOut:
        // exit app
        Fluttertoast.showToast(
          msg: "Belum Implementasi!",
          fontSize: 18,
        );
        break;
    }
  }
}
