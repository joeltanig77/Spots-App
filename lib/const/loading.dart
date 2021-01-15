import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

// Need to fix the loading animation

class LoadingAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bgColor  = Color(0xffEFE2C8);
    final barColor = Color(0xFF4a6299);
    final gColor1  = Color(0xffd8a156);
    return Container(
      color: bgColor,
      child: Center(
        child: LoadingFlipping.circle(
          backgroundColor: bgColor,
          size: 50.0,
        ),
      ),
    );
  }
}
