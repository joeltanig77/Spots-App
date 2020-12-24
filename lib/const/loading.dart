import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

// Need to fix the loading animation

class LoadingAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber[100],
      child: Center(
        child: LoadingFlipping.circle(
          backgroundColor: Colors.orange[300],
          size: 50.0,
        ),
      ),
    );
  }
}
