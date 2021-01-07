import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('this is ran');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About"
        ),
      ),
    );
  }
}
