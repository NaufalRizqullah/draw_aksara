import 'dart:ui';
import 'package:flutter/material.dart';

void main() => runApp(new MaterialApp(
      home: new HomePage(),
      debugShowCheckedModeBanner: false,
    ));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Draw Aksara"),
        centerTitle: true,
        backgroundColor: Colors.green[700],
        leading: GestureDetector(
          child: Icon(Icons.menu),
          onTap: () {},
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              child: Icon(Icons.info_outline),
              onTap: () {},
            ),
          ),
        ],
      ),
      body: Container(),
    );
  }
}
