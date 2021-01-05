import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spots_app/models/user.dart';
import 'package:spots_app/models/locations.dart';

QuerySnapshot stolenLocation;




class MarkerDatabase{
  final String user;
  MarkerDatabase({this.user});



  // Tells us the change of the doc in any certain point using a stream
  Stream <List<Location>> get locations {
    final CollectionReference userLocations =
    Firestore.instance.collection('Coordinates').document(user).collection("User_Locations");
    return userLocations.snapshots().map(_locationList);
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



  Future getDocumentSnapshot (String userz)async {
    final QuerySnapshot snapCheck =
    await Firestore.instance.collection('Coordinates').document(userz).collection("User_Locations").getDocuments();

    print("Reading Database...");

    List<DocumentSnapshot> garbo= snapCheck.documents;
    print(garbo.toString());
    garbo.forEach((element) {
      print(element.data);
      print("BREAK");

    }

    );
  }


  Future updateData(double lat, double long, String locationName, String desc, int radius, String uid) async {
    final CollectionReference userLocations =
    Firestore.instance.collection('Coordinates').document(user).collection("User_Locations");

    return await userLocations.document(locationName).setData({
      'lat': lat,
      "long": long,
      "locationName": locationName,
      "desc": desc,
      "radius": radius,
      "uid":uid
    });




  }

}





