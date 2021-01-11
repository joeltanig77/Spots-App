import 'package:flutter/material.dart';
import 'package:spots_app/const/sharedStyles.dart';
import 'package:spots_app/main.dart';
import 'package:spots_app/screens/authenticate/changePassword.dart';
import 'package:spots_app/screens/authenticate/forgotPassword.dart';
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
              showAboutDialog(
                context: context,
                applicationVersion: '1.0.0',
              );
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
                  showAlertNoti(context);
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
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) => ChangePassword(),
                      transitionDuration: Duration(seconds: 0),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  showAlertNoti(BuildContext context) {
      Widget cancelButton = FlatButton(
        child: Text('Cancel'),
        onPressed: () {
            Navigator.of(context).pop();
        }
      );
      Widget continueButton = FlatButton(
        child: Text('Continue'),
        onPressed: (){
          _markerDatabase.deleteAllData(thisUID);
          Navigator.of(context).pop();
        },
      );
      AlertDialog alertDialog = AlertDialog(
        title: Text(
          'Delete all Markers?'
        ),
        content: Text('All markers will be deleted from your map, this action cannot be undone. '
            'Are your sure you still want to continue?'),
        actions: [
          cancelButton,
          continueButton,
        ],
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        }
      );
  }






}


