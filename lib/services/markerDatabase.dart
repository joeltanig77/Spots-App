import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spots_app/models/user.dart';

class MarkerDatabase{
  final String user;
  MarkerDatabase({this.user});

  final CollectionReference coordinates =
      Firestore.instance.collection('Coordinates');

  Future updateData(double lat, double long, String locationName, int radius) async {
    return await coordinates.document(user).setData({
      'lat': lat,
      "long": long,
      "locationName": locationName,
      "radius": radius,
    });

  }

  }





