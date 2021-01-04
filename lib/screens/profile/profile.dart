import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spots_app/models/user.dart';
import 'package:spots_app/services/auth.dart';
import 'package:spots_app/screens/home/trade.dart';
import 'package:spots_app/screens/home/home.dart';
import 'package:spots_app/screens/authenticate/authenticate.dart';
import 'package:spots_app/models/userInformation.dart';
import 'package:spots_app/services/userInformationDatabase.dart';

class ProfilePage extends StatelessWidget {
  final Service _auth = Service();
   String _username = "";


  @override
  Widget build(BuildContext context) {
    
  Future getUserInformation() async {
    UserInformationDatabase userInformationDatabase = UserInformationDatabase();
    String database = userInformationDatabase.getDocumentSnapshot().toString();
    _username = database;

  }
    getUserInformation();
    return MaterialApp(
      home: StreamProvider<List<UserInformation>>.value(
      value: UserInformationDatabase().userInfo,
        child: Scaffold(
          backgroundColor: Colors.amber[100],
          appBar: AppBar(
            // Note, This is actions for the appbar like the log in button
            actions: [
              FlatButton(
                padding:  EdgeInsets.only(right: 60.0),
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
                      pageBuilder: (context, animation1, animation2) => TradePage(),
                      transitionDuration: Duration(seconds: 0),
                    ),
                  );
                },
                child: Text(
                    "Trade",
                    style:  TextStyle(
                      color: Colors.white70,
                      fontSize: 20.0,
                    )),
              ),
              FlatButton(
                padding:  EdgeInsets.only(right: 60.0),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () async {
                  Navigator.pop(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) => Home(null, null, null),
                      transitionDuration: Duration(seconds: 0),
                    ),
                  );
                },
                child: Text(
                    "Map",
                    style:  TextStyle(
                      color: Colors.white70,
                      fontSize: 20.0,
                    )),
              ),
              FlatButton(
                padding:  EdgeInsets.only(right: 60.0),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () async {
                },
                child: Text(
                    "Profile",
                    style:  TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    )),
              ),
            ],
          ),
          body: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.orange, Colors.amber]
                    ),
                  ),
                  height: MediaQuery.of(context).size.height/2.6,
                ),
                ListView(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          backgroundImage: NetworkImage("https://i.pinimg.com/originals/1c/0d/f9/1c0df903d94f7e5ad087ae072f0b8997.jpg"),
                          radius: 100,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                       '$_username',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Container(
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                            ),
                            labelText: 'Bio:',
                          )
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Text(
                        "Inventory: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                        )
                        ),
                      ),
                    ),
                  ],
                ),
                FlatButton.icon(
                  icon: Icon(Icons.logout),
                  onPressed:  ()  async {
                    await _auth.signOut();
                    Navigator.pop(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) => Home(null, null, null),
                        transitionDuration: Duration(seconds: 0),
                      ),
                    );
                  },

                  label: Text(
                      "Log Out",
                      style: TextStyle(
                      color: Colors.white70,
                      ),
                  ),

                ),
                Align(
                  alignment: Alignment.topRight,
                  child: FlatButton.icon(
                    icon: Icon(Icons.settings),
                    onPressed:  ()  async {
                    },

                    label: Text("Settings",
                        style: TextStyle(
                        color: Colors.white70,
                        ),
                        ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 8,
                    height: MediaQuery.of(context).size.height,
                    child: GestureDetector(
                        onHorizontalDragEnd: (DragEndDetails details) {
                          if (details.primaryVelocity > 0) {
                            Navigator.pop(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation1, animation2) => Home(null, null, null),
                                transitionDuration: Duration(seconds: 0),
                              ),
                            );
                          } else if (details.primaryVelocity < 0) {

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