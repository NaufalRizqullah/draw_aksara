import 'package:flutter/material.dart';

class PopUpStroke extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController customController = TextEditingController();

    return AlertDialog(
      title: Text("Atur Stroke"),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            Text("Sebaiknya jangan diubah. Default: 10.0"),
            SizedBox(height: 10),
            TextField(
              controller: customController,
              decoration: InputDecoration(
                  hintText: '10.0',
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
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
          
        ),
      ],
    );
  }
}
