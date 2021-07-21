import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:draw_aksara/utils/utils.dart';
import 'package:draw_your_image/draw_your_image.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = DrawController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Signature"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.90,
                height: MediaQuery.of(context).size.width * 0.90,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                child: Draw(
                  controller: _controller,
                  backgroundColor: Colors.white,
                  strokeColor: Colors.black,
                  strokeWidth: 5,
                  isErasing: false,
                  onConvertImage: (value) {
                    _handleSaveButtonPressed(value);
                  },
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: Text("To Image"),
                  onPressed: _handleToImageButtonPressed,
                ),
                TextButton(
                  child: Text("Clear"),
                  onPressed: _handleClearButtonPressed,
                ),
                TextButton(
                  child: Text("Undo"),
                  onPressed: _handleUndoButtonPressed,
                ),
                TextButton(
                  child: Text("Redo"),
                  onPressed: _handleRedoButtonPressed,
                ),
              ],
            )
          ],
        ));
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

  void _handleSaveButtonPressed(final data) async {
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
                      storeSignature(context, data!.buffer.asUint8List()),
                  icon: Icon(Icons.done),
                ),
              ],
            ),
            body: Center(
              child: Container(
                color: Colors.grey[300],
                child: Image.memory(
                  data!.buffer.asUint8List(),
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
      _controller.clear();

      Navigator.pop(context);

      Utils.showSnackBar(context,
          text: 'Saved to Signature Folder', color: Colors.green);
    } else {
      Utils.showSnackBar(context,
          text: 'Failed to save Signature', color: Colors.red);
    }
  }
}
