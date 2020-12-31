import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spots_app/models/user.dart';
import 'package:spots_app/models/locations.dart';

class MarkerDatabase{
  final String user;
  MarkerDatabase({this.user});

  final CollectionReference coordinates =
      Firestore.instance.collection('Coordinates');


  // Tells us the change of the doc in any certain point using a stream
  Stream <List<Location>> get locations {
    return coordinates.snapshots().map(_locationList);
  }

  List<Location> _locationList (QuerySnapshot querySnapshot) {
    return querySnapshot.documents.map((e) {
      return Location(
        locationName: e.data['locationName'] ?? "",
        lat: e.data['lat'] ?? 0.0,
        long: e.data['long']?? 0.0,
        radius: e.data['radius'] ?? 0,
      );
    }).toList();
  }



  Future updateData(double lat, double long, String locationName, int radius) async {
    return await coordinates.document(user).setData({
      'lat': lat,
      "long": long,
      "locationName": locationName,
      "radius": radius,
    });




  }

  }





