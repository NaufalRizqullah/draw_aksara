import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:draw_aksara/CarouselWithDotPage.dart';
import 'package:draw_aksara/CarouselWithDotPageAndController.dart';
import 'package:draw_aksara/CarouselWithDotPageImageNetwork.dart';
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
  // init carousel slider
  CarouselSlider _carouselSlider;
  // index started
  int _current = 0;
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

  // carousel controller
  CarouselController buttonCarouselController = CarouselController();

  // fungsi untuk dots di indicator
  List<T> mapDots<T>(List list, Function handler) {
    List<T> result = [];

    for (var i = 0; i < list.length; i++) {
      // di add nanti itu => current index dan urlImage
      result.add(handler(i, list[i]));
    }

    return result;
  }

  // function goToPrevious dan goToNext untuk berpindah halaman

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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _carouselSlider = CarouselSlider(
              items: imgAssets
                  .map(
                    (e) => Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.green,
                          ),
                          child: Image.asset(e, fit: BoxFit.cover),
                        );
                      },
                    ),
                  )
                  .toList(),
              options: CarouselOptions(
                height: 300.0,
                initialPage: 0,
                enlargeCenterPage: true,
                autoPlay: false,
                reverse: false,
                autoPlayInterval: Duration(seconds: 2),
                autoPlayAnimationDuration: Duration(milliseconds: 1500),
                onPageChanged: (index, reason) {
                  this.setState(() {
                    // ketiga gambar di slide/ganti maka value _current akan berubah
                    _current = index;
                  });
                },
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: mapDots(imgAssets, (index, url) {
                return Container(
                  width: 10.0,
                  height: 10.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index ? Colors.redAccent : Colors.grey,
                  ),
                );
              }),
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                    onPressed: () => buttonCarouselController.previousPage(
                          duration: Duration(milliseconds: 300),
                        ),
                    child: Text('<')),
                RaisedButton(
                    onPressed: () => buttonCarouselController.nextPage(
                          duration: Duration(milliseconds: 300),
                        ),
                    child: Text('>')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
