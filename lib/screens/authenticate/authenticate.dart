import 'package:flutter/material.dart';
import 'package:spots_app/screens/authenticate/register.dart';
import 'package:spots_app/screens/authenticate/signIn.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool changeView = true;
  void toggleView() {
    setState(() {
      changeView = !changeView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return changeView ? SignIn(toggleView: toggleView) : Register(toggleView: toggleView);
  }
}
