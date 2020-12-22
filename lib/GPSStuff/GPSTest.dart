import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GPSTest extends StatefulWidget {
  @override
  _GPSTestState createState() => _GPSTestState();
}

class _GPSTestState extends State<GPSTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: GoogleMap(
       initialCameraPosition: CameraPosition(target: LatLng(0,0), zoom: 14),
    ));
  }
}
