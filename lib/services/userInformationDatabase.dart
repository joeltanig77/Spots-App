import 'package:flutter/material.dart';
import 'package:spots_app/models/userInformation.dart';
import 'package:spots_app/screens/home/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Might use this for later for a different database

QuerySnapshot stolenLocation;
CollectionReference locationCollection = Firestore.instance.collection("Coordinates");
List<DocumentSnapshot> garbo;


class UserInformationDatabase {
  // This takes in a uid like the marker database
  final String user;
  UserInformationDatabase({this.user});

  final CollectionReference userInformation =
      Firestore.instance.collection('UserInformation');


  Stream <List<UserInformation>> get userInfo {
    return userInformation.snapshots().map(_userInfoList);
  }

  List<UserInformation> _userInfoList (QuerySnapshot querySnapshot) {
    return querySnapshot.documents.map((e) {
      // We have to "steal the data here" because somehow Provider.of does not work
      stolenLocation=querySnapshot;

      return UserInformation(
        username: e.data['username'] ?? "",
        bio: e.data['bio'] ?? "",
      );
    }).toList();
    
  }

  Future getDocumentSnapshot () async {
    print("Reading Database from username collection...");
    garbo= stolenLocation.documents;
    garbo.forEach((element) {
      print(element.data);
      print("BREAK");

    }
    );
  }

  Future updateData(String userName, String bio) async{
    return await userInformation.document(user).setData({
      'username': userName,
      'bio': bio,
    });
  }


}