import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:draw_aksara/my_image_view.dart';
import 'package:flutter/material.dart';

void main() => runApp(
      MaterialApp(
        home: HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Draw Aksara"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: CarouselSlider(
          options: CarouselOptions(height: 400.0),
          items: [
            'assets/1.jpg',
            'assets/2.png',
            'assets/3.png',
            'assets/4.png'
          ].map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Image.asset(i.toString()),
                    ));
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
