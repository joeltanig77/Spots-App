import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spots_app/services/auth.dart';
import 'package:spots_app/screens/home/home.dart';
import 'package:spots_app/screens/home/trade.dart';
import 'package:spots_app/screens/profile/profile.dart';
import 'package:spots_app/screens/authenticate/authenticate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:spots_app/models/locations.dart';
import 'package:spots_app/services/markerDatabase.dart';

class TradePage extends StatefulWidget  {
  @override
  _TradePageState createState() => _TradePageState();
}

class _TradePageState extends State<TradePage>  {

  //final Service _auth = Service();
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
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
                          Home(null, null, null),
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
                      Home(null, null, null),
                  transitionDuration: Duration(seconds: 0),
                      ),
                      );
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) => ProfilePage(null, "", ""),
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
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(icon: Icon(Icons.explore)),
                Tab(icon: Icon(Icons.mail)),
              ],
            ),
          ),
          body: Stack(
            children: [
              TabBarView(
                children: [
                  GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                    children: <Widget>[
                      Flexible(
                        child: Card(
                          color: Colors.amber,
                          child: Column(
                            children: [
                              Image.asset('images/beach.jpg'),
                              Flexible(child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  child: Text(
                                      'Happy Place',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),
                                  ),
                                ),
                              )
                              ),
                              Flexible(
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: FlatButton(
                                          textColor: Colors.yellow[300],
                                          onPressed: (){},
                                          child: Text('TRADE'),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: FlatButton(
                                          textColor: Colors.yellow[300],
                                          onPressed: (){},
                                          child: Text('TEXT'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: ListView(
                      children: [ Column(
                        children: [
                          Image.asset('images/sampleChat.jpg'),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                              ' Sample Chat Above\nNot Yet Implemented',
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
                ],
              ),
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
                              pageBuilder: (context, animation1, animation2) => Home(null, null, null),
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
      ),
    );
  }
}
