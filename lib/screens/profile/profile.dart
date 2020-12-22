import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.amber[100],
        appBar: AppBar(
          title: Text(
            "Spots",
          ),
          centerTitle: true,
          backgroundColor: Colors.orange[300],
          // Note, This is actions for the appbar like the log in button
          actions: [
            FlatButton.icon(
              icon: Icon(Icons.person),
              onPressed: () async {

              },
              label: Text("Log out"),
            ),
          ],
        ),
      ),
    );
  }
}
