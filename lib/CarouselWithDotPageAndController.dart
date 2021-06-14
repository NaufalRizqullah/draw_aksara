import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselWithDotPageAndController extends StatefulWidget {
  // untuk kali ini kita pakai list di dalam assets
  List<String> imgList;

  CarouselWithDotPageAndController({this.imgList});

  @override
  _CarouselWithDotPageAndControllerState createState() =>
      _CarouselWithDotPageAndControllerState();
}

class _CarouselWithDotPageAndControllerState
    extends State<CarouselWithDotPageAndController> {
  // initial index current gambar
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // items carousel di pass buat pisah (anothe example)
    final List<Widget> imageSliders = widget.imgList
        .map((item) => Container(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Stack(
                  children: [
                    Image.asset(
                      item,
                      fit: BoxFit.cover,
                      width: 1000,
                    ),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        child: Text(
                          "Gambar No. ${widget.imgList.indexOf(item)}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ))
        .toList();

    // carousel controller setting
    CarouselController buttonCarouselController = CarouselController();

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            "Carousel with Image(Assets), Text & Dots",
            style: TextStyle(
              color: Colors.green[700],
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        CarouselSlider(
          carouselController: buttonCarouselController,
          items: imageSliders,
          options: CarouselOptions(
            autoPlay: false,
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            aspectRatio: 2.0,
            initialPage: 0,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.imgList.map((item) {
            // index gambar dari carouselnya
            int index = widget.imgList.indexOf(item);
            return Container(
              width: 8,
              height: 8,
              margin: EdgeInsets.symmetric(horizontal: 3, vertical: 10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index
                    ? Color.fromRGBO(0, 0, 0, 0.9)
                    : Color.fromRGBO(0, 0, 0, 0.4),
              ),
            );
          }).toList(),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RaisedButton(
                onPressed: () => buttonCarouselController.previousPage(
                    duration: Duration(milliseconds: 300), curve: Curves.ease),
                child: Text("Prev")),
            RaisedButton(
                onPressed: () => buttonCarouselController.nextPage(
                    duration: Duration(milliseconds: 300), curve: Curves.ease),
                child: Text("Next")),
          ],
        ),
      ],
    );
  }
}
