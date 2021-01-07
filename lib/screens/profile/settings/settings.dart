import 'package:flutter/material.dart';
import 'package:spots_app/const/sharedStyles.dart';
import 'package:spots_app/screens/home/home.dart';
import 'package:spots_app/services/markerDatabase.dart';
import 'package:spots_app/screens/profile/settings/about.dart';

String thisUID = "";
String stolenID = "";


class SettingsPage extends StatefulWidget {
  SettingsPage(String uid) {
    String uidThis = uid;
    thisUID = uidThis;
  }

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

MarkerDatabase _markerDatabase = MarkerDatabase();
Home home = Home(null,null,null);

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.amber,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
          Card(
          elevation: 0,
          margin: EdgeInsets.all(8),
          color: Colors.white,
          child: ListTile(
            title: Text("About"),
            onTap: () {
              print("About button pressed");
            },
          ),
        ),
            Card(
              elevation: 0,
              margin: EdgeInsets.all(8),
              color: Colors.white,
              child: ListTile(
                title: Text("Privacy"),
                onTap: () {
                  print("Privacy button pressed");
                },
              ),
            ),
            Card(
              elevation: 0,
              margin: EdgeInsets.all(8),
              color: Colors.white,
              child: ListTile(
                title: Text("Delete all Markers"),
                onTap: () {
                  print("Delete all marker markers pressed");
                  _markerDatabase.deleteAllData(thisUID);
                },
              ),
            ),
            Card(
              elevation: 0,
              margin: EdgeInsets.all(8),
              color: Colors.white,
              child: ListTile(
                title: Text("Change Email"),
                onTap: () {
                  print("Change Email button pressed");
                },
              ),
            ),
            Card(
              elevation: 0,
              margin: EdgeInsets.all(8),
              color: Colors.white,
              child: ListTile(
                title: Text("Change Password"),
                onTap: () {
                  print("Change Password button pressed");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }



}


