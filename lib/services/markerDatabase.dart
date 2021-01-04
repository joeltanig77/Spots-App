import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spots_app/models/user.dart';
import 'package:spots_app/models/locations.dart';

QuerySnapshot stolenLocation = null;
CollectionReference locationCollection = Firestore.instance.collection("Coordinates");

List<DocumentSnapshot> garbo = null;

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
      stolenLocation=querySnapshot;

      return Location(
        locationName: e.data['locationName'] ?? "",
        lat: e.data['lat'] ?? 0.0,
        long: e.data['long']?? 0.0,
        radius: e.data['radius'] ?? 0,
        uid: e.data["uid"] ?? "",
      );
    }).toList();
  }



  Future getDocumentSnapshot ()async {
    print("Reading Database...");
    garbo= stolenLocation.documents;
    garbo.forEach((element) {
      print(element.data);

      print("BREAK");

    }
    );
  }


  Future updateData(double lat, double long, String locationName, int radius, String uid) async {
    return await coordinates.document(user).setData({
      'lat': lat,
      "long": long,
      "locationName": locationName,
      "radius": radius,
      "uid":uid
    });




  }

  }





