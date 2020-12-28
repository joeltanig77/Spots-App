import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spots_app/screens/wrapper.dart';
import 'package:spots_app/services/auth.dart';
import 'package:spots_app/models/user.dart';
import 'package:geolocator/geolocator.dart';




void main() {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Now every widget listening to the Wrapper root can access this stream of log in/ log out data
    return StreamProvider<User>.value(
      value: Service().user,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}




