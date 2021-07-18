import 'package:flutter/material.dart';

class PopUpNameDialog extends StatefulWidget {
  @override
  _PopUpNameDialogState createState() => _PopUpNameDialogState();
}

class _PopUpNameDialogState extends State<PopUpNameDialog> {
  @override
  Widget build(BuildContext context) {
    TextEditingController customController = TextEditingController();

    return AlertDialog(
      title: Text("Masukan Nama"),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            Text("Contoh Format: Ophal_Day2"),
            SizedBox(height: 10),
            TextField(
              controller: customController,
              decoration: InputDecoration(
                  hintText: 'Format: Name_Day1/2/3/...',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  )),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(customController.text.toString());
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}
