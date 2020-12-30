import 'package:flutter/material.dart';
import 'package:spots_app/services/auth.dart';
import 'package:spots_app/screens/home/home.dart';
import 'package:spots_app/screens/trade/trade.dart';
import 'package:spots_app/screens/profile/profile.dart';
import 'package:spots_app/screens/authenticate/authenticate.dart';

class TradePage extends StatelessWidget {
  final Service _auth = Service();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.amber[100],
        appBar: AppBar(
          backgroundColor: Colors.orange[300],
          // Note, This is actions for the appbar like the log in button
          actions: [
            FlatButton(
              padding: EdgeInsets.only(right: 60.0),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () async {},
              child: Text("Trade",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  )),
            ),
            FlatButton(
              padding: EdgeInsets.only(right: 60.0),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () async {
                Navigator.pop(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        Home(null, null),
                    transitionDuration: Duration(seconds: 0),
                  ),
                );
              },
              child: Text("Map",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 20.0,
                  )),
            ),
            FlatButton(
              padding: EdgeInsets.only(right: 60.0),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () async {
                Navigator.pop(
                    context,
                    PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                    Home(null, null),
                transitionDuration: Duration(seconds: 0),
                    ),
                    );
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) => ProfilePage(),
                    transitionDuration: Duration(seconds: 0),
                  ),
                );
              },
              child: Text("Profile",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 20.0,
                  )),
            ),
          ],
        ),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: MediaQuery.of(context).size.width / 8,
                height: MediaQuery.of(context).size.height,
                child: GestureDetector(
                    onHorizontalDragEnd: (DragEndDetails details) {
                      if (details.primaryVelocity > 0) {

                      } else if (details.primaryVelocity < 0) {
                        Navigator.pop(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) => Home(null, null),
                            transitionDuration: Duration(seconds: 0),
                          ),
                        );
                      }
                    }
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }
}