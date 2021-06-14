import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselWithDotPageImageNetwork extends StatefulWidget {
  List<String> imgList;

  CarouselWithDotPageImageNetwork({this.imgList});

  @override
  _CarouselWithDotPageImageNetworkState createState() =>
      _CarouselWithDotPageImageNetworkState();
}

class _CarouselWithDotPageImageNetworkState
    extends State<CarouselWithDotPageImageNetwork> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = widget.imgList
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
        .toList();

    return Container(
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
            items: imageSliders,
            options: CarouselOptions(
              autoPlay: true,
              aspectRatio: 2.0,
              enlargeCenterPage: true,
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
