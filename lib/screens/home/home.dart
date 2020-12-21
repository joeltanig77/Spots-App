import 'package:flutter/material.dart';
import 'package:spots_app/services/auth.dart';

class Home extends StatelessWidget {
  // Reference our service class
  final Service _auth = Service();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[100],
      appBar: AppBar(
        title: Text("Spots",),
        centerTitle: true,
        backgroundColor: Colors.orange[300],
        // Note, This is actions for the appbar like the log in button
        actions: [
          FlatButton.icon(
            icon: Icon(Icons.person),
            onPressed: () async{
              await _auth.signOut();
            },
            label: Text("Log out"),
          )
        ],
      ),
    );
  }
}
