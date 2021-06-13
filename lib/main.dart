import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:draw_aksara/CarouselWithDotPage.dart';
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
  // link image
  final List<String> imgList = [
    'https://images.unsplash.com/photo-1623460685741-b847a13bda53?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=834&q=80',
    'https://images.unsplash.com/photo-1606787619248-f301830a5a57?ixid=MnwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80',
    'https://images.unsplash.com/photo-1623524142806-d08a59e73698?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=889&q=80',
    'https://images.unsplash.com/photo-1623556265095-9785a859efa2?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=823&q=80',
    'https://images.unsplash.com/photo-1623555113954-7dafe70c934d?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80',
    'https://images.unsplash.com/photo-1623557286978-e8663bb9736d?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80',
    'https://images.unsplash.com/photo-1485217988980-11786ced9454?ixid=MnwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80',
    'https://images.unsplash.com/photo-1604051189201-700f955d1cf8?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80'
  ];

  // list asset image
  final List<String> imgAssets = [
    'assets/1.jpg',
    'assets/2.png',
    'assets/3.png',
    'assets/4.png'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Draw Aksara"),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Carousel with Image(Network)",
                style: TextStyle(
                  color: Colors.green[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            CarouselSlider(
              items: imgList
                  .map(
                    (item) => Container(
                      child: Center(
                        child: Image.network(
                          item,
                          fit: BoxFit.cover,
                          width: 1000,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              options: CarouselOptions(
                autoPlay: true,
                aspectRatio: 2.0,
                enlargeCenterPage: true,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            CarouselWithDotPage(
              imgList: imgAssets,
            ),
          ],
        ),
      ),
    );
  }
}
