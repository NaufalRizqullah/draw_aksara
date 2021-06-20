import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() => runApp(new MaterialApp(
      home: new HomePage(),
      debugShowCheckedModeBanner: false,
    ));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // var index
  int currentIndex = 0;

  // list asset image
  final List<String> imgAssets = [
    'assets/1.jpg',
    'assets/2.png',
    'assets/3.png',
    'assets/4.png',
    'assets/5.jpg',
    'assets/6.jpg',
    'assets/7.jpg',
  ];

  // carousel controller
  CarouselController buttonCarouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Draw Aksara"),
        centerTitle: true,
        backgroundColor: Colors.green[700],
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: InkResponse(
              child: Icon(Icons.info_outline),
              onTap: () {
                debugPrint("Hit info");
              },
            ),
          ),
        ],
      ),
      body: Builder(
        builder: (context) => Column(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: RaisedButton(
                      child: Icon(Icons.arrow_back),
                      onPressed: () {
                        buttonCarouselController.previousPage(
                          duration: Duration(seconds: 1),
                          curve: Curves.linear,
                        );
                      },
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Center(
                      child: Text(
                        "${currentIndex.toString()}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: RaisedButton(
                      child: Icon(Icons.arrow_forward),
                      onPressed: () {
                        buttonCarouselController.nextPage(
                          duration: Duration(seconds: 1),
                          curve: Curves.linear,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 4,
              fit: FlexFit.tight,
              child: Container(
                child: CarouselSlider(
                  carouselController: buttonCarouselController,
                  items: imgAssets
                      .map(
                        (e) => Container(
                          margin: EdgeInsets.all(10),
                          child: Image.asset(e, fit: BoxFit.contain,),
                        ),
                      )
                      .toList(),
                  options: CarouselOptions(
                    initialPage: 0,
                    enlargeCenterPage: true,
                    aspectRatio: 16/9,
                    height: MediaQuery.of(context).size.width * 0.8,
                    viewportFraction: 1.0,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      this.setState(() {
                        currentIndex = index;
                      });
                    },
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 4,
              fit: FlexFit.tight,
              child: Container(color: Colors.green),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
