import 'package:flutter/material.dart';

class Location {
  String uid;
  double lat;
  double long;
  String locationName;
  int radius;


  Location({this.lat, this.long, this.locationName, this.radius, this.uid});
  
  
}