import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:spots_app/models/user.dart';
import 'package:spots_app/screens/profile/settings/settings.dart';
import 'package:spots_app/services/auth.dart';
import 'package:spots_app/screens/home/trade.dart';
import 'package:spots_app/screens/home/home.dart';
import 'package:spots_app/screens/authenticate/authenticate.dart';
import 'package:spots_app/models/userInformation.dart';
import 'package:spots_app/services/userInformationDatabase.dart';
import 'dart:io';

String currentImageUrl2 =
    "https://firebasestorage.googleapis.com/v0/b/spots-80f7d.appspot.com/o/Default%20Assets%2Ficonperson.jpg?alt=media&token=acbaeec3-8761-4825-aa2c-2cf24f054a37";
String myId = "";
String user;
String bio = "TEST";

//dimensions

final Service _auth = Service();

class ProfilePage extends StatefulWidget {
  ProfilePage(String uid, String user1, String bio1) {
    myId = uid;
    user = user1;
    bio = bio1;
  }

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

Widget Spot(String name, double width, double height, double inset) {
  return Padding(
    padding: EdgeInsets.only(left: inset, top: inset),
    child: Card(
      color: Color(0xFFB07343),
      child: InkWell(
        splashColor: Color(0xFFbbbbbb),
        onTap: () {
          print('Card tapped.');
        },
        child: Container(
          width: width,
          height: height,
          child: Align(child: Text(name)),
        ),
      ),
    ),
  );
}

class _ProfilePageState extends State<ProfilePage> {
  //String garb = _auth.getUsernameFromAccount(myId);

  Future updateBio() async {
    final CollectionReference userLocations = Firestore.instance
        .collection('User Settings and Data')
        .document(myId)
        .collection("User Info");

    return await userLocations.document("Basic Credentials").setData({
      'username': user,
      'bio': bio,
    });
  }

  String returnBio() {
    return bio;
  }

  //Make a folder called profile pictures
  Future getAvatarFromGallery() async {
    var locationImage =
    await ImagePicker.pickImage(source: ImageSource.gallery);

    userImage = File(locationImage.path);
    String currentPath = 'Profile Pictures' + '/' + myId;

    if (locationImage != null) {
      await imageDatabase
          .ref()
          .child(currentPath)
          .putFile(userImage)
          .onComplete;

      String funTimes =
      await (imageDatabase.ref().child(currentPath).getDownloadURL());
      currentImageUrl2 = funTimes;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final TabFontSize = screenSize.width / 19;
    final bgColor  = Color(0xffEFE2C8);
    final barColor = Color(0xFFB07343);
    final gColor1  = Color(0xffCBAC80);
    final gColor2  = Color(0xffD5B487);
    final textColor = Color(0xff000000);

    return MaterialApp(
        home: StreamProvider<List<UserInformation>>.value(
      value: UserInformationDatabase().userInfo,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          // Note, This is actions for the appbar like the log in button
          automaticallyImplyLeading: false,
          backgroundColor: barColor,

          actions: [
            Expanded(
              child: Container(
                //color: Colors.blue,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: FlatButton(
                        //padding:  EdgeInsets.only(right: screenSize.width/6.5 ),
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
                              pageBuilder: (context, animation1, animation2) =>
                                  TradePage(),
                              transitionDuration: Duration(seconds: 0),
                            ),
                          );
                        },
                        child: Text("Trade",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: TabFontSize,
                            )),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: FlatButton(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenSize.width / 8),
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
                              fontSize: TabFontSize,
                            )),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: FlatButton(
                        //padding:  EdgeInsets.only(right: screenSize.width/6.5),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: () async {},
                        child: Text("Profile",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: TabFontSize,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: Stack(children: [
          ListView(
              //physics: const NeverScrollableScrollPhysics(),
              children: [
                Stack(children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [gColor1, gColor2]),
                    ),
                    height: MediaQuery.of(context).size.height / 2.7,
                  ),
                  Column(
                    children: [
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(screenSize.height / 55),
                          child: GestureDetector(
                            onTap: () {
                              getAvatarFromGallery();
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.black,
                              backgroundImage: NetworkImage(
                                  currentImageUrl2
                              ),
                              radius: MediaQuery.of(context).size.height / 7,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(user,
                            style: TextStyle(
                              color: textColor,
                              fontSize: screenSize.width / 15,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ],
                  ),

                ]),
                Padding(
                  padding: EdgeInsets.all(screenSize.height / 30),
                  child: Container(
                    child: TextFormField(
                        initialValue: returnBio(),
                        onChanged: (value) {
                          setState(() {
                            bio = value;

                            updateBio();
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Bio',
                        )),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: screenSize.height / 162,
                        horizontal: screenSize.width / 12),
                    child: Text("Inventory",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenSize.height / 31,
                        )),
                  ),
                ),
                Divider(),
                Container(
                  color: Colors.transparent,
                  alignment: Alignment.bottomCenter,
                  height: screenSize.height / 3.3,
                  width: MediaQuery.of(context).size.width,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Column(
                        children: [
                          Spot('Ronny Ronny Ronny', screenSize.width / 3,
                              screenSize.height / 8, screenSize.width / 47),
                          Spot('Mcdonalds', screenSize.width / 3,
                              screenSize.height / 8, screenSize.width / 47)
                        ],
                      ),
                      Column(
                        children: [
                          Spot('Drakes Smokehouse', screenSize.width / 3,
                              screenSize.height / 8, screenSize.width / 47),
                          Spot('El Dorado', screenSize.width / 3,
                              screenSize.height / 8, screenSize.width / 47),
                        ],
                      ),
                      Column(
                        children: [
                          Spot('Boodock Base', screenSize.width / 3,
                              screenSize.height / 8, screenSize.width / 47),
                          Spot('WSU', screenSize.width / 3,
                              screenSize.height / 8, screenSize.width / 47),
                        ],
                      ),
                      Column(
                        children: [
                          Spot('Britain', screenSize.width / 3,
                              screenSize.height / 8, screenSize.width / 47),
                          Spot('Ottawa', screenSize.width / 3,
                              screenSize.height / 8, screenSize.width / 47),
                        ],
                      ),
                    ],
                  ),
                ),
              ]),
          FlatButton.icon(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
              Navigator.pop(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      Home(null, null, null),
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
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        SettingsPage(myId),
                    transitionDuration: Duration(seconds: 1),
                  ),
                );
              },
              label: Text(
                "Settings",
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
                      pageBuilder: (context, animation1, animation2) =>
                          Home(null, null, null),
                      transitionDuration: Duration(seconds: 0),
                    ),
                  );
                } else if (details.primaryVelocity < 0) {}
              }),
            ),
          ),
        ]),
      ),
    ));
  }
}
