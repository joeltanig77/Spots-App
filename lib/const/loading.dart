import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

// Need to fix the loading animation

class LoadingAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[100],
      child: Center(
        child: LoadingFlipping.circle(
          backgroundColor: Colors.blue,
          size: 50.0,
        ),
      ),
    );
  }
}
