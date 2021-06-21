import 'dart:typed_data';

import 'package:draw_aksara/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class SignaturePreviewPage extends StatelessWidget {
  final Uint8List signature;

  const SignaturePreviewPage({Key? key, required this.signature})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: CloseButton(),
        title: Text('Store Signature'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async => storeSignature(context),
            icon: Icon(Icons.done),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.memory(signature),
      ),
    );
  }

  Future storeSignature(BuildContext context) async {
    final status = await Permission.storage.status;

    if (!status.isGranted) {
      await Permission.storage.request();
    }

    final time = DateTime.now().toIso8601String().replaceAll('.', ':');
    final name = 'signature_$time.png';

    final result = await ImageGallerySaver.saveImage(signature, name: name);

    final isSuccess = result['isSuccess'];

    if (isSuccess) {
      Navigator.pop(context);

      Utils.showSnackBar(context,
          text: 'Saved to Signature Folder', color: Colors.green);
    } else {
      Utils.showSnackBar(context,
          text: 'Failed to save Signature', color: Colors.red);
    }
  }
}
