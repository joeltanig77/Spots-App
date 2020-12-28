import 'package:flutter/material.dart';
import 'package:spots_app/services/auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spots_app/screens/profile/profile.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:spots_app/services/determinePosition.dart';

double long=0;
double lat=0;

class Home extends StatefulWidget {

  // Reference our service class
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {



  final Service _auth = Service();
  String _mapStyle;
  GoogleMapController mapController;


  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.setMapStyle(_mapStyle);
  }

  @override
  void initState() {
    getLocal();
    super.initState();

    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }

  @override
  Widget build(BuildContext context) {
    getLocal();
    return MaterialApp(
      home: Scaffold(
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

        body: GoogleMap(

          onMapCreated: _onMapCreated,
          myLocationEnabled:true,

          //zoomControlsEnabled: false,
          initialCameraPosition: CameraPosition(

            target: LatLng(getLat(), getLong()), zoom: 11.0),

        ),




        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 45.0),
          child: FloatingActionButton(
            child: Icon(Icons.add_location),
            backgroundColor: Colors.orange[300],
            onPressed: (){
              getLocal();
              mapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(

                      target: LatLng(lat, long), zoom: 20.0),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}




getLocal() async{

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

