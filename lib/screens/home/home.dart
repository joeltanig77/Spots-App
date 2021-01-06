import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spots_app/models/userInformation.dart';
import 'package:spots_app/screens/authenticate/register.dart';
import 'package:spots_app/services/auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spots_app/screens/profile/profile.dart';

import 'package:geolocator/geolocator.dart';
import 'package:spots_app/models/locations.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'package:spots_app/services/markerDatabase.dart';
import 'package:spots_app/models/locations.dart';
import 'package:spots_app/models/user.dart';
import 'package:spots_app/screens/home/trade.dart';
import 'package:spots_app/services/userInformationDatabase.dart';

double long = -75.7009;
double lat = 45.4236;
int count = 0;

bool activeMarker = false;

List<Marker> userMarkers = [];
List<LatLng> coords = [];
LatLng currentCoords = LatLng(0, 0);
User usz = User();
String myId = "";
String desc="";
String locationName="";
TextEditingController _textController=new TextEditingController();
TextEditingController _textController2=new TextEditingController();
List<Marker> cloudMarkers=[];
String user;
String bio;


class Home extends StatefulWidget {
  double lat = 75.7009;
  double long = 45.4236;
  String ide = ""; //The users identification



  Home(latx, laty, uidd) {
    this.lat = latx;
    this.long = laty;
    this.ide = uidd;
    myId = this.ide;
  }
  // Reference our service class
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  BitmapDescriptor pinLocationIcon;

  final Service _auth = Service();

  String _mapStyle;
  GoogleMapController mapController;

  double pinPillPosition = -250;

  double finishedPillPosition = -250;

  void _onMapCreated(GoogleMapController controller) {
    currentUser();
    mapController = controller;
    getLocal();
    mapController.setMapStyle(_mapStyle);
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(getLat(), getLong()), zoom: 20.0),
      ),
    );
  }

  @override
  void initState() {


    getLocal();
    super.initState();

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.5), 'assets/marker4.png')
        .then((icon) {
      pinLocationIcon = icon;
    });

    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    getCurrentMarkers();

  }

  void getCurrentMarkers()async{
    final QuerySnapshot snapCheck =
        await Firestore.instance.collection('Coordinates').document(myId).collection("User_Locations").getDocuments();

    List<DocumentSnapshot> garbo= snapCheck.documents;

    garbo.forEach((element) {
      coords.add(LatLng(element.data["lat"],element.data["long"]));

      print("BREAK");
      MarkerId theMarkerId=MarkerId(element.data["locationName"]);
      String otherDesc=element.data["desc"];
      setState(() {
        //change the marker id property to a iny
        userMarkers.add (Marker(
          markerId: theMarkerId,
          onTap: () {
            if (!activeMarker) {
              locationName = theMarkerId.value;
              desc = otherDesc;
              setState(() {
                finishedPillPosition = 85;
              });
            }
          },
          infoWindow: InfoWindow(
            title: element.data["locationName"],
          ),
          draggable: false,
          icon: pinLocationIcon,
          position: LatLng(element.data["lat"], element.data["long"]),
        ));
        count++;
      });
    });
        }





  //Replaces marker with the same marker but with undraggable property.
  Future replaceMarker(MarkerId id) async {
    MarkerDatabase garb = MarkerDatabase();

    String valueOfMarker = id.value;
    int toIntValue = int.parse(valueOfMarker);
    id=MarkerId(locationName);

    String otherDesc=desc;



    setState(() {
      //change the marker id property to a iny
      userMarkers[toIntValue] = (Marker(
        markerId: id,
        onTap: () {
          if (!activeMarker) {
            locationName = id.value;
            desc = otherDesc;
            setState(() {
              finishedPillPosition = 85;
            });
          }
        },
        infoWindow: InfoWindow(
          title: locationName,
        ),
        draggable: false,
        icon: pinLocationIcon,
        position: coords[toIntValue],
      ));
    });
    //After we place the marker, update the data!!
    await MarkerDatabase(user: myId).updateData(
        coords[toIntValue].latitude,
        coords[toIntValue].longitude,
        locationName, desc,
        0,
        myId);


  }



/*
  Future storeUserInformation(String bio) async {
    String garb4 = Register().userName;
    await UserInformationDatabase(user: myId).updateData(garb4, bio);
  }
*/

  @override
  Widget build(BuildContext context) {
    getLocal();
    setState(() {

      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(getLat(), getLong()), zoom: 20.0),
      );
    });


    /*storeUserInformation("Im a happy boy hehe");*/
    return MaterialApp(
        home: StreamProvider<List<Location>>.value(
      value: MarkerDatabase().locations,
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
              onPressed: () async {
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
                    fontSize: 20.0,
                  )),
            ),
            FlatButton(
              padding: EdgeInsets.only(right: 60.0),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () async {},
              child: Text("Map",
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
                await currentUser();
                await currentBio();
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        ProfilePage(myId, user, bio),
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
        body: Stack(children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            markers: Set.from(userMarkers),

            //zoomControlsEnabled: false,

            initialCameraPosition:
                CameraPosition(target: LatLng(getLat(), getLong()), zoom: 11.0),
            onTap: (LatLng location) {
              setState(() {
                pinPillPosition = -250;
                finishedPillPosition = -250;
              });
            },
          ),
          AnimatedPositioned(
            bottom: finishedPillPosition,
            right: 0,
            left: 0,
            duration: Duration(milliseconds: 200),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.all(20),
                height: 200,
                child: Card(
                  color: Colors.amber,
                  child: ListView(
                    children: [
                      Column(
                        children: [
                          //finished image
                          Image.asset('images/stockSpots.jpg'),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 8.0),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              color: Colors.amber[600],
                              child: Text(
                                    'Name: '+ locationName,
                                ),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 8.0),
                            child: Container(
                              color: Colors.amber[600],
                              height: 50,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                    'Description: '+desc,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            bottom: pinPillPosition,
            right: 0,
            left: 0,
            duration: Duration(milliseconds: 200),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.all(20),
                height: 200,
                child: Card(
                  color: Colors.amber,
                  child: Stack(
                    children: [
                      ListView(
                        children: [
                          Column(
                            children: [
                              FlatButton(
                                  color: Colors.amber[600],
                                  height: 70,
                                  minWidth: 330,
                                  onPressed: () {

                                  },
                                  child: Icon(
                                    Icons.add_a_photo,
                                    color: Colors.white,
                                  ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 8.0),
                                child: Container(
                                  color: Colors.amber[600],
                                  child: TextField(
                                    controller: _textController,

                                    onChanged: (value){
                                      setState(() {
                                        locationName=value;


                                      });
                                    },
                                    decoration: InputDecoration(

                                        border: InputBorder.none,
                                        hintText:
                                            'Enter a name for the location'),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 8.0),
                                child: Container(
                                  color: Colors.amber[600],
                                  height: 50,
                                  child: TextField(
                                    controller: _textController2,
                                      onChanged: (value){
                                        setState(() {
                                          desc=value;

                                        });
                                      },

                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText:
                                            'Enter a description for the location'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: RaisedButton(
                            color: Colors.white,
                            shape: CircleBorder(),
                            child: Icon(
                              Icons.check,
                              color: Colors.green,
                            ),
                            onPressed: () {
                              activeMarker=false;
                              final ident = MarkerId(count.toString());

                              coords.add(currentCoords);
                              count++;
                              setState(() {
                                pinPillPosition = -250;
                              });
                              // Turn off the dragable property
                              replaceMarker(ident);
                              _textController.clear();
                              _textController2.clear();


                            },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width / 4,
              height: MediaQuery.of(context).size.height,
              child: GestureDetector(
                  onHorizontalDragEnd: (DragEndDetails details) {
                if (details.primaryVelocity > 0) {
                } else if (details.primaryVelocity < 0) {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          ProfilePage(myId, user, bio),
                      transitionDuration: Duration(seconds: 0),
                    ),
                  );
                }
              }),
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
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          TradePage(),
                      transitionDuration: Duration(seconds: 0),
                    ),
                  );
                } else if (details.primaryVelocity < 0) {}
              }),
            ),
          ),
        ]),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(left: 32.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton(
              child: Icon(Icons.add_location),
              backgroundColor: Colors.orange[300],
              onPressed: () {
                if (!activeMarker) {
                  activeMarker=true;
                  currentCoords = LatLng(getLat(), getLong());
                  setState(() {
                    userMarkers.add(
                      Marker(
                        markerId: MarkerId(count.toString()),
                        infoWindow: InfoWindow(
                          title: count.toString(),
                        ),
                        icon: pinLocationIcon,
                        draggable: true,
                        onDragEnd: ((newMarker) {
                          //Updates location after dragging
                          currentCoords =
                              LatLng(newMarker.latitude, newMarker.longitude);
                        }),
                        onTap: () {
                          setState(() {
                            pinPillPosition = 85;
                          });
                        },
                        position: LatLng(getLat(), getLong()),
                      ),
                    );
                  });
                };
              },
            ),
          ),
        ),
      ),
    ));
  }
}



Future getLocal() async {
  final location = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  lat = location.latitude;
  long = location.longitude;
  return location;
}

double getLong() {
  getLocal();
  return long;
}

double getLat() {
  getLocal();

  return lat;
}

Future currentUser() async {
  final QuerySnapshot snapCheck =
  await Firestore.instance.collection('User Settings and Data')
      .document(myId)
      .collection("User Info")
      .getDocuments();

  List<DocumentSnapshot> garbo = snapCheck.documents;
  user=garbo[0]["username"];
  print(user);

}


Future currentBio() async {
  final QuerySnapshot snapCheck =
  await Firestore.instance.collection('User Settings and Data')
      .document(myId)
      .collection("User Info")
      .getDocuments();
  List<DocumentSnapshot> garbo = snapCheck.documents;

    bio=garbo[0]["bio"];


}

