import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spots_app/models/user.dart';
import 'package:spots_app/models/locations.dart';
import 'package:spots_app/screens/home/home.dart';

QuerySnapshot stolenLocation;




class MarkerDatabase{
  final String user;
  MarkerDatabase({this.user});
  final FirebaseAuth _auth = FirebaseAuth.instance;


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



  Future getDocumentSnapshot (String userz) async {
    final QuerySnapshot snapCheck =
    await Firestore.instance.collection('Coordinates').document(userz).collection("User_Locations").getDocuments();


    List<DocumentSnapshot> garbo= snapCheck.documents;

    garbo.forEach((element) {


    }

    );
  }


  Future updateData(double lat, double long, String locationName, String desc, int radius, String uid, String url) async {
    final CollectionReference userLocations =
    Firestore.instance.collection('Coordinates').document(user).collection("User_Locations");

    return await userLocations.document(locationName).setData({
      'lat': lat,
      "long": long,
      "locationName": locationName,
      "desc": desc,
      "radius": radius,
      "uid":uid,
      "url":url
    });

  }



  //TODO: Find out how to also do notifications to ask if you want to delete the data or not (pop up)
  Future deleteAllData(String uid) async {
    CollectionReference _documentRef = Firestore.instance.collection("Coordinates").document(uid).collection("User_Locations");
    _documentRef.getDocuments().then((ds){
      if(ds!=null){
        ds.documents.forEach((value)  {
          value.reference.delete();
        });
      }
    });
    print("Data has been deleted for markers");

    //This is for deleting images in the database
    //TODO: Fix this
    String pathUID = uid;
    print(pathUID);
    await imageDatabase.ref()
        .child(pathUID)
        .delete();

    print("Data has been deleted for images");
  }


}





