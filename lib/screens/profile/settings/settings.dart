import 'package:flutter/material.dart';
import 'package:spots_app/const/sharedStyles.dart';
import 'package:spots_app/services/markerDatabase.dart';
import 'package:spots_app/screens/profile/settings/about.dart';

String thisUID = "";


class SettingsPage extends StatefulWidget {
  SettingsPage(String uid) {
    String uidThis = uid;
    thisUID = uidThis;
  }

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

MarkerDatabase _markerDatabase = MarkerDatabase();
AboutPage _aboutPage = AboutPage();

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
            settingsCard("About", _aboutPage),
            settingsCard("Privacy", null),
            settingsCard("Delete all Markers", null),
            settingsCard("Change Email", null),
            settingsCard("Change Password", null),
          ],
        ),
      ),
    );
  }
}


