import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spots_app/screens/wrapper.dart';
import 'package:spots_app/services/auth.dart';
import 'package:spots_app/models/user.dart';
import 'package:geolocator/geolocator.dart';
import 'package:spots_app/services/markerDatabase.dart';

/*
//RUN APP WITH DEVICE PREVIEW
void main() => runApp(
  DevicePreview(
    builder: (context) => MyApp(), // Wrap your app
  ),
);


class MyApp extends StatelessWidget {
   // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Now every widget listening to the Wrapper root can access this stream of log in/ log out data
    return StreamProvider<User>.value(
      value: Service().user,
      child: MaterialApp(
        builder: DevicePreview.appBuilder, // Add the builder here
        home: Wrapper(),
      ),
    );
  }
}
*/

//RUN APP ALONE
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


