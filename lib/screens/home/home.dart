import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

double long=-75.7009;
double lat=45.4236;
int count=0;
bool isDragable=true;
bool activeMarker=false;
Map<int, Location> markerz = <int, Location>{};
List<Marker> userMarkers = [];
List<LatLng> coords = [];
List<Location> locations=[];
LatLng currentCoords=LatLng(0,0);
User usz= User();
String myId="";



class Home extends StatefulWidget {
  double lat=75.7009;
  double long=45.4236;
  String ide = ""; //The users identification


  Home(latx, laty, uidd){

    this.lat= latx;
    this.long=laty;
    this.ide = uidd;
    myId=this.ide;
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

  double pinPillPosition = -100;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    getLocal();
    mapController.setMapStyle(_mapStyle);
    mapController.animateCamera(

      CameraUpdate.newCameraPosition(
        CameraPosition(

            target: LatLng(getLat(), getLong()), zoom: 20.0),
      ),
    );
  }



  @override
  void initState() {
    getLocal();
    super.initState();

    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/marker4.png').then((icon) {
      pinLocationIcon = icon;
    });

    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }

  //Replaces marker with the same marker but with undraggable property.
  Future replaceMarker(MarkerId id) async {

    MarkerDatabase garb = MarkerDatabase();


    String valueOfMarker= id.value;
    int toIntValue = int.parse(valueOfMarker);
    setState(() {
      //change the marker id property to a iny
      userMarkers[toIntValue]= (Marker(
        markerId: id,
        onTap: () {
          setState(() {
            pinPillPosition = 90;
          });
        },
        infoWindow: InfoWindow(
          title: userMarkers[toIntValue].infoWindow.title,
        ),
        draggable: false,
        icon: pinLocationIcon,

        position: coords[toIntValue],
      ));
    });
    await MarkerDatabase(user: myId+"_"+toIntValue.toString()).updateData(
        coords[toIntValue].latitude,  coords[toIntValue].longitude,
        userMarkers[toIntValue].infoWindow.title, 0, myId);
    garb.getDocumentSnapshot();

  }




  @override
  Widget build(BuildContext context) {
    getLocal();
    setState(() {

      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(getLat(), getLong()), zoom: 20.0),
      );
    });


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
                  padding:  EdgeInsets.only(right: 60.0),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () async {
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

                  },
                  child: Text(
                      "Map",
                      style:  TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      )),
                ),

                FlatButton(
                  padding:  EdgeInsets.only(right: 60.0),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () async {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) => ProfilePage(),
                        transitionDuration: Duration(seconds: 0),
                      ),
                    );
                  },
                  child: Text(

                      "Profile",
                      style:  TextStyle(
                        color: Colors.white70,
                        fontSize: 20.0,
                      )),
                ),
              ],

            ),

            body: Stack(
                children: [
                  GoogleMap(

                    onMapCreated: _onMapCreated,
                    myLocationEnabled:true,
                    markers: Set.from(userMarkers),

                    //zoomControlsEnabled: false,

                    initialCameraPosition: CameraPosition(target: LatLng(getLat(), getLong()), zoom: 11.0),
                    onTap: (LatLng location) {
                      setState(() {
                        pinPillPosition = -100;
                      });
                    },

                  ),
                  AnimatedPositioned(
                    bottom: pinPillPosition, right: 0, left: 0,
                    duration: Duration(milliseconds: 200),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.all(20),
                        height: 70,

                        child: Card(
                          color: Colors.amber,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Dead Fish',
                            ),
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
                                  pageBuilder: (context, animation1, animation2) => ProfilePage(),
                                  transitionDuration: Duration(seconds: 0),
                                ),
                              );
                            }
                          }

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
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation1, animation2) => TradePage(),
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

            floatingActionButton: Padding(
              padding: const EdgeInsets.only(left: 32.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FloatingActionButton(
                  child: Icon(Icons.add_location),
                  backgroundColor: Colors.orange[300],

                  onPressed: (){
                    currentCoords=LatLng(getLat(), getLong());
                    final ident = MarkerId(count.toString());
                    setState(() {
                      userMarkers.add(Marker(
                        markerId: MarkerId(count.toString()),
                        infoWindow: InfoWindow(
                          title: count.toString(),
                        ),
                        icon: pinLocationIcon,
                        draggable: true,
                        onDragEnd:((newMarker){ //Updates location after dragging
                          currentCoords=LatLng(newMarker.latitude, newMarker.longitude);
                        }),
                        onTap: () { //This is the "Confirm Button" for now
                          coords.add(currentCoords);
                          _saveLocal(ident);
                          pinPillPosition = 90;
                          // Turn off the dragable property
                          replaceMarker(ident);

                        },
                        position: LatLng(getLat(), getLong()),
                      )
                        ,
                      );

                    });
                  },
                ),
              ),
            ),
          ),
        )
    );
  }
}



_saveLocal(MarkerId id) {
  String valueOfMarker= id.value;
  int toIntValue = int.parse(valueOfMarker);

  Location locationOfMarker = new Location(
      lat:coords[toIntValue].latitude, long:coords[toIntValue].longitude);
  locations.add(locationOfMarker);





  //if (int.parse(garb)==count){
  activeMarker=false;
  isDragable=true;
  if (toIntValue==count){
    count++;}}

Future getLocal() async{
  final location = await Geolocator
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  lat=location.latitude;
  long=location.longitude;
  return location;

}

double getLong(){
  getLocal();
  return long;
}

double getLat(){
  getLocal();

  return lat;
}

List<Location> getLocations(){
  return locations;
}


