import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:draw_aksara/utils/signNature_lib.dart';
import 'package:draw_aksara/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();

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
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                child: SfSignaturePad(
                  key: signatureGlobalKey,
                  backgroundColor: Colors.white,
                  strokeColor: Colors.black,
                  minimumStrokeWidth: 3.0,
                  maximumStrokeWidth: 6.0,
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: Text("To Image"),
                  onPressed: _handleSaveButtonPressed,
                ),
                TextButton(
                  child: Text("Clear"),
                  onPressed: _handleClearButtonPressed,
                ),
              ],
            )
          ],
        ));
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
