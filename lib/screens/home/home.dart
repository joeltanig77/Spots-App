import 'package:flutter/material.dart';
import 'package:spots_app/services/auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spots_app/screens/profile/profile.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart' show rootBundle;

double long=-75.7009;
double lat=45.4236;
int count=0;

class Home extends StatefulWidget {
  double lat=75.7009;
  double long=45.4236;

  Home(latx, laty){
    this.lat= latx;
    this.long=laty;
  }
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
    getLocal();
    mapController.setMapStyle(_mapStyle);
    mapController.animateCamera(

      CameraUpdate.newCameraPosition(
        CameraPosition(

            target: LatLng(getLat(), getLong()), zoom: 20.0),
      ),
    );
  }

  List<Marker> userMarkers = [];
  List<LatLng> coords = [];

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
    setState(() {

      CameraUpdate.newCameraPosition(
        CameraPosition(

            target: LatLng(getLat(), getLong()), zoom: 20.0),
      );
    });



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

        body: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 75,
                  height: MediaQuery.of(context).size.height,
                  child: GestureDetector(
                      onHorizontalDragEnd: (DragEndDetails details) {
                        if (details.primaryVelocity > 0) {

                        } else if (details.primaryVelocity < 0) {

                        }
                      }
                  ),
                ),
              ),
              GoogleMap(

                onMapCreated: _onMapCreated,
                myLocationEnabled:true,
                markers: Set.from(userMarkers),

                //zoomControlsEnabled: false,

                initialCameraPosition: CameraPosition(target: LatLng(getLat(), getLong()), zoom: 11.0),

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
                count++;

                setState(() {
                  userMarkers.add(Marker(
                    markerId: MarkerId((count).toString()),

                    draggable: true,
                    onDragEnd:((newMarker){
                      coords.add(LatLng(newMarker.latitude, newMarker.longitude));

                  }),

                    onTap: () {
                      print("Initial Position");
                      print(userMarkers[count-1].position);
                      print("Final Position");
                      print(coords[count-1]);

                      print('Marker tapped!');
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

