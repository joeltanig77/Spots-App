import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spots_app/models/user.dart';
import 'package:spots_app/screens/profile/settings/settings.dart';
import 'package:spots_app/services/auth.dart';
import 'package:spots_app/screens/home/trade.dart';
import 'package:spots_app/screens/home/home.dart';
import 'package:spots_app/screens/authenticate/authenticate.dart';
import 'package:spots_app/models/userInformation.dart';
import 'package:spots_app/services/userInformationDatabase.dart';

String myId = "";
String user;
String bio="TEST";
final Service _auth = Service();
class ProfilePage extends StatefulWidget {

  ProfilePage(String uid, String user1, String bio1) {
    myId = uid;
    user=user1;
    bio=bio1;

  }

  @override
  _ProfilePageState createState() => _ProfilePageState();

}
Widget Spot(String name) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 8.0),
      child: Card(
        color: Colors.amberAccent,
        child: InkWell(
          splashColor: Colors.amber,
          onTap: () {
            print('Card tapped.');
          },
          child: Container(
            width: 112,
            height: 100,
            child: Align(
                child: Text(name)
            ),
          ),
        ),
      ),
    );

}



class _ProfilePageState extends State<ProfilePage> {

  //String garb = _auth.getUsernameFromAccount(myId);

  String _username = "";


  Future updateBio() async {
    final CollectionReference userLocations =
    Firestore.instance.collection('User Settings and Data').document(myId).collection("User Info");

    return await userLocations.document("Basic Credentials").setData({
      'username': user,
      'bio': bio,
    });
  }

  String returnBio(){
    return bio;
  }


  @override
  Widget build(BuildContext context) {

    
    return MaterialApp(
      home: StreamProvider<List<UserInformation>>.value(
      value: UserInformationDatabase().userInfo,
        child: Scaffold(
          backgroundColor: Colors.amber[100],
          appBar: AppBar(
            // Note, This is actions for the appbar like the log in button
            backgroundColor: Colors.orange[300],
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
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
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
                         user,
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
                            initialValue: returnBio(),
                              onChanged: (value){

                                setState(() {
                                  bio=value;

                                  updateBio();
                                });
                              },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                              ),
                              labelText: 'Bio',
                            )
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
                          child: Text(
                          "Inventory",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                          )
                          ),
                        ),
                      ),
                      Divider(),
                      Container(
                        color: Colors.transparent,
                        alignment: Alignment.bottomCenter,
                        height: 250,
                        width: MediaQuery.of(context).size.width ,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            Column(
                              children: [
                                Spot('Ronny Ronny Ronny'),
                                Spot('Mcdonalds')
                              ],
                            ),
                            Column(
                              children: [
                                Spot('Drakes Smokehouse'),
                                Spot('El Dorado'),
                              ],
                            ),
                            Column(
                              children: [
                                Spot('Boodock Base'),
                                Spot('WSU'),
                              ],
                            ),
                            Column(
                              children: [
                                Spot('Britain'),
                                Spot('Ottawa'),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ]
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
                    onPressed:  () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>  SettingsPage(myId),
                          transitionDuration: Duration(seconds: 1),
                        ),
                      );
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