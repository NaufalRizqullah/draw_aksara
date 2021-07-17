import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer(
      gradient: LinearGradient(
        colors: [
          Colors.white.withOpacity(0),
          Colors.white.withOpacity(0.5),
          Colors.white.withOpacity(0),
        ],
        stops: [
          0.45,
          0.5,
          0.55
        ],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight
      ),
      child: Container(
        color: Colors.grey,
        width: 400,
        height: 200,
      ),
    );
  }
}
