import 'dart:ui';

import 'package:draw_aksara/model/assets_image_base.dart';
import 'package:draw_aksara/widget/shimmerLoading.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

class ImageSlider extends StatefulWidget {
  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int currentIndex = 0;

  CarouselController buttonCarouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    final instance = Provider.of<AssetsImageBase>(context);
    final double width = MediaQuery.of(context).size.width;

    Future.delayed(Duration(seconds: 2), () {
      // instance.fetchData(context);
      context.read<AssetsImageBase>().fetchData(context);
    });

    return (instance.getListBase() == null)
        ? ShimmerLoading()
        : Column(
            children: [
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      flex: 2,
                      fit: FlexFit.loose,
                      child: ElevatedButton(
                        child: Icon(Icons.arrow_back),
                        onPressed: () {
                          buttonCarouselController.previousPage(
                            duration: Duration(milliseconds: 400),
                            curve: Curves.linear,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blueGrey,
                          onPrimary: Colors.white,
                          elevation: 5,
                          minimumSize: Size(150, 40),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.loose,
                      child: Center(
                        child: Text(
                          "${(currentIndex + 1).toString()} / ${instance.getListBase()!.length}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      fit: FlexFit.loose,
                      child: ElevatedButton(
                        child: Icon(Icons.arrow_forward),
                        onPressed: () {
                          buttonCarouselController.nextPage(
                            duration: Duration(milliseconds: 400),
                            curve: Curves.linear,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blueGrey,
                          onPrimary: Colors.white,
                          elevation: 5,
                          minimumSize: Size(150, 40),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 4,
                fit: FlexFit.tight,
                child: Container(
                  width: width * 0.95,
                  child: CarouselSlider(
                    carouselController: buttonCarouselController,
                    items: instance
                        .getListBase()!
                        .map(
                          (e) => Container(
                            width: MediaQuery.of(context).size.width,
                            child: Image.asset(
                              e,
                              fit: BoxFit.contain,
                            ),
                          ),
                        )
                        .toList(),
                    options: CarouselOptions(
                      initialPage: 0,
                      enlargeCenterPage: true,
                      aspectRatio: 16 / 9,
                      height: MediaQuery.of(context).size.width * 0.8,
                      viewportFraction: 1.0,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, reason) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
